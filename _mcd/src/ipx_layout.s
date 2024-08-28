#include "macros.s"
#include "main/memmap_def.h"

// ROM will begin at the start of Work RAM, overwriting the security code/IP
GLOBAL MODULE_ROM_ORIGIN _WRKRAM

GLOBAL MODULE_RAM_ORIGIN 0xFFA200

GLOBAL MODULE_ROM_LENGTH, MODULE_RAM_ORIGIN - MODULE_ROM_ORIGIN

GLOBAL MODULE_RAM_LENGTH, 0x200

// Finally, we must specify from where the code will actually execute, which is
// to say, to where it should be copied after being put in Word RAM by the Sub
GLOBAL MMD_DEST _WRKRAM
