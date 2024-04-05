; ---------------------------------------------------------------------------
; Subroutine to	update the HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

HUD_Update:
		tst.w	f_debugmode	; is debug mode	on?
		bne.w	HudDebug	; if yes, branch
		tst.b	f_scorecount ; does the score need updating?
		beq.s	.chkrings	; if not, branch

		clr.b	f_scorecount
		locVRAMTile	(ArtTile_HUD+$1A),d0	; set VRAM address
		move.l	v_score,d1	; load score
		bsr.w	Hud_Score

.chkrings:
		tst.b	f_ringcount	; does the ring	counter	need updating?
		beq.s	.chktime	; if not, branch
		bpl.s	.notzero
		bsr.w	Hud_LoadZero	; reset rings to 0 if Sonic is hit

.notzero:
		clr.b	f_ringcount
		locVRAMTile	(ArtTile_HUD+$30),d0	; set VRAM address
		moveq	#0,d1
		move.w	v_rings,d1	; load number of rings
		bsr.w	Hud_Rings

.chktime:
		tst.b	f_timecount	; does the time	need updating?
		beq.s	.chklives	; if not, branch
		tst.w	f_pause	; is the game paused?
		bne.s	.chklives	; if yes, branch
		lea	v_time,a1
		cmpi.l	#(9*$10000)+(59*$100)+59,(a1)+ ; is the time 9:59:59?
		if NeoGeo=0
		beq.s	TimeOver	; if yes, branch
		else
		beq.w	TimeOver	; if yes, branch
		endif

		addq.b	#1,-(a1)	; increment 1/60s counter
		cmpi.b	#60,(a1)	; check if passed 60
		blo.s	.chklives
		move.b	#0,(a1)
		addq.b	#1,-(a1)	; increment second counter
		cmpi.b	#60,(a1)	; check if passed 60
		blo.s	.updatetime
		move.b	#0,(a1)
		addq.b	#1,-(a1)	; increment minute counter
		cmpi.b	#9,(a1)		; check if passed 9
		blo.s	.updatetime
		move.b	#9,(a1)		; keep as 9

.updatetime:
		locVRAMTile	(ArtTile_HUD+$28),d0
		moveq	#0,d1
		move.b	v_timemin,d1 ; load	minutes
		bsr.w	Hud_Mins
		locVRAMTile	(ArtTile_HUD+$2C),d0
		moveq	#0,d1
		move.b	v_timesec,d1 ; load	seconds
		bsr.w	Hud_Secs

.chklives:
		tst.b	f_lifecount ; does the lives counter need updating?
		beq.s	.chkbonus	; if not, branch
		clr.b	f_lifecount
		bsr.w	Hud_Lives

.chkbonus:
		tst.b	f_endactbonus ; do time/ring bonus counters need updating?
		beq.s	.finish		; if not, branch
		clr.b	f_endactbonus
		locVRAMTile	ArtTile_Bonuses
		moveq	#0,d1
		move.w	v_timebonus,d1 ; load time bonus
		bsr.w	Hud_TimeRingBonus
		moveq	#0,d1
		move.w	v_ringbonus,d1 ; load ring bonus
		bsr.w	Hud_TimeRingBonus

.finish:
		rts	
; ===========================================================================

TimeOver:
		clr.b	f_timecount
		lea	v_player,a0
		movea.l	a0,a2
		bsr.w	KillSonic
		move.b	#1,f_timeover
		rts	
; ===========================================================================

HudDebug:
		bsr.w	HudDb_XY
		tst.b	f_ringcount	; does the ring	counter	need updating?
		beq.s	.objcounter	; if not, branch
		bpl.s	.notzero
		bsr.w	Hud_LoadZero	; reset rings to 0 if Sonic is hit

.notzero:
		clr.b	f_ringcount
		locVRAMTile	(ArtTile_HUD+$30),d0	; set VRAM address
		moveq	#0,d1
		move.w	v_rings,d1	; load number of rings
		bsr.w	Hud_Rings

.objcounter:
		locVRAMTile	(ArtTile_HUD+$2C),d0	; set VRAM address
		moveq	#0,d1
		move.b	v_spritecount,d1 ; load "number of objects" counter
		bsr.w	Hud_Secs
		tst.b	f_lifecount ; does the lives counter need updating?
		beq.s	.chkbonus	; if not, branch
		clr.b	f_lifecount
		bsr.w	Hud_Lives

