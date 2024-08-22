#include "ipx.h"
#include "main/bootlib.h"
#include "main/gatearr.h"
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

extern u32 Debugger_BusError;
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
extern u32 Debugger_TrapVector;

static volatile u8* v_gamemode = (u8*)0x23F600;
static u8 v_gamemode_backup;
static volatile u8* v_zone = (u8*)0x23FE10;
static u8 v_zone_backup;
static volatile u8* v_should_quit_module = (u8*)0x23CAE4;
static volatile u16* v_lastlamp = (u16*)0x23FE30;
static volatile u8* v_use_cd_audio = (u8*)0x23CAE4;
static volatile u8* v_undef_obj_id = (u8*)0x23CAE5;

void vint_ex()
{
	
}

void hint_ex()
{

}

static void print_msg(const char* msg, u8 x, u8 y)
{
	blib_print(msg, (VDPPTR(NMT_POS_PLANE(x, y, _BLIB_PLANEA_ADDR)) | VRAM_W));
	blib_vint_wait(0);
}

void enable_debug_output()
{
	blib_clear_tables();
	blib_load_font_defaults();
	for (u8 i = 0; i < 64; i++)
	{
		BLIB_PALETTE[i] = 0x0000;
	}
	BLIB_PALETTE[1] = 0xeee;
	MLEVEL6_VECTOR = (void *(*) ) _BLIB_VINT_HANDLER;
	*BLIB_VINT_EX_PTR = vint_ex;
	BLIB_VDP_UPDATE_FLAGS |= PAL_UPDATE_MSK;
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

// At this point, the full IPX binary has been copies to Work RAM and all
// traces of the security code and tiny IP are gone. We can now get on with
// actually useful game code
void main()
{
	*(volatile u32*)(_MADRERR+2) = Debugger_AddressError;
	*(volatile u32*)(_MDIVERR+2) = Debugger_ZeroDivideError;
	*(volatile u32*)(_MONKERR+2) = Debugger_CHKExceptionError;
	*(volatile u32*)(_MTRPERR+2) = Debugger_TRAPVError;
  	*(volatile u32*)(_MSPVERR+2) = Debugger_PrivilegeViolation;
	*(volatile u32*)(_MTRACE+2) = Debugger_TraceError;
	*(volatile u32*)(_MNOCOD0+2) = Debugger_LineAEmulation;
	*(volatile u32*)(_MNOCOD1+2) = Debugger_LineFEmulation;

	v_gamemode_backup = 0;
	v_zone_backup = 0;

	memset8(0, (u8*)0x200000, 0x40000);

	for (u8 i = 0; i < 64; i++)
	{
		BLIB_PALETTE[i] = 0x0000;
	}

	do
	{
		MLEVEL6_VECTOR = (void *(*) ) _BLIB_VINT_HANDLER;
		*BLIB_VINT_EX_PTR = vint_ex;

		blib_vint_wait(0);

		// make sure that the Sub CPU controls 2M Word RAM before we request the
		// file
		grant_2m();

		// In this example, we have the command for the Sub CPU stored in COMCMD0
		// and the command argument in COMCMD1. Command 1 will be "load a file"
		// and the argument will be the ID for that file, which is defined in
		// the SPX
		// Set the argument first
		u8 com_cmd = 0;
		switch (v_gamemode_backup)
		{
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
		*GA_COMCMD1 = com_cmd;

		// then set the command
		*GA_COMCMD0 = 1;

		// wait for acknowledgment from the Sub CPU that the command was
		// received and will be acted on
		print_msg("Waiting for acknowledge\xff", 0, 1);
		do
		{
			// the NOP is so GCC doesn't optimize the loop away
			// though since comstat is marked volatile it should be fine...
			asm ("nop");
			if (*GA_COMSTAT0 == 0xff)
			{
				enable_debug_output();
				print_msg("Acknowledge error      \xff", 0, 1);
				while (1)
				{
					asm ("nop");
				}
			}
		} while (*GA_COMSTAT0 == 0);

		// reset the command to none (0) once we have the acknowledgment
		*GA_COMCMD0 = 0;
		print_msg("Acknowledged           \xff", 0, 1);

		// the Sub CPU side work will be complete when COMSTAT0 returns to 0
		print_msg("Loading module   \xff", 0, 2);
		do
		{
			asm ("nop");
			if (*GA_COMSTAT0 == 0xff)
			{
				enable_debug_output();
				print_msg("Module load error\xff", 0, 2);
				while (1)
				{
					asm ("nop");
				}
			}
		} while (*GA_COMSTAT0 != 0);

		// Sub CPU side work is complete and the MMD should now be in 2M Word RAM
		// Run it!
		*v_lastlamp = 0;
		*v_undef_obj_id = 0xff;
		// *v_use_cd_audio = 1;
		mmd_exec();
		blib_disable_hint();
		// wait for the playing flag to clear
		while (*GA_COMFLAGS_SUB & 0x80)
			;

		while (*GA_COMSTAT0 == 0)
			;
		*GA_COMCMD0 = 0;
		while (*GA_COMSTAT0 != 0)
			;
		if (*v_undef_obj_id != 0xff)
		{
			undef_obj_error(*v_undef_obj_id);
		}
		*v_should_quit_module = 0;
		v_gamemode_backup = *v_gamemode;
		v_zone_backup = *v_zone;
	} while (1);
}
