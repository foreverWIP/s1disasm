        align 2
init_mega:
                movea.l #v_megaunpack_buf_internal,a0
                movea.l a0,a2
                move.w  #$FFFE,d0
                moveq   #$F,d3

MEGAUNPACK_loc_C5C8:
                move.w  d0,(a0)+
                rol.w   #1,d0
                dbf     d3,MEGAUNPACK_loc_C5C8
                moveq   #0,d2

MEGAUNPACK_loc_C5D2:
                move.b  d2,d0
                moveq   #0,d1

MEGAUNPACK_loc_C5D6:
                add.b   d0,d0
                bcc.s   MEGAUNPACK_loc_C5DC
                addq.b  #1,d1

MEGAUNPACK_loc_C5DC:
                bne.s   MEGAUNPACK_loc_C5D6
                move.b  d1,(a0)+
                addq.b  #1,d2
                bne.s   MEGAUNPACK_loc_C5D2
                moveq   #1,d2

MEGAUNPACK_loc_C5E6:
                move.b  d2,d0
                moveq   #7,d1

MEGAUNPACK_loc_C5EA:
                add.b   d0,d0
                dbcs    d1,MEGAUNPACK_loc_C5EA
                move.b  d1,(a0)+
                addq.b  #1,d2
                bne.s   MEGAUNPACK_loc_C5E6
                move.b  #8,(a0)+
                moveq   #2,d2

MEGAUNPACK_loc_C5FC:
                move.b  d2,d0

MEGAUNPACK_loc_C5FE:
                subq.b  #1,d0
                move.b  d0,(a0)+
                bne.s   MEGAUNPACK_loc_C5FE
                add.b   d2,d2
                bne.s   MEGAUNPACK_loc_C5FC
                move.b  #$FF,(a0)+
                movea.l a0,a1
                move.w  #$FF,d3

MEGAUNPACK_loc_C612:
                moveq   #8,d1
                sub.b   $20(a2,d3.w),d1
                adda.l  d1,a1
                moveq   #7,d1
                move.b  d3,d0

MEGAUNPACK_loc_C61E:
                add.b   d0,d0
                dbcc    d1,MEGAUNPACK_loc_C61E
                bcs.s   MEGAUNPACK_loc_C62C
                move.b  d1,-(a1)
                dbf     d1,MEGAUNPACK_loc_C61E

MEGAUNPACK_loc_C62C:
                addq.l  #8,a1
                dbf     d3,MEGAUNPACK_loc_C612
                rts
; End of function init_mega

        align  2
MEGAUNPACK_sub_C2B0:
                moveq   #0,d3
                bsr.w   MEGAUNPACK_sub_C0A8
                bcc.s   MEGAUNPACK_loc_C2C4
                moveq   #$F,d1
                move.b  d1,d3
                bsr.w   MEGAUNPACK_sub_C0FE
                eor.b   d7,d3
                asl.b   #3,d3

MEGAUNPACK_loc_C2C4:
                bsr.w   MEGAUNPACK_sub_C0A8
                bcc.s   MEGAUNPACK_loc_C2D4
                moveq   #7,d1
                or.b    d1,d3
                bsr.w   MEGAUNPACK_sub_C0FE
                eor.b   d7,d3

MEGAUNPACK_loc_C2D4:
                moveq   #8,d0
                and.b   d3,d0
                beq.s   MEGAUNPACK_loc_C2DE
                eori.b  #7,d3

MEGAUNPACK_loc_C2DE:
                ror.l   #8,d3
                bsr.w   MEGAUNPACK_sub_C0A8
                bcc.s   MEGAUNPACK_loc_C2F2
                moveq   #$F,d1
                move.b  d1,d3
                bsr.w   MEGAUNPACK_sub_C0FE
                eor.b   d7,d3
                asl.b   #3,d3

MEGAUNPACK_loc_C2F2:
                bsr.w   MEGAUNPACK_sub_C0A8
                bcc.s   MEGAUNPACK_loc_C302
                moveq   #7,d1
                or.b    d1,d3
                bsr.w   MEGAUNPACK_sub_C0FE
                eor.b   d7,d3

MEGAUNPACK_loc_C302:
                moveq   #8,d0
                and.b   d3,d0
                beq.s   MEGAUNPACK_loc_C30C
                eori.b  #7,d3

