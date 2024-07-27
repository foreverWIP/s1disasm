; ---------------------------------------------------------------------------
; Title	screen
; ---------------------------------------------------------------------------

GM_Title:
		move.b	#bgm_Stop,d0
		jsr		PlaySound_Special ; stop music
		jsr		ClearPLC
		jsr		PaletteFadeOut
		disable_ints
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$9001,(a6)	; 64-cell hscroll size
		move.w	#$9200,(a6)	; window vertical position
		move.w	#$8B03,(a6)
		move.w	#$8720,(a6)	; set background colour (palette line 2, entry 0)
		clr.b	(f_wtr_state).l
		jsr		ClearScreen

		clearRAM v_objspace

		locVRAM	ArtTile_Title_Japanese_Text*tile_size
		lea	(Nem_JapNames).l,a0 ; load Japanese credits
		jsr		NemDec
		locVRAM	ArtTile_Sonic_Team_Font*tile_size
		lea	(Nem_CreditText).l,a0 ;	load alphabet
		jsr		NemDec
		lea	(v_256x256&$FFFFFF).l,a1
		lea	(Eni_JapNames).l,a0 ; load mappings for	Japanese credits
		move.w	#make_art_tile(ArtTile_Title_Japanese_Text,0,FALSE),d0
		jsr		EniDec

		copyTilemap	v_256x256&$FFFFFF,vram_fg,40,28

		clearRAM v_palette_fading

		moveq	#palid_Sonic,d0	; load Sonic's palette
		jsr		PalLoad_Fade
		move.b	#id_CreditsText,(v_sonicteam).l ; load "SONIC TEAM PRESENTS" object
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		jsr		PaletteFadeIn
		disable_ints
		locVRAM	ArtTile_Title_Foreground*tile_size
		lea	(Nem_TitleFg).l,a0 ; load title	screen patterns
		jsr		NemDec
		locVRAM	ArtTile_Title_Sonic*tile_size
		lea	(Nem_TitleSonic).l,a0 ;	load Sonic title screen	patterns
		jsr		NemDec
		locVRAM	ArtTile_Title_Trademark*tile_size
		lea	(Nem_TitleTM).l,a0 ; load "TM" patterns
		jsr		NemDec
		lea	(vdp_data_port).l,a6
		locVRAM	ArtTile_Level_Select_Font*tile_size,4(a6)
		lea	(Art_Text).l,a5	; load level select font
		move.w	#(Art_Text_End-Art_Text)/2-1,d1

Tit_LoadText:
		move.w	(a5)+,(a6)
		dbf	d1,Tit_LoadText	; load level select font

		move.b	#0,(v_lastlamp).l ; clear lamppost counter
		move.w	#0,(v_debuguse).l ; disable debug item placement mode
		move.w	#0,(f_demo).l	; disable debug mode
		move.w	#0,(v_unused2).l ; unused variable
		move.w	#(id_GHZ<<8),(v_zone).l	; set level to GHZ (00)
		move.w	#0,(v_pcyc_time).l ; disable palette cycling
		jsr		LevelSizeLoad
		jsr		DeformLayers
		lea	(v_16x16).l,a1
		lea	(Blk16_GHZ).l,a0 ; load	GHZ 16x16 mappings
		move.w	#make_art_tile(ArtTile_Level,0,FALSE),d0
		jsr		EniDec
		lea	(Blk256_GHZ).l,a0 ; load GHZ 256x256 mappings
		lea	(v_256x256&$FFFFFF).l,a1
		jsr		KosDec
		jsr		LevelLayoutLoad
		jsr		PaletteFadeOut
		disable_ints
		jsr		ClearScreen
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bgscreenposx).l,a3
		lea	(v_lvllayout+$40).l,a4
		move.w	#$6000,d2
		jsr		DrawChunks
		lea	(v_256x256&$FFFFFF).l,a1
		lea	(Eni_Title).l,a0 ; load	title screen mappings
		move.w	#0,d0
		jsr		EniDec

		copyTilemap	v_256x256&$FFFFFF,vram_fg+$206,34,22

		locVRAM	ArtTile_Level*tile_size
		lea	(Nem_GHZ_1st).l,a0 ; load GHZ patterns
		jsr		NemDec
		moveq	#palid_Title,d0	; load title screen palette
		jsr		PalLoad_Fade
		move.b	#bgm_Title,d0
		jsr		PlaySound_Special	; play title screen music
		move.b	#0,(f_debugmode).l ; disable debug mode
		move.w	#$178,(v_demolength).l ; run title screen for $178 frames
		
	if FixBugs
		clearRAM v_sonicteam,v_sonicteam+object_size
	else
		; Bug: this only clears half of the "SONIC TEAM PRESENTS" slot.
		; This is responsible for why the "PRESS START BUTTON" text doesn't
		; show up, as the routine ID isn't reset.
		clearRAM v_sonicteam,v_sonicteam+object_size/2
	endif

		move.b	#id_TitleSonic,(v_titlesonic).l ; load big Sonic object
		move.b	#id_PSBTM,(v_pressstart).l ; load "PRESS START BUTTON" object
		;clr.b	(v_pressstart+obRoutine).l ; The 'Mega Games 10' version of Sonic 1 added this line, to fix the 'PRESS START BUTTON' object not appearing

		tst.b   (v_megadrive).l	; is console Japanese?
		bpl.s   .isjap		; if yes, branch

		move.b	#id_PSBTM,(v_titletm).l ; load "TM" object
		move.b	#3,(v_titletm+obFrame).l
.isjap:
		move.b	#id_PSBTM,(v_ttlsonichide).l ; load object which hides part of Sonic
		move.b	#2,(v_ttlsonichide+obFrame).l
		jsr	(ExecuteObjects).l
		jsr		DeformLayers
		jsr	(BuildSprites).l
		moveq	#plcid_Main,d0
		jsr		NewPLC
		move.w	#0,(v_title_dcount).l
		move.w	#0,(v_title_ccount).l
		move.w	(v_vdp_buffer1).l,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		jsr		PaletteFadeIn

Tit_MainLoop:
		move.b	#4,(v_vbla_routine).l
		jsr		WaitForVBla
		jsr	(ExecuteObjects).l
		jsr		DeformLayers
		jsr	(BuildSprites).l
		jsr		PalCycle_Title
		jsr		RunPLC
		move.w	(v_player+obX).l,d0
		addq.w	#2,d0
		move.w	d0,(v_player+obX).l ; move Sonic to the right
		cmpi.w	#$1C00,d0	; has Sonic object passed $1C00 on x-axis?
		blo.s	Tit_ChkRegion	; if not, branch

		move.b	#id_Title,(v_gamemode).l ; go to title screen
		rts	
; ===========================================================================

Tit_ChkRegion:
		tst.b	(v_megadrive).l	; check	if the machine is US or	Japanese
		bpl.s	Tit_RegionJap	; if Japanese, branch

		lea	(LevSelCode_US).l,a0 ; load US code
		bra.s	Tit_EnterCheat

Tit_RegionJap:
		lea	(LevSelCode_J).l,a0 ; load J code

Tit_EnterCheat:
		move.w	(v_title_dcount).l,d0
		adda.w	d0,a0
		move.b	(v_jpadpress1).l,d0 ; get button press
		andi.b	#btnDir,d0	; read only UDLR buttons
		cmp.b	(a0),d0		; does button press match the cheat code?
		bne.s	Tit_ResetCheat	; if not, branch
		addq.w	#1,(v_title_dcount).l ; next button press
		tst.b	d0
		bne.s	Tit_CountC
		lea	(f_levselcheat).l,a0
		move.w	(v_title_ccount).l,d1
		lsr.w	#1,d1
		andi.w	#3,d1
		beq.s	Tit_PlayRing
		tst.b	(v_megadrive).l
		bpl.s	Tit_PlayRing
		moveq	#1,d1
		move.b	d1,1(a0,d1.w)	; cheat depends on how many times C is pressed

Tit_PlayRing:
		move.b	#1,(a0,d1.w)	; activate cheat
		move.b	#sfx_Ring,d0
		jsr		PlaySound_Special	; play ring sound when code is entered
		bra.s	Tit_CountC
; ===========================================================================

Tit_ResetCheat:
		tst.b	d0
		beq.s	Tit_CountC
		cmpi.w	#9,(v_title_dcount).l
		beq.s	Tit_CountC
		move.w	#0,(v_title_dcount).l ; reset UDLR counter

Tit_CountC:
		move.b	(v_jpadpress1).l,d0
		andi.b	#btnC,d0	; is C button pressed?
		beq.s	loc_3230	; if not, branch
		addq.w	#1,(v_title_ccount).l ; increment C counter

loc_3230:
		tst.w	(v_demolength).l
		beq.w	GotoDemo
		andi.b	#btnStart,(v_jpadpress1).l ; check if Start is pressed
		beq.w	Tit_MainLoop	; if not, branch

Tit_ChkLevSel:
		tst.b	(f_levselcheat).l ; check if level select code is on
		beq.w	PlayLevel	; if not, play level
		btst	#bitA,(v_jpadhold1).l ; check if A is pressed
		beq.w	PlayLevel	; if not, play level

		moveq	#palid_LevelSel,d0
		jsr		PalLoad	; load level select palette

		clearRAM v_hscrolltablebuffer

		move.l	d0,(v_scrposy_vdp).l
		disable_ints
		lea	(vdp_data_port).l,a6
		locVRAM	vram_bg
		move.w	#plane_size_64x32/4-1,d1

Tit_ClrScroll2:
		move.l	d0,(a6)
		dbf	d1,Tit_ClrScroll2 ; clear scroll data (in VRAM)

		bsr.w	LevSelTextLoad

; ---------------------------------------------------------------------------
; Level	Select
; ---------------------------------------------------------------------------

LevelSelect:
		move.b	#4,(v_vbla_routine).l
		jsr		WaitForVBla
		bsr.w	LevSelControls
		jsr		RunPLC
		tst.l	(v_plc_buffer).l
		bne.s	LevelSelect
		andi.b	#btnABC+btnStart,(v_jpadpress1).l ; is A, B, C, or Start pressed?
		beq.s	LevelSelect	; if not, branch
		move.w	(v_levselitem).l,d0
		cmpi.w	#$14,d0		; have you selected item $14 (sound test)?
		bne.s	LevSel_Level_SS	; if not, go to	Level/SS subroutine
		move.w	(v_levselsound).l,d0
		addi.w	#$80,d0
		tst.b	(f_creditscheat).l ; is Japanese Credits cheat on?
		beq.s	LevSel_NoCheat	; if not, branch
		cmpi.w	#$9F,d0		; is sound $9F being played?
		beq.s	LevSel_Ending	; if yes, branch
		cmpi.w	#$9E,d0		; is sound $9E being played?
		beq.s	LevSel_Credits	; if yes, branch

LevSel_NoCheat:
		; This is a workaround for a bug; see PlaySoundID for more.
		; Once you've fixed the bugs there, comment these four instructions out.
		cmpi.w	#bgm__Last+1,d0	; is sound $80-$93 being played?
		blo.s	LevSel_PlaySnd	; if yes, branch
		cmpi.w	#sfx__First,d0	; is sound $94-$9F being played?
		blo.s	LevelSelect	; if yes, branch

LevSel_PlaySnd:
		jsr		PlaySound_Special
		bra.s	LevelSelect
; ===========================================================================

LevSel_Ending:
		move.b	#id_Ending,(v_gamemode).l ; set screen mode to $18 (Ending)
		move.w	#(id_EndZ<<8),(v_zone).l ; set level to 0600 (Ending)
		rts	
; ===========================================================================

