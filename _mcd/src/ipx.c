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

#define v_spritetablebuffer ((Sprite*) 0xFFF800)
#define v_palette ((u16*) 0xFFFB00)

static u32 frame_counter = 0;
static u8 cur_sonic_anim_index = 0;
static u8 is_loading = 0;

#define v_gamemode (*((u8*)0x23F600))
static u8 v_gamemode_backup;
#define v_zone (*((u8*)0x23FE10))
static u8 v_zone_backup;
#define v_lastlamp (*((u16*)0x23FE30))
#define v_use_cd_audio (*((u8*)0x23CAE4))
#define v_undef_obj_id (*((u8*)0x23CAE5))
#define v_undef_gm_id (*((u8*)0x23CAE6))
#define v_vbla_routine (*((u8*)0xFFF62A))
#define v_should_quit_module (*((u8*)0x23CAF0))

extern u8* Loading_Sonic_Art, Loading_Sonic_Art_end;
extern u16* Loading_Sonic_Map;
extern u16* Loading_Sonic_Pal, Loading_Sonic_Pal_end;

const u16 Loading_Sonic_Art_VRAM_Pos = 0x4000;

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
		v_spritetablebuffer[next_sprite].pos_y = (u16)(ypos + 128 + 180);
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

__attribute__((interrupt)) void vint_ex()
{
	asm("bset.b #0, (0xA12000).l");
	if (is_loading)
	{
		cur_sonic_anim_index = (frame_counter >> 4) & 1;
		set_sonic_frame(cur_sonic_anim_index + 3);

		blib_dma_xfer(VDPPTR(0) | CRAM_W, v_palette, 128 >> 1);
		blib_dma_xfer(VDPPTR(0xF800), v_spritetablebuffer, 0x280 >> 1);
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

void set_up_loading_screen()
{
	enable_debug_output();
	blib_dma_fill_clear(VDPPTR(0xB800), (0x10000 - 0xB800) >> 1);

	blib_dma_xfer(VDPPTR(Loading_Sonic_Art_VRAM_Pos), &Loading_Sonic_Art, 0x6b60 >> 1);
	memcpy8(&Loading_Sonic_Pal, &v_palette[16], 32);
	VDP_CTRL_16 = 0x8500+(0xf800>>9);

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
	/**(volatile u32*)(_MADRERR+2) = Debugger_AddressError;
	*(volatile u32*)(_MDIVERR+2) = Debugger_ZeroDivideError;
	*(volatile u32*)(_MONKERR+2) = Debugger_CHKExceptionError;
	*(volatile u32*)(_MTRPERR+2) = Debugger_TRAPVError;
  	*(volatile u32*)(_MSPVERR+2) = Debugger_PrivilegeViolation;
	*(volatile u32*)(_MTRACE+2) = Debugger_TraceError;
	*(volatile u32*)(_MNOCOD0+2) = Debugger_LineAEmulation;
	*(volatile u32*)(_MNOCOD1+2) = Debugger_LineFEmulation;*/
	install_handlers();

	v_gamemode_backup = 0;
	v_zone_backup = 0;

	memset8(0, (u8*)0x200000, 0x40000);

	do
	{
		MLEVEL6_VECTOR = vint_ex;

		set_up_loading_screen();

		enable_interrupts();

		// In this example, we have the command for the Sub CPU stored in COMCMD0
		// and the command argument in COMCMD1. Command 1 will be "load a file"
		// and the argument will be the ID for that file, which is defined in
		// the SPX
		// Set the argument first
		u8 com_cmd = 0;
		switch (v_gamemode_backup)
		{
			case 0x8:
			case 0xc:
				switch (v_zone_backup)
				{
					case 1:
						print_msg("Requesting LZ\xff", 0, 0);
						com_cmd = MMD_LZ;
						break;
					case 2:
						print_msg("Requesting MZ\xff", 0, 0);
						com_cmd = MMD_MZ;
						break;
					case 3:
						print_msg("Requesting SLZ\xff", 0, 0);
						com_cmd = MMD_SLZ;
						break;
					case 4:
						print_msg("Requesting SYZ\xff", 0, 0);
						com_cmd = MMD_SYZ;
						break;
					case 5:
						print_msg("Requesting SBZ\xff", 0, 0);
						com_cmd = MMD_SBZ;
						break;
					case 6:
						print_msg("Requesting LZ\xff", 0, 0);
						com_cmd = MMD_ENDING;
						break;
					case 7:
						print_msg("Requesting Special Stage\xff", 0, 0);
						com_cmd = MMD_SS;
						break;
					default:
						print_msg("Requesting GHZ\xff", 0, 0);
						com_cmd = MMD_GHZ;
						break;
				}
				break;
			case 0x10:
				print_msg("Requesting Special Stage\xff", 0, 0);
				com_cmd = MMD_SS;
				break;
			case 0x14:
				print_msg("Requesting continue\xff", 0, 0);
				com_cmd = MMD_CONTINUE;
				break;
			case 0x18:
				print_msg("Requesting ending\xff", 0, 0);
				com_cmd = MMD_ENDING;
				break;
			case 0x1c:
				print_msg("Requesting credits\xff", 0, 0);
				com_cmd = MMD_CREDITS;
				break;
			default:
				print_msg("Requesting title\xff", 0, 0);
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
		v_should_quit_module = 0;
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
		v_gamemode_backup = v_gamemode;
		v_zone_backup = v_zone;
	} while (1);
}
