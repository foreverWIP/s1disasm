; ---------------------------------------------------------------------------
; Subroutine to display Sonic and set music
; ---------------------------------------------------------------------------

Sonic_Display:
		move.w	flashtime(a0),d0
		beq.s	.display
		subq.w	#1,flashtime(a0)
		lsr.w	#3,d0
		bcc.s	.chkinvincible

.display:
		jsr	(DisplaySprite).l

.chkinvincible:
		tst.b	(v_invinc).l	; does Sonic have invincibility?
		beq.s	.chkshoes	; if not, branch
		tst.w	invtime(a0)	; check	time remaining for invinciblity
		beq.s	.chkshoes	; if no	time remains, branch
		subq.w	#1,invtime(a0)	; subtract 1 from time
		bne.s	.chkshoes
		tst.b	(f_lockscreen).l
		bne.s	.removeinvincible
		cmpi.w	#$C,(v_air).l
		blo.s	.removeinvincible
		moveq	#0,d0
		move.b	(v_zone).l,d0
		cmpi.w	#(id_LZ<<8)+3,(v_zone).l ; check if level is SBZ3
		bne.s	.music
		moveq	#5,d0		; play SBZ music

.music:
		lea	(MusicList2).l,a1
		move.b	(a1,d0.w),d0
		jsr	(PlaySound).l	; play normal music

.removeinvincible:
		move.b	#0,(v_invinc).l ; cancel invincibility

.chkshoes:
		tst.b	(v_shoes).l	; does Sonic have speed	shoes?
		beq.s	.exit		; if not, branch
		tst.w	shoetime(a0)	; check	time remaining
		beq.s	.exit
		subq.w	#1,shoetime(a0)	; subtract 1 from time
		bne.s	.exit
		move.w	#$600,(v_sonspeedmax).l ; restore Sonic's speed
		move.w	#$C,(v_sonspeedacc).l ; restore Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).l ; restore Sonic's deceleration
		move.b	#0,(v_shoes).l	; cancel speed shoes
		move.w	#bgm_Slowdown,d0
		jmp	(PlaySound).l	; run music at normal speed

.exit:
		rts	