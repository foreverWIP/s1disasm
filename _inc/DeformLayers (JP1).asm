; ---------------------------------------------------------------------------
; Background layer deformation subroutines
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DeformLayers:
		tst.b	f_nobgscroll
		beq.s	.bgscroll
		rts	
; ===========================================================================

	.bgscroll:
		clr.w	v_fg_scroll_flags
		clr.w	v_bg1_scroll_flags
		clr.w	v_bg2_scroll_flags
		clr.w	v_bg3_scroll_flags
		bsr.w	ScrollHoriz
		bsr.w	ScrollVertical
		bsr.w	DynamicLevelEvents
		move.w	v_screenposy,v_scrposy_vdp
		move.w	v_bgscreenposy,v_bgscrposy_vdp
		moveq	#0,d0
		move.b	v_zone,d0
		add.w	d0,d0
		move.w	Deform_Index(pc,d0.w),d0
		jmp	Deform_Index(pc,d0.w)
; End of function DeformLayers

; ===========================================================================
; ---------------------------------------------------------------------------
; Offset index for background layer deformation	code
; ---------------------------------------------------------------------------
Deform_Index:	dc.w Deform_GHZ-Deform_Index, Deform_LZ-Deform_Index
		dc.w Deform_MZ-Deform_Index, Deform_SLZ-Deform_Index
		dc.w Deform_SYZ-Deform_Index, Deform_SBZ-Deform_Index
		zonewarning Deform_Index,2
		dc.w Deform_GHZ-Deform_Index
; ---------------------------------------------------------------------------
; Green	Hill Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_GHZ:
	; block 3 - distant mountains
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d6
		bsr.w	BGScroll_Block3
	; block 2 - hills & waterfalls
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#0,d6
		bsr.w	BGScroll_Block2
	; calculate Y position
		lea	v_hscrolltablebuffer,a1
		move.w	v_screenposy,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$20,d0
		bpl.s	.limitY
		moveq	#0,d0
	.limitY:
		move.w	d0,d4
		move.w	d0,v_bgscrposy_vdp
		move.w	v_screenposx,d0
		cmpi.b	#id_Title,v_gamemode
		bne.s	.notTitle
		moveq	#0,d0	; reset foreground position in title screen
	.notTitle:
		neg.w	d0
		swap	d0
	; auto-scroll clouds
		lea	v_bgscroll_buffer,a2
		addi.l	#$10000,(a2)+
		addi.l	#$C000,(a2)+
		addi.l	#$8000,(a2)+
	; calculate background scroll	
		move.w	v_bgscroll_buffer,d0
		add.w	v_bg3screenposx,d0
		neg.w	d0
		move.w	#$1F,d1
		sub.w	d4,d1
		bcs.s	.gotoCloud2
	.cloudLoop1:		; upper cloud (32px)
		move.l	d0,(a1)+
		dbf	d1,.cloudLoop1

	.gotoCloud2:
		move.w	v_bgscroll_buffer+4,d0
		add.w	v_bg3screenposx,d0
		neg.w	d0
		move.w	#$F,d1
	.cloudLoop2:		; middle cloud (16px)
		move.l	d0,(a1)+
		dbf	d1,.cloudLoop2

		move.w	v_bgscroll_buffer+8,d0
		add.w	v_bg3screenposx,d0
		neg.w	d0
		move.w	#$F,d1
	.cloudLoop3:		; lower cloud (16px)
		move.l	d0,(a1)+
		dbf	d1,.cloudLoop3

		move.w	#$2F,d1
		move.w	v_bg3screenposx,d0
		neg.w	d0
	.mountainLoop:		; distant mountains (48px)
		move.l	d0,(a1)+
		dbf	d1,.mountainLoop

		move.w	#$27,d1
		move.w	v_bg2screenposx,d0
		neg.w	d0
	.hillLoop:			; hills & waterfalls (40px)
		move.l	d0,(a1)+
		dbf	d1,.hillLoop

		move.w	v_bg2screenposx,d0
		move.w	v_screenposx,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$47,d1
		add.w	d4,d1
	.waterLoop:			; water deformation
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,.waterLoop
		rts
