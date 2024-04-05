    dc.l $0010F300            ; Initial SP
    dc.l $00C00402            ; Initial PC
    dc.l $00C00408            ; Bus error
    dc.l $00C0040E            ; Address error
    dc.l $00C0040E            ; Illegal Instruction
    dc.l $0000034C            ; Divide by 0
    dc.l $0000034E            ; CHK Instruction
    dc.l $0000034E            ; TRAPV Instruction
    dc.l $00C0041A            ; Privilege Violation
    dc.l $00C00420            ; Trace
    dc.l $0000034E,$0000034E  ; Emu
    dc.l $00C00426,$00C00426,$00C00426  ; Reserved
    dc.l $00C0042C            ; Uninit. Int. Vector.
    dc.l $00C00426,$00C00426,$00C00426,$00C00426  ; Reserved
    dc.l $00C00426,$00C00426,$00C00426,$00C00426  ; Reserved
    dc.l $00C00432            ; Spurious Interrupt
    dc.l NG_VBL               ; Level 1
    dc.l HBlank               ; Level 2
    dc.l $00C00426            ; Level 3
    dc.l $00C00426,$00C00426,$00C00426,$00C00426  ; Level 4~7
    dc.l $0000056E,$0000056E,$0000056E,$0000056E  ; Traps...
    dc.l $0000056E,$0000056E,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
    dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF

    dc.b "NEO-GEO",$00
    dc.w $0047	; NGH

	org $0114
	dc.w $0100	;logo flag, don't show it just go straight to the entry point

    org $0122
	jmp USER	;entry

	org $0182
	dc.l NGSecurityCode	;code pointer
NGSecurityCode:
	dc.l $76004A6D,$0A146600,$003C206D,$0A043E2D
	dc.l $0A0813C0,$00300001,$32100C01,$00FF671A
	dc.l $30280002,$B02D0ACE,$66103028,$0004B02D
	dc.l $0ACF6606,$B22D0AD0,$67085088,$51CFFFD4
	dc.l $36074E75,$206D0A04,$3E2D0A08,$3210E049
	dc.l $0C0100FF,$671A3010,$B02D0ACE,$66123028
	dc.l $0002E048,$B02D0ACF,$6606B22D,$0AD06708
	dc.l $588851CF,$FFD83607
	dc.w $4e75

    ORG $300
NG_VBL:                             ; Label defined in header.asm
    btst    #7,BIOS_SYSTEM_MODE     ; Check if the system ROM wants to take care of the interrupt
    bne     .getvbl                 ; No: jump to .getvbl
    jmp     SYS_INT1                ; Yes: jump to system ROM
.getvbl:
    move.w  #4,REG_IRQACK           ; Acknowledge v-blank interrupt
    move.b  d0,REG_DIPSW            ; Kick watchdog
    jsr     (VBlank).l
    rte                             ; Return from interrupt

JT_USER:
    dc.l    StartupInit             ; Jump table for the different things the system ROM can ask for
    dc.l    EyeCatcher
    dc.l    EntryPoint
    dc.l    Title

USER:
    move.b  d0,REG_DIPSW            ; Kick watchdog
    clr.l   d0                      ; Clear register D0
    move.b  BIOS_USER_REQUEST,d0    ; Put BIOS_USER_REQUEST (byte) in D0
    lsl.b   #2,d0                   ; D0 <<= 2
    lea     JT_USER,a0              ; Put the address of JT_USER in A0
    movea.l (a0,d0),a0              ; Read from jump table
    jsr     (a0)                    ; Jump to label
    jmp     SYS_RETURN              ; Tell the system ROM that we're done

StartupInit:
EyeCatcher:
Title:
    rts