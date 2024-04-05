		tst.l	(z80_port_1_control).l ; test port A & B control registers
		bne.s	PortA_Ok
		tst.w	(z80_expansion_control).l ; test port C control register

PortA_Ok:
		bne.s	SkipSetup ; Skip the VDP and Z80 setup code if port A, B or C is ok...?
		lea	SetupValues(pc),a5	; Load setup values array address.
		movem.w	(a5)+,d5-d7
		movem.l	(a5)+,a0-a4
		move.b	-$10FF(a1),d0	; get hardware version (from $A10001)
		andi.b	#$F,d0
		beq.s	SkipSecurity	; If the console has no TMSS, skip the security stuff.
		move.l	#'SEGA',$2F00(a1) ; move "SEGA" to TMSS register ($A14000)

SkipSecurity:
		move.w	(a4),d0	; clear write-pending flag in VDP to prevent issues if the 68k has been reset in the middle of writing a command long word to the VDP.
		moveq	#0,d0	; clear d0
		movea.l	d0,a6	; clear a6
		move.l	a6,usp	; set usp to $0

		moveq	#$17,d1
VDPInitLoop:
		move.b	(a5)+,d5	; add $8000 to value
		move.w	d5,(a4)		; move value to	VDP register
		add.w	d7,d5		; next register
		dbf	d1,VDPInitLoop
		
		move.l	(a5)+,(a4)
		move.w	d0,(a3)		; clear	the VRAM
		if NeoGeo=0
		move.w	d7,(a1)		; stop the Z80
		move.w	d7,(a2)		; reset	the Z80

WaitForZ80:
		btst	d0,(a1)		; has the Z80 stopped?
		bne.s	WaitForZ80	; if not, branch

		moveq	#$25,d2
Z80InitLoop:
		move.b	(a5)+,(a0)+
		dbf	d2,Z80InitLoop
		
		move.w	d0,(a2)
		move.w	d0,(a1)		; start	the Z80
		move.w	d7,(a2)		; reset	the Z80
		endif

ClrRAMLoop:
		move.l	d0,-(a6)	; clear 4 bytes of RAM
		dbf	d6,ClrRAMLoop	; repeat until the entire RAM is clear
		move.l	(a5)+,(a4)	; set VDP display mode and increment mode
		move.l	(a5)+,(a4)	; set VDP to CRAM write

		moveq	#$1F,d3	; set repeat times
ClrCRAMLoop:
		move.l	d0,(a3)	; clear 2 palettes
		dbf	d3,ClrCRAMLoop	; repeat until the entire CRAM is clear
		move.l	(a5)+,(a4)	; set VDP to VSRAM write

		moveq	#$13,d4
ClrVSRAMLoop:
		move.l	d0,(a3)	; clear 4 bytes of VSRAM.
		dbf	d4,ClrVSRAMLoop	; repeat until the entire VSRAM is clear
		moveq	#3,d5

		if NeoGeo=0
PSGInitLoop:
		move.b	(a5)+,$11(a3)	; reset	the PSG
		dbf	d5,PSGInitLoop	; repeat for other channels
		move.w	d0,(a2)
		endif
		movem.l	(a6),d0-a6	; clear all registers
		disable_ints

SkipSetup:
		bra.s	GameProgram	; begin game