; End of function Deform_GHZ

; ---------------------------------------------------------------------------
; Labyrinth Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_LZ:
	; plain background scroll
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	v_scrshifty,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	BGScroll_XY

		move.w	v_bgscreenposy,v_bgscrposy_vdp
		lea	(Lz_Scroll_Data).l,a3
		lea	(Drown_WobbleData).l,a2
		move.b	v_lz_deform,d2
		move.b	d2,d3
		addi.w	#$80,v_lz_deform

		add.w	v_bgscreenposy,d2
		andi.w	#$FF,d2
		add.w	v_screenposy,d3
		andi.w	#$FF,d3
		lea	v_hscrolltablebuffer,a1
		move.w	#$DF,d1
		move.w	v_screenposx,d0
		neg.w	d0
		move.w	d0,d6
		swap	d0
		move.w	v_bgscreenposx,d0
		neg.w	d0
		move.w	v_waterpos1,d4
		move.w	v_screenposy,d5
	; write normal scroll before meeting water position
	.normalLoop:		
		cmp.w	d4,d5	; is current y >= water y?
		bge.s	.underwaterLoop	; if yes, branch
		move.l	d0,(a1)+
		addq.w	#1,d5
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,.normalLoop
		rts
	; apply water deformation when underwater
	.underwaterLoop:
		move.b	(a3,d3.w),d4
		ext.w	d4
		add.w	d6,d4
		move.w	d4,(a1)+
		move.b	(a2,d2.w),d4
		ext.w	d4
		add.w	d0,d4
		move.w	d4,(a1)+
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,.underwaterLoop
		rts

Lz_Scroll_Data:
		dc.b $01,$01,$02,$02,$03,$03,$03,$03,$02,$02,$01,$01,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $FF,$FF,$FE,$FE,$FD,$FD,$FD,$FD,$FE,$FE,$FF,$FF,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $01,$01,$02,$02,$03,$03,$03,$03,$02,$02,$01,$01,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; End of function Deform_LZ

; ---------------------------------------------------------------------------
; Marble Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_MZ:
	; block 1 - dungeon interior
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#6,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#2,d6
		bsr.w	BGScroll_Block1
	; block 3 - mountains
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#6,d4
		moveq	#6,d6
		bsr.w	BGScroll_Block3
	; block 2 - bushes & antique buildings
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#4,d6
		bsr.w	BGScroll_Block2
	; calculate y-position of background
		move.w	#$200,d0	; start with 512px, ignoring 2 chunks
		move.w	v_screenposy,d1
		subi.w	#$1C8,d1	; 0% scrolling when y <= 56px 
		bcs.s	.noYscroll
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0
	.noYscroll:
		move.w	d0,v_bg2screenposy
		move.w	d0,v_bg3screenposy
		bsr.w	BGScroll_YAbsolute
		move.w	v_bgscreenposy,v_bgscrposy_vdp
	; do something with redraw flags
		move.b	v_bg1_scroll_flags,d0
		or.b	v_bg2_scroll_flags,d0
		or.b	d0,v_bg3_scroll_flags
		clr.b	v_bg1_scroll_flags
		clr.b	v_bg2_scroll_flags
	; calculate background scroll buffer
		lea	v_bgscroll_buffer,a1
		move.w	v_screenposx,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#2,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#5,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#4,d1
	.cloudLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.cloudLoop

		move.w	v_bg3screenposx,d0
		neg.w	d0
		move.w	#1,d1
	.mountainLoop:		
		move.w	d0,(a1)+
		dbf	d1,.mountainLoop

		move.w	v_bg2screenposx,d0
		neg.w	d0
		move.w	#8,d1
	.bushLoop:		
		move.w	d0,(a1)+
		dbf	d1,.bushLoop

		move.w	v_bgscreenposx,d0
		neg.w	d0
		move.w	#$F,d1
	.interiorLoop:		
		move.w	d0,(a1)+
		dbf	d1,.interiorLoop

		lea	v_bgscroll_buffer,a2
		move.w	v_bgscreenposy,d0
		subi.w	#$200,d0	; subtract 512px (unused 2 chunks)
		move.w	d0,d2
		cmpi.w	#$100,d0
		blo.s	.limitY
		move.w	#$100,d0
	.limitY:
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		bra.w	Bg_Scroll_X
; End of function Deform_MZ

; ---------------------------------------------------------------------------
; Star Light Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SLZ:
	; vertical scrolling
		move.w	v_scrshifty,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	Bg_Scroll_Y
		move.w	v_bgscreenposy,v_bgscrposy_vdp
	; calculate background scroll buffer
		lea	v_bgscroll_buffer,a1
		move.w	v_screenposx,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$1C,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#$1B,d1
	.starLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.starLoop

		move.w	d2,d0
		asr.w	#3,d0
		move.w	d0,d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	#4,d1
	.buildingLoop1:		; distant black buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop1

		move.w	d2,d0
		asr.w	#2,d0
		move.w	#4,d1
	.buildingLoop2:		; closer buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop2

		move.w	d2,d0
		asr.w	#1,d0
		move.w	#$1D,d1
	.bottomLoop:		; bottom part of background
		move.w	d0,(a1)+
		dbf	d1,.bottomLoop

		lea	v_bgscroll_buffer,a2
		move.w	v_bgscreenposy,d0
		move.w	d0,d2
		subi.w	#$C0,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
Bg_Scroll_X:
		lea	v_hscrolltablebuffer,a1
		move.w	#$E,d1
		move.w	v_screenposx,d0
		neg.w	d0
		swap	d0
		andi.w	#$F,d2
		add.w	d2,d2
		move.w	(a2)+,d0
		jmp	.pixelJump(pc,d2.w)		; skip pixels for first row
	.blockLoop:
		move.w	(a2)+,d0
	.pixelJump:		
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbf	d1,.blockLoop
		rts

; ---------------------------------------------------------------------------
; Spring Yard Zone background layer deformation	code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SYZ:
	; vertical scrolling
		move.w	v_scrshifty,d5
		ext.l	d5
		asl.l	#4,d5
		move.l	d5,d1
		asl.l	#1,d5
		add.l	d1,d5
		bsr.w	Bg_Scroll_Y
		move.w	v_bgscreenposy,v_bgscrposy_vdp
	; calculate background scroll buffer
		lea	v_bgscroll_buffer,a1
		move.w	v_screenposx,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#8,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#7,d1
	.cloudLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.cloudLoop

		move.w	d2,d0
		asr.w	#3,d0
		move.w	#4,d1
	.mountainLoop:		
		move.w	d0,(a1)+
		dbf	d1,.mountainLoop

		move.w	d2,d0
		asr.w	#2,d0
		move.w	#5,d1
	.buildingLoop:		
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop

		move.w	d2,d0
		move.w	d2,d1
		asr.w	#1,d1
		sub.w	d1,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$E,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#$D,d1
	.bushLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.bushLoop

		lea	v_bgscroll_buffer,a2
		move.w	v_bgscreenposy,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		bra.w	Bg_Scroll_X
; End of function Deform_SYZ

