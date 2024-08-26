; ---------------------------------------------------------------------------
; Object 79 - lamppost
; ---------------------------------------------------------------------------

Lamppost:
		if MMD_Is_Level
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Lamp_Index(pc,d0.w),d1
		jsr	Lamp_Index(pc,d1.w)
		jmp	(RememberState).l
; ===========================================================================
Lamp_Index:	dc.w Lamp_Main-Lamp_Index
		dc.w Lamp_Blue-Lamp_Index
		dc.w Lamp_Finish-Lamp_Index
		dc.w Lamp_Twirl-Lamp_Index

lamp_origX = objoff_30		; original x-axis position
lamp_origY = objoff_32		; original y-axis position
lamp_time = objoff_36		; length of time to twirl the lamp
; ===========================================================================

Lamp_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Lamp,obMap(a0)
		move.w	#make_art_tile(ArtTile_Lamppost,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#8,obActWid(a0)
		move.b	#5,obPriority(a0)
		lea	(v_objstate).l,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		bne.s	.red
		move.b	(v_lastlamp).l,d1
		andi.b	#$7F,d1
		move.b	obSubtype(a0),d2 ; get lamppost number
		andi.b	#$7F,d2
		cmp.b	d2,d1		; is this a "new" lamppost?
		blo.s	Lamp_Blue	; if yes, branch

.red:
		bset	#0,2(a2,d0.w)
		move.b	#4,obRoutine(a0) ; goto Lamp_Finish next
		move.b	#3,obFrame(a0)	; use red lamppost frame
		rts	
; ===========================================================================

Lamp_Blue:	; Routine 2
		tst.w	(v_debuguse).l	; is debug mode	being used?
		bne.w	.donothing	; if yes, branch
		tst.b	(f_playerctrl).l
		bmi.w	.donothing
		move.b	(v_lastlamp).l,d1
		andi.b	#$7F,d1
		move.b	obSubtype(a0),d2
		andi.b	#$7F,d2
		cmp.b	d2,d1		; is this a "new" lamppost?
		blo.s	.chkhit		; if yes, branch
		lea	(v_objstate).l,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#4,obRoutine(a0)
		move.b	#3,obFrame(a0)
		bra.w	.donothing
; ===========================================================================

.chkhit:
		move.w	(v_player+obX).l,d0
		sub.w	obX(a0),d0
		addq.w	#8,d0
		cmpi.w	#$10,d0
		bhs.w	.donothing
		move.w	(v_player+obY).l,d0
		sub.w	obY(a0),d0
		addi.w	#$40,d0
		cmpi.w	#$68,d0
		bhs.s	.donothing

		move.w	#sfx_Lamppost,d0
		jsr	(PlaySound_Special).l	; play lamppost sound
		addq.b	#2,obRoutine(a0)
		jsr	(FindFreeObj).l
		bne.s	.fail
		_move.b	#id_Lamppost,obID(a1)	; load twirling	lamp object
		move.b	#6,obRoutine(a1) ; goto Lamp_Twirl next
		move.w	obX(a0),lamp_origX(a1)
		move.w	obY(a0),lamp_origY(a1)
		subi.w	#$18,lamp_origY(a1)
		move.l	#Map_Lamp,obMap(a1)
		move.w	#make_art_tile(ArtTile_Lamppost,0,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#8,obActWid(a1)
		move.b	#4,obPriority(a1)
		move.b	#2,obFrame(a1)	; use "ball only" frame
		move.w	#$20,lamp_time(a1)

.fail:
		move.b	#1,obFrame(a0)	; use "post only" frame
		bsr.w	Lamp_StoreInfo
		lea	(v_objstate).l,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		bset	#0,2(a2,d0.w)

.donothing:
		rts	
; ===========================================================================

Lamp_Finish:	; Routine 4
		rts	
; ===========================================================================

Lamp_Twirl:	; Routine 6
		subq.w	#1,lamp_time(a0) ; decrement timer
		bpl.s	.continue	; if time remains, keep twirling
		move.b	#4,obRoutine(a0) ; goto Lamp_Finish next

.continue:
		move.b	obAngle(a0),d0
		subi.b	#$10,obAngle(a0)
		subi.b	#$40,d0
		jsr	(CalcSine).l
		muls.w	#$C00,d1
		swap	d1
		add.w	lamp_origX(a0),d1
		move.w	d1,obX(a0)
		muls.w	#$C00,d0
		swap	d0
		add.w	lamp_origY(a0),d0
		move.w	d0,obY(a0)
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	store information when you hit a lamppost
; ---------------------------------------------------------------------------

