.state_setup:
	move.w	#$8200|($A000>>10),(vdp_control_port).l ; plane a
	move.w	#$8400|($A000>>13),(vdp_control_port).l ; plane b
	move.w	#$8500+(vram_sprites>>9),(vdp_control_port).l 
	move.w	#$9003,(vdp_control_port).l ; plane size
	move.w	#$8D00+(vram_hscroll>>10),(vdp_control_port).l ; hscroll
	move.w	#$8B00,(vdp_control_port).l ; full screen scrolling
	move.w	#$8F02,(vdp_control_port).l ; auto increment 2
	move.l	#$40000010+($0<<16),(vdp_control_port).l
	move.l	#$0,(vdp_data_port).l
	fillVRAM 0,vram_sprites,vram_sprites+$400
	writeVRAM .art,0
	writeVRAM .mappings,$A000
	moveq	#palid_SplashScreen,d0	; load Sonic's palette
	jsr		PalLoad_Fade

.state_fadein:
	jsr		PaletteFadeIn

.state_shc:
	lea		.frameTimings,a0
	lea		.frameMappings,a1
	lea		.xoffsets,a2
.state_shc_nextframe:
	move.w	(a0)+,d0
	move.w	(a1)+,d1
	cmpi.b	#$FF,d1
	beq.w	.state_fadeout
	btst	#7,d1
	beq.s	.state_shc_noplaysound
	sendSubCpuCommand #$40,#$90
.state_shc_noplaysound:
	andi.w	#$7F,d1
	subi.w	#1,d0
	moveq	#0,d2
	lsl.w	#1,d1
	move.w	(a2,d1.w),d2
	move.w	d2,(v_hscrolltablebuffer).l
	move.w	d2,(v_hscrolltablebuffer+2).l
.state_shc_waitframe:
	move.b	#$16,(v_vbla_routine).l
	jsr		WaitForVBla
	andi.b	#btnStart,(v_jpadpress1).l
	bne.s	.state_fadeout
	dbf		d0,.state_shc_waitframe
	bra.w	.state_shc_nextframe
.state_fadeout:
	jsr		PaletteFadeOut
	rts

.xoffsets:
	dc.w	0,-320,-(320*2)

.frameMappings:
	dc.w	0, $81, 2, 1, 0, 1, 2, 0, 2, 1, 0, 2, 0, 1, 2, 1, 2, 1, 0, 1, 2, 0, 2, 0, 1, 2, 0, 2, 1, 0, 2, 0, 2, 0, 1, 2, 1, 2, 0, 2, 1, 0, 2, 0, 1, 2, 1, 0, 1, 0, 1, 2, 0, 2, 1, 0, $FF
.frameMappings_end:
.frameTimings:
	dc.w	64, 1, 1, 1, 1, 1, 2, 1, 2, 1, 3, 1, 4, 3, 1, 2, 3, 2, 4, 3, 3, 4, 64, 4, 2, 3, 2, 3, 2, 2, 3, 2, 3, 2, 2, 3, 2, 64, 2, 3, 2, 2, 3, 2, 2, 3, 2, 2, 2, 2, 2, 3, 2, 3, 2, 360, $FFFF
.frameTimings_end:

.art:		binclude "../splashscreenconvert/splash_tiles.bin"
	even
.art_end:
.mappings:	binclude "../splashscreenconvert/splash_tileinfo.bin"
	even
.mappings_end:
.palette:	binclude "../splashscreenconvert/splash_palette.bin"
	even
.palette_end: