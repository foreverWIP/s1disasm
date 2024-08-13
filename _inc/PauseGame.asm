; ---------------------------------------------------------------------------
; Subroutine to	pause the game
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PauseGame:
		nop	
		tst.b	(v_lives).l	; do you have any lives	left?
		beq.s	Unpause		; if not, branch
		tst.w	(f_pause).l	; is game already paused?
		bne.s	Pause_StopGame	; if yes, branch
		btst	#bitStart,(v_jpadpress1).l ; is Start button pressed?
		beq.s	Pause_DoNothing	; if not, branch

Pause_StopGame:
		move.w	#1,(f_pause).l	; freeze time
		move.b	#1,(v_snddriver_ram.f_pausemusic).l ; pause music

Pause_Loop:
		move.b	#$10,(v_vbla_routine).l
		bsr.w	WaitForVBla
		tst.b	(f_slomocheat).l ; is slow-motion cheat on?
		beq.s	Pause_ChkStart	; if not, branch
		btst	#bitA,(v_jpadpress1).l ; is button A pressed?
		beq.s	Pause_ChkBC	; if not, branch
		move.b	#id_Title,(v_gamemode).l ; set game mode to 4 (title screen)
		quitModule
		nop	
		bra.s	Pause_EndMusic
; ===========================================================================

Pause_ChkBC:
		btst	#bitB,(v_jpadhold1).l ; is button B pressed?
		bne.s	Pause_SlowMo	; if yes, branch
		btst	#bitC,(v_jpadpress1).l ; is button C pressed?
		bne.s	Pause_SlowMo	; if yes, branch

Pause_ChkStart:
		btst	#bitStart,(v_jpadpress1).l ; is Start button pressed?
		beq.s	Pause_Loop	; if not, branch

Pause_EndMusic:
		move.b	#$80,(v_snddriver_ram.f_pausemusic).l	; unpause the music

Unpause:
		move.w	#0,(f_pause).l	; unpause the game

Pause_DoNothing:
		rts	
; ===========================================================================

Pause_SlowMo:
		move.w	#1,(f_pause).l
		move.b	#$80,(v_snddriver_ram.f_pausemusic).l	; Unpause the music
		rts	
; End of function PauseGame