MEGAUNPACK_loc_C30C:
                ori.w   #$300,d3
                move.w  d3,-(sp)
                move.w  -6(a6),d5
                bsr.w   MEGAUNPACK_sub_C134

MEGAUNPACK_loc_C31A:
                move.w  d0,d2

MEGAUNPACK_loc_C31C:
                add.b   d3,d3
                bmi.s   MEGAUNPACK_loc_C330
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C32C
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C32C:
                add.l   d7,d7
                bcs.s   MEGAUNPACK_loc_C334

MEGAUNPACK_loc_C330:
                move.w  d2,d0
                bra.s   MEGAUNPACK_loc_C33C

MEGAUNPACK_loc_C334:
                move.w  d2,d1
                add.w   d1,d1
                bsr.w   MEGAUNPACK_sub_C12C

MEGAUNPACK_loc_C33C:
                asl.b   #4,d2
                or.b    d0,d2
                move.b  d2,(a4)+
                subi.w  #$100,d3
                bcs.s   MEGAUNPACK_loc_C36E
                add.b   d3,d3
                bmi.s   MEGAUNPACK_loc_C35C
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C358
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C358:
                add.l   d7,d7
                bcs.s   MEGAUNPACK_loc_C362

MEGAUNPACK_loc_C35C:
                andi.b  #$F,d2
                bra.s   MEGAUNPACK_loc_C31C

MEGAUNPACK_loc_C362:
                moveq   #$F,d1
                and.w   d2,d1
                add.w   d1,d1
                bsr.w   MEGAUNPACK_sub_C12C
                bra.s   MEGAUNPACK_loc_C31A

MEGAUNPACK_loc_C36E:
                move.w  #6,-(sp)

MEGAUNPACK_loc_C372:
                add.l   d3,d3
                bmi.w   MEGAUNPACK_loc_C4F0
                move.w  2(sp),d3
                clr.w   d7
                move.b  -4(a4),d2
                lsr.b   #4,d2
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C390
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C390:
                add.l   d7,d7
                bcc.s   MEGAUNPACK_loc_C39E
                move.w  d2,d1
                add.w   d1,d1
                bsr.w   MEGAUNPACK_sub_C12C

MEGAUNPACK_loc_C39C:
                move.w  d0,d2

MEGAUNPACK_loc_C39E:
                add.b   d3,d3
                bmi.s   MEGAUNPACK_loc_C3D2
                tst.b   (sp)
                bpl.s   MEGAUNPACK_loc_C3E6
                moveq   #$F,d0
                and.b   -4(a4),d0
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C3B8
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C3B8:
                add.l   d7,d7
                bcc.s   MEGAUNPACK_loc_C438
                cmp.b   d2,d0
                beq.s   MEGAUNPACK_loc_C3D6
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C3CC
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C3CC:
                add.l   d7,d7
                bcs.s   MEGAUNPACK_loc_C414
                clr.b   (sp)

MEGAUNPACK_loc_C3D2:
                move.w  d2,d0
                bra.s   MEGAUNPACK_loc_C438

MEGAUNPACK_loc_C3D6:
                add.b   d0,d0
                move.w  -6(a6),d5
                and.w   (a2,d0.w),d5
                bsr.w   MEGAUNPACK_sub_C134
                bra.s   MEGAUNPACK_loc_C438

MEGAUNPACK_loc_C3E6:
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C3F2
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C3F2:
                add.l   d7,d7
                bcs.s   MEGAUNPACK_loc_C3FA
                move.w  d2,d0
                bra.s   MEGAUNPACK_loc_C438

MEGAUNPACK_loc_C3FA:
                moveq   #$F,d0
                and.b   -4(a4),d0
                cmp.b   d0,d2
                beq.s   MEGAUNPACK_loc_C430
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C410
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C410:
                add.l   d7,d7
                bcc.s   MEGAUNPACK_loc_C42C

MEGAUNPACK_loc_C414:
                move.w  -6(a6),d5
                add.b   d0,d0
                move.w  d2,d1
                add.b   d1,d1
                and.w   (a2,d0.w),d5
                and.w   (a2,d1.w),d5
                bsr.w   MEGAUNPACK_sub_C134
                bra.s   MEGAUNPACK_loc_C438

MEGAUNPACK_loc_C42C:
                st      (sp)
                bra.s   MEGAUNPACK_loc_C438