; ===========================================================================
SetupValues:	dc.w $8000		; VDP register start number
		dc.w $3FFF		; size of RAM/4
		dc.w $100		; VDP register diff

		if NeoGeo=0
		dc.l z80_ram		; start	of Z80 RAM
		dc.l z80_bus_request	; Z80 bus request
		dc.l z80_reset		; Z80 reset
		else
		dc.l 0
		dc.l 0
		dc.l 0
		endif
		dc.l vdp_data_port	; VDP data
		dc.l vdp_control_port	; VDP control

		dc.b 4			; VDP $80 - 8-colour mode
		dc.b $14		; VDP $81 - Megadrive mode, DMA enable
		dc.b ($C000>>10)	; VDP $82 - foreground nametable address
		dc.b ($F000>>10)	; VDP $83 - window nametable address
		dc.b ($E000>>13)	; VDP $84 - background nametable address
		dc.b ($D800>>9)		; VDP $85 - sprite table address
		dc.b 0			; VDP $86 - unused
		dc.b 0			; VDP $87 - background colour
		dc.b 0			; VDP $88 - unused
		dc.b 0			; VDP $89 - unused
		dc.b 255		; VDP $8A - HBlank register
		dc.b 0			; VDP $8B - full screen scroll
		dc.b $81		; VDP $8C - 40 cell display
		dc.b ($DC00>>10)	; VDP $8D - hscroll table address
		dc.b 0			; VDP $8E - unused
		dc.b 1			; VDP $8F - VDP increment
		dc.b 1			; VDP $90 - 64 cell hscroll size
		dc.b 0			; VDP $91 - window h position
		dc.b 0			; VDP $92 - window v position
		dc.w $FFFF		; VDP $93/94 - DMA length
		dc.w 0			; VDP $95/96 - DMA source
		dc.b $80		; VDP $97 - DMA fill VRAM
		dc.l $40000080		; VRAM address 0

		if NeoGeo=0
	; Z80 instructions (not the sound driver; that gets loaded later)
    if (*)+$26 < $10000
    save
    CPU Z80 ; start assembling Z80 code
    phase 0 ; pretend we're at address 0
	xor	a	; clear a to 0
	ld	bc,((z80_ram_end-z80_ram)-zStartupCodeEndLoc)-1 ; prepare to loop this many times
	ld	de,zStartupCodeEndLoc+1	; initial destination address
	ld	hl,zStartupCodeEndLoc	; initial source address
	ld	sp,hl	; set the address the stack starts at
	ld	(hl),a	; set first byte of the stack to 0
	ldir		; loop to fill the stack (entire remaining available Z80 RAM) with 0
	pop	ix	; clear ix
	pop	iy	; clear iy
	ld	i,a	; clear i
	ld	r,a	; clear r
	pop	de	; clear de
	pop	hl	; clear hl
	pop	af	; clear af
	ex	af,af'	; swap af with af'
	exx		; swap bc/de/hl with their shadow registers too
	pop	bc	; clear bc
	pop	de	; clear de
	pop	hl	; clear hl
	pop	af	; clear af
	ld	sp,hl	; clear sp
	di		; clear iff1 (for interrupt handler)
	im	1	; interrupt handling mode = 1
	ld	(hl),0E9h ; replace the first instruction with a jump to itself
	jp	(hl)	  ; jump to the first instruction (to stay there forever)
zStartupCodeEndLoc:
    dephase ; stop pretending
	restore
    padding off ; unfortunately our flags got reset so we have to set them again...
    else ; due to an address range limitation I could work around but don't think is worth doing so:
	message "Warning: using pre-assembled Z80 startup code."
	dc.w $AF01,$D91F,$1127,$0021,$2600,$F977,$EDB0,$DDE1,$FDE1,$ED47,$ED4F,$D1E1,$F108,$D9C1,$D1E1,$F1F9,$F3ED,$5636,$E9E9
    endif
		else
	dc.w $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		endif

		dc.w $8104		; VDP display mode
		dc.w $8F02		; VDP increment
		dc.l $C0000000		; CRAM write mode
		dc.l $40000010		; VSRAM address 0

		dc.b $9F, $BF, $DF, $FF	; values for PSG channel volumes
; ===========================================================================

GameProgram:
		tst.w	(vdp_control_port).l
			if NeoGeo=0
		btst	#6,(z80_expansion_control+1).l
		beq.s	CheckSumCheck
		cmpi.l	#'init',v_init ; has checksum routine already run?
		beq.w	GameInit	; if yes, branch

CheckSumCheck:
		movea.l	#EndOfHeader,a0	; start	checking bytes after the header	($200)
		movea.l	#RomEndLoc,a1	; stop at end of ROM
		move.l	(a1),d0
		moveq	#0,d1

.loop:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bhs.s	.loop
		movea.l	#Checksum,a1	; read the checksum
		cmp.w	(a1),d1		; compare checksum in header to ROM
		bne.w	CheckSumError	; if they don't match, branch

			endif
CheckSumOk: