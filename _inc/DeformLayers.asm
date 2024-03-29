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
		move.w	v_screenposx,v_scrposx_vdp
		move.w	v_screenposy,v_scrposy_vdp
		move.w	v_bgscreenposx,v_bgscrposx_vdp
		move.w	v_bgscreenposy,v_bgscrposy_vdp
		move.w	v_bg3screenposx,v_bg3scrposx_vdp
		move.w	v_bg3screenposy,v_bg3scrposy_vdp
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
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d5
		bsr.w	ScrollBlock1
		bsr.w	ScrollBlock4
		lea	v_hscrolltablebuffer,a1
		move.w	v_screenposy,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$26,d0
		move.w	d0,v_bg2screenposy
		move.w	d0,d4
		bsr.w	ScrollBlock3
		move.w	v_bgscreenposy,v_bgscrposy_vdp
		move.w	#$6F,d1
		sub.w	d4,d1
		move.w	v_screenposx,d0
		cmpi.b	#id_Title,v_gamemode
		bne.s	loc_633C
		moveq	#0,d0

loc_633C:
		neg.w	d0
		swap	d0
		move.w	v_bgscreenposx,d0
		neg.w	d0

loc_6346:
		move.l	d0,(a1)+
		dbf	d1,loc_6346
		move.w	#$27,d1
		move.w	v_bg2screenposx,d0
		neg.w	d0

loc_6356:
		move.l	d0,(a1)+
		dbf	d1,loc_6356
		move.w	v_bg2screenposx,d0
		addi.w	#0,d0
		move.w	v_screenposx,d2
		addi.w	#-$200,d2
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

loc_6384:
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,loc_6384
		rts	
; End of function Deform_GHZ

; ---------------------------------------------------------------------------
; Labyrinth Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_LZ:
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	v_scrshifty,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	ScrollBlock1
		move.w	v_bgscreenposy,v_bgscrposy_vdp
		lea	v_hscrolltablebuffer,a1
		move.w	#223,d1
		move.w	v_screenposx,d0
		neg.w	d0
		swap	d0
		move.w	v_bgscreenposx,d0
		neg.w	d0

loc_63C6:
		move.l	d0,(a1)+
		dbf	d1,loc_63C6
		move.w	v_waterpos1,d0
		sub.w	v_screenposy,d0
		rts	
; End of function Deform_LZ

; ---------------------------------------------------------------------------
; Marble Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_MZ:
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#6,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d5
		bsr.w	ScrollBlock1
		move.w	#$200,d0
		move.w	v_screenposy,d1
		subi.w	#$1C8,d1
		bcs.s	loc_6402
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0

loc_6402:
		move.w	d0,v_bg2screenposy
		bsr.w	ScrollBlock3
		move.w	v_bgscreenposy,v_bgscrposy_vdp
		lea	v_hscrolltablebuffer,a1
		move.w	#223,d1
		move.w	v_screenposx,d0
		neg.w	d0
		swap	d0
		move.w	v_bgscreenposx,d0
		neg.w	d0

loc_6426:
		move.l	d0,(a1)+
		dbf	d1,loc_6426
		rts	
; End of function Deform_MZ

; ---------------------------------------------------------------------------
; Star Light Zone background layer deformation code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SLZ:
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	v_scrshifty,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	ScrollBlock2
		move.w	v_bgscreenposy,v_bgscrposy_vdp
		bsr.w	Deform_SLZ_2
		lea	v_bgscroll_buffer,a2
		move.w	v_bgscreenposy,d0
		move.w	d0,d2
		subi.w	#$C0,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0.w),a2
		lea	v_hscrolltablebuffer,a1
		move.w	#$E,d1
		move.w	v_screenposx,d0
		neg.w	d0
		swap	d0
		andi.w	#$F,d2
		add.w	d2,d2
		move.w	(a2)+,d0
		jmp	loc_6482(pc,d2.w)
; ===========================================================================

loc_6480:
		move.w	(a2)+,d0

loc_6482:
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
		dbf	d1,loc_6480
		rts	
; End of function Deform_SLZ


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SLZ_2:
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

loc_64CE:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_64CE
		move.w	d2,d0
		asr.w	#3,d0
		move.w	#4,d1

loc_64E2:
		move.w	d0,(a1)+
		dbf	d1,loc_64E2
		move.w	d2,d0
		asr.w	#2,d0
		move.w	#4,d1

loc_64F0:
		move.w	d0,(a1)+
		dbf	d1,loc_64F0
		move.w	d2,d0
		asr.w	#1,d0
		move.w	#$1D,d1

loc_64FE:
		move.w	d0,(a1)+
		dbf	d1,loc_64FE
		rts	
; End of function Deform_SLZ_2

; ---------------------------------------------------------------------------
; Spring Yard Zone background layer deformation	code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SYZ:
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#6,d4
		move.w	v_scrshifty,d5
		ext.l	d5
		asl.l	#4,d5
		move.l	d5,d1
		asl.l	#1,d5
		add.l	d1,d5
		bsr.w	ScrollBlock1
		move.w	v_bgscreenposy,v_bgscrposy_vdp
		lea	v_hscrolltablebuffer,a1
		move.w	#223,d1
		move.w	v_screenposx,d0
		neg.w	d0
		swap	d0
		move.w	v_bgscreenposx,d0
		neg.w	d0

loc_653C:
		move.l	d0,(a1)+
		dbf	d1,loc_653C
		rts	
; End of function Deform_SYZ

; ---------------------------------------------------------------------------
; Scrap	Brain Zone background layer deformation	code
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Deform_SBZ:
		move.w	v_scrshiftx,d4
		ext.l	d4
		asl.l	#6,d4
		move.w	v_scrshifty,d5
		ext.l	d5
		asl.l	#4,d5
		asl.l	#1,d5
		bsr.w	ScrollBlock1
		move.w	v_bgscreenposy,v_bgscrposy_vdp
		lea	v_hscrolltablebuffer,a1
		move.w	#223,d1
		move.w	v_screenposx,d0
		neg.w	d0
		swap	d0
		move.w	v_bgscreenposx,d0
		neg.w	d0

loc_6576:
		move.l	d0,(a1)+
		dbf	d1,loc_6576
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
		bne.s	locret_65B0
		eori.b	#$10,v_fg_xblock
		move.w	v_screenposx,d0
		sub.w	d4,d0		; compare new with old screen position
		bpl.s	SH_Forward

		bset	#2,v_fg_scroll_flags ; screen moves backward
		rts	

SH_Forward:
		bset	#3,v_fg_scroll_flags ; screen moves forward

locret_65B0:
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
		bne.s	locret_6766
		eori.b	#$10,v_fg_yblock
		move.w	v_screenposy,d0
		sub.w	d4,d0
		bpl.s	loc_6760
		bset	#0,v_fg_scroll_flags
		rts	
; ===========================================================================

loc_6760:
		bset	#1,v_fg_scroll_flags

locret_6766:
		rts	
; End of function ScrollVertical


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollBlock1:
		move.l	v_bgscreenposx,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,v_bgscreenposx
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	v_bg1_xblock,d3
		eor.b	d3,d1
		bne.s	loc_679C
		eori.b	#$10,v_bg1_xblock
		sub.l	d2,d0
		bpl.s	loc_6796
		bset	#2,v_bg1_scroll_flags
		bra.s	loc_679C
; ===========================================================================

loc_6796:
		bset	#3,v_bg1_scroll_flags

loc_679C:
		move.l	v_bgscreenposy,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,v_bgscreenposy
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	v_bg1_yblock,d2
		eor.b	d2,d1
		bne.s	locret_67D0
		eori.b	#$10,v_bg1_yblock
		sub.l	d3,d0
		bpl.s	loc_67CA
		bset	#0,v_bg1_scroll_flags
		rts	
; ===========================================================================

loc_67CA:
		bset	#1,v_bg1_scroll_flags

locret_67D0:
		rts	
; End of function ScrollBlock1


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollBlock2:
		move.l	v_bgscreenposx,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,v_bgscreenposx
		move.l	v_bgscreenposy,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,v_bgscreenposy
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	v_bg1_yblock,d2
		eor.b	d2,d1
		bne.s	locret_6812
		eori.b	#$10,v_bg1_yblock
		sub.l	d3,d0
		bpl.s	loc_680C
		bset	#0,v_bg1_scroll_flags
		rts	
; ===========================================================================

loc_680C:
		bset	#1,v_bg1_scroll_flags

locret_6812:
		rts	
; End of function ScrollBlock2


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollBlock3:
		move.w	v_bgscreenposy,d3
		move.w	d0,v_bgscreenposy
		move.w	d0,d1
		andi.w	#$10,d1
		move.b	v_bg1_yblock,d2
		eor.b	d2,d1
		bne.s	locret_6842
		eori.b	#$10,v_bg1_yblock
		sub.w	d3,d0
		bpl.s	loc_683C
		bset	#0,v_bg1_scroll_flags
		rts	
; ===========================================================================

loc_683C:
		bset	#1,v_bg1_scroll_flags

locret_6842:
		rts	
; End of function ScrollBlock3


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollBlock4:
		move.w	v_bg2screenposx,d2
		move.w	v_bg2screenposy,d3
		move.w	v_scrshiftx,d0
		ext.l	d0
		asl.l	#7,d0
		add.l	d0,v_bg2screenposx
		move.w	v_bg2screenposx,d0
		andi.w	#$10,d0
		move.b	v_bg2_xblock,d1
		eor.b	d1,d0
		bne.s	locret_6884
		eori.b	#$10,v_bg2_xblock
		move.w	v_bg2screenposx,d0
		sub.w	d2,d0
		bpl.s	loc_687E
		bset	#2,v_bg2_scroll_flags
		bra.s	locret_6884
; ===========================================================================

loc_687E:
		bset	#3,v_bg2_scroll_flags

locret_6884:
		rts	
; End of function ScrollBlock4
