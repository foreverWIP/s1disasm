#include "ipx.h"
#include "main/bootlib.h"
#include "main/gatearray.h"
#include "main/memmap.h"
#include "main/mmd_exec.h"
#include "main/vdp.h"
#include "system.h"
#include "memory.h"
#include "main/printval.h"

enum {
	MMD_TITLE = 0,
	MMD_GHZ,
	MMD_MZ,
	MMD_SYZ,
	MMD_LZ,
	MMD_SLZ,
	MMD_SBZ,
	MMD_SS,
	MMD_CONTINUE,
	MMD_ENDING,
	MMD_CREDITS,
};

/*extern u32 Debugger_BusError;
extern u32 Debugger_AddressError;
extern u32 Debugger_TraceError;
extern u32 Debugger_SpuriousException;
extern u32 Debugger_ZeroDivideError;
extern u32 Debugger_CHKExceptionError;
extern u32 Debugger_TRAPVError;
extern u32 Debugger_IllegalInstrError;
extern u32 Debugger_PrivilegeViolation;
extern u32 Debugger_LineAEmulation;
extern u32 Debugger_LineFEmulation;
extern u32 Debugger_TrapVector;*/

static Sprite v_spritetablebuffer[80];
static u16 v_palette[64];
#define v_palette_wram ((u16 *)0x23FB80)

static u32 frame_counter = 0;
static u8 cur_sonic_anim_index = 0;
static u8 is_loading = 0;

#define v_gamemode (*((u8*)0x23EFB0))
static u8 v_gamemode_backup;
#define v_zone (*((u8*)0x23F32E))
static u8 v_zone_backup;
#define v_lastlamp (*((u16*)0x23F34A))
#define v_use_cd_audio (*((u8*)0x23C4E4))
#define v_undef_obj_id (*((u8*)0x23C4E5))
#define v_undef_gm_id (*((u8*)0x23C4E6))
static u8 v_vbla_routine;

extern u8* Loading_Sonic_Art, Loading_Sonic_Art_end;
extern u16* Loading_Sonic_Map;
extern u16* Loading_Sonic_Pal, Loading_Sonic_Pal_end;
extern u8* Loading_Text, Loading_Text_end;
extern u16* Loading_Text_Pal, Loading_Text_Pal_end;

const u16 Loading_Sonic_Art_VRAM_Pos = 0x1000;
const u16 Loading_Text_VRAM_Pos = 0x2000;

static inline void wait_for_vbla()
{
	disable_interrupts();
	v_vbla_routine = 1;
	enable_interrupts();
	while (v_vbla_routine)
	{
		asm("nop");
	}
}

static void set_sonic_frame(u8 frame)
{
	u16 sprite_offset = *((u16*)&Loading_Sonic_Map + frame);
	u8* raw_sprite_ptr = (u8*)&Loading_Sonic_Map + sprite_offset;
	u8 num_sprite_pieces = *raw_sprite_ptr++;
	u8 next_sprite = 0;
	for (u8 i = 0; i < num_sprite_pieces; i++)
	{
		s16 ypos = (s16)((s8)*raw_sprite_ptr++);
		v_spritetablebuffer[next_sprite].pos_y = (u16)(ypos + 128 + (240 - 40 - 8));
		u8 size = *raw_sprite_ptr++;
		v_spritetablebuffer[next_sprite].width = size >> 2;
		v_spritetablebuffer[next_sprite].height = size & 0b11;
		v_spritetablebuffer[next_sprite].next = (i == (num_sprite_pieces - 1)) ? 0 : next_sprite + 1;
		s16 tileinfo_highbyte = *raw_sprite_ptr++;
		s16 tileinfo_lowbyte = *raw_sprite_ptr++;
		s16 tileinfo = (tileinfo_highbyte << 8) | tileinfo_lowbyte;
		v_spritetablebuffer[next_sprite].priority = 1 | (tileinfo >> 15);
		v_spritetablebuffer[next_sprite].palette = ((tileinfo >> 13) + 1) & 0b11;
		v_spritetablebuffer[next_sprite].v_flip = (tileinfo >> 12) & 1;
		v_spritetablebuffer[next_sprite].h_flip = (tileinfo >> 11) & 1;
		s16 xpos = (s16)((s8)*raw_sprite_ptr++);
		v_spritetablebuffer[next_sprite].tile = (Loading_Sonic_Art_VRAM_Pos >> 5) + (tileinfo & 0x7ff);
		v_spritetablebuffer[next_sprite].pos_x = (u16)(xpos + 128 + 280);

		next_sprite++;
	}
}

const signed char loading_col_offsets[] = {
    2, 2, 2, 3, 3, 3, 3, 3,
	3, 4, 4, 4, 4, 4, 4, 4,
	4, 4, 4, 4, 4, 4, 3, 3,
	3, 3, 3, 3, 2, 2, 2, 2,
	2, 1, 1, 1, 1, 1, 1, 0,
	0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 1, 1, 1, 1,
	1, 1, 2, 2
};
const u8 loading_col_offsets_len = (sizeof(loading_col_offsets) / sizeof(s8));

