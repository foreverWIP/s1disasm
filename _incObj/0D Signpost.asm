; ---------------------------------------------------------------------------
; Object 0D - signpost at the end of a level
; ---------------------------------------------------------------------------

Signpost:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Sign_Index(pc,d0.w),d1
		jsr	Sign_Index(pc,d1.w)
		lea	(Ani_Sign).l,a1
		bsr.w	AnimateSprite
		bsr.w	DisplaySprite
		out_of_range.w	DeleteObject
		rts	
; ===========================================================================
Sign_Index:	dc.w Sign_Main-Sign_Index
		dc.w Sign_Touch-Sign_Index
		dc.w Sign_Spin-Sign_Index
		dc.w Sign_SonicRun-Sign_Index
		dc.w Sign_Exit-Sign_Index

spintime = objoff_30		; time for signpost to spin
sparkletime = objoff_32		; time between sparkles
sparkle_id = objoff_34		; counter to keep track of sparkles
; ===========================================================================

Sign_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Sign,obMap(a0)
		move.w	#make_art_tile(ArtTile_Signpost,0,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$18,obActWid(a0)
		move.b	#4,obPriority(a0)

Sign_Touch:	; Routine 2
		move.w	(v_player+obX).l,d0
		sub.w	obX(a0),d0
		bcs.s	.notouch
		cmpi.w	#$20,d0		; is Sonic within $20 pixels of	the signpost?
		bhs.s	.notouch	; if not, branch
		move.w	#sfx_Signpost,d0
		jsr	(PlaySound).l	; play signpost sound
		clr.b	(f_timecount).l	; stop time counter
		move.w	(v_limitright2).l,(v_limitleft2).l ; lock screen position
		addq.b	#2,obRoutine(a0)

.notouch:
		rts	
; ===========================================================================

Sign_Spin:	; Routine 4
		subq.w	#1,spintime(a0)	; subtract 1 from spin time
		bpl.s	.chksparkle	; if time remains, branch
		move.w	#60,spintime(a0) ; set spin cycle time to 1 second
		addq.b	#1,obAnim(a0)	; next spin cycle
		cmpi.b	#3,obAnim(a0)	; have 3 spin cycles completed?
		bne.s	.chksparkle	; if not, branch
		addq.b	#2,obRoutine(a0)

.chksparkle:
		subq.w	#1,sparkletime(a0) ; subtract 1 from time delay
		bpl.s	.fail		; if time remains, branch
		move.w	#$B,sparkletime(a0) ; set time between sparkles to $B frames
		moveq	#0,d0
		move.b	sparkle_id(a0),d0 ; get sparkle id
		addq.b	#2,sparkle_id(a0) ; increment sparkle counter
		andi.b	#$E,sparkle_id(a0)
		lea	Sign_SparkPos(pc,d0.w),a2 ; load sparkle position data
		bsr.w	FindFreeObj
		bne.s	.fail
		_move.b	#id_Rings,obID(a1)	; load rings object
		move.b	#id_Ring_Sparkle,obRoutine(a1) ; jump to ring sparkle subroutine
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obX(a0),d0
		move.w	d0,obX(a1)
		move.b	(a2)+,d0
		ext.w	d0
		add.w	obY(a0),d0
		move.w	d0,obY(a1)
		move.l	#Map_Ring,obMap(a1)
		move.w	#make_art_tile(ArtTile_Ring,1,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#2,obPriority(a1)
		move.b	#8,obActWid(a1)

.fail:
		rts	
; ===========================================================================
Sign_SparkPos:	dc.b -$18,-$10		; x-position, y-position
		dc.b	8,   8
		dc.b -$10,   0
		dc.b  $18,  -8
		dc.b	0,  -8
		dc.b  $10,   0
		dc.b -$18,   8
		dc.b  $18, $10
; ===========================================================================

Sign_SonicRun:	; Routine 6
		tst.w	(v_debuguse).l	; is debug mode	on?
		bne.w	locret_ECEE	; if yes, branch
	if FixBugs
		; This function's checks are a mess, creating an edgecase where it's
		; possible for the player to avoid having their controls locked by
		; jumping at the right side of the screen just as the score tally
		; appears.
		tst.b	(v_player+obID).l	; Check if Sonic's object has been deleted (because he entered the giant ring)
		beq.s	loc_EC86
		btst	#1,(v_player+obStatus).l
		bne.w	locret_ECEE
	else
		btst	#1,(v_player+obStatus).l
		bne.s	loc_EC70
	endif
		move.b	#1,(f_lockctrl).l ; lock controls
		move.w	#btnR<<8,(v_jpadhold2).l ; make Sonic run to the right
	if ~~FixBugs
loc_EC70:
		tst.b	(v_player+obID).l	; Check if Sonic's object has been deleted (because he entered the giant ring)
		beq.s	loc_EC86
	endif
		move.w	(v_player+obX).l,d0
		move.w	(v_limitright2).l,d1
		addi.w	#$128,d1
		cmp.w	d1,d0
		blo.w	locret_ECEE

loc_EC86:
		addq.b	#2,obRoutine(a0)