; ---------------------------------------------------------------------------
; Scrap	Brain Zone background layer deformation	code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SBZ:
		tst.b	v_act
		bne.w	Deform_SBZ2
	; block 1 - lower black buildings
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#2,d6
		bsr.w	BGScroll_Block1
	; block 3 - distant brown buildings
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#6,d4
		moveq	#6,d6
		bsr.w	BGScroll_Block3
	; block 2 - upper black buildings
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#4,d6
		bsr.w	BGScroll_Block2
	; vertical scrolling
		moveq	#0,d4
		move.w	v_scrshifty,d5
		ext.l	d5
		asl.l	#5,d5
		bsr.w	BGScroll_YRelative

		move.w	v_bgscreenposy,d0
		move.w	d0,v_bg2screenposy
		move.w	d0,v_bg3screenposy
		move.w	d0,v_bgscrposy_vdp
		move.b	v_bg1_scroll_flags,d0
		or.b	v_bg3_scroll_flags,d0
		or.b	d0,v_bg2_scroll_flags
		clr.b	v_bg1_scroll_flags
		clr.b	v_bg3_scroll_flags
	; calculate background scroll buffer
		lea	v_bgscroll_buffer,a1
		move.w	v_screenposx,d2
		neg.w	d2
		asr.w	#2,d2
		move.w	d2,d0
		asr.w	#1,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#4,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#3,d1
	.cloudLoop:		
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,.cloudLoop

		move.w	v_bg3screenposx,d0
		neg.w	d0
		move.w	#9,d1
	.buildingLoop1:		; distant brown buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop1

		move.w	v_bg2screenposx,d0
		neg.w	d0
		move.w	#6,d1
	.buildingLoop2:		; upper black buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop2

		move.w	v_bgscreenposx,d0
		neg.w	d0
		move.w	#$A,d1
	.buildingLoop3:		; lower black buildings
		move.w	d0,(a1)+
		dbf	d1,.buildingLoop3
		lea	v_bgscroll_buffer,a2
		move.w	v_bgscreenposy,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		bra.w	Bg_Scroll_X
;-------------------------------------------------------------------------------
Deform_SBZ2:;loc_68A2:
	; plain background deformation
		move.w	v_scrshiftx,d4
		ext.l	d4		
		asl.l	#6,d4
		move.w	v_scrshifty,d5
		ext.l	d5
		asl.l	#5,d5
		bsr.w	BGScroll_XY
		move.w	v_bgscreenposy,v_bgscrposy_vdp
	; copy fg & bg x-position to hscroll table
		lea	v_hscrolltablebuffer,a1
		move.w	#223,d1
		move.w	v_screenposx,d0
		neg.w	d0
		swap	d0
		move.w	v_bgscreenposx,d0
		neg.w	d0
	.loop:		
		move.l	d0,(a1)+
		dbf	d1,.loop
		rts
; End of function Deform_SBZ

; ---------------------------------------------------------------------------
; Subroutine to	scroll the level horizontally as Sonic moves
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollHoriz:
		move.w	v_screenposx,d4 ; save old screen position
		bsr.s	MoveScreenHoriz
		move.w	v_screenposx,d0
		andi.w	#$10,d0
		move.b	v_fg_xblock,d1
		eor.b	d1,d0
		bne.s	.return
		eori.b	#$10,v_fg_xblock
		move.w	v_screenposx,d0
		sub.w	d4,d0		; compare new with old screen position
		bpl.s	.scrollRight

		bset	#2,v_fg_scroll_flags ; screen moves backward
		rts	

	.scrollRight:
		bset	#3,v_fg_scroll_flags ; screen moves forward

	.return:
		rts	
; End of function ScrollHoriz


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


MoveScreenHoriz:
		move.w	v_player+obX,d0
		sub.w	v_screenposx,d0 ; Sonic's distance from left edge of screen
		subi.w	#144,d0		; is distance less than 144px?
		bcs.s	SH_BehindMid	; if yes, branch
		subi.w	#16,d0		; is distance more than 160px?
		bcc.s	SH_AheadOfMid	; if yes, branch
		clr.w	v_scrshiftx
		rts	
; ===========================================================================

SH_AheadOfMid:
		cmpi.w	#16,d0		; is Sonic within 16px of middle area?
		blo.s	SH_Ahead16	; if yes, branch
		move.w	#16,d0		; set to 16 if greater

SH_Ahead16:
		add.w	v_screenposx,d0
		cmp.w	v_limitright2,d0
		blt.s	SH_SetScreen
		move.w	v_limitright2,d0

SH_SetScreen:
		move.w	d0,d1
		sub.w	v_screenposx,d1
		asl.w	#8,d1
		move.w	d0,v_screenposx ; set new screen position
		move.w	d1,v_scrshiftx ; set distance for screen movement
		rts	
; ===========================================================================

