; ===========================================================================
; ---------------------------------------------------------------------------
; Ending sequence in Green Hill	Zone
; ---------------------------------------------------------------------------

GM_Ending:
		move.b	#bgm_Stop,d0
		bsr.w	PlaySound_Special ; stop music
		bsr.w	PaletteFadeOut

		clearRAM v_objspace
		clearRAM v_misc_variables
		clearRAM v_levelvariables
		clearRAM v_timingandscreenvariables

		disable_ints
		move.w	(v_vdp_buffer1).l,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)	; line scroll mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$8500+(vram_sprites>>9),(a6) ; set sprite table address
		move.w	#$9001,(a6)		; 64-cell hscroll size
		move.w	#$8004,(a6)		; 8-colour mode
		move.w	#$8720,(a6)		; set background colour (line 3; colour 0)
		move.w	#$8A00+223,(v_hbla_hreg).l ; set palette change position (for water)
		move.w	(v_hbla_hreg).l,(a6)
		move.w	#30,(v_air).l
		move.w	#id_EndZ<<8,(v_zone).l ; set level number to 0600 (extra flowers)
		cmpi.b	#6,(v_emeralds).l ; do you have all 6 emeralds?
		beq.s	End_LoadData	; if yes, branch
		move.w	#(id_EndZ<<8)+1,(v_zone).l ; set level number to 0601 (no flowers)

End_LoadData:
		moveq	#plcid_Ending,d0
		bsr.w	QuickPLC	; load ending sequence patterns
		jsr	(Hud_Base).l
		bsr.w	LevelSizeLoad
		bsr.w	DeformLayers
		bset	#2,(v_fg_scroll_flags).l
		bsr.w	LevelDataLoad
		bsr.w	LoadTilesFromStart
		enable_ints
		lea	(Kos_EndFlowers).l,a0 ;	load extra flower patterns
		lea	(v_256x256_end-$1000).l,a1 ; RAM address to buffer the patterns
		bsr.w	KosDec
		moveq	#palid_Sonic,d0
		bsr.w	PalLoad_Fade	; load Sonic's palette
		move.w	#bgm_Ending,d0
		bsr.w	PlaySound	; play ending sequence music
		btst	#bitA,(v_jpadhold1).l ; is button A pressed?
		beq.s	End_LoadSonic	; if not, branch
		move.b	#1,(f_debugmode).l ; enable debug mode

End_LoadSonic:
		move.b	#id_SonicPlayer,(v_player).l ; load Sonic object
		bset	#0,(v_player+obStatus).l ; make Sonic face left
		move.b	#1,(f_lockctrl).l ; lock controls
		move.w	#(btnL<<8),(v_jpadhold2).l ; move Sonic to the left
		move.w	#$F800,(v_player+obInertia).l ; set Sonic's speed
		move.b	#id_HUD,(v_hud).l ; load HUD object
		jsr	(ObjPosLoad).l
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		moveq	#0,d0
		move.w	d0,(v_rings).l
		move.l	d0,(v_time).l
		move.b	d0,(v_lifecount).l
		move.b	d0,(v_shield).l
		move.b	d0,(v_invinc).l
		move.b	d0,(v_shoes).l
		move.b	d0,(v_unused1).l
		move.w	d0,(v_debuguse).l
		move.w	d0,(f_restart).l
		move.w	d0,(v_framecount).l
		bsr.w	OscillateNumInit
		move.b	#1,(f_scorecount).l
		move.b	#1,(f_ringcount).l
		move.b	#0,(f_timecount).l
		move.w	#1800,(v_demolength).l
		move.b	#$18,(v_vbla_routine).l
		bsr.w	WaitForVBla
		move.w	(v_vdp_buffer1).l,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		move.w	#$3F,(v_pfade_start).l
		bsr.w	PaletteFadeIn

; ---------------------------------------------------------------------------
; Main ending sequence loop
; ---------------------------------------------------------------------------

End_MainLoop:
		bsr.w	PauseGame
		move.b	#$18,(v_vbla_routine).l
		bsr.w	WaitForVBla
		addq.w	#1,(v_framecount).l
		bsr.w	End_MoveSonic
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		bsr.w	PaletteCycle
		bsr.w	OscillateNumDo
		bsr.w	SynchroAnimate
		cmpi.b	#id_Ending,(v_gamemode).l ; is game mode $18 (ending)?
		beq.s	End_ChkEmerald	; if yes, branch

		move.b	#id_Credits,(v_gamemode).l ; goto credits
		move.b	#bgm_Credits,d0
		bsr.w	PlaySound_Special ; play credits music
		move.w	#0,(v_creditsnum).l ; set credits index number to 0
		rts	
