.section .text

.global Loading_Sonic_Art
Loading_Sonic_Art: .incbin "loading/sonicart.bin"
.global Loading_Sonic_Art_end
Loading_Sonic_Art_end:
.global Loading_Sonic_Map
Loading_Sonic_Map: .incbin "loading/sonicmap.bin"
.global Loading_Sonic_Pal
Loading_Sonic_Pal: .incbin "loading/sonicpal.bin"
.global Loading_Sonic_Pal_end
Loading_Sonic_Pal_end:
.global Loading_Text
Loading_Text:	.incbin "../../../creditsfont.bin"
.global Loading_Text_end
Loading_Text_end: