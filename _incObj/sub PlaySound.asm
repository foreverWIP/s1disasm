; ---------------------------------------------------------------------------
; Subroutine to	play a music track

; input:
;	d0 = track to play
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PlaySound:
		tst.b	(v_use_cd_audio).l
		beq.s	.playfm
		cmpi.b	#sfx__First,d0
		bhs.s	.ret

		sendSubCpuCommand #$41,d0
		rts
.playfm:
		move.b	d0,(v_snddriver_ram.v_soundqueue0).l
.ret:
		rts	
; End of function PlaySound

; ---------------------------------------------------------------------------
; Subroutine to	play a sound effect
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PlaySound_Special:
		tst.b	(v_use_cd_audio).l
		beq.s	.playfm
		cmpi.b	#sfx__First,d0
		bhs.s	.ret

		sendSubCpuCommand #$41,d0
		rts
.playfm:
		move.b	d0,(v_snddriver_ram.v_soundqueue1).l
.ret:
		rts	
; End of function PlaySound_Special

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused sound/music subroutine
; ---------------------------------------------------------------------------

PlaySound_Unused:
		tst.b	(v_use_cd_audio).l
		beq.s	.playfm
		cmpi.b	#sfx__First,d0
		bhs.s	.ret

		sendSubCpuCommand #$41,d0
		rts
.playfm:
		move.b	d0,(v_snddriver_ram.v_soundqueue2).l
.ret:
		rts	