LevSel_Credits:
		move.b	#id_Credits,(v_gamemode).l ; set screen mode to $1C (Credits)
		move.b	#bgm_Credits,d0
		jsr		PlaySound_Special ; play credits music
		move.w	#0,(v_creditsnum).l
		rts	
; ===========================================================================

LevSel_Level_SS:
		add.w	d0,d0
		lea		LevSel_Ptrs,a0 ; load level number
		adda.l	d0,a0
		move.w	(a0),d0
		bmi.w	LevelSelect
		cmpi.w	#id_SS*$100,d0	; check	if level is 0700 (Special Stage)
		bne.s	LevSel_Level	; if not, branch
		move.b	#id_Special,(v_gamemode).l ; set screen mode to $10 (Special Stage)
		clr.w	(v_zone).l	; clear	level
		move.b	#3,(v_lives).l	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).l	; clear rings
		move.l	d0,(v_time).l	; clear time
		move.l	d0,(v_score).l	; clear score
		move.l	#5000,(v_scorelife).l ; extra life is awarded at 50000 points
		rts	
; ===========================================================================

LevSel_Level:
		andi.w	#$3FFF,d0
		move.w	d0,(v_zone).l	; set level number

PlayLevel:
		move.b	#id_Level,(v_gamemode).l ; set screen mode to $0C (level)
		move.b	#3,(v_lives).l	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).l	; clear rings
		move.l	d0,(v_time).l	; clear time
		move.l	d0,(v_score).l	; clear score
		move.b	d0,(v_lastspecial).l ; clear special stage number
		move.b	d0,(v_emeralds).l ; clear emeralds
		move.l	d0,(v_emldlist).l ; clear emeralds
		move.l	d0,(v_emldlist+4).l ; clear emeralds
		move.b	d0,(v_continues).l ; clear continues
		move.l	#5000,(v_scorelife).l ; extra life is awarded at 50000 points
		move.b	#bgm_Fade,d0
		jsr		PlaySound_Special ; fade out music
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Level	select - level pointers
; ---------------------------------------------------------------------------
LevSel_Ptrs:
		dc.b id_GHZ, 0
		dc.b id_GHZ, 1
		dc.b id_GHZ, 2
		dc.b id_MZ, 0
		dc.b id_MZ, 1
		dc.b id_MZ, 2
		dc.b id_SYZ, 0
		dc.b id_SYZ, 1
		dc.b id_SYZ, 2
		dc.b id_LZ, 0
		dc.b id_LZ, 1
		dc.b id_LZ, 2
		dc.b id_SLZ, 0
		dc.b id_SLZ, 1
		dc.b id_SLZ, 2
		dc.b id_SBZ, 0
		dc.b id_SBZ, 1
		dc.b id_LZ, 3
		dc.b id_SBZ, 2
		dc.b id_SS, 0		; Special Stage
		dc.w $8000		; Sound Test
		even
; ---------------------------------------------------------------------------
; Level	select codes
; ---------------------------------------------------------------------------
LevSelCode_J:	dc.b btnUp,btnDn,btnDn,btnDn,btnL,btnR,0,$FF
		even

LevSelCode_US:	dc.b btnUp,btnDn,btnL,btnR,0,$FF
		even
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to	change what you're selecting in the level select
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSelControls:
		move.b	(v_jpadpress1).l,d1
		andi.b	#btnUp+btnDn,d1	; is up/down pressed and held?
		bne.s	LevSel_UpDown	; if yes, branch
		subq.w	#1,(v_levseldelay).l ; subtract 1 from time to next move
		bpl.s	LevSel_SndTest	; if time remains, branch

LevSel_UpDown:
		move.w	#$B,(v_levseldelay).l ; reset time delay
		move.b	(v_jpadhold1).l,d1
		andi.b	#btnUp+btnDn,d1	; is up/down pressed?
		beq.s	LevSel_SndTest	; if not, branch
		move.w	(v_levselitem).l,d0
		btst	#bitUp,d1	; is up	pressed?
		beq.s	LevSel_Down	; if not, branch
		subq.w	#1,d0		; move up 1 selection
		bhs.s	LevSel_Down
		moveq	#$14,d0		; if selection moves below 0, jump to selection	$14

