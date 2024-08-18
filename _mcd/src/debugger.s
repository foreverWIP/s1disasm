# ===========================================================================
# Copyright (C) 2011-2018 by flamewing
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
# OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
# ===========================================================================

	.include "kosinski.s"

# For all the "unhandled" vectors.
ErrorTrap:
	nop
	nop
	bra.s	ErrorTrap

# These get called from the binary blob. Do not edit them, or move them
# relative to the binary blobs below.
	jmp	(KosDec).l
	/* jmp	(EniDec).l */
	jmp	(0x000330).l

# This is the terminal code and graphics, plus the disassembler and the plane
# mappings for the debugger.
	.incbin "debuggerblob/Part1.bin"

.equ WHITE, 0<<13
.equ BLUE , 1<<13
.equ RED  , 2<<13
.equ GREEN, 3<<13
# Strings are word arrays: length followed by characters. You can change the
# length, but do NOT change the number of characters! The wasted space is the
# price to pay for a binary blob...
# The high byte of each word used for a character is the palette line to use:
HackerName:
	dc.w 11
	dc.w WHITE|'Y',	 WHITE|'o',	 WHITE|'u',	 WHITE|'r',	 WHITE|' ',	 WHITE|'N'
	dc.w WHITE|'a',	 WHITE|'m',	 WHITE|'e',	 WHITE|' ',	 WHITE|' '
	.align 2
EMailmsg:
	dc.w 33
	dc.w BLUE|'y',	BLUE|'o',	BLUE|'u',	BLUE|'r',	BLUE|'.',	BLUE|'e'
	dc.w BLUE|'m',	BLUE|'a',	BLUE|'i',	BLUE|'l',	BLUE|'@',	BLUE|'s'
	dc.w BLUE|'e',	BLUE|'r',	BLUE|'v',	BLUE|'e',	BLUE|'r',	BLUE|'.'
	dc.w BLUE|'d',	BLUE|'o',	BLUE|'m',	BLUE|'a',	BLUE|'i',	BLUE|'n'
	dc.w BLUE|' ',	BLUE|' ',	BLUE|' ',	BLUE|' ',	BLUE|' ',	BLUE|' '
	dc.w BLUE|' ',	BLUE|' ',	BLUE|' '
	.align 2

# Do not move or add padding between the code that follows. The debugger is
# split into these many parts because asm68k sucks.
Debugger_BusErrorMsg:
	.incbin "debuggerblob/Part2.bin"

	.global Debugger_BusError
Debugger_BusError:
	.incbin "debuggerblob/Part3.bin"

	.global Debugger_AddressError
Debugger_AddressError:
	.incbin "debuggerblob/Part4.bin"

	.global Debugger_TraceError
Debugger_TraceError:
	.incbin "debuggerblob/Part5.bin"

	.global Debugger_SpuriousException
Debugger_SpuriousException:
	.incbin "debuggerblob/Part6.bin"

	.global Debugger_ZeroDivideError
Debugger_ZeroDivideError:
	.incbin "debuggerblob/Part7.bin"

	.global Debugger_CHKExceptionError
Debugger_CHKExceptionError:
	.incbin "debuggerblob/Part8.bin"

	.global Debugger_TRAPVError
Debugger_TRAPVError:
	.incbin "debuggerblob/Part9.bin"

	.global Debugger_IllegalInstrError
Debugger_IllegalInstrError:
	.incbin "debuggerblob/PartA.bin"

	.global Debugger_PrivilegeViolation
Debugger_PrivilegeViolation:
	.incbin "debuggerblob/PartB.bin"

	.global Debugger_LineAEmulation
Debugger_LineAEmulation:
	.incbin "debuggerblob/PartC.bin"

	.global Debugger_LineFEmulation
Debugger_LineFEmulation:
	.incbin "debuggerblob/PartD.bin"

	.global Debugger_TrapVector
Debugger_TrapVector:
	.incbin "debuggerblob/PartE.bin"

# Edit this to something sensible. One suggestion is the SVN revision.
RevisionNumber:
	dc.w	1
	.incbin "debuggerblob/PartF.bin"