__attribute__((interrupt)) void vint_ex() {
	asm("bset.b #0, (0xA12000).l");
	if (is_loading)
	{
		cur_sonic_anim_index = (frame_counter >> 4) & 1;
		set_sonic_frame(cur_sonic_anim_index + 3);

		blib_dma_xfer(VDPPTR(0) | CRAM_W, v_palette, 128 >> 1);
		blib_dma_xfer(VDPPTR(0xF800), v_spritetablebuffer, 0x280 >> 1);

		VDP_CTRL_32 = VDPPTR(0) | VSRAM_W;
		for (u8 i = 0; i < 20; i++)
		{
			u8 off_index = frame_counter + i;
			while (off_index >= loading_col_offsets_len)
			{
				off_index -= loading_col_offsets_len;
			}
			s16 off = loading_col_offsets[off_index] - 2;
			VDP_DATA_16 = off;
			VDP_DATA_16 = off;
		}
	}
	frame_counter++;
	v_vbla_routine = 0;
}

__attribute__((interrupt)) void hint_ex()
{

}

static void print_msg(const char* msg, u8 x, u8 y)
{
	blib_print(msg, (VDPPTR(NMT_POS_PLANE(x, y, _BLIB_PLANEA_ADDR)) | VRAM_W));
	wait_for_vbla();
}

void enable_debug_output()
{
	blib_clear_tables();
	blib_load_font_defaults();
	for (u8 i = 0; i < 64; i++)
	{
		v_palette[i] = 0x0000;
	}
	v_palette[1] = 0xeee;
	for (u8 i = 1; i < 16; i++)
	{
		v_palette[i] = 0xeee;
	}
	MLEVEL6_VECTOR = vint_ex;
}

void undef_obj_error(u8 obj_id)
{
	char id_char_buf[4];
	enable_debug_output();
	print_msg("Undefined object!\xff", 0, 0);
	printval_u8_c(obj_id, id_char_buf);
	print_msg("ID: --\xff", 0, 1);
	print_msg(id_char_buf, 4, 1);
	do
	{
		asm("nop");
	} while (1);
}

void undef_gm_error(u8 gm_id)
{
	char id_char_buf[4];
	enable_debug_output();
	print_msg("Undefined game mode!\xff", 0, 0);
	printval_u8_c(gm_id, id_char_buf);
	print_msg("ID: --\xff", 0, 1);
	print_msg(id_char_buf, 4, 1);
	do
	{
		asm("nop");
	} while (1);
}

void sync_with_sub()
{
	/*
	do
	{
		asm ("nop");
	} while (*GA_COMSTAT0 == 0);

	*GA_COMCMD0 = 0;

	do
	{
		asm ("nop");
	} while (*GA_COMSTAT0 != 0);
	*/
	checkcomcmd: // .checkcomcmd:
	if (*GA_COMCMD0 != 0) {// 		tst.w	(GA_COMCMD0).l
	goto waitforcomstatnot0; // 		bne.s	.waitforcomstatnot0
	}else{goto waitforcomstat0;} // 		beq.s	.waitforcomstat0
	waitforcomstatnot0: // .waitforcomstatnot0:
	if (*GA_COMSTAT0 == 0) // 		tst.w	(GA_COMSTAT0).l
	goto waitforcomstatnot0; // 		beq.s	.waitforcomstatnot0
	*GA_COMCMD0 = 0; // 		move.w	#$0,(GA_COMCMD0).l
	goto checkcomcmd; // 		bra.s	.checkcomcmd
	waitforcomstat0: // .waitforcomstat0:
	if (*GA_COMSTAT0 != 0) // 		tst.w	(GA_COMSTAT0).l
	goto waitforcomstat0; // 		bne.s	.waitforcomstat0
}

void wait_on_cd_command(u8 cmd0, u8 cmd1)
{
	grant_2m();
	*GA_COMCMD1 = cmd1;
	*GA_COMCMD0 = cmd0;

	sync_with_sub();

	wait_2m();
}

struct loading_char_info {
	u8 loc;
	u8 width;
};

const struct loading_char_info loading_char_infos[] = {
	{0,2}, // A
	{2,2}, // B
	{4,2}, // C
	{6,2}, // D
	{8,2}, // E
	{10,2}, // F
	{12,2}, // G
	{14,2}, // H
	{16,1}, // I
	{17,2}, // J
	{19,2}, // K
	{21,2}, // L
	{23,3}, // M
	{26,2}, // N
	{28,2}, // O
	{30,2}, // P
	{32,2}, // Q
	{34,2}, // R
	{36,2}, // S
	{38,2}, // T
	{40,2}, // U
	{42,2}, // V
	{44,3}, // W
	{47,2}, // X
	{49,2}, // Y
	{51,2}, // Z
	{53,2}, // 2
};
const u8 loading_text_art_width_tiles = 55;

