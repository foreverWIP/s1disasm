; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Water:
		cmpi.b	#id_LZ,v_zone	; is level LZ?
		beq.s	.islabyrinth	; if yes, branch

.exit:
		rts	
; ===========================================================================

.islabyrinth:
		move.w	v_waterpos1,d0
		cmp.w	obY(a0),d0	; is Sonic above the water?
		bge.s	.abovewater	; if yes, branch
		bset	#6,obStatus(a0)
		bne.s	.exit
		bsr.w	ResumeMusic
		move.b	#id_DrownCount,v_sonicbubbles ; load bubbles object from Sonic's mouth
		move.b	#$81,v_sonicbubbles+obSubtype
		move.w	#$300,v_sonspeedmax ; change Sonic's top speed
		move.w	#6,v_sonspeedacc ; change Sonic's acceleration
		move.w	#$40,v_sonspeeddec ; change Sonic's deceleration
		asr	obVelX(a0)
		asr	obVelY(a0)
		asr	obVelY(a0)	; slow Sonic
		beq.s	.exit		; branch if Sonic stops moving
		move.b	#id_Splash,v_splash ; load splash object
		move.w	#sfx_Splash,d0
		jmp	(PlaySound_Special).l	 ; play splash sound
; ===========================================================================

.abovewater:
		bclr	#6,obStatus(a0)
		beq.s	.exit
		bsr.w	ResumeMusic
		move.w	#$600,v_sonspeedmax ; restore Sonic's speed
		move.w	#$C,v_sonspeedacc ; restore Sonic's acceleration
		move.w	#$80,v_sonspeeddec ; restore Sonic's deceleration
		asl	obVelY(a0)
		beq.w	.exit
		move.b	#id_Splash,v_splash ; load splash object
		cmpi.w	#-$1000,obVelY(a0)
		bgt.s	.belowmaxspeed
		move.w	#-$1000,obVelY(a0) ; set maximum speed on leaving water

.belowmaxspeed:
		move.w	#sfx_Splash,d0
		jmp	(PlaySound_Special).l	 ; play splash sound
; End of function Sonic_Water