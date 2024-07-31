; ---------------------------------------------------------------------------
; Object 3D - Eggman (GHZ)
; ---------------------------------------------------------------------------

BossGreenHill:
		if MMD_Is_GHZ_3
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	BGHZ_Index(pc,d0.w),d1
		jmp	BGHZ_Index(pc,d1.w)
; ===========================================================================
BGHZ_Index:	dc.w BGHZ_Main-BGHZ_Index
		dc.w BGHZ_ShipMain-BGHZ_Index
		dc.w BGHZ_FaceMain-BGHZ_Index
		dc.w BGHZ_FlameMain-BGHZ_Index

BGHZ_ObjData:	dc.b 2,	0		; routine counter, animation
		dc.b 4,	1
		dc.b 6,	7
; ===========================================================================

BGHZ_Main:	; Routine 0
		lea	(BGHZ_ObjData).l,a2
		movea.l	a0,a1
		moveq	#2,d1
		bra.s	BGHZ_LoadBoss
; ===========================================================================

BGHZ_Loop:
		jsr	(FindNextFreeObj).l
		bne.s	loc_17772

BGHZ_LoadBoss:
		move.b	(a2)+,obRoutine(a1)
		_move.b	#id_BossGreenHill,obID(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.l	#Map_Eggman,obMap(a1)
		move.w	#make_art_tile(ArtTile_Eggman,0,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$20,obActWid(a1)
		move.b	#3,obPriority(a1)
		move.b	(a2)+,obAnim(a1)
		move.l	a0,objoff_34(a1)
		dbf	d1,BGHZ_Loop	; repeat sequence 2 more times

loc_17772:
		move.w	obX(a0),objoff_30(a0)
		move.w	obY(a0),objoff_38(a0)
		move.b	#$F,obColType(a0)
		move.b	#8,obColProp(a0) ; set number of hits to 8

BGHZ_ShipMain:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	BGHZ_ShipIndex(pc,d0.w),d1
		jsr	BGHZ_ShipIndex(pc,d1.w)
		lea	(Ani_Eggman).l,a1
		jsr	(AnimateSprite).l
		move.b	obStatus(a0),d0
		andi.b	#3,d0
		andi.b	#$FC,obRender(a0)
		or.b	d0,obRender(a0)
		jmp	(DisplaySprite).l
; ===========================================================================
BGHZ_ShipIndex:	dc.w BGHZ_ShipStart-BGHZ_ShipIndex
		dc.w BGHZ_MakeBall-BGHZ_ShipIndex
		dc.w BGHZ_ShipMove-BGHZ_ShipIndex
		dc.w loc_17954-BGHZ_ShipIndex
		dc.w loc_1797A-BGHZ_ShipIndex
		dc.w loc_179AC-BGHZ_ShipIndex
		dc.w loc_179F6-BGHZ_ShipIndex
; ===========================================================================

BGHZ_ShipStart:
		move.w	#$100,obVelY(a0) ; move ship down
		bsr.w	BossMove
		cmpi.w	#boss_ghz_y+$38,objoff_38(a0)
		bne.s	loc_177E6
		move.w	#0,obVelY(a0)	; stop ship
		addq.b	#2,ob2ndRout(a0) ; goto next routine

loc_177E6:
		move.b	objoff_3F(a0),d0
		jsr	(CalcSine).l
		asr.w	#6,d0
		add.w	objoff_38(a0),d0
		move.w	d0,obY(a0)
		move.w	objoff_30(a0),obX(a0)
		addq.b	#2,objoff_3F(a0)
		cmpi.b	#8,ob2ndRout(a0)
		bhs.s	locret_1784A
		tst.b	obStatus(a0)
		bmi.s	loc_1784C
		tst.b	obColType(a0)
		bne.s	locret_1784A
		tst.b	objoff_3E(a0)
		bne.s	BGHZ_ShipFlash
		move.b	#$20,objoff_3E(a0)	; set number of	times for ship to flash
		move.w	#sfx_HitBoss,d0
		jsr	(PlaySound_Special).l	; play boss damage sound

BGHZ_ShipFlash:
		lea	(v_palette+$22).l,a1 ; load 2nd palette, 2nd entry
		moveq	#0,d0		; move 0 (black) to d0
		tst.w	(a1)
		bne.s	loc_1783C
		move.w	#cWhite,d0	; move 0EEE (white) to d0

loc_1783C:
		move.w	d0,(a1)		; load colour stored in	d0
		subq.b	#1,objoff_3E(a0)
		bne.s	locret_1784A
		move.b	#$F,obColType(a0)

locret_1784A:
		rts	
; ===========================================================================

loc_1784C:
		moveq	#100,d0
		bsr.w	AddPoints
		move.b	#8,ob2ndRout(a0)
		move.w	#$B3,objoff_3C(a0)
		endif
		rts	