LevSel_Down:
		btst	#bitDn,d1	; is down pressed?
		beq.s	LevSel_Refresh	; if not, branch
		addq.w	#1,d0		; move down 1 selection
		cmpi.w	#$15,d0
		blo.s	LevSel_Refresh
		moveq	#0,d0		; if selection moves above $14,	jump to	selection 0

LevSel_Refresh:
		move.w	d0,(v_levselitem).l ; set new selection
		bsr.w	LevSelTextLoad	; refresh text
		rts	
; ===========================================================================

LevSel_SndTest:
		cmpi.w	#$14,(v_levselitem).l ; is item $14 selected?
		bne.s	LevSel_NoMove	; if not, branch
		move.b	(v_jpadpress1).l,d1
		andi.b	#btnR+btnL,d1	; is left/right	pressed?
		beq.s	LevSel_NoMove	; if not, branch
		move.w	(v_levselsound).l,d0
		btst	#bitL,d1	; is left pressed?
		beq.s	LevSel_Right	; if not, branch
		subq.w	#1,d0		; subtract 1 from sound	test
		bhs.s	LevSel_Right
		moveq	#$4F,d0		; if sound test	moves below 0, set to $4F

LevSel_Right:
		btst	#bitR,d1	; is right pressed?
		beq.s	LevSel_Refresh2	; if not, branch
		addq.w	#1,d0		; add 1	to sound test
		cmpi.w	#$50,d0
		blo.s	LevSel_Refresh2
		moveq	#0,d0		; if sound test	moves above $4F, set to	0

LevSel_Refresh2:
		move.w	d0,(v_levselsound).l ; set sound test number
		bsr.w	LevSelTextLoad	; refresh text

LevSel_NoMove:
		rts	
; End of function LevSelControls

; ---------------------------------------------------------------------------
; Subroutine to load level select text
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSelTextLoad:

textpos:	= ($40000000+(($E210&$3FFF)<<16)+(($E210&$C000)>>14))
					; $E210 is a VRAM address

		lea	(LevelMenuText).l,a1
		lea	(vdp_data_port).l,a6
		move.l	#textpos,d4	; text position on screen
		move.w	#$E680,d3	; VRAM setting (4th palette, $680th tile)
		moveq	#$14,d1		; number of lines of text

LevSel_DrawAll:
		move.l	d4,4(a6)
		bsr.w	LevSel_ChgLine	; draw line of text
		addi.l	#$800000,d4	; jump to next line
		dbf	d1,LevSel_DrawAll

		moveq	#0,d0
		move.w	(v_levselitem).l,d0
		move.w	d0,d1
		move.l	#textpos,d4
		lsl.w	#7,d0
		swap	d0
		add.l	d0,d4
		lea	(LevelMenuText).l,a1
		lsl.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		adda.w	d1,a1
		move.w	#$C680,d3	; VRAM setting (3rd palette, $680th tile)
		move.l	d4,4(a6)
		bsr.w	LevSel_ChgLine	; recolour selected line
		move.w	#$E680,d3
		cmpi.w	#$14,(v_levselitem).l
		bne.s	LevSel_DrawSnd
		move.w	#$C680,d3

LevSel_DrawSnd:
		locVRAM	vram_bg+$C30		; sound test position on screen
		move.w	(v_levselsound).l,d0
		addi.w	#$80,d0
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.w	LevSel_ChgSnd	; draw 1st digit
		move.b	d2,d0
		bsr.w	LevSel_ChgSnd	; draw 2nd digit
		rts	
; End of function LevSelTextLoad


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSel_ChgSnd:
		andi.w	#$F,d0
		cmpi.b	#$A,d0		; is digit $A-$F?
		blo.s	LevSel_Numb	; if not, branch
		addi.b	#7,d0		; use alpha characters

