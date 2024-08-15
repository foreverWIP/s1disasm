#include "ipx.h"
#include "main/bootlib.h"
#include "main/gatearr.h"
#include "main/memmap.h"
#include "main/mmd_exec.h"
#include "main/vdp.h"
#include "system.h"
#include "memory.h"

enum {
	MMD_TITLE = 0,
	MMD_GHZ,
	MMD_MZ,
	MMD_SYZ,
	MMD_LZ,
	MMD_SLZ,
	MMD_SBZ,
	MMD_FZ,
	MMD_SS,
	MMD_CONTINUE,
	MMD_ENDING,
	MMD_CREDITS,
};

static const u32 BusError = 0x201E8A;
static const u32 AddressError = 0x201EA4;
static const u32 TraceError = 0x201EBE;
static const u32 SpuriousException = 0x201EDA;
static const u32 ZeroDivideError = 0x201EF6;
static const u32 CHKExceptionError = 0x201F16;
static const u32 TRAPVError = 0x201F36;
static const u32 IllegalInstrError = 0x201F56;
static const u32 PrivilegeViolation = 0x201F72;
static const u32 LineAEmulation = 0x201F8E;
static const u32 LineFEmulation = 0x201FAA;
static const u32 TrapVector = 0x201FC6;
static const u32 HBlank = 0x2026A0;

static volatile u8* v_gamemode = (u8*)0x23F600;
static u8 v_gamemode_backup;
static volatile u8* v_zone = (u8*)0x23FE10;
static u8 v_zone_backup;
static volatile u8* v_act = (u8*)0x23FE11;
static u8 v_act_backup;
static volatile u8* v_should_quit_module = (u8*)0x23CAE4;

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

// At this point, the full IPX binary has been copies to Work RAM and all
// traces of the security code and tiny IP are gone. We can now get on with
// actually useful game code
void main()
{
	memset8(0, (u8*)0x230000, 0x10000);

	do
	{
		MLEVEL6_VECTOR = (void *(*) ) _BLIB_VINT_HANDLER;
		*BLIB_VINT_EX_PTR = vint_ex;
		install_handlers();
		blib_load_font_defaults();
		for (u8 i = 0; i < 64; i++)
		{
			BLIB_PALETTE[i] = 0x0000;
		}
		BLIB_PALETTE[1] = 0xeee;
		BLIB_VDP_UPDATE_FLAGS |= PAL_UPDATE_MSK;
		blib_clear_tables();

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
						if (v_act_backup > 1)
						{
							print_msg("Requesting FZ\xff", 0, 0);
							com_cmd = MMD_FZ;
						}
						else
						{
							print_msg("Requesting SBZ\xff", 0, 0);
						}
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
				print_msg("Module load error\xff", 0, 2);
				while (1)
				{
					asm ("nop");
				}
			}
		} while (*GA_COMSTAT0 != 0);
		
		*(volatile u32*)(_MADRERR+2) = AddressError;
		*(volatile u32*)(_MDIVERR+2) = ZeroDivideError;
		*(volatile u32*)(_MONKERR+2) = CHKExceptionError;
		*(volatile u32*)(_MTRPERR+2) = TRAPVError;
  		*(volatile u32*)(_MSPVERR+2) = PrivilegeViolation;
		*(volatile u32*)(_MTRACE+2) = TraceError;
		*(volatile u32*)(_MNOCOD0+2) = LineAEmulation;
		*(volatile u32*)(_MNOCOD1+2) = LineFEmulation;

		// Sub CPU side work is complete and the MMD should now be in 2M Word RAM
		// Run it!
		mmd_exec();
		blib_disable_hint();
		*v_should_quit_module = 0;
		v_gamemode_backup = *v_gamemode;
		v_zone_backup = *v_zone;
		v_act_backup = *v_act;
	} while (1);
}
