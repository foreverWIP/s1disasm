; ---------------------------------------------------------------------------
; Subroutine to	record Sonic's previous positions for invincibility stars
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_RecordPosition:
		move.w	(v_trackpos).l,d0
		lea	(v_tracksonic).l,a1
		lea	(a1,d0.w),a1
		move.w	obX(a0),(a1)+
		move.w	obY(a0),(a1)+
		addq.b	#4,(v_trackbyte).l
		rts	
; End of function Sonic_RecordPosition