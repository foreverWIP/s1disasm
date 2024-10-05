.section .text

#include "main/gatearray.macro.s"
#include "wait_for_subcpu.s"

Haven:
		move.w	d1,(_GA_COMCMD1).l
		move.w	d0,(_GA_COMCMD0).l
		GRANT_2M
		WAIT_2M
		WAIT_FOR_SUBCPU
	rts