SH_BehindMid:
		add.w	v_screenposx,d0
		cmp.w	v_limitleft2,d0
		bgt.s	SH_SetScreen
		move.w	v_limitleft2,d0
		bra.s	SH_SetScreen
; End of function MoveScreenHoriz

; ===========================================================================
		tst.w	d0
		bpl.s	loc_6610
		move.w	#-2,d0
		bra.s	SH_BehindMid

loc_6610:
		move.w	#2,d0
		bra.s	SH_AheadOfMid

; ---------------------------------------------------------------------------
; Subroutine to	scroll the level vertically as Sonic moves
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollVertical:
		moveq	#0,d1
		move.w	v_player+obY,d0
		sub.w	v_screenposy,d0 ; Sonic's distance from top of screen
		btst	#2,v_player+obStatus ; is Sonic rolling?
		beq.s	SV_NotRolling	; if not, branch
		subq.w	#5,d0

SV_NotRolling:
		btst	#1,v_player+obStatus ; is Sonic jumping?
		beq.s	loc_664A	; if not, branch

		addi.w	#32,d0
		sub.w	v_lookshift,d0
		bcs.s	loc_6696
		subi.w	#64,d0
		bcc.s	loc_6696
		tst.b	f_bgscrollvert
		bne.s	loc_66A8
		bra.s	loc_6656
; ===========================================================================

loc_664A:
		sub.w	v_lookshift,d0
		bne.s	loc_665C
		tst.b	f_bgscrollvert
		bne.s	loc_66A8

loc_6656:
		clr.w	v_scrshifty
		rts	
; ===========================================================================

loc_665C:
		cmpi.w	#$60,v_lookshift
		bne.s	loc_6684
		move.w	v_player+obInertia,d1
		bpl.s	loc_666C
		neg.w	d1

loc_666C:
		cmpi.w	#$800,d1
		bhs.s	loc_6696
		move.w	#$600,d1
		cmpi.w	#6,d0
		bgt.s	loc_66F6
		cmpi.w	#-6,d0
		blt.s	loc_66C0
		bra.s	loc_66AE
; ===========================================================================

loc_6684:
		move.w	#$200,d1
		cmpi.w	#2,d0
		bgt.s	loc_66F6
		cmpi.w	#-2,d0
		blt.s	loc_66C0
		bra.s	loc_66AE
; ===========================================================================

loc_6696:
		move.w	#$1000,d1
		cmpi.w	#$10,d0
		bgt.s	loc_66F6
		cmpi.w	#-$10,d0
		blt.s	loc_66C0
		bra.s	loc_66AE
; ===========================================================================

loc_66A8:
		moveq	#0,d0
		move.b	d0,f_bgscrollvert

loc_66AE:
		moveq	#0,d1
		move.w	d0,d1
		add.w	v_screenposy,d1
		tst.w	d0
		bpl.w	loc_6700
		bra.w	loc_66CC
; ===========================================================================

loc_66C0:
		neg.w	d1
		ext.l	d1
		asl.l	#8,d1
		add.l	v_screenposy,d1
		swap	d1

loc_66CC:
		cmp.w	v_limittop2,d1
		bgt.s	loc_6724
		cmpi.w	#-$100,d1
		bgt.s	loc_66F0
		andi.w	#$7FF,d1
		andi.w	#$7FF,v_player+obY
		andi.w	#$7FF,v_screenposy
		andi.w	#$3FF,v_bgscreenposy
		bra.s	loc_6724
; ===========================================================================

loc_66F0:
		move.w	v_limittop2,d1
		bra.s	loc_6724
; ===========================================================================

loc_66F6:
		ext.l	d1
		asl.l	#8,d1
		add.l	v_screenposy,d1
		swap	d1

loc_6700:
		cmp.w	v_limitbtm2,d1
		blt.s	loc_6724
		subi.w	#$800,d1
		bcs.s	loc_6720
		andi.w	#$7FF,v_player+obY
		subi.w	#$800,v_screenposy
		andi.w	#$3FF,v_bgscreenposy
		bra.s	loc_6724
