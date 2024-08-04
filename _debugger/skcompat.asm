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
; A few constants
palette_line_0      =      (0<<13)
palette_line_1      =      (1<<13)
palette_line_2      =      (2<<13)
palette_line_3      =      (3<<13)
tile_mask           =      $07FF

; Remapped function names
;KosDec EQU Kos_Decomp
;EniDec EQU Eni_Decomp

; Remapped RAM locations
;Chunk_Table EQU Chunk_table
;System_Stack EQU System_stack

; VRAM constants
ArtTile_VRAM_Start                       = $0000

; simplifying macros and functions

; makes a VDP address difference
vdpCommDelta function addr,((addr&$3FFF)<<16)|((addr&$C000)>>14)

; macros to convert from tile index to art tiles, block mapping or VRAM address.
; make_art_tile function addr,pal,pri,((pri&1)<<15)|((pal&3)<<13)|(addr&tile_mask)
tiles_to_bytes function addr,((addr&$7FF)<<5)

; macro to declare an offset table
offsetTable macro {INTLABEL}
current_offset_table := __LABEL__
__LABEL__ label *
    endm

; macro to declare an entry in an offset table
offsetTableEntry macro ptr
	dc.ATTRIBUTE ptr-current_offset_table
    endm

; makes a VDP command
vdpComm function addr,type,rwd,(((type&rwd)&3)<<30)|((addr&$3FFF)<<16)|(((type&rwd)&$FC)<<2)|((addr&$C000)>>14)

; values for the type argument
VRAM = %100001
CRAM = %101011
VSRAM = %100101

; values for the rwd argument
READ = %001100
WRITE = %000111
DMA = %100111

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 4 bytes per iteration
bytesToLcnt function n,n>>2-1

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 2 bytes per iteration
bytesToWcnt function n,n>>1-1

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at x bytes per iteration
bytesToXcnt function n,x,n/x-1

dma68kToVDP macro src,addr,len,memspace
	if memspace==CRAM
	writeCRAM src,addr
	endif
	if memspace==VRAM
	writeVRAM src,addr
	endif
	endm

dmaFillVRAM macro byte,start,end
	fillVRAM byte,start,end
	endm

VDP_control_port = vdp_control_port
VDP_data_port = vdp_data_port
Chunk_Table = v_256x256
		if MMD_Enabled
System_Stack = $FFFD00
		else
System_Stack = v_systemstack
		endif
ROMEndLoc = EndOfRom