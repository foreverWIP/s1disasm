
#include "sub/cdrom.h"
#include "sub/gatearr.h"
#include "sub/memmap.h"
#include "sub/pcm.h"

extern void sp_fatal();

char const * const filenames[] = {
	"TITLE.BIN;1",
	"GHZ.BIN;1",
	"MZ.BIN;1",
	"SYZ.BIN;1",
	"LZ.BIN;1",
	"SLZ.BIN;1",
	"SBZ.BIN;1",
	"SS.BIN;1",
	"CONTINUE.BIN;1",
	"ENDING.BIN;1",
	"CREDITS.BIN;1",
};

#define HZ_TO_SCD(hz) (((hz << 8) << 3) / 32252)

const PcmChannelSettings pcmSettings[] = {
	{0xff, 0xff, (HZ_TO_SCD(8250) & 0xff), HZ_TO_SCD(8250) >> 8, 0, 0, 0x00},
	{0xff, 0xff, (HZ_TO_SCD(24000) & 0xff), HZ_TO_SCD(24000) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x40},
};

const u32 pcm_sizes[] = {
	0x6a4,
	0xee0,
	0x202c,
};

static u8 cur_sample_id;
static u16 starting_sample_pos;
static u16 cur_sample_pos;
static u8 cur_sample_frame_count;

const u8 max_sample_frame_counts[] = {
	// 13,
	// 10,
	// 69,
	5,
	5,
	5,
};

volatile u8 *S_Chan_RAMPtr(u8 chan_id) {
    if (chan_id == 0) {
        return _PCM_PLAY_CH1_L;
    }    
    return _PCM_PLAY_CH1_L + ((chan_id) << 2);
}

u16 S_Chan_GetPosition(u8 chan_id)
{
    volatile u8 *ptr = S_Chan_RAMPtr(chan_id);
    u16 hi = *(ptr + 2);
    u16 lo = *(ptr    );
    return (hi << 8) | lo;
}

void load_pcm (u8 * pcm_data, u32 pcm_data_size)
{
	u8 maxCopyIter = pcm_data_size / 0x1000;
	// wave bank select
	// put initial block of data into lower bank
	u8 wb_select = 0x80;
	for (u8 copyIter = 0; copyIter < maxCopyIter; ++copyIter)
	{
		*PCM_CTRL = wb_select;
		u8 * pcm_ram = (u8 *) (_PCM_RAM + 1);
		for (u16 addr = 0; addr < 0x1000; ++addr)
		{
			*pcm_ram = *pcm_data++;
			pcm_ram += 2;
		}
		++wb_select;
	}
}

void pcm_playback (u8 sample_id)
{
	*PCM_CDISABLE = 0xff;
	pcm_config_channel_c (CHANNEL (1), &pcmSettings[sample_id]);

	cur_sample_id = sample_id;
	starting_sample_pos = S_Chan_GetPosition(0);
	cur_sample_frame_count = 0;

	*PCM_CDISABLE = 0xfe;
}

extern u32* spx_vint_ptr;

/*
kick = 1674 bytes @ 8250hz
8250 / 60 = 137.5
1674 / 137.5 ~= 13
snare = 3808 bytes @ 24000hz
24000 / 60 = 400
3808 / 400 ~= 10
timpani = 8236 bytes @ 7250hz
7250 / 60 ~= 120.83
8236 / 120.83 ~= 69
*/
void vblank_sub()
{
	/*if ((*GA_COMFLAGS_SUB & 0x80) != 0)
	{
		goto done;
	}*/
	if ((*PCM_CDISABLE & 1) != 0)
	{
		goto done;
	}

	cur_sample_pos = S_Chan_GetPosition(0);
	// if ((cur_sample_pos - starting_sample_pos) >= pcm_sizes[cur_sample_id])
	if (cur_sample_frame_count >= max_sample_frame_counts[cur_sample_id])
	{
		*PCM_CDISABLE = 0xff;
	}
	else
	{
		cur_sample_frame_count++;
	}

done:
	asm("\
		movea.l  acc_loop_jump, a0 /*load the jump ptr*/\n\
		jmp      (a0) /*and pick up where we left off*/\n\
		");
}

// It's a good idea to put SPX's main in .init to ensure it's at the very start
// of the code, since we jump to where we expect it to be in memory
__attribute__((section(".init"))) void main()
{

	register u16 cmd0, cmd1;

	*(u32*)(_USERCALL2+2) = vblank_sub;

	load_file (ACC_OP_LOAD_CDC, "AUDIO.PCM;1", (u8 *) _PRGRAM_1M_2);
	if (access_op_result != RESULT_OK)
	{
		sp_fatal();
	}
	pcm_clear_ram_c();
	load_pcm((u8 *)_PRGRAM_1M_2, 0x8000);

	do
	{

		do
		{
			cmd0 = *GA_COMCMD0;
		} while (cmd0 == 0);

		if (cmd0 != *GA_COMCMD0)
			continue;

		cmd1 = *GA_COMCMD1;

		switch (cmd0)
		{

			// load MMD
			case 1:
				load_file(ACC_OP_LOAD_CDC, filenames[cmd1], (u8 *) _WRDRAM_2M);
				if (access_op_result != RESULT_OK)
				{
					*GA_COMSTAT0 = 0xff;
					sp_fatal();
				}
				grant_2m();
				break;
			
			case 0x40:
				*GA_COMFLAGS_SUB |= 0x80;
				pcm_playback(cmd1 - 0x81);
				*GA_COMFLAGS_SUB &= ~0x80;
				break;

			// load IPX
			case 0xfe:
				load_file(ACC_OP_LOAD_CDC, "IPX.MMD;1", (u8 *) _WRDRAM_2M);
				if (access_op_result != RESULT_OK)
				{
					sp_fatal();
				}
				grant_2m();
				break;
		}

		*GA_COMSTAT0 = *GA_COMCMD0;
		do
		{
			cmd0 = *GA_COMCMD0;
		} while (cmd0 != 0);

		do
		{
			cmd0 = *GA_COMCMD0;
		} while (cmd0 != 0);

		*GA_COMSTAT0 = 0;

	} while (1);
}
