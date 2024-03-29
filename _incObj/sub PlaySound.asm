; ---------------------------------------------------------------------------
; Subroutine to	play a music track

; input:
;	d0 = track to play
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PlaySound:
		if NeoGeo=0
		move.b	d0,v_snddriver_ram+v_soundqueue0
		endif
		rts	
; End of function PlaySound

; ---------------------------------------------------------------------------
; Subroutine to	play a sound effect
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PlaySound_Special:
		if NeoGeo=0
		move.b	d0,v_snddriver_ram+v_soundqueue1
		endif
		rts	
; End of function PlaySound_Special

; ===========================================================================
; ---------------------------------------------------------------------------
; Unused sound/music subroutine
; ---------------------------------------------------------------------------

PlaySound_Unused:
		if NeoGeo=0
		move.b	d0,v_snddriver_ram+v_soundqueue2
		endif
		rts	