MEGAUNPACK_loc_C430:
                move.w  d2,d1
                add.b   d1,d1
                bsr.w   MEGAUNPACK_sub_C12C

MEGAUNPACK_loc_C438:
                asl.b   #4,d2
                or.b    d0,d2
                move.b  d2,(a4)+
                subi.w  #$100,d3
                bcs.w   MEGAUNPACK_loc_C4F4
                andi.b  #$F,d2
                add.b   d3,d3
                bmi.w   MEGAUNPACK_loc_C39E
                tst.b   (sp)
                bpl.s   MEGAUNPACK_loc_C498
                move.b  -4(a4),d0
                lsr.b   #4,d0
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C466
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C466:
                add.l   d7,d7
                bcc.w   MEGAUNPACK_loc_C39C
                cmp.b   d2,d0
                beq.s   MEGAUNPACK_loc_C486
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C47C
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C47C:
                add.l   d7,d7
                bcs.s   MEGAUNPACK_loc_C4C4
                clr.b   (sp)
                bra.w   MEGAUNPACK_loc_C39E

MEGAUNPACK_loc_C486:
                add.b   d0,d0
                move.w  -6(a6),d5
                and.w   (a2,d0.w),d5
                bsr.w   MEGAUNPACK_sub_C134
                bra.w   MEGAUNPACK_loc_C39C

MEGAUNPACK_loc_C498:
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C4A4
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C4A4:
                add.l   d7,d7
                bcc.w   MEGAUNPACK_loc_C39E
                move.b  -4(a4),d0
                lsr.b   #4,d0
                cmp.b   d0,d2
                beq.s   MEGAUNPACK_loc_C4E4
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C4C0
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C4C0:
                add.l   d7,d7
                bcc.s   MEGAUNPACK_loc_C4DE

MEGAUNPACK_loc_C4C4:
                move.w  -6(a6),d5
                add.b   d0,d0
                move.w  d2,d1
                add.b   d1,d1
                and.w   (a2,d0.w),d5
                and.w   (a2,d1.w),d5
                bsr.w   MEGAUNPACK_sub_C134
                bra.w   MEGAUNPACK_loc_C39C

MEGAUNPACK_loc_C4DE:
                st      (sp)
                bra.w   MEGAUNPACK_loc_C39C

MEGAUNPACK_loc_C4E4:
                move.w  d2,d1
                add.b   d1,d1
                bsr.w   MEGAUNPACK_sub_C12C
                bra.w   MEGAUNPACK_loc_C39C

MEGAUNPACK_loc_C4F0:
                move.l  -4(a4),(a4)+

MEGAUNPACK_loc_C4F4:
                subq.b  #1,1(sp)
                bcc.w   MEGAUNPACK_loc_C372
                addq.l  #4,sp
                rts
; End of function MEGAUNPACK_sub_C2B0

        align  2
MEGAUNPACK_sub_C12C:
                move.w  -6(a6),d5
                and.w   (a2,d1.w),d5
; End of function MEGAUNPACK_sub_C12C


MEGAUNPACK_sub_C134:
                clr.w   d4
                move.b  d5,d4
                move.b  $20(a2,d4.w),d4
                move.w  d4,-(sp)
                move.w  d5,d0
                lsr.w   #8,d0
                add.b   $20(a2,d0.w),d4
                move.b  -$80(a3,d4.w),d0
                sub.b   d0,d6
                bcc.s   MEGAUNPACK_loc_C15E
                add.b   d0,d6
                move.w  (a5)+,d7
                swap    d7
                rol.w   d6,d7
                sub.b   d6,d0
                moveq   #$10,d6
                sub.b   d0,d6
                bra.s   MEGAUNPACK_loc_C160

MEGAUNPACK_loc_C15E:
                clr.w   d7

MEGAUNPACK_loc_C160:
                rol.l   d0,d7
                cmp.b   $7F(a3,d4.w),d7
                bls.s   MEGAUNPACK_loc_C17C
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C174
                swap    d7
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C174:
                rol.l   #1,d7
                sub.b   $7F(a3,d4.w),d7
                subq.w  #1,d7

MEGAUNPACK_loc_C17C:
                move.w  d7,d0
                sub.w   (sp)+,d0
                bcc.s   MEGAUNPACK_loc_C192
                andi.w  #$FF,d5
                asl.w   #3,d5
                add.w   d7,d5
                moveq   #0,d0
                move.b  (a0,d5.w),d0
                rts

MEGAUNPACK_loc_C192:
                clr.b   d5
                lsr.w   #5,d5
                add.w   d0,d5
                moveq   #8,d0
                add.b   (a0,d5.w),d0
                rts
; End of function MEGAUNPACK_sub_C134

        align  2
MEGAUNPACK_sub_C1A0:
                move.w  -4(a6),d1
                bsr.w   MEGAUNPACK_sub_C0F8
                not.w   d7
                asl.w   #5,d7
                lea     (a4,d7.w),a1
                clr.w   d3
                bsr.w   MEGAUNPACK_sub_C0A8
                bcc.s   MEGAUNPACK_loc_C1C4
                moveq   #$F,d1
                bsr.w   MEGAUNPACK_sub_C0FE
                not.b   d7
                asl.w   #4,d7
                move.b  d7,d3

MEGAUNPACK_loc_C1C4:
                bsr.w   MEGAUNPACK_sub_C0A8
                bcc.s   MEGAUNPACK_loc_C1D4
                moveq   #$F,d1
                or.b    d1,d3
                bsr.w   MEGAUNPACK_sub_C0FE
                eor.b   d7,d3

MEGAUNPACK_loc_C1D4:
                move.b  d3,-8(a6)
                clr.w   d4
                bsr.w   MEGAUNPACK_sub_C0A8
                bcc.s   MEGAUNPACK_loc_C1EC
                moveq   #$F,d1
                bsr.w   MEGAUNPACK_sub_C0FE
                not.b   d7
                asl.w   #4,d7
                move.b  d7,d4

MEGAUNPACK_loc_C1EC:
                bsr.w   MEGAUNPACK_sub_C0A8
                bcc.s   MEGAUNPACK_loc_C1FC
                moveq   #$F,d1
                or.b    d1,d4
                bsr.w   MEGAUNPACK_sub_C0FE
                eor.b   d7,d4

MEGAUNPACK_loc_C1FC:
                ori.w   #$700,d4

MEGAUNPACK_loc_C200:
                add.b   d4,d4
                bcs.s   MEGAUNPACK_loc_C26C
                clr.w   d7
                move.b  -8(a6),d2
                moveq   #$FFFFFFFE,d0
                cmp.b   d0,d4
                beq.s   MEGAUNPACK_loc_C230
                moveq   #7,d1

MEGAUNPACK_loc_C212:
                rol.b   #1,d2
                bcs.s   MEGAUNPACK_loc_C22C
                cmp.b   d0,d2
                beq.s   MEGAUNPACK_loc_C22C
                clr.w   d7
                subq.b  #1,d6
                bcc.s   MEGAUNPACK_loc_C226
                move.w  (a5)+,d7
                swap    d7
                moveq   #$F,d6

MEGAUNPACK_loc_C226:
                add.l   d7,d7
                bcc.s   MEGAUNPACK_loc_C22C
                addq.b  #1,d2

MEGAUNPACK_loc_C22C:
                dbf     d1,MEGAUNPACK_loc_C212

MEGAUNPACK_loc_C230:
                swap    d4
                moveq   #3,d3

MEGAUNPACK_loc_C234:
                add.b   d2,d2
                bcs.s   MEGAUNPACK_loc_C278
                move.w  #$F0,d1
                and.b   (a1),d1
                lsr.w   #3,d1
                bsr.w   MEGAUNPACK_sub_C12C
                asl.b   #4,d0
                moveq   #$F,d1
                and.b   (a1)+,d1
                add.b   d2,d2
                bcs.s   MEGAUNPACK_loc_C28A
                move.w  d0,d5
                swap    d5
                add.w   d1,d1
                bsr.w   MEGAUNPACK_sub_C12C
                swap    d5
                or.w    d0,d5
                move.b  d5,(a4)+
                dbf     d3,MEGAUNPACK_loc_C234
                swap    d4
                subi.w  #$100,d4
                bcc.s   MEGAUNPACK_loc_C200
                rts

MEGAUNPACK_loc_C26C:
                addq.b  #1,d4
                move.l  (a1)+,(a4)+
                subi.w  #$100,d4
                bcc.s   MEGAUNPACK_loc_C200
                rts

MEGAUNPACK_loc_C278:
                add.b   d2,d2
                bcs.s   MEGAUNPACK_loc_C29E
                moveq   #$F,d1
                and.b   (a1),d1
                add.w   d1,d1
                bsr.w   MEGAUNPACK_sub_C12C
                moveq   #$FFFFFFF0,d1
                and.b   (a1)+,d1

MEGAUNPACK_loc_C28A:
                or.b    d1,d0
                move.b  d0,(a4)+
                dbf     d3,MEGAUNPACK_loc_C234
                swap    d4
                subi.w  #$100,d4
                bcc.w   MEGAUNPACK_loc_C200
                rts

MEGAUNPACK_loc_C29E:
                move.b  (a1)+,(a4)+
                dbf     d3,MEGAUNPACK_loc_C234
                swap    d4
                subi.w  #$100,d4
                bcc.w   MEGAUNPACK_loc_C200
                rts
; End of function MEGAUNPACK_sub_C1A0

        align  2
MEGAUNPACK_sub_C0A8:
	subq.b  #1,d6
	bcs.s   MEGAUNPACK_loc_C0B2
	clr.w   d7
	add.l   d7,d7
	rts
MEGAUNPACK_loc_C0B2:
	move.w  (a5)+,d7
	swap    d7
	moveq   #$F,d6
	add.l   d7,d7
	rts

        align  2
MEGAUNPACK_sub_C0BC:
	sub.b   d0,d6
	bcs.s   MEGAUNPACK_loc_C0C6
	clr.w   d7
	rol.l   d0,d7
	rts

MEGAUNPACK_loc_C0C6:
	add.b   d0,d6
	move.w  (a5)+,d7
	swap    d7
	rol.w   d6,d7
	sub.b   d6,d0
	rol.l   d0,d7
	moveq   #$10,d6
	sub.b   d0,d6
	rts
; End of function MEGAUNPACK_sub_C0BC

; START OF FUNCTION CHUNK FOR MEGAUNPACK_sub_C0F8

MEGAUNPACK_loc_C0D8:
	subq.w  #1,d1
	moveq   #0,d2
	move.b  d1,d2
	addq.w  #1,d2
	lsr.w   #8,d1
	addq.w  #1,d1
	bsr.s   MEGAUNPACK_sub_C0FE
	move.w  d2,d1
	subq.w  #1,d7
	bcs.s   MEGAUNPACK_sub_C0FE
	asl.w   #8,d7
	add.w   d7,d2
	moveq   #8,d0
	bsr.s   MEGAUNPACK_sub_C0BC
	add.w   d2,d7
	rts
; END OF FUNCTION CHUNK FOR MEGAUNPACK_sub_C0F8


        align  2
MEGAUNPACK_sub_C0F8:

; FUNCTION CHUNK AT 0000C0D8 SIZE 00000020 BYTES

	cmp.w   #$100,d1
	bhi.s   MEGAUNPACK_loc_C0D8
; End of function MEGAUNPACK_sub_C0F8


        align  2
MEGAUNPACK_sub_C0FE:
	move.b  -$80(a3,d1.w),d0
	bsr.s   MEGAUNPACK_sub_C0BC
	cmp.b   $7F(a3,d1.w),d7
	bhi.s   MEGAUNPACK_loc_C10C
	rts

MEGAUNPACK_loc_C10C:
	subq.b  #1,d6
	bcs.s   MEGAUNPACK_loc_C11A
	rol.l   #1,d7
	sub.b   $7F(a3,d1.w),d7
	subq.w  #1,d7
	rts

MEGAUNPACK_loc_C11A:
	swap    d7
	move.w  (a5)+,d7
	add.l   d7,d7
	swap    d7
	moveq   #$F,d6
	sub.b   $7F(a3,d1.w),d7
	subq.w  #1,d7
	rts
; End of function MEGAUNPACK_sub_C0FE

MAX_SET_NUMS: equ $200

; a0 - src
; a1 - dst

        align  2
