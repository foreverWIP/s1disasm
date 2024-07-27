; ---------------------------------------------------------------------------
; Credits ending sequence
; ---------------------------------------------------------------------------

GM_Credits:
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)		; 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$9001,(a6)		; 64-cell hscroll size
		move.w	#$9200,(a6)		; window vertical position
		move.w	#$8B03,(a6)		; line scroll mode
		move.w	#$8720,(a6)		; set background colour (line 3; colour 0)
		clr.b	(f_wtr_state).l
		bsr.w	ClearScreen

		clearRAM v_objspace

		locVRAM	ArtTile_Credits_Font*tile_size
		lea	(Nem_CreditText).l,a0 ;	load credits alphabet patterns
		bsr.w	NemDec

		clearRAM v_palette_fading

		moveq	#palid_Sonic,d0
		bsr.w	PalLoad_Fade	; load Sonic's palette
		move.b	#id_CreditsText,(v_credits).l ; load credits object
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		bsr.w	EndingDemoLoad
		if MMD_Is_GHZ
		movea.l	#LevelHeader_GHZ,a2
		endif
		if MMD_Is_MZ
		movea.l	#LevelHeader_MZ,a2
		endif
		if MMD_Is_SYZ
		movea.l	#LevelHeader_SYZ,a2
		endif
		if MMD_Is_LZ
		movea.l	#LevelHeader_LZ,a2
		endif
		if MMD_Is_SLZ
		movea.l	#LevelHeader_SLZ,a2
		endif
		if MMD_Is_SBZ
		movea.l	#LevelHeader_SBZ,a2
		endif
		if MMD_Is_Ending
		movea.l	#LevelHeader_Ending,a2
		endif
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	Cred_SkipObjGfx
		bsr.w	AddPLC		; load object graphics

Cred_SkipObjGfx:
		moveq	#plcid_Main2,d0
		bsr.w	AddPLC		; load standard	level graphics
		move.w	#120,(v_demolength).l ; display a credit for 2 seconds
		bsr.w	PaletteFadeIn

Cred_WaitLoop:
		move.b	#4,(v_vbla_routine).l
		bsr.w	WaitForVBla
		bsr.w	RunPLC
		tst.w	(v_demolength).l ; have 2 seconds elapsed?
		bne.s	Cred_WaitLoop	; if not, branch
		tst.l	(v_plc_buffer).l ; have level gfx finished decompressing?
		bne.s	Cred_WaitLoop	; if not, branch
		cmpi.w	#9,(v_creditsnum).l ; have the credits finished?
		beq.w	TryAgainEnd	; if yes, branch
		rts	

		include	"_incObj/8B Try Again & End Eggman.asm"
		include "_anim/Try Again & End Eggman.asm"
		include	"_incObj/8C Try Again Emeralds.asm"
Map_EEgg:	include	"_maps/Try Again & End Eggman.asm"