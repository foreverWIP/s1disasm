; ---------------------------------------------------------------------------
; Subroutine to	load level boundaries and start	locations
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevelSizeLoad:
		moveq	#0,d0
		move.b	d0,v_unused7
		move.b	d0,v_unused8
		move.b	d0,v_unused9
		move.b	d0,v_unused10
		move.b	d0,v_dle_routine
		move.w	v_zone,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		lea	LevelSizeArray(pc,d0.w),a0 ; load level	boundaries
		move.w	(a0)+,d0
		move.w	d0,v_unused11
		move.l	(a0)+,d0
		move.l	d0,v_limitleft2
		move.l	d0,v_limitleft1
		move.l	(a0)+,d0
		move.l	d0,v_limittop2
		move.l	d0,v_limittop1
		move.w	v_limitleft2,d0
		addi.w	#$240,d0
		move.w	d0,v_limitleft3
		move.w	#$1010,v_fg_xblock ; and v_fg_yblock
		move.w	(a0)+,d0
		move.w	d0,v_lookshift
		bra.w	LevSz_ChkLamp
; ===========================================================================
; ---------------------------------------------------------------------------
; Level size array
; ---------------------------------------------------------------------------
LevelSizeArray:
		; GHZ
		dc.w $0004, $0000, $24BF, $0000, $0300, $0060
		dc.w $0004, $0000, $1EBF, $0000, $0300, $0060
		dc.w $0004, $0000, $2960, $0000, $0300, $0060
		dc.w $0004, $0000, $2ABF, $0000, $0300, $0060
		; LZ
		dc.w $0004, $0000, $19BF, $0000, $0530, $0060
		dc.w $0004, $0000, $10AF, $0000, $0720, $0060
		dc.w $0004, $0000, $202F, $FF00, $0800, $0060
		dc.w $0004, $0000, $20BF, $0000, $0720, $0060
		; MZ
		dc.w $0004, $0000, $17BF, $0000, $01D0, $0060
		dc.w $0004, $0000, $17BF, $0000, $0520, $0060
		dc.w $0004, $0000, $1800, $0000, $0720, $0060
		dc.w $0004, $0000, $16BF, $0000, $0720, $0060
		; SLZ
		dc.w $0004, $0000, $1FBF, $0000, $0640, $0060
		dc.w $0004, $0000, $1FBF, $0000, $0640, $0060
		dc.w $0004, $0000, $2000, $0000, $06C0, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		; SYZ
		dc.w $0004, $0000, $22C0, $0000, $0420, $0060
		dc.w $0004, $0000, $28C0, $0000, $0520, $0060
		dc.w $0004, $0000, $2C00, $0000, $0620, $0060
		dc.w $0004, $0000, $2EC0, $0000, $0620, $0060
		; SBZ
		dc.w $0004, $0000, $21C0, $0000, $0720, $0060
		dc.w $0004, $0000, $1E40, $FF00, $0800, $0060
		dc.w $0004, $2080, $2460, $0510, $0510, $0060
		dc.w $0004, $0000, $3EC0, $0000, $0720, $0060
		zonewarning LevelSizeArray,$30
		; Ending
		dc.w $0004, $0000, $0500, $0110, $0110, $0060
		dc.w $0004, $0000, $0DC0, $0110, $0110, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060
		dc.w $0004, $0000, $2FFF, $0000, $0320, $0060

; ---------------------------------------------------------------------------
; Ending start location array
; ---------------------------------------------------------------------------
EndingStLocArray:
		include	"_inc/Start Location Array - Ending.asm"

; ===========================================================================

LevSz_ChkLamp:
		tst.b	v_lastlamp	; have any lampposts been hit?
		beq.s	LevSz_StartLoc	; if not, branch

		jsr	(Lamp_LoadInfo).l
		move.w	v_player+obX,d1
		move.w	v_player+obY,d0
		bra.s	LevSz_SkipStartPos
; ===========================================================================

LevSz_StartLoc:
		move.w	v_zone,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	StartLocArray(pc,d0.w),a1 ; load Sonic's start location
		tst.w	f_demo	; is ending demo mode on?
		bpl.s	LevSz_SonicPos	; if not, branch

		move.w	v_creditsnum,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		lea	EndingStLocArray(pc,d0.w),a1 ; load Sonic's start location

LevSz_SonicPos:
		moveq	#0,d1
		move.w	(a1)+,d1
		move.w	d1,v_player+obX ; set Sonic's position on x-axis
		moveq	#0,d0
		move.w	(a1),d0
		move.w	d0,v_player+obY ; set Sonic's position on y-axis

SetScreen:
LevSz_SkipStartPos:
		subi.w	#160,d1		; is Sonic more than 160px from left edge?
		bcc.s	SetScr_WithinLeft ; if yes, branch
		moveq	#0,d1

SetScr_WithinLeft:
		move.w	v_limitright2,d2
		cmp.w	d2,d1		; is Sonic inside the right edge?
		blo.s	SetScr_WithinRight ; if yes, branch
		move.w	d2,d1

SetScr_WithinRight:
		move.w	d1,v_screenposx ; set horizontal screen position

		subi.w	#96,d0		; is Sonic within 96px of upper edge?
		bcc.s	SetScr_WithinTop ; if yes, branch
		moveq	#0,d0

SetScr_WithinTop:
		cmp.w	v_limitbtm2,d0 ; is Sonic above the bottom edge?
		blt.s	SetScr_WithinBottom ; if yes, branch
		move.w	v_limitbtm2,d0

SetScr_WithinBottom:
		move.w	d0,v_screenposy ; set vertical screen position
		bsr.w	BgScrollSpeed
		moveq	#0,d0
		move.b	v_zone,d0
		lsl.b	#2,d0
		move.l	LoopTileNums(pc,d0.w),v_256loop1
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic start location array
; ---------------------------------------------------------------------------
StartLocArray:	include	"_inc/Start Location Array - Levels.asm"

; ---------------------------------------------------------------------------
; Which	256x256	tiles contain loops or roll-tunnels
; ---------------------------------------------------------------------------

LoopTileNums:

; 		loop	loop	tunnel	tunnel

	dc.b	$B5,	$7F,	$1F,	$20	; Green Hill
	dc.b	$7F,	$7F,	$7F,	$7F	; Labyrinth
	dc.b	$7F,	$7F,	$7F,	$7F	; Marble
	dc.b	$AA,	$B4,	$7F,	$7F	; Star Light
	dc.b	$7F,	$7F,	$7F,	$7F	; Spring Yard
	dc.b	$7F,	$7F,	$7F,	$7F	; Scrap Brain
	zonewarning LoopTileNums,4
	dc.b	$7F,	$7F,	$7F,	$7F	; Ending (Green Hill)

		even

; ---------------------------------------------------------------------------
; Subroutine to	set scroll speed of some backgrounds
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BgScrollSpeed:
		tst.b	v_lastlamp
		bne.s	loc_6206
		move.w	d0,v_bgscreenposy
		move.w	d0,v_bg2screenposy
		move.w	d1,v_bgscreenposx
		move.w	d1,v_bg2screenposx
		move.w	d1,v_bg3screenposx

loc_6206:
		moveq	#0,d2
		move.b	v_zone,d2
		add.w	d2,d2
		move.w	BgScroll_Index(pc,d2.w),d2
		jmp	BgScroll_Index(pc,d2.w)
; End of function BgScrollSpeed

; ===========================================================================
BgScroll_Index:	dc.w BgScroll_GHZ-BgScroll_Index, BgScroll_LZ-BgScroll_Index
		dc.w BgScroll_MZ-BgScroll_Index, BgScroll_SLZ-BgScroll_Index
		dc.w BgScroll_SYZ-BgScroll_Index, BgScroll_SBZ-BgScroll_Index
		zonewarning BgScroll_Index,2
		dc.w BgScroll_End-BgScroll_Index
; ===========================================================================

BgScroll_GHZ:
		clr.l	v_bgscreenposx
		clr.l	v_bgscreenposy
		clr.l	v_bg2screenposy
		clr.l	v_bg3screenposy
		lea	v_bgscroll_buffer,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		rts
; ===========================================================================

BgScroll_LZ:
		asr.l	#1,d0
		move.w	d0,v_bgscreenposy
		rts	
; ===========================================================================

BgScroll_MZ:
		rts	
; ===========================================================================

BgScroll_SLZ:
		asr.l	#1,d0
		addi.w	#$C0,d0
		move.w	d0,v_bgscreenposy
		clr.l	v_bgscreenposx
		rts	
; ===========================================================================

BgScroll_SYZ:
		asl.l	#4,d0
		move.l	d0,d2
		asl.l	#1,d0
		add.l	d2,d0
		asr.l	#8,d0
		addq.w	#1,d0
		move.w	d0,v_bgscreenposy
		clr.l	v_bgscreenposx
		rts	
; ===========================================================================

BgScroll_SBZ:
		andi.w	#$7F8,d0
		asr.w	#3,d0
		addq.w	#1,d0
		move.w	d0,v_bgscreenposy
		rts	
; ===========================================================================

BgScroll_End:
		move.w	v_screenposx,d0
		asr.w	#1,d0
		move.w	d0,v_bgscreenposx
		move.w	d0,v_bg2screenposx
		asr.w	#2,d0
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		move.w	d0,v_bg3screenposx
		clr.l	v_bgscreenposy
		clr.l	v_bg2screenposy
		clr.l	v_bg3screenposy
		lea	v_bgscroll_buffer,a2
		clr.l	(a2)+
		clr.l	(a2)+
		clr.l	(a2)+
		rts