Lamp_StoreInfo:
		move.b	obSubtype(a0),(v_lastlamp).l 		; lamppost number
		move.b	(v_lastlamp).l,(v_lastlamp+1).l
		move.w	obX(a0),(v_lamp_xpos).l			; x-position
		move.w	obY(a0),(v_lamp_ypos).l			; y-position
		move.w	(v_rings).l,(v_lamp_rings).l 		; rings
		move.b	(v_lifecount).l,(v_lamp_lives).l 	; lives
		move.l	(v_time).l,(v_lamp_time).l 		; time
		move.b	(v_dle_routine).l,(v_lamp_dle).l	; routine counter for dynamic level mod
		move.w	(v_limitbtm2).l,(v_lamp_limitbtm).l 	; lower y-boundary of level
		move.w	(v_screenposx).l,(v_lamp_scrx).l 	; screen x-position
		move.w	(v_screenposy).l,(v_lamp_scry).l 	; screen y-position
		move.w	(v_bgscreenposx).l,(v_lamp_bgscrx).l	; bg position
		move.w	(v_bgscreenposy).l,(v_lamp_bgscry).l 	; bg position
		move.w	(v_bg2screenposx).l,(v_lamp_bg2scrx).l 	; bg position
		move.w	(v_bg2screenposy).l,(v_lamp_bg2scry).l 	; bg position
		move.w	(v_bg3screenposx).l,(v_lamp_bg3scrx).l 	; bg position
		move.w	(v_bg3screenposy).l,(v_lamp_bg3scry).l 	; bg position
		move.w	(v_waterpos2).l,(v_lamp_wtrpos).l 	; water height
		move.b	(v_wtr_routine).l,(v_lamp_wtrrout).l	; rountine counter for water
		move.b	(f_wtr_state).l,(v_lamp_wtrstat).l 	; water direction
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	load stored info when you start	a level	from a lamppost
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Lamp_LoadInfo:
		move.b	(v_lastlamp+1).l,(v_lastlamp).l
		move.w	(v_lamp_xpos).l,(v_player+obX).l
		move.w	(v_lamp_ypos).l,(v_player+obY).l
		move.w	(v_lamp_rings).l,(v_rings).l
		move.b	(v_lamp_lives).l,(v_lifecount).l
		clr.w	(v_rings).l
		clr.b	(v_lifecount).l
		move.l	(v_lamp_time).l,(v_time).l
		move.b	#59,(v_timecent).l
		subq.b	#1,(v_timesec).l
		move.b	(v_lamp_dle).l,(v_dle_routine).l
		move.b	(v_lamp_wtrrout).l,(v_wtr_routine).l
		move.w	(v_lamp_limitbtm).l,(v_limitbtm2).l
		move.w	(v_lamp_limitbtm).l,(v_limitbtm1).l
		move.w	(v_lamp_scrx).l,(v_screenposx).l
		move.w	(v_lamp_scry).l,(v_screenposy).l
		move.w	(v_lamp_bgscrx).l,(v_bgscreenposx).l
		move.w	(v_lamp_bgscry).l,(v_bgscreenposy).l
		move.w	(v_lamp_bg2scrx).l,(v_bg2screenposx).l
		move.w	(v_lamp_bg2scry).l,(v_bg2screenposy).l
		move.w	(v_lamp_bg3scrx).l,(v_bg3screenposx).l
		move.w	(v_lamp_bg3scry).l,(v_bg3screenposy).l
		cmpi.b	#id_LZ,(v_zone).l	; is this Labyrinth Zone?
		bne.s	.notlabyrinth	; if not, branch

		move.w	(v_lamp_wtrpos).l,(v_waterpos2).l
		move.b	(v_lamp_wtrrout).l,(v_wtr_routine).l
		move.b	(v_lamp_wtrstat).l,(f_wtr_state).l

.notlabyrinth:
		tst.b	(v_lastlamp).l
		bpl.s	locret_170F6
		move.w	(v_lamp_xpos).l,d0
		subi.w	#$A0,d0
		move.w	d0,(v_limitleft2).l

locret_170F6:
		rts	
		else
		undefObjTrap
		endif