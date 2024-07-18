; ---------------------------------------------------------------------------
; Sega screen
; ---------------------------------------------------------------------------

GM_Sega:
		move.b	#bgm_Stop,d0
		jsr		(PlaySound_Special).l ; stop music
		jsr		(ClearPLC).l
		jsr		(PaletteFadeOut).l
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; use 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$8700,(a6)	; set background colour (palette entry 0)
		move.w	#$8B00,(a6)	; full-screen vertical scrolling
		clr.b	(f_wtr_state).w
		disable_ints
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		jsr		(ClearScreen).l
		locVRAM	ArtTile_Sega_Tiles*tile_size
		lea	(Nem_SegaLogo).l,a0 ; load Sega	logo patterns
		jsr		(NemDec).l
		lea	(v_256x256&$FFFFFF).l,a1
		lea	(Eni_SegaLogo).l,a0 ; load Sega	logo mappings
		move.w	#make_art_tile(ArtTile_Sega_Tiles,0,FALSE),d0
		jsr		(EniDec).l

		copyTilemap	v_256x256&$FFFFFF,vram_bg+$510,24,8
		copyTilemap	(v_256x256+24*8*2)&$FFFFFF,vram_fg,40,28

		if Revision<>0
			tst.b   (v_megadrive).w	; is console Japanese?
			bmi.s   .loadpal
			copyTilemap	(v_256x256+$A40)&$FFFFFF,vram_fg+$53A,3,2 ; hide "TM" with a white rectangle
		endif

.loadpal:
		moveq	#palid_SegaBG,d0
		jsr		(PalLoad)	; load Sega logo palette
		move.w	#-$A,(v_pcyc_num).w
		move.w	#0,(v_pcyc_time).w
		move.w	#0,(v_pal_buffer+$12).w
		move.w	#0,(v_pal_buffer+$10).w
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l

Sega_WaitPal:
		move.b	#2,(v_vbla_routine).w
		jsr		(WaitForVBla).l
		bsr.w	PalCycle_Sega
		bne.s	Sega_WaitPal

		move.b	#sfx_Sega,d0
		jsr		PlaySound_Special	; play "SEGA" sound
		move.b	#$14,(v_vbla_routine).w
		jsr		(WaitForVBla).l
		move.w	#$1E,(v_demolength).w

Sega_WaitEnd:
		move.b	#2,(v_vbla_routine).w
		jsr		(WaitForVBla).l
		tst.w	(v_demolength).w
		beq.s	Sega_GotoTitle
		andi.b	#btnStart,(v_jpadpress1).w ; is Start button pressed?
		beq.s	Sega_WaitEnd	; if not, branch

Sega_GotoTitle:
		move.b	#id_Title,(v_gamemode).w ; go to title screen
		rts	
; ===========================================================================

; ---------------------------------------------------------------------------
; Palette cycling routine - Sega logo
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_Sega:
		tst.b	(v_pcyc_time+1).w
		bne.s	loc_206A
		lea	(v_palette+$20).w,a1
		lea	(Pal_Sega1).l,a0
		moveq	#5,d1
		move.w	(v_pcyc_num).w,d0

loc_2020:
		bpl.s	loc_202A
		addq.w	#2,a0
		subq.w	#1,d1
		addq.w	#2,d0
		bra.s	loc_2020
; ===========================================================================

loc_202A:
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_2034
		addq.w	#2,d0

loc_2034:
		cmpi.w	#$60,d0
		bhs.s	loc_203E
		move.w	(a0)+,(a1,d0.w)

loc_203E:
		addq.w	#2,d0
		dbf	d1,loc_202A

		move.w	(v_pcyc_num).w,d0
		addq.w	#2,d0
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_2054
		addq.w	#2,d0

loc_2054:
		cmpi.w	#$64,d0
		blt.s	loc_2062
		move.w	#$401,(v_pcyc_time).w
		moveq	#-$C,d0

loc_2062:
		move.w	d0,(v_pcyc_num).w
		moveq	#1,d0
		rts	
; ===========================================================================

loc_206A:
		subq.b	#1,(v_pcyc_time).w
		bpl.s	loc_20BC
		move.b	#4,(v_pcyc_time).w
		move.w	(v_pcyc_num).w,d0
		addi.w	#$C,d0
		cmpi.w	#$30,d0
		blo.s	loc_2088
		moveq	#0,d0
		rts	
; ===========================================================================

loc_2088:
		move.w	d0,(v_pcyc_num).w
		lea	(Pal_Sega2).l,a0
		lea	(a0,d0.w),a0
		lea	(v_palette+$04).w,a1
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)
		lea	(v_palette+$20).w,a1
		moveq	#0,d0
		moveq	#$2C,d1

loc_20A8:
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_20B2
		addq.w	#2,d0

loc_20B2:
		move.w	(a0),(a1,d0.w)
		addq.w	#2,d0
		dbf	d1,loc_20A8

loc_20BC:
		moveq	#1,d0
		rts	
; End of function PalCycle_Sega

; ===========================================================================

Pal_Sega1:	binclude	"palette/Sega1.bin"
Pal_Sega2:	binclude	"palette/Sega2.bin"
Pal_SegaBG:	bincludePalette	"palette/Sega Background.bin"
		if Revision=0
Nem_SegaLogo:	binclude	"artnem/Sega Logo.nem"	; large Sega logo
		even
Eni_SegaLogo:	binclude	"tilemaps/Sega Logo.eni" ; large Sega logo (mappings)
		even
		else
		rept $300
			dc.b	$FF
		endm
Nem_SegaLogo:	binclude	"artnem/Sega Logo (JP1).nem" ; large Sega logo
			even
Eni_SegaLogo:	binclude	"tilemaps/Sega Logo (JP1).eni" ; large Sega logo (mappings)
			even
		endif