.chkbonus:
		tst.b	f_endactbonus ; does the ring/time bonus counter need updating?
		beq.s	.finish		; if not, branch
		clr.b	f_endactbonus
		locVRAMTile	ArtTile_Bonuses		; set VRAM address
		moveq	#0,d1
		move.w	v_timebonus,d1 ; load time bonus
		bsr.w	Hud_TimeRingBonus
		moveq	#0,d1
		move.w	v_ringbonus,d1 ; load ring bonus
		bsr.w	Hud_TimeRingBonus

.finish:
		rts	
; End of function HUD_Update

; ---------------------------------------------------------------------------
; Subroutine to	load "0" on the	HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Hud_LoadZero:
		if NeoGeo<>1
		locVRAMTile	(ArtTile_HUD+$30)
		lea	Hud_TilesZero(pc),a2
		move.w	#2,d2
		bra.s	loc_1C83E
		else
		rts
		endif
; End of function Hud_LoadZero

; ---------------------------------------------------------------------------
; Subroutine to	load uncompressed HUD patterns ("E", "0", colon)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Hud_Base:
		if NeoGeo<>1
		lea	(vdp_data_port).l,a6
		bsr.w	Hud_Lives
		locVRAMTile	(ArtTile_HUD+$18)
		lea	Hud_TilesBase(pc),a2
		move.w	#$E,d2

loc_1C83E:
		lea	Art_Hud(pc),a1

loc_1C842:
		move.w	#$F,d1
		move.b	(a2)+,d0
		bmi.s	loc_1C85E
		ext.w	d0
		lsl.w	#5,d0
		lea	(a1,d0.w),a3

loc_1C852:
		move.l	(a3)+,(a6)
		dbf	d1,loc_1C852

loc_1C858:
		dbf	d2,loc_1C842
		endif

		rts	
; ===========================================================================

loc_1C85E:
		if NeoGeo<>1
		move.l	#0,(a6)
		dbf	d1,loc_1C85E

		bra.s	loc_1C858
		else
		rts
		endif
; End of function Hud_Base

; ===========================================================================
Hud_TilesBase:	dc.b $16, $FF, $FF, $FF, $FF, $FF, $FF,	0, 0, $14, 0, 0
Hud_TilesZero:	dc.b $FF, $FF, 0, 0
; ---------------------------------------------------------------------------
; Subroutine to	load debug mode	numbers	patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HudDb_XY:
		if NeoGeo<>1
		locVRAMTile	(ArtTile_HUD+$18)		; set VRAM address
		move.w	v_screenposx,d1 ; load camera x-position
		swap	d1
		move.w	v_player+obX,d1 ; load Sonic's x-position
		bsr.s	HudDb_XY2
		move.w	v_screenposy,d1 ; load camera y-position
		swap	d1
		move.w	v_player+obY,d1 ; load Sonic's y-position
; End of function HudDb_XY


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HudDb_XY2:
		moveq	#7,d6
		lea	(Art_Text).l,a1

HudDb_XYLoop:
		rol.w	#4,d1
		move.w	d1,d2
		andi.w	#$F,d2
		cmpi.w	#$A,d2
		blo.s	loc_1C8B2
		addq.w	#7,d2

loc_1C8B2:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		swap	d1
		dbf	d6,HudDb_XYLoop	; repeat 7 more	times
		endif

		rts	
; End of function HudDb_XY2

; ---------------------------------------------------------------------------
; Subroutine to	load rings numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Hud_Rings:
		if NeoGeo<>1
		lea	(Hud_100).l,a2
		moveq	#2,d6
		bra.s	Hud_LoadArt
		endif
; End of function Hud_Rings

; ---------------------------------------------------------------------------
; Subroutine to	load score numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Hud_Score:
		if NeoGeo<>1
		lea	(Hud_100000).l,a2
		moveq	#5,d6

Hud_LoadArt:
		moveq	#0,d4
		lea	Art_Hud(pc),a1

Hud_ScoreLoop:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1C8EC:
		sub.l	d3,d1
		bcs.s	loc_1C8F4
		addq.w	#1,d2
		bra.s	loc_1C8EC
; ===========================================================================

loc_1C8F4:
		add.l	d3,d1
		tst.w	d2
		beq.s	loc_1C8FE
		move.w	#1,d4

loc_1C8FE:
		tst.w	d4
		beq.s	loc_1C92C
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)

loc_1C92C:
		addi.l	#$400000,d0
		dbf	d6,Hud_ScoreLoop
		endif

		rts	

; End of function Hud_Score
