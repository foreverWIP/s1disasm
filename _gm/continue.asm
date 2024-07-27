; ---------------------------------------------------------------------------
; Continue screen
; ---------------------------------------------------------------------------

GM_Continue:
		bsr.w	PaletteFadeOut
		disable_ints
		move.w	(v_vdp_buffer1).l,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; 8 colour mode
		move.w	#$8700,(a6)	; background colour
		bsr.w	ClearScreen

		clearRAM v_objspace

		locVRAM	ArtTile_Title_Card*tile_size
		lea	(Nem_TitleCard).l,a0 ; load title card patterns
		bsr.w	NemDec
		locVRAM	ArtTile_Continue_Sonic*tile_size
		lea	(Nem_ContSonic).l,a0 ; load Sonic patterns
		bsr.w	NemDec
		locVRAM	ArtTile_Mini_Sonic*tile_size
		lea	(Nem_MiniSonic).l,a0 ; load continue screen patterns
		bsr.w	NemDec
		moveq	#10,d1
		jsr	(ContScrCounter).l	; run countdown	(start from 10)
		moveq	#palid_Continue,d0
		bsr.w	PalLoad_Fade	; load continue	screen palette
		move.b	#bgm_Continue,d0
		bsr.w	PlaySound	; play continue	music
		move.w	#659,(v_demolength).l ; set time delay to 11 seconds
		clr.l	(v_screenposx).l
		move.l	#$1000000,(v_screenposy).l
		move.b	#id_ContSonic,(v_player).l ; load Sonic object
		move.b	#id_ContScrItem,(v_continuetext).l ; load continue screen objects
		move.b	#id_ContScrItem,(v_continuelight).l
		move.b	#3,(v_continuelight+obPriority).l
		move.b	#4,(v_continuelight+obFrame).l
		move.b	#id_ContScrItem,(v_continueicon).l
		move.b	#4,(v_continueicon+obRoutine).l
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		move.w	(v_vdp_buffer1).l,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteFadeIn

; ---------------------------------------------------------------------------
; Continue screen main loop
; ---------------------------------------------------------------------------

Cont_MainLoop:
		move.b	#$16,(v_vbla_routine).l
		bsr.w	WaitForVBla
		cmpi.b	#6,(v_player+obRoutine).l
		bhs.s	loc_4DF2
		disable_ints
		move.w	(v_demolength).l,d1
		divu.w	#$3C,d1
		andi.l	#$F,d1
		jsr	(ContScrCounter).l
		enable_ints

loc_4DF2:
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		cmpi.w	#$180,(v_player+obX).l ; has Sonic run off screen?
		bhs.s	Cont_GotoLevel	; if yes, branch
		cmpi.b	#6,(v_player+obRoutine).l
		bhs.s	Cont_MainLoop
		tst.w	(v_demolength).l
		bne.w	Cont_MainLoop
		move.b	#id_Title,(v_gamemode).l ; go to title screen
		rts	
; ===========================================================================

Cont_GotoLevel:
		move.b	#id_Level,(v_gamemode).l ; set screen mode to $0C (level)
		move.b	#3,(v_lives).l	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).l	; clear rings
		move.l	d0,(v_time).l	; clear time
		move.l	d0,(v_score).l	; clear score
		move.b	d0,(v_lastlamp).l ; clear lamppost count
		subq.b	#1,(v_continues).l ; subtract 1 from continues
		rts	
; ===========================================================================

		include	"_incObj/80 Continue Screen Elements.asm"
		include	"_incObj/81 Continue Screen Sonic.asm"
		include	"_anim/Continue Screen Sonic.asm"
Map_ContScr:	include	"_maps/Continue Screen.asm"
; ---------------------------------------------------------------------------
; Subroutine to	load countdown numbers on the continue screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ContScrCounter:
		locVRAM	ArtTile_Continue_Number*tile_size
		lea	(vdp_data_port).l,a6
		lea	(Hud_10).l,a2
		moveq	#2-1,d6
		moveq	#0,d4
		lea	(Art_Hud).l,a1 ; load numbers patterns

ContScr_Loop:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1C95A:
		sub.l	d3,d1
		blo.s	loc_1C962
		addq.w	#1,d2
		bra.s	loc_1C95A
; ===========================================================================

loc_1C962:
		add.l	d3,d1
		lsl.w	#6,d2
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
		dbf	d6,ContScr_Loop	; repeat 1 more	time

		rts	
; End of function ContScrCounter
