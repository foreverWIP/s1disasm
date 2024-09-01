
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
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(7250) & 0xff), HZ_TO_SCD(7250) >> 8, 0, 0, 0x30},
	{0xff, 0xff, (HZ_TO_SCD(16000) & 0xff), HZ_TO_SCD(16000) >> 8, 0, 0, 0x60},
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
static u8 cur_sample_frame_count;
static u8 in_the_middle_of_loading;

const u8 max_sample_frame_counts[] = {
	1,
	0x6a4 / (8250 / 60),
	0xee0 / (24000 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
	0x202c / (7250 / 60),
};

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
	cur_sample_id = sample_id;
	cur_sample_frame_count = 0;

	*PCM_CDISABLE = 0xfe;
}

void vblank_sub()
{
	if (in_the_middle_of_loading)
	{
		goto done;
	}
	if ((cur_sample_id != 0) && (cur_sample_frame_count >= (max_sample_frame_counts[cur_sample_id] << 1)))
	{
		cur_sample_id = 0;
		*PCM_CDISABLE = 0xff;
		*PCM_CTRL = 0;
	}

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

typedef struct {
	const char* filename;
	u32 location_wram_relative;
} FileKVP;

const FileKVP SonicArt = {
	"ARTSONIC.BIN;1", 0x25000
};

const FileKVP TitleFiles[] = {
	{ "M16GHZ.ENI;1", 0x1e000 },
	{ "M256GHZ.KOS;1", 0x1f000 },
	{ "ARTGHZ1.NEM;1", 0x22000 },
	{ "ARTGHZ2.NEM;1", 0x23800 },
	{ 0, 0 },
};

const FileKVP GHZFiles[] = {
	{ "M16GHZ.ENI;1", 0x1e000 },
	{ "M256GHZ.KOS;1", 0x1f000 },
	{ "ARTGHZ1.NEM;1", 0x22000 },
	{ "ARTGHZ2.NEM;1", 0x23800 },
	SonicArt,
	{ 0, 0 },
};

const FileKVP MZFiles[] = {
	{ "M16MZ.ENI;1", 0x1e000 },
	{ "M256MZ.KOS;1", 0x1f000 },
	{ "ARTMZ.NEM;1", 0x22000 },
	SonicArt,
	{ 0, 0 },
};

const FileKVP SYZFiles[] = {
	{ "M16SYZ.ENI;1", 0x1e000 },
	{ "M256SYZ.KOS;1", 0x1f000 },
	{ "ARTSYZ.NEM;1", 0x22000 },
	SonicArt,
	{ 0, 0 },
};

const FileKVP LZFiles[] = {
	{ "M16LZ.ENI;1", 0x20400 },
	{ "M256LZ.KOS;1", 0x20800 },
	{ "ARTLZ.NEM;1", 0x23000 },
	SonicArt,
	{ 0, 0 },
};

const FileKVP SLZFiles[] = {
	{ "M16SLZ.ENI;1", 0x1e000 },
	{ "M256SLZ.KOS;1", 0x1f000 },
	{ "ARTSLZ.NEM;1", 0x22000 },
	SonicArt,
	{ 0, 0 },
};

const FileKVP SBZFiles[] = {
	{ "M16SBZ.ENI;1", 0x1ec00 },
	{ "M256SBZ.KOS;1", 0x1fc00 },
	{ "ARTSBZ.NEM;1", 0x22800 },
	SonicArt,
	{ 0, 0 },
};

const FileKVP ContinueFiles[] = {
	SonicArt,
	{ 0, 0 },
};

const FileKVP SpecialStageFiles[] = {
	{ "SSWALL.BIN;1", 0x20000 },
	{ "ARTSONIC.BIN;1", 0x30000 },
	{ 0, 0 },
};

void load_file_list(const FileKVP* file_list)
{
	FileKVP* file_entry = &file_list[0];

	while (file_entry->filename)
	{
		load_file_wrapper(ACC_OP_LOAD_CDC, file_entry->filename, (u8 *) (_WRDRAM_2M + file_entry->location_wram_relative));
		file_entry++;
	}
}

// It's a good idea to put SPX's main in .init to ensure it's at the very start
// of the code, since we jump to where we expect it to be in memory
__attribute__((section(".init"))) void main()
{

	register u16 cmd0, cmd1;

	cur_sample_id = 0;
	cur_sample_frame_count = 0;
	in_the_middle_of_loading = 0;

	*(u32*)(_USERCALL2+2) = vblank_sub;

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
				in_the_middle_of_loading = 1;
				bios_mscstop();
				*PCM_CDISABLE = 0xff;
				*PCM_CTRL = 0;
				load_file_wrapper(ACC_OP_LOAD_CDC, filenames[cmd1], (u8 *) _WRDRAM_2M);
				switch (cmd1)
				{
					case 0:
						load_file_list(TitleFiles);
						break;
					case 1:
					case 9:
						load_file_list(GHZFiles);
						break;
					case 2:
						load_file_list(MZFiles);
						break;
					case 3:
						load_file_list(SYZFiles);
						break;
					case 4:
						load_file_list(LZFiles);
						break;
					case 5:
						load_file_list(SLZFiles);
						break;
					case 6:
						load_file_list(SBZFiles);
						break;
					case 7:
						load_file_list(SpecialStageFiles);
						break;
					case 8:
						load_file_list(ContinueFiles);
						break;
				}

				grant_2m();
				in_the_middle_of_loading = 0;
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
			
			// load initial resources
			case 0xfd:
				pcm_clear_ram_c();
				load_file_wrapper(ACC_OP_LOAD_CDC, "AUDIO.PCM;1", (u8 *) _PRGRAM_1M_2);
				load_pcm((u8 *)_PRGRAM_1M_2, 0x5000);
				set_up_dummy_sample();
				grant_2m();
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
