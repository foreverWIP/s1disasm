; ===========================================================================
; Copyright (C) 2011-2018 by flamewing
;
; Permission to use, copy, modify, and/or distribute this software for any
; purpose with or without fee is hereby granted.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
; OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
; ===========================================================================
; For all the "unhandled" vectors.
ErrorTrap:
	nop
	nop
	bra.s	ErrorTrap

; These get called from the binary blob. Do not edit them, or move them
; relative to the binary blobs below.
	jmp	(KosDec).l
	jmp	(EniDec).l

; This is the terminal code and graphics, plus the disassembler and the plane
; mappings for the debugger.
	BINCLUDE "_debugger/Part1.bin"

WHITE EQU 0<<13
BLUE  EQU 1<<13
RED   EQU 2<<13
GREEN EQU 3<<13
; Strings are word arrays: length followed by characters. You can change the
; length, but do NOT change the number of characters! The wasted space is the
; price to pay for a binary blob...
; The high byte of each word used for a character is the palette line to use:
HackerName:
	dc.w 11
	dc.w WHITE|'A',	 WHITE|'m',	 WHITE|'y',	 WHITE|' ',	 WHITE|'F',	 WHITE|'.'
	dc.w WHITE|' ',	 WHITE|' ',	 WHITE|' ',	 WHITE|' ',	 WHITE|' '
	even
EMailmsg:
	dc.w 33
	dc.w BLUE|'a',	BLUE|'m',	BLUE|'y',	BLUE|'w',	BLUE|'r',	BLUE|'i'
	dc.w BLUE|'g',	BLUE|'h',	BLUE|'t',	BLUE|'m',	BLUE|'a',	BLUE|'i'
	dc.w BLUE|'l',	BLUE|'@',	BLUE|'p',	BLUE|'r',	BLUE|'o',	BLUE|'t'
	dc.w BLUE|'o',	BLUE|'n',	BLUE|'m',	BLUE|'a',	BLUE|'i',	BLUE|'l'
	dc.w BLUE|'.',	BLUE|'c',	BLUE|'o',	BLUE|'m',	BLUE|' ',	BLUE|' '
	dc.w BLUE|' ',	BLUE|' ',	BLUE|' '
	even

; Do not move or add padding between the code that follows. The debugger is
; split into these many parts because asm68k sucks.
BusErrorMsg:
	BINCLUDE "_debugger/Part2.bin"

BusError:
	BINCLUDE "_debugger/Part3.bin"

AddressError:
	BINCLUDE "_debugger/Part4.bin"

TraceError:
	BINCLUDE "_debugger/Part5.bin"

SpuriousException:
	BINCLUDE "_debugger/Part6.bin"

ZeroDivideError:
	BINCLUDE "_debugger/Part7.bin"

CHKExceptionError:
	BINCLUDE "_debugger/Part8.bin"

TRAPVError:
	BINCLUDE "_debugger/Part9.bin"

IllegalInstrError:
	BINCLUDE "_debugger/PartA.bin"

PrivilegeViolation:
	BINCLUDE "_debugger/PartB.bin"

LineAEmulation:
	BINCLUDE "_debugger/PartC.bin"

LineFEmulation:
	BINCLUDE "_debugger/PartD.bin"

TrapVector:
	BINCLUDE "_debugger/PartE.bin"

; Edit this to something sensible. One suggestion is the SVN revision.
RevisionNumber:
	dc.w	1
	BINCLUDE "_debugger/PartF.bin"

