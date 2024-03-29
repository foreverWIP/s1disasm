; ---------------------------------------------------------------------------
; Object 79 - lamppost
; ---------------------------------------------------------------------------

Lamppost:
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
		lea	v_objstate,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		bclr	#7,2(a2,d0.w)
		btst	#0,2(a2,d0.w)
		bne.s	.red
		move.b	v_lastlamp,d1
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
		tst.w	v_debuguse	; is debug mode	being used?
		bne.w	.donothing	; if yes, branch
		tst.b	f_playerctrl
		bmi.w	.donothing
		move.b	v_lastlamp,d1
		andi.b	#$7F,d1
		move.b	obSubtype(a0),d2
		andi.b	#$7F,d2
		cmp.b	d2,d1		; is this a "new" lamppost?
		blo.s	.chkhit		; if yes, branch
		lea	v_objstate,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		bset	#0,2(a2,d0.w)
		move.b	#4,obRoutine(a0)
		move.b	#3,obFrame(a0)
		bra.w	.donothing
; ===========================================================================

.chkhit:
		move.w	v_player+obX,d0
		sub.w	obX(a0),d0
		addq.w	#8,d0
		cmpi.w	#$10,d0
		bhs.w	.donothing
		move.w	v_player+obY,d0
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
		lea	v_objstate,a2
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
		move.b	obSubtype(a0),v_lastlamp 		; lamppost number
		move.b	v_lastlamp,v_lastlamp+1
		move.w	obX(a0),v_lamp_xpos			; x-position
		move.w	obY(a0),v_lamp_ypos			; y-position
		move.w	v_rings,v_lamp_rings 		; rings
		move.b	v_lifecount,v_lamp_lives 	; lives
		move.l	v_time,v_lamp_time 		; time
		move.b	v_dle_routine,v_lamp_dle	; routine counter for dynamic level mod
		move.w	v_limitbtm2,v_lamp_limitbtm 	; lower y-boundary of level
		move.w	v_screenposx,v_lamp_scrx 	; screen x-position
		move.w	v_screenposy,v_lamp_scry 	; screen y-position
		move.w	v_bgscreenposx,v_lamp_bgscrx	; bg position
		move.w	v_bgscreenposy,v_lamp_bgscry 	; bg position
		move.w	v_bg2screenposx,v_lamp_bg2scrx 	; bg position
		move.w	v_bg2screenposy,v_lamp_bg2scry 	; bg position
		move.w	v_bg3screenposx,v_lamp_bg3scrx 	; bg position
		move.w	v_bg3screenposy,v_lamp_bg3scry 	; bg position
		move.w	v_waterpos2,v_lamp_wtrpos 	; water height
		move.b	v_wtr_routine,v_lamp_wtrrout	; rountine counter for water
		move.b	f_wtr_state,v_lamp_wtrstat 	; water direction
		rts	

; ---------------------------------------------------------------------------
; Subroutine to	load stored info when you start	a level	from a lamppost
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Lamp_LoadInfo:
		move.b	v_lastlamp+1,v_lastlamp
		move.w	v_lamp_xpos,v_player+obX
		move.w	v_lamp_ypos,v_player+obY
		move.w	v_lamp_rings,v_rings
		move.b	v_lamp_lives,v_lifecount
		clr.w	v_rings
		clr.b	v_lifecount
		move.l	v_lamp_time,v_time
		move.b	#59,v_timecent
		subq.b	#1,v_timesec
		move.b	v_lamp_dle,v_dle_routine
		move.b	v_lamp_wtrrout,v_wtr_routine
		move.w	v_lamp_limitbtm,v_limitbtm2
		move.w	v_lamp_limitbtm,v_limitbtm1
		move.w	v_lamp_scrx,v_screenposx
		move.w	v_lamp_scry,v_screenposy
		move.w	v_lamp_bgscrx,v_bgscreenposx
		move.w	v_lamp_bgscry,v_bgscreenposy
		move.w	v_lamp_bg2scrx,v_bg2screenposx
		move.w	v_lamp_bg2scry,v_bg2screenposy
		move.w	v_lamp_bg3scrx,v_bg3screenposx
		move.w	v_lamp_bg3scry,v_bg3screenposy
		cmpi.b	#id_LZ,v_zone	; is this Labyrinth Zone?
		bne.s	.notlabyrinth	; if not, branch

		move.w	v_lamp_wtrpos,v_waterpos2
		move.b	v_lamp_wtrrout,v_wtr_routine
		move.b	v_lamp_wtrstat,f_wtr_state

.notlabyrinth:
		tst.b	v_lastlamp
		bpl.s	locret_170F6
		move.w	v_lamp_xpos,d0
		subi.w	#$A0,d0
		move.w	d0,v_limitleft2

locret_170F6:
		rts	
