;
; Patch Offset Table
;

	dc.b	$2A,$00		; Offset to patch #0: 42
	dc.b	$51,$00		; Offset to patch #1: 81
	dc.b	$78,$00		; Offset to patch #2: 120
	dc.b	$9F,$00		; Offset to patch #3: 159
	dc.b	$C6,$00		; Offset to patch #4: 198
	dc.b	$ED,$00		; Offset to patch #5: 237
	dc.b	$14,$01		; Offset to patch #6: 276
	dc.b	$3B,$01		; Offset to patch #7: 315
	dc.b	$62,$01		; Offset to patch #8: 354
	dc.b	$89,$01		; Offset to patch #9: 393
	dc.b	$B0,$01		; Offset to patch #10: 432
	dc.b	$D7,$01		; Offset to patch #11: 471
	dc.b	$FE,$01		; Offset to patch #12: 510
	dc.b	$25,$02		; Offset to patch #13: 549
	dc.b	$4C,$02		; Offset to patch #14: 588
	dc.b	$73,$02		; Offset to patch #15: 627
	dc.b	$9A,$02		; Offset to patch #16: 666
	dc.b	$C1,$02		; Offset to patch #17: 705
	dc.b	$C8,$02		; Offset to patch #18: 712
	dc.b	$CA,$02		; Offset to patch #19: 714
	dc.b	$CB,$02		; Offset to patch #20: 715
;
; Patch Data
;

; Patch 0 "NEGFEEDB.FM": FM
	dc.b	0
	dc.b	$0C,$00,$06,$F4,$03,$00,$1F,$00
	dc.b	$00,$25,$03,$08,$1F,$1F,$0C,$18
	dc.b	$03,$11,$1F,$11,$10,$28,$01,$04
	dc.b	$1D,$10,$14,$1B,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 1 "NEGFEED1.FM": FM
	dc.b	0
	dc.b	$0A,$00,$0E,$F4,$02,$00,$1F,$00
	dc.b	$00,$05,$03,$10,$1F,$1F,$0C,$28
	dc.b	$00,$0C,$1F,$11,$10,$28,$04,$07
	dc.b	$1D,$10,$14,$2B,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 2 "WEIRD.FM": FM
	dc.b	0
	dc.b	$0B,$00,$3E,$D3,$79,$2C,$1E,$0B
	dc.b	$0F,$A4,$30,$0D,$1F,$06,$01,$45
	dc.b	$73,$10,$13,$0A,$0D,$76,$31,$11
	dc.b	$13,$0A,$11,$75,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 3 "BODYSOCW.FM": FM
	dc.b	0
	dc.b	$0B,$00,$2A,$C5,$73,$08,$9F,$19
	dc.b	$08,$CA,$00,$0D,$5E,$13,$05,$BB
	dc.b	$33,$05,$5F,$19,$06,$AB,$01,$08
	dc.b	$5F,$0F,$11,$6A,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 4 "INDUSTRY.FM": FM
	dc.b	0
	dc.b	$0A,$00,$0B,$F6,$00,$00,$1F,$00
	dc.b	$00,$25,$00,$08,$1F,$1F,$0C,$18
	dc.b	$05,$11,$1F,$11,$10,$28,$01,$04
	dc.b	$1D,$0F,$14,$1B,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 5 "FIREPAD1.FM": FM
	dc.b	0
	dc.b	$0A,$00,$2D,$F5,$36,$11,$53,$02
	dc.b	$00,$34,$32,$13,$52,$05,$00,$74
	dc.b	$70,$1B,$51,$1D,$00,$64,$71,$12
	dc.b	$52,$1D,$00,$55,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 6 "CLHAT1.FM": FM
	dc.b	0
	dc.b	$0C,$00,$28,$F5,$0F,$00,$1F,$00
	dc.b	$00,$25,$0F,$08,$1F,$1F,$0C,$18
	dc.b	$0F,$11,$1F,$11,$10,$28,$0E,$0D
	dc.b	$1D,$12,$14,$4A,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 7 "HACKSNR.FM": FM
	dc.b	0
	dc.b	$0B,$00,$20,$F5,$00,$09,$1F,$01
	dc.b	$00,$25,$00,$04,$1F,$1F,$0C,$08
	dc.b	$00,$11,$1F,$11,$10,$28,$02,$07
	dc.b	$1E,$10,$14,$1B,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 8 "REGBASS.FM": FM
	dc.b	0
	dc.b	$0B,$00,$29,$C0,$21,$11,$1F,$10
	dc.b	$07,$D8,$50,$27,$5F,$11,$00,$F8
	dc.b	$20,$1F,$5F,$09,$00,$F8,$01,$03
	dc.b	$5F,$0C,$00,$F8,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 9 "BODYSOCR.FM": FM
	dc.b	0
	dc.b	$0B,$00,$2A,$C5,$73,$08,$9F,$19
	dc.b	$08,$CA,$00,$0D,$5E,$13,$05,$BB
	dc.b	$33,$05,$5F,$19,$06,$AB,$01,$0B
	dc.b	$5F,$0F,$11,$6A,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 10 "K3IN4.FM": FM
	dc.b	0
	dc.b	$0B,$00,$27,$C0,$2A,$2B,$1F,$0A
	dc.b	$00,$BA,$54,$26,$57,$0A,$02,$79
	dc.b	$23,$26,$58,$09,$02,$AB,$52,$27
	dc.b	$58,$0B,$01,$9A,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 11 "B3B.FM": FM
	dc.b	0
	dc.b	$08,$00,$17,$E4,$33,$0C,$5F,$8B
	dc.b	$01,$8B,$33,$0F,$1D,$9D,$00,$3A
	dc.b	$71,$11,$1F,$1F,$00,$3A,$71,$0F
	dc.b	$5B,$9C,$00,$3A,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 12 "SOLIDBS.FM": FM
	dc.b	0
	dc.b	$0C,$00,$39,$C4,$01,$22,$1F,$10
	dc.b	$07,$D8,$51,$27,$5F,$11,$00,$F8
	dc.b	$00,$1F,$5F,$09,$00,$F8,$00,$03
	dc.b	$5F,$09,$00,$F8,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 13 "RIMD2.FM": FM
	dc.b	0
	dc.b	$0C,$00,$21,$F5,$02,$00,$1F,$00
	dc.b	$00,$25,$00,$08,$1F,$1F,$0C,$18
	dc.b	$00,$11,$1F,$11,$10,$28,$00,$04
	dc.b	$1D,$10,$14,$1B,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 14 "SOLOTPT1.FM": FM
	dc.b	0
	dc.b	$0B,$00,$35,$E3,$21,$0B,$94,$8C
	dc.b	$01,$4B,$21,$25,$92,$80,$02,$37
	dc.b	$31,$17,$9D,$05,$02,$46,$31,$11
	dc.b	$9A,$00,$02,$48,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 15 "FUNKSYN4.FM": FM
	dc.b	0
	dc.b	$0B,$00,$38,$E5,$70,$28,$1F,$0A
	dc.b	$00,$E8,$31,$1D,$1F,$09,$00,$E8
	dc.b	$70,$13,$5F,$0A,$00,$E8,$31,$11
	dc.b	$5F,$0A,$00,$EA,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 16 "Ship fire": FM
	dc.b	0
	dc.b	$08,$00,$15,$E4,$33,$0C,$5A,$8B
	dc.b	$01,$8B,$33,$0F,$1D,$9D,$00,$3A
	dc.b	$31,$11,$1F,$1F,$00,$3A,$31,$0F
	dc.b	$5B,$9C,$00,$3A,$1F,$FF,$1F,$FF
	dc.b	$1F,$FF,$1F,$FF,$0F,$00
; Patch 17 "Ship thrust": PSG Noise
	dc.b	3
	dc.b	$05,$FF,$00,$00,$FF,$FF
; Patch 18 "Ship Explosion": DIG
	dc.b	1
	dc.b	$04
; Patch 19 "<Unused #19>": Unknown Type!
	dc.b	99		; unknown/undefined patch type
; Patch 20 "Untitled PSG #20": PSG Tone
	dc.b	2
	dc.b	$00,$00,$00,$00,$00,$00
