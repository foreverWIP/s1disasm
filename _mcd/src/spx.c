
#include "sub/cdrom.h"
#include "sub/gatearr.h"
#include "sub/memmap.h"
#include "sub/pcm.h"
#include "sub/bios.h"

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

const u16 cdda_track_offsets[] = {
	2, // ghz
	3, // lz
	4, // mz
	5, // slz
	6, // syz
	7, // sbz
	8, // invincible
	9, // extra life
	10, // ss
	11, // title
	12, // ending
	13, // boss
	14, // fz
	15, // got through
	16, // game over
	17, // continue
	18, // credits
	19, // drowning
	20, // emerald
};

#define HZ_TO_SCD(hz) (((hz << 8) << 3) / 32252)

const PcmChannelSettings pcmSettings[] = {
	{0xff, 0xff, (HZ_TO_SCD(8250) & 0xff), HZ_TO_SCD(8250) >> 8, 0, 0, 0x80},
	{0xff, 0xff, (HZ_TO_SCD(8250) & 0xff), HZ_TO_SCD(8250) >> 8, 0, 0, 0x00},
	{0xff, 0xff, (HZ_TO_SCD(24000) & 0xff), HZ_TO_SCD(24000) >> 8, 0, 0, 0x10},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x20},
	{0xff, 0xff, (HZ_TO_SCD(16000) & 0xff), HZ_TO_SCD(16000) >> 8, 0, 0, 0x50},
};

const u32 pcm_sizes[] = {
	4,
	0x6a4,
	0xee0,
	0x202c,
	0x202c,
	0x202c,
	0x202c,
	0x202c,
	0x202c,
	0x202c,
	0x202c,
	0x202c,
	0x202c,
	0x202c,
	0x202c,
	0x202c,
	0x202c,
	0xf55a,
};

static u8 cur_sample_id;
static u16 starting_sample_pos;
static u16 cur_sample_pos;
static u8 cur_sample_frame_count;
static u8 pcm_enabled;

const u8 max_sample_frame_counts[] = {
	1,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
	5,
};

#define ENABLE_PCM() { *PCM_CTRL = 0x80; pcm_enabled = 1; }
#define DISABLE_PCM() { *PCM_CTRL = 0x00; pcm_enabled = 0; }
#define PCM_ENABLED() (pcm_enabled)

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

void set_up_dummy_sample()
{
	*PCM_CTRL = 0x88;
	u8 * pcm_ram = (u8 *) (_PCM_RAM + 1);
	*pcm_ram = 0x00;
	pcm_ram += 2;
	*pcm_ram = 0x00;
	pcm_ram += 2;
	*pcm_ram = 0xff;
	pcm_ram += 2;
	*pcm_ram = 0xff;
	pcm_ram += 2;
}

void load_pcm (u8 * pcm_data, u32 pcm_data_size)
{
	u8 maxCopyIter = pcm_data_size / 0x1000;
	// wave bank select
	// put initial block of data into lower bank
	u8 wb_select = 0x00;
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
	sample_id -= 0x80;
	pcm_config_channel_c (CHANNEL (1), &pcmSettings[sample_id]);
	if (sample_id > 0)
	{
		cur_sample_id = sample_id;
	}
	starting_sample_pos = S_Chan_GetPosition(0);
	cur_sample_frame_count = 0;

	*PCM_CDISABLE = 0xfe;
}

void vblank_sub()
{
	cur_sample_frame_count++;

done:
	asm("\
		movea.l  acc_loop_jump, a0 /*load the jump ptr*/\n\
		jmp      (a0) /*and pick up where we left off*/\n\
		");
}

void load_file_wrapper(u16 const access_operation, char const * load_filename, u8 * buffer)
{
	load_file(access_operation, load_filename, buffer);
	if (access_op_result != RESULT_OK)
	{
		*GA_COMSTAT0 = 0xff;
		sp_fatal();
	}
}

