    lea     $10F300,sp              ; Init stack pointer
    kickWatchdog
    move.w  #$0000,REG_LSPCMODE     ; Make sur the pixel timer is disabled

    move.w  #7,REG_IRQACK           ; Clear all interrupts
    enable_ints
    
    move.l  #($F300/32)-1,d7        ; We'll clear $F300 bytes of user RAM by writing 8 longwords (32 bytes) at a time
    lea     RAMSTART,a0             ; Start at the beginning of user RAM
    moveq.l #0,d0                   ; Clear it with 0's
.clear_ram:
    move.l  d0,(a0)+                ; Write the 8 longwords, incrementing A0 each time
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    move.b  d0,REG_DIPSW
    dbra    d7,.clear_ram           ; Are we done ? No: jump back to .clear_ram
    
    move.w   #SCB3,REG_VRAMADDR     ; Height attributes are in VRAM at Sprite Control Bank 3
    clr.w    d0
    move.w   #1,REG_VRAMMOD         ; Set the VRAM address auto-increment value
    move.l   #512-1,d7              ; Clear all 512 sprites
    nop
.clearspr:
    move.w   d0,REG_VRAMRW          ; Write to VRAM
    nop                             ; Wait a bit...
    nop
    dbra     d7,.clearspr           ; Are we done ? No: jump back to .clearspr
    
    move.l   #(40*32)-1,d7          ; Clear the whole map
    move.w   #FIXMAP,REG_VRAMADDR
    move.w   #$0120,d0              ; Use tile $FF
.clearfix:
    move.w   d0,REG_VRAMRW          ; Write to VRAM
    nop                             ; Wait a bit...
    nop
    dbra     d7,.clearfix           ; Are we done ? No: jump back to .clearfix 