LevSel_Numb:
		add.w	d3,d0
		move.w	d0,(a6)
		rts	
; End of function LevSel_ChgSnd


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSel_ChgLine:
		moveq	#$17,d2		; number of characters per line

LevSel_LineLoop:
		moveq	#0,d0
		move.b	(a1)+,d0	; get character
		bpl.s	LevSel_CharOk	; branch if valid
		move.w	#0,(a6)		; use blank character
		dbf	d2,LevSel_LineLoop
		rts	


LevSel_CharOk:
		add.w	d3,d0		; combine char with VRAM setting
		move.w	d0,(a6)		; send to VRAM
		dbf	d2,LevSel_LineLoop
		rts	
; End of function LevSel_ChgLine

; ===========================================================================
; ---------------------------------------------------------------------------
; Level	select menu text
; ---------------------------------------------------------------------------
LevelMenuText:	binclude	"misc/Level Select Text (JP1).bin"
		even

		include	"_incObj/0E Title Screen Sonic.asm"
		include	"_incObj/0F Press Start and TM.asm"

		include	"_anim/Title Screen Sonic.asm"
		include	"_anim/Press Start and TM.asm"

Pal_TitleCyc:	binclude	"palette/Cycle - Title Screen Water.bin"
Pal_Title:	bincludePalette	"palette/Title Screen.bin"
Map_TSon:	include	"_maps/Title Screen Sonic.asm"
Eni_Title:	binclude	"tilemaps/Title Screen.eni" ; title screen foreground (mappings)
		even
; ---------------------------------------------------------------------------
; Demo mode
; ---------------------------------------------------------------------------

GotoDemo:
		move.w	#$1E,(v_demolength).l

loc_33B6:
		move.b	#4,(v_vbla_routine).l
		call	WaitForVBla
		call	DeformLayers
		call	PaletteCycle
		call	RunPLC
		move.w	(v_player+obX).l,d0
		addq.w	#2,d0
		move.w	d0,(v_player+obX).l
		cmpi.w	#$1C00,d0
		blo.s	loc_33E4
		move.b	#id_Title,(v_gamemode).l
		rts	
; ===========================================================================

loc_33E4:
		andi.b	#btnStart,(v_jpadpress1).l ; is Start button pressed?
		bne.w	Tit_ChkLevSel	; if yes, branch
		tst.w	(v_demolength).l
		bne.w	loc_33B6
		move.b	#bgm_Fade,d0
		jsr		PlaySound_Special ; fade out music
		move.w	(v_demonum).l,d0 ; load	demo number
		andi.w	#7,d0
		add.w	d0,d0
		move.w	Demo_Levels(pc,d0.w),d0	; load level number for	demo
		move.w	d0,(v_zone).l
		addq.w	#1,(v_demonum).l ; add 1 to demo number
		cmpi.w	#4,(v_demonum).l ; is demo number less than 4?
		blo.s	loc_3422	; if yes, branch
		move.w	#0,(v_demonum).l ; reset demo number to	0

loc_3422:
		move.w	#1,(f_demo).l	; turn demo mode on
		move.b	#id_Demo,(v_gamemode).l ; set screen mode to 08 (demo)
		cmpi.w	#$600,d0	; is level number 0600 (special	stage)?
		bne.s	Demo_Level	; if not, branch
		move.b	#id_Special,(v_gamemode).l ; set screen mode to $10 (Special Stage)
		clr.w	(v_zone).l	; clear	level number
		clr.b	(v_lastspecial).l ; clear special stage number

Demo_Level:
		move.b	#3,(v_lives).l	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).l	; clear rings
		move.l	d0,(v_time).l	; clear time
		move.l	d0,(v_score).l	; clear score
		move.l	#5000,(v_scorelife).l ; extra life is awarded at 50000 points
		rts	

; ---------------------------------------------------------------------------
; Levels used in demos
; ---------------------------------------------------------------------------
Demo_Levels:	binclude	"misc/Demo Level Order - Intro.bin"
		even