static inline void print_loading_char_inner(char c, u8 char_width, u16 tiledata)
{
	if (c == 0 || c == ' ')
	{
		VDP_DATA_32 = 0;
		return;
	}
	for (u8 i = 0; i < char_width; i++)
	{
		VDP_DATA_16 = tiledata + i;
	}
	if ((char_width & 1) == 1)
	{
		VDP_DATA_16 = 0;
	}
}

u8 print_loading_char(char c, u8 x)
{
	if (c == 0 || c == ' ')
	{
		return 1;	
	}
	u8 char_width = loading_char_infos[c - 'A'].width;
	u8 char_loc = loading_char_infos[c - 'A'].loc;
	// top half
	VDP_CTRL_32 = (VDPPTR(NMT_POS_PLANE(x, 24, _BLIB_PLANEA_ADDR)) | VRAM_W);
	u16 tiledata = 0x2000 | ((Loading_Text_VRAM_Pos >> 5) + char_loc);
	print_loading_char_inner(c, char_width, tiledata);
	// bottom half
	VDP_CTRL_32 = (VDPPTR(NMT_POS_PLANE(x, 25, _BLIB_PLANEA_ADDR)) | VRAM_W);
	tiledata = 0x2000 | ((Loading_Text_VRAM_Pos >> 5) + (char_loc + loading_text_art_width_tiles));
	print_loading_char_inner(c, char_width, tiledata);
	return char_width;
}

void print_loading_text(const char* text)
{
	u8 x = 2;
	while (*text != 0)
	{
		u8 width = print_loading_char(*text, x);
		x += width;
		text++;
	}
}

void set_up_loading_screen()
{
	blib_clear_vram();
	VDP_CTRL_16 = 0x8700;

	blib_dma_xfer(VDPPTR(Loading_Sonic_Art_VRAM_Pos), &Loading_Sonic_Art, (((u32)&Loading_Sonic_Art_end) - ((u32)&Loading_Sonic_Art)) >> 1);
	blib_dma_xfer(VDPPTR(Loading_Text_VRAM_Pos), &Loading_Text, 0xdc0 >> 1);
	print_loading_text("NOW LOADING");
	memcpy16(&Loading_Sonic_Pal, &v_palette[16], 16);
	VDP_CTRL_16 = 0x8500 + (0xf800 >> 9);
	VDP_CTRL_16 = 0x8B00 + 0b100;

	is_loading = 1;
}

void mmd_exec_wrapper()
{
	// this is needed since mmd_exec() is inline
	// as it turns out a jsr straight into s1's code
	// and back out makes the c runtime cranky...
	asm("movem.l d0-a6,-(sp)");
	mmd_exec();
	asm("movem.l (sp)+,d0-a6");
}

// At this point, the full IPX binary has been copies to Work RAM and all
// traces of the security code and tiny IP are gone. We can now get on with
// actually useful game code
void main()
{
  
	install_handlers();

	v_gamemode_backup = 0;
	v_zone_backup = 0;
	memset16(0, v_palette, 64);

	memset8(0, (u8 *)0x200000, 0x40000);

	do {
		MLEVEL6_VECTOR = vint_ex;

		set_up_loading_screen();

		enable_interrupts();

		u8 com_cmd = 0;
		switch (v_gamemode_backup)
		{
			case 0x8:
			case 0xc:
				switch (v_zone_backup)
				{
					case 1:
						com_cmd = MMD_LZ;
						break;
					case 2:
						com_cmd = MMD_MZ;
						break;
					case 3:
						com_cmd = MMD_SLZ;
						break;
					case 4:
						com_cmd = MMD_SYZ;
						break;
					case 5:
						com_cmd = MMD_SBZ;
						break;
					case 6:
						com_cmd = MMD_ENDING;
						break;
					case 7:
						com_cmd = MMD_SS;
						break;
					default:
						com_cmd = MMD_GHZ;
						break;
				}
				break;
			case 0x10:
				com_cmd = MMD_SS;
				break;
			case 0x14:
				com_cmd = MMD_CONTINUE;
				break;
			case 0x18:
				com_cmd = MMD_ENDING;
				break;
			case 0x1c:
				com_cmd = MMD_CREDITS;
				break;
			default:
				com_cmd = MMD_TITLE;
				break;
		}
		sync_with_sub();
		wait_on_cd_command(1, com_cmd);

		// Sub CPU side work is complete and the MMD should now be in 2M Word RAM
		// Run it!
		disable_interrupts();
		is_loading = 0;
		frame_counter = 0;
		v_lastlamp = 0;
		v_undef_obj_id = 0xff;
		v_undef_gm_id = 0xff;
		// v_use_cd_audio = 1;
		mmd_exec_wrapper();
		disable_interrupts();

		sync_with_sub();

		if (v_undef_obj_id != 0xff)
		{
			undef_obj_error(v_undef_obj_id);
		}
		if (v_undef_gm_id != 0xff)
		{
			undef_gm_error(v_undef_gm_id);
		}
		memcpy16(v_palette_wram, v_palette, 64);
		v_gamemode_backup = v_gamemode;
		v_zone_backup = v_zone;
	} while (1);
}
