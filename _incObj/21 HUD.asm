; ---------------------------------------------------------------------------
; Object 21 - SCORE, TIME, RINGS
; ---------------------------------------------------------------------------

HUD:
		if MMD_Is_Level||MMD_Is_Ending
		cmpi.b	#id_Ending,(v_gamemode).l
		bne.s	.notending
		rts
.notending:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	HUD_Index(pc,d0.w),d1
		jmp	HUD_Index(pc,d1.w)
; ===========================================================================
HUD_Index:	dc.w HUD_Main-HUD_Index
		dc.w HUD_Flash-HUD_Index
; ===========================================================================

HUD_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$90,obX(a0)
		move.w	#$108,obScreenY(a0)
		move.l	#Map_HUD,obMap(a0)
		move.w	#make_art_tile(ArtTile_HUD,0,0),obGfx(a0)
		move.b	#0,obRender(a0)
		move.b	#0,obPriority(a0)

HUD_Flash:	; Routine 2
		tst.w	(v_rings).l	; do you have any rings?
		beq.s	.norings	; if not, branch
		clr.b	obFrame(a0)	; make all counters yellow
		jmp	(DisplaySprite).l
; ===========================================================================

.norings:
		moveq	#0,d0
		btst	#3,(v_framebyte).l
		bne.s	.display
		addq.w	#1,d0		; make ring counter flash red
		cmpi.b	#9,(v_timemin).l ; have	9 minutes elapsed?
		bne.s	.display	; if not, branch
		addq.w	#2,d0		; make time counter flash red

.display:
		move.b	d0,obFrame(a0)
		jmp	(DisplaySprite).l
		else
		undefObjTrap
		endif