megaunp:
	movea.l a0,a5
	movea.l a1,a4
	movea.l #v_megaunpack_buf_internal,a2
	movea.l a2,a2
	lea     $19F(a2),a3
	lea     $31F(a2),a0
	link    a6,#-8
	moveq   #0,d6
	moveq   #0,d7
	moveq   #8,d0
	bsr.w   MEGAUNPACK_sub_C0BC
	move.w  d7,d1
	moveq   #2,d0
	bsr.w   MEGAUNPACK_sub_C0BC
	asl.w   #8,d7
	add.w   d7,d1
	move.w  d1,-2(a6)
	cmp.w   #MAX_SET_NUMS,d1
	bls.s   MEGAUNPACK_loc_C53A
	move.w  #MAX_SET_NUMS,d1

MEGAUNPACK_loc_C53A:
	bsr.w   MEGAUNPACK_sub_C0F8
	move.w  d7,d3
	move.w  d3,d4
	bra.s   MEGAUNPACK_loc_C568

MEGAUNPACK_loc_C544:
	bsr.w   MEGAUNPACK_sub_C0A8
	bcs.s   MEGAUNPACK_loc_C568
	move.w  d4,d1
	sub.w   d3,d1
	bsr.w   MEGAUNPACK_sub_C0F8
	add.w   d7,d7
	move.w  (sp,d7.w),d2
	moveq   #4,d0
	bsr.w   MEGAUNPACK_sub_C0BC
	moveq   #1,d1
	asl.w   d7,d1
	eor.w   d1,d2
	move.w  d2,-(sp)
	bra.s   MEGAUNPACK_loc_C570

MEGAUNPACK_loc_C568:
	moveq   #$10,d0
	bsr.w   MEGAUNPACK_sub_C0BC
	move.w  d7,-(sp)

MEGAUNPACK_loc_C570:
	dbf     d3,MEGAUNPACK_loc_C544
	move.w  #1,-(sp)
	clr.w   -4(a6)

MEGAUNPACK_loc_C57C:
	move.w  (sp),d1
	move.w  d1,d3
	bsr.w   MEGAUNPACK_sub_C0F8
	tst.w   d7
	bne.s   MEGAUNPACK_loc_C58A
	addq.w  #1,(sp)

MEGAUNPACK_loc_C58A:
	sub.w   d3,d7
	add.w   d7,d7
	move.w  -8(a6,d7.w),-6(a6)
	bsr.w   MEGAUNPACK_sub_C0A8
	bcs.s   MEGAUNPACK_loc_C5A0
	bsr.w   MEGAUNPACK_sub_C1A0
	bra.s   MEGAUNPACK_loc_C5A4

MEGAUNPACK_loc_C5A0:
	bsr.w   MEGAUNPACK_sub_C2B0

MEGAUNPACK_loc_C5A4:
	addq.w  #1,-4(a6)
	move.w  -4(a6),d0
	cmp.w   -2(a6),d0
	bne.s   MEGAUNPACK_loc_C57C
	moveq   #0,d1
	move.w  -2(a6),d1
	asl.l   #5,d1
	unlk    a6
	rts
; End of function megaunp

MegaDecToVRAM: macro source,destination
    lea         (source).l,a0
    move.w      destination,d0
    bsr.w       MegaDecTest
    endm

MegaDecTest:
        disable_ints
        movem.l	d0-a6,-(sp)
        ; locVRAM
        ; move.l #($40000000+(((loc)&$3FFF)<<16)+(((loc)&$C000)>>14)),(vdp_control_port).l
        lsl.l   #2,d0
        lsr.w   #2,d0
        ori.w   #$4000,d0
        swap    d0
        move.l  d0,(vdp_control_port).l
        ; compress
        move.l  a0,-(sp)
        bsr.w	init_mega
        move.l  (sp)+,a0
	lea     (v_megaunpack_buf).l,a1
	bsr.w	megaunp
        ; get size of uncompressed data
	move.l	a5,d1
        lea     (v_megaunpack_buf).l,a1
	sub.l	a1,d1
        ; send data
        lea     (vdp_data_port).l,a0
        lsr.w   #5,d1
        subq    #1,d1
        ; repeat for every tile
.loop:
        move.l  (a1)+,(a0)
        move.l  (a1)+,(a0)
        move.l  (a1)+,(a0)
        move.l  (a1)+,(a0)
        move.l  (a1)+,(a0)
        move.l  (a1)+,(a0)
        move.l  (a1)+,(a0)
        move.l  (a1)+,(a0)
        dbf     d1,.loop 
        movem.l	(sp)+,d0-a6
        enable_ints
        rts