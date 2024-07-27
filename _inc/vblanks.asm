; ---------------------------------------------------------------------------
; Vertical interrupt
; ---------------------------------------------------------------------------

VBlank:
		movem.l	d0-a6,-(sp)
		tst.b	(v_vbla_routine).l
		beq.s	VBla_00
		move.w	(vdp_control_port).l,d0
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_scrposy_vdp).l,(vdp_data_port).l ; send screen y-axis pos. to VSRAM
		btst	#6,(v_megadrive).l ; is Megadrive PAL?
		beq.s	.notPAL		; if not, branch

		move.w	#$700,d0
.waitPAL:
		dbf	d0,.waitPAL ; wait here in a loop doing nothing for a while...

.notPAL:
		move.b	(v_vbla_routine).l,d0
		move.b	#0,(v_vbla_routine).l
		move.w	#1,(f_hbla_pal).l
		andi.w	#$3E,d0
		move.w	VBla_Index(pc,d0.w),d0
		jsr	VBla_Index(pc,d0.w)

VBla_Music:
		if MMD_Enabled==0
		jsr	(UpdateMusic).l
		endif

VBla_Exit:
		addq.l	#1,(v_vbla_count).l
		movem.l	(sp)+,d0-a6
		rte	
; ===========================================================================
VBla_Index:	dc.w VBla_00-VBla_Index, VBla_02-VBla_Index
		dc.w VBla_04-VBla_Index, VBla_06-VBla_Index
		dc.w VBla_08-VBla_Index, VBla_0A-VBla_Index
		dc.w VBla_0C-VBla_Index, VBla_0E-VBla_Index
		dc.w VBla_10-VBla_Index, VBla_12-VBla_Index
		dc.w VBla_14-VBla_Index, VBla_16-VBla_Index
		dc.w VBla_0C-VBla_Index
; ===========================================================================

VBla_00:
		cmpi.b	#$80+id_Level,(v_gamemode).l
		beq.s	.islevel
		cmpi.b	#id_Level,(v_gamemode).l ; is game on a level?
		bne.w	VBla_Music	; if not, branch

.islevel:
		cmpi.b	#id_LZ,(v_zone).l ; is level LZ ?
		bne.w	VBla_Music	; if not, branch

		move.w	(vdp_control_port).l,d0
		btst	#6,(v_megadrive).l ; is Megadrive PAL?
		beq.s	.notPAL		; if not, branch

		move.w	#$700,d0
.waitPAL:
		dbf	d0,.waitPAL

.notPAL:
		move.w	#1,(f_hbla_pal).l ; set HBlank flag
		stopZ80
		waitZ80
		tst.b	(f_wtr_state).l	; is water above top of screen?
		bne.s	.waterabove 	; if yes, branch

		writeCRAM	v_palette,0
		bra.s	.waterbelow

.waterabove:
		writeCRAM	v_palette_water,0

.waterbelow:
		move.w	(v_hbla_hreg).l,(a5)
		startZ80
		bra.w	VBla_Music
; ===========================================================================

VBla_02:
		bsr.w	sub_106E

VBla_14:
		tst.w	(v_demolength).l
		beq.w	.end
		subq.w	#1,(v_demolength).l

.end:
		rts	
; ===========================================================================

VBla_04:
		bsr.w	sub_106E
		bsr.w	LoadTilesAsYouMove_BGOnly
		bsr.w	sub_1642
		tst.w	(v_demolength).l
		beq.w	.end
		subq.w	#1,(v_demolength).l

.end:
		rts	
; ===========================================================================

VBla_06:
		bsr.w	sub_106E
		rts	
; ===========================================================================

VBla_10:
		if MMD_Is_SS
		bra.w	VBla_0A
		endif

VBla_08:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		tst.b	(f_wtr_state).l
		bne.s	.waterabove

		writeCRAM	v_palette,0
		bra.s	.waterbelow

.waterabove:
		writeCRAM	v_palette_water,0

.waterbelow:
		move.w	(v_hbla_hreg).l,(a5)

		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		writeVRAM	v_spritetablebuffer,vram_sprites
		tst.b	(f_sonframechg).l ; has Sonic's sprite changed?
		beq.s	.nochg		; if not, branch

		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size ; load new Sonic gfx
		move.b	#0,(f_sonframechg).l

.nochg:
		startZ80
		movem.l	(v_screenposx).l,d0-d7
		movem.l	d0-d7,(v_screenposx_dup).l
		movem.l	(v_fg_scroll_flags).l,d0-d1
		movem.l	d0-d1,(v_fg_scroll_flags_dup).l
		cmpi.b	#96,(v_hbla_line).l
		bhs.s	Demo_Time
		move.b	#1,(f_doupdatesinhblank).l
		addq.l	#4,sp
		bra.w	VBla_Exit

; ---------------------------------------------------------------------------
; Subroutine to	run a demo for an amount of time
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Demo_Time:
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		if MMD_Is_Level
		jsr	(HUD_Update).l
		endif
		bsr.w	ProcessDPLC2
		tst.w	(v_demolength).l ; is there time left on the demo?
		beq.w	.end		; if not, branch
		subq.w	#1,(v_demolength).l ; subtract 1 from time left

.end:
		rts	
; End of function Demo_Time

; ===========================================================================

VBla_0A:
		if MMD_Is_SS
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		writeCRAM	v_palette,0
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		startZ80
		call	PalCycle_SS
		tst.b	(f_sonframechg).l ; has Sonic's sprite changed?
		beq.s	.nochg		; if not, branch

		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size ; load new Sonic gfx
		move.b	#0,(f_sonframechg).l

.nochg:
		tst.w	(v_demolength).l	; is there time left on the demo?
		beq.w	.end	; if not, return
		subq.w	#1,(v_demolength).l	; subtract 1 from time left in demo

.end:
		endif
		rts	
; ===========================================================================

VBla_0C:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		tst.b	(f_wtr_state).l
		bne.s	.waterabove

		writeCRAM	v_palette,0
		bra.s	.waterbelow

.waterabove:
		writeCRAM	v_palette_water,0

.waterbelow:
		move.w	(v_hbla_hreg).l,(a5)
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		writeVRAM	v_spritetablebuffer,vram_sprites
		tst.b	(f_sonframechg).l
		beq.s	.nochg
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size
		move.b	#0,(f_sonframechg).l

.nochg:
		startZ80
		movem.l	(v_screenposx).l,d0-d7
		movem.l	d0-d7,(v_screenposx_dup).l
		movem.l	(v_fg_scroll_flags).l,d0-d1
		movem.l	d0-d1,(v_fg_scroll_flags_dup).l
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		if MMD_Is_Level
		jsr	(HUD_Update).l
		endif
		bsr.w	sub_1642
		rts	
; ===========================================================================

VBla_0E:
		bsr.w	sub_106E
		addq.b	#1,(v_vbla_0e_counter).l ; Unused besides this one write...
		move.b	#$E,(v_vbla_routine).l
		rts	
; ===========================================================================

VBla_12:
		bsr.w	sub_106E
		move.w	(v_hbla_hreg).l,(a5)
		bra.w	sub_1642
; ===========================================================================

VBla_16:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		writeCRAM	v_palette,0
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		startZ80
		tst.b	(f_sonframechg).l
		beq.s	.nochg
		writeVRAM	v_sgfx_buffer,ArtTile_Sonic*tile_size
		move.b	#0,(f_sonframechg).l

.nochg:
		tst.w	(v_demolength).l
		beq.w	.end
		subq.w	#1,(v_demolength).l

.end:
		rts	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_106E:
		stopZ80
		waitZ80
		bsr.w	ReadJoypads
		tst.b	(f_wtr_state).l ; is water above top of screen?
		bne.s	.waterabove	; if yes, branch
		writeCRAM	v_palette,0
		bra.s	.waterbelow

.waterabove:
		writeCRAM	v_palette_water,0

.waterbelow:
		writeVRAM	v_spritetablebuffer,vram_sprites
		writeVRAM	v_hscrolltablebuffer,vram_hscroll
		startZ80
		rts	
; End of function sub_106E