; ===========================================================================

End_ChkEmerald:
		tst.w	(f_restart).l	; has Sonic released the emeralds?
		beq.w	End_MainLoop	; if not, branch

		clr.w	(f_restart).l
		move.w	#$3F,(v_pfade_start).l
		clr.w	(v_palchgspeed).l

End_AllEmlds:
		bsr.w	PauseGame
		move.b	#$18,(v_vbla_routine).l
		bsr.w	WaitForVBla
		addq.w	#1,(v_framecount).l
		bsr.w	End_MoveSonic
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		bsr.w	OscillateNumDo
		bsr.w	SynchroAnimate
		subq.w	#1,(v_palchgspeed).l
		bpl.s	End_SlowFade
		move.w	#2,(v_palchgspeed).l
		bsr.w	WhiteOut_ToWhite

End_SlowFade:
		tst.w	(f_restart).l
		beq.w	End_AllEmlds
		clr.w	(f_restart).l
		move.w	#$2E2F,(v_lvllayout+$80).l ; modify level layout
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_screenposx).l,a3
		lea	(v_lvllayout).l,a4
		move.w	#$4000,d2
		bsr.w	DrawChunks
		moveq	#palid_Ending,d0
		bsr.w	PalLoad_Fade	; load ending palette
		bsr.w	PaletteWhiteIn
		bra.w	End_MainLoop

; ---------------------------------------------------------------------------
; Subroutine controlling Sonic on the ending sequence
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


End_MoveSonic:
		move.b	(v_sonicend).l,d0
		bne.s	End_MoveSon2
		cmpi.w	#$90,(v_player+obX).l ; has Sonic passed $90 on x-axis?
		bhs.w	End_MoveSonExit	; if not, branch

		addq.b	#2,(v_sonicend).l
		move.b	#1,(f_lockctrl).l ; lock player's controls
		move.w	#(btnR<<8),(v_jpadhold2).l ; move Sonic to the right
		rts	
; ===========================================================================

End_MoveSon2:
		subq.b	#2,d0
		bne.s	End_MoveSon3
		cmpi.w	#$A0,(v_player+obX).l ; has Sonic passed $A0 on x-axis?
		blo.w	End_MoveSonExit	; if not, branch

		addq.b	#2,(v_sonicend).l
		moveq	#0,d0
		move.b	d0,(f_lockctrl).l
		move.w	d0,(v_jpadhold2).l ; stop Sonic moving
		move.w	d0,(v_player+obInertia).l
		move.b	#$81,(f_playerctrl).l ; lock controls and disable object interaction
		move.b	#fr_Wait2,(v_player+obFrame).l
		move.w	#(id_Wait<<8)+id_Wait,(v_player+obAnim).l ; use "standing" animation
		move.b	#3,(v_player+obTimeFrame).l
		rts	
; ===========================================================================

End_MoveSon3:
		subq.b	#2,d0
		bne.w	End_MoveSonExit
		addq.b	#2,(v_sonicend).l
		move.w	#$A0,(v_player+obX).l
		move.b	#id_EndSonic,(v_player).l ; load Sonic ending sequence object
		clr.w	(v_player+obRoutine).l

End_MoveSonExit:
		rts	
; End of function End_MoveSonic

; ===========================================================================

		include	"_incObj/87 Ending Sequence Sonic.asm"
		include "_anim/Ending Sequence Sonic.asm"
		include	"_incObj/88 Ending Sequence Emeralds.asm"
		include	"_incObj/89 Ending Sequence STH.asm"
Map_ESon:	include	"_maps/Ending Sequence Sonic.asm"
Map_ESth:	include	"_maps/Ending Sequence STH.asm"
; ---------------------------------------------------------------------------
; Ending sequence demos
; ---------------------------------------------------------------------------
Demo_EndGHZ1:	binclude	"demodata/Ending - GHZ1.bin"
		even
Demo_EndMZ:	binclude	"demodata/Ending - MZ.bin"
		even
Demo_EndSYZ:	binclude	"demodata/Ending - SYZ.bin"
		even
Demo_EndLZ:	binclude	"demodata/Ending - LZ.bin"
		even
Demo_EndSLZ:	binclude	"demodata/Ending - SLZ.bin"
		even
Demo_EndSBZ1:	binclude	"demodata/Ending - SBZ1.bin"
		even
Demo_EndSBZ2:	binclude	"demodata/Ending - SBZ2.bin"
		even
Demo_EndGHZ2:	binclude	"demodata/Ending - GHZ2.bin"
		even