// It's a good idea to put SPX's main in .init to ensure it's at the very start
// of the code, since we jump to where we expect it to be in memory
__attribute__((section(".init"))) void main()
{

	register u16 cmd0, cmd1;

	cur_sample_id = 0xff;
	cur_sample_frame_count = 0;

	*(u32*)(_USERCALL2+2) = vblank_sub;

	load_file_wrapper(ACC_OP_LOAD_CDC, "AUDIO.PCM;1", (u8 *) _PRGRAM_1M_2);
	pcm_clear_ram_c();
	load_pcm((u8 *)_PRGRAM_1M_2, 0x5000);
	set_up_dummy_sample();

	do
	{

		do
		{
			// if ((cur_sample_id != 0xff) && ((S_Chan_GetPosition(0) - starting_sample_pos) >= pcm_sizes[cur_sample_id])/*(cur_sample_frame_count >= max_sample_frame_counts[cur_sample_id])*/)
			if ((cur_sample_id != 0xff) && (cur_sample_frame_count >= max_sample_frame_counts[cur_sample_id]))
			{
				cur_sample_id = 0xff;
				pcm_playback(0x80);
			}
			cmd0 = *GA_COMCMD0;
		} while (cmd0 == 0);

		if (cmd0 != *GA_COMCMD0)
			continue;

		cmd1 = *GA_COMCMD1;

		switch (cmd0)
		{

			// load MMD
			case 1:
				bios_mscstop();
				*PCM_CDISABLE = 0xff;
				// *PCM_CTRL = 0;
				DISABLE_PCM();
				load_file_wrapper(ACC_OP_LOAD_CDC, filenames[cmd1], (u8 *) _WRDRAM_2M);
				switch (cmd1)
				{
					case 0:
						load_file_wrapper(ACC_OP_LOAD_CDC, "GHZ1.NEM;1", (u8 *) (_WRDRAM_2M + 0x20000));
						load_file_wrapper(ACC_OP_LOAD_CDC, "GHZ2.NEM;1", (u8 *) (_WRDRAM_2M + 0x22000));
						break;
					case 1:
					case 9:
						load_file_wrapper(ACC_OP_LOAD_CDC, "GHZ1.NEM;1", (u8 *) (_WRDRAM_2M + 0x20000));
						load_file_wrapper(ACC_OP_LOAD_CDC, "GHZ2.NEM;1", (u8 *) (_WRDRAM_2M + 0x22000));
						load_file_wrapper(ACC_OP_LOAD_CDC, "SONIC.BIN;1", (u8 *) (_WRDRAM_2M + 0x24000));
						break;
					case 2:
						load_file_wrapper(ACC_OP_LOAD_CDC, "MZ.NEM;1", (u8 *) (_WRDRAM_2M + 0x20000));
						load_file_wrapper(ACC_OP_LOAD_CDC, "SONIC.BIN;1", (u8 *) (_WRDRAM_2M + 0x24000));
						break;
					case 3:
						load_file_wrapper(ACC_OP_LOAD_CDC, "SYZ.NEM;1", (u8 *) (_WRDRAM_2M + 0x20000));
						load_file_wrapper(ACC_OP_LOAD_CDC, "SONIC.BIN;1", (u8 *) (_WRDRAM_2M + 0x24000));
						break;
					case 4:
						load_file_wrapper(ACC_OP_LOAD_CDC, "LZ.NEM;1", (u8 *) (_WRDRAM_2M + 0x20000));
						load_file_wrapper(ACC_OP_LOAD_CDC, "SONIC.BIN;1", (u8 *) (_WRDRAM_2M + 0x24000));
						break;
					case 5:
						load_file_wrapper(ACC_OP_LOAD_CDC, "SLZ.NEM;1", (u8 *) (_WRDRAM_2M + 0x20000));
						load_file_wrapper(ACC_OP_LOAD_CDC, "SONIC.BIN;1", (u8 *) (_WRDRAM_2M + 0x24000));
						break;
					case 6:
						load_file_wrapper(ACC_OP_LOAD_CDC, "SBZ.NEM;1", (u8 *) (_WRDRAM_2M + 0x20000));
						load_file_wrapper(ACC_OP_LOAD_CDC, "SONIC.BIN;1", (u8 *) (_WRDRAM_2M + 0x24000));
						break;
					case 7:
					case 8:
						load_file_wrapper(ACC_OP_LOAD_CDC, "SONIC.BIN;1", (u8 *) (_WRDRAM_2M + 0x24000));
						break;
				}

				grant_2m();
				break;
			
			// play a dac sample
			case 0x40:
				pcm_playback(cmd1);
				break;
			
			// play a cd track
			case 0x41:
				bios_mscstop();
				bios_fdrset(0x250);
				bios_fdrset(0x8400);
				bios_mscplayr(&cdda_track_offsets[cmd1 - 0x81]);
				break;

			// load IPX
			case 0xfe:
				load_file_wrapper(ACC_OP_LOAD_CDC, "IPX.MMD;1", (u8 *) _WRDRAM_2M);
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
