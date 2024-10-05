.section .text

#include "main/gatearray.def.h"

.macro WAIT_FOR_SUBCPU
1:
	move.w	_GA_COMSTAT0,d0			/* Has the Sub CPU received the command? */
	beq.s	1b			/* If not, wait */
	cmp.w	_GA_COMSTAT0,d0
	bne.s	1b			/* If not, wait */

	move.w	#0,_GA_COMCMD0			/* Mark as ready to send commands again */

2:
	move.w	_GA_COMSTAT0,d0			/* Is the Sub CPU done processing the command? */
	bne.s	2b			/* If not, wait */
	move.w	_GA_COMSTAT0,d0
	bne.s	2b			/* If not, wait */
	.endm