; ===========================================================================

loc_6720:
		move.w	v_limitbtm2,d1

loc_6724:
		move.w	v_screenposy,d4
		swap	d1
		move.l	d1,d3
		sub.l	v_screenposy,d3
		ror.l	#8,d3
		move.w	d3,v_scrshifty
		move.l	d1,v_screenposy
		move.w	v_screenposy,d0
		andi.w	#$10,d0
		move.b	v_fg_yblock,d1
		eor.b	d1,d0
		bne.s	.return
		eori.b	#$10,v_fg_yblock
		move.w	v_screenposy,d0
		sub.w	d4,d0
		bpl.s	.scrollBottom
		bset	#0,v_fg_scroll_flags
		rts	
; ===========================================================================

	.scrollBottom:
		bset	#1,v_fg_scroll_flags

	.return:
		rts	
; End of function ScrollVertical


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; Scrolls background and sets redraw flags.
; d4 - background x offset * $10000
; d5 - background y offset * $10000

BGScroll_XY:
		move.l	v_bgscreenposx,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,v_bgscreenposx
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	v_bg1_xblock,d3
		eor.b	d3,d1
		bne.s	BGScroll_YRelative	; no change in Y
		eori.b	#$10,v_bg1_xblock
		sub.l	d2,d0	; new - old
		bpl.s	.scrollRight
		bset	#2,v_bg1_scroll_flags
		bra.s	BGScroll_YRelative
	.scrollRight:
		bset	#3,v_bg1_scroll_flags
BGScroll_YRelative:
		move.l	v_bgscreenposy,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,v_bgscreenposy
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	v_bg1_yblock,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,v_bg1_yblock
		sub.l	d3,d0
		bpl.s	.scrollBottom
		bset	#0,v_bg1_scroll_flags
		rts
	.scrollBottom:
		bset	#1,v_bg1_scroll_flags
	.return:
		rts
; End of function BGScroll_XY

Bg_Scroll_Y:
		move.l	v_bgscreenposy,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,v_bgscreenposy
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	v_bg1_yblock,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,v_bg1_yblock
		sub.l	d3,d0
		bpl.s	.scrollBottom
		bset	#4,v_bg1_scroll_flags
		rts
	.scrollBottom:
		bset	#5,v_bg1_scroll_flags
	.return:
		rts


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BGScroll_YAbsolute:
		move.w	v_bgscreenposy,d3
		move.w	d0,v_bgscreenposy
		move.w	d0,d1
		andi.w	#$10,d1
		move.b	v_bg1_yblock,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,v_bg1_yblock
		sub.w	d3,d0
		bpl.s	.scrollBottom
		bset	#0,v_bg1_scroll_flags
		rts
	.scrollBottom:
		bset	#1,v_bg1_scroll_flags
	.return:
		rts
; End of function BGScroll_YAbsolute


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; d6 - bit to set for redraw

BGScroll_Block1:
		move.l	v_bgscreenposx,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,v_bgscreenposx
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	v_bg1_xblock,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,v_bg1_xblock
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,v_bg1_scroll_flags
		bra.s	.return
	.scrollRight:
		addq.b	#1,d6
		bset	d6,v_bg1_scroll_flags
	.return:
		rts
; End of function BGScroll_Block1


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BGScroll_Block2:
		move.l	v_bg2screenposx,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,v_bg2screenposx
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	v_bg2_xblock,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,v_bg2_xblock
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,v_bg2_scroll_flags
		bra.s	.return
	.scrollRight:
		addq.b	#1,d6
		bset	d6,v_bg2_scroll_flags
	.return:
		rts
;-------------------------------------------------------------------------------
BGScroll_Block3:
		move.l	v_bg3screenposx,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,v_bg3screenposx
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	v_bg3_xblock,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,v_bg3_xblock
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,v_bg3_scroll_flags
		bra.s	.return
	.scrollRight:
		addq.b	#1,d6
		bset	d6,v_bg3_scroll_flags
	.return:
		rts
