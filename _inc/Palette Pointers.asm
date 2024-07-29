; ---------------------------------------------------------------------------
; Palette pointers
; ---------------------------------------------------------------------------

palp:	macro desinationPaletteLine,sourceAddress,cond
	ifb cond
	dc.l sourceAddress
	dc.w v_palette+desinationPaletteLine*$10*2,(sourceAddress_end-sourceAddress)/4-1
	else
	if cond
	dc.l sourceAddress
	dc.w v_palette+desinationPaletteLine*$10*2,(sourceAddress_end-sourceAddress)/4-1
	else
	dc.l 0
	dc.w 0,0
	endif
	endif
	endm

PalPointers:

; palette address, RAM address, colours

ptr_Pal_Title:		palp	0,Pal_Title,MMD_Is_Title		; 1 - title screen
ptr_Pal_LevelSel:	palp	0,Pal_LevelSel		; 2 - level select
ptr_Pal_Sonic:		palp	0,Pal_Sonic,MMD_Has_Sonic		; 3 - Sonic
Pal_Levels:
ptr_Pal_GHZ:		palp	1,Pal_GHZ,MMD_Is_GHZ		; 4 - GHZ
ptr_Pal_LZ:		palp	1,Pal_LZ,MMD_Is_LZ		; 5 - LZ
ptr_Pal_MZ:		palp	1,Pal_MZ,MMD_Is_MZ		; 6 - MZ
ptr_Pal_SLZ:		palp	1,Pal_SLZ,MMD_Is_SLZ		; 7 - SLZ
ptr_Pal_SYZ:		palp	1,Pal_SYZ,MMD_Is_SYZ		; 8 - SYZ
ptr_Pal_SBZ1:		palp	1,Pal_SBZ1,MMD_Is_SBZ_1		; 9 - SBZ1
			zonewarning Pal_Levels,8
ptr_Pal_Special:	palp	0,Pal_Special,MMD_Is_SS		; $A (10) - special stage
ptr_Pal_LZWater:	palp	0,Pal_LZWater,MMD_Is_LZ		; $B (11) - LZ underwater
ptr_Pal_SBZ3:		palp	1,Pal_SBZ3,MMD_Is_SBZ_3		; $C (12) - SBZ3
ptr_Pal_SBZ3Water:	palp	0,Pal_SBZ3Water,MMD_Is_SBZ_3		; $D (13) - SBZ3 underwater
ptr_Pal_SBZ2:		palp	1,Pal_SBZ2,MMD_Is_SBZ_2		; $E (14) - SBZ2
ptr_Pal_LZSonWater:	palp	0,Pal_LZSonWater,MMD_Is_LZ	; $F (15) - LZ Sonic underwater
ptr_Pal_SBZ3SonWat:	palp	0,Pal_SBZ3SonWat,MMD_Is_SBZ_3	; $10 (16) - SBZ3 Sonic underwater
ptr_Pal_SSResult:	palp	0,Pal_SSResult,MMD_Is_SS		; $11 (17) - special stage results
ptr_Pal_Continue:	palp	0,Pal_Continue,MMD_Is_Continue		; $12 (18) - special stage results continue
ptr_Pal_Ending:		palp	0,Pal_Ending,MMD_Is_Ending		; $13 (19) - ending sequence
			even


palid_Title:		equ (ptr_Pal_Title-PalPointers)/8
palid_LevelSel:		equ (ptr_Pal_LevelSel-PalPointers)/8
palid_Sonic:		equ (ptr_Pal_Sonic-PalPointers)/8
palid_GHZ:		equ (ptr_Pal_GHZ-PalPointers)/8
palid_LZ:		equ (ptr_Pal_LZ-PalPointers)/8
palid_MZ:		equ (ptr_Pal_MZ-PalPointers)/8
palid_SLZ:		equ (ptr_Pal_SLZ-PalPointers)/8
palid_SYZ:		equ (ptr_Pal_SYZ-PalPointers)/8
palid_SBZ1:		equ (ptr_Pal_SBZ1-PalPointers)/8
palid_Special:		equ (ptr_Pal_Special-PalPointers)/8
palid_LZWater:		equ (ptr_Pal_LZWater-PalPointers)/8
palid_SBZ3:		equ (ptr_Pal_SBZ3-PalPointers)/8
palid_SBZ3Water:	equ (ptr_Pal_SBZ3Water-PalPointers)/8
palid_SBZ2:		equ (ptr_Pal_SBZ2-PalPointers)/8
palid_LZSonWater:	equ (ptr_Pal_LZSonWater-PalPointers)/8
palid_SBZ3SonWat:	equ (ptr_Pal_SBZ3SonWat-PalPointers)/8
palid_SSResult:		equ (ptr_Pal_SSResult-PalPointers)/8
palid_Continue:		equ (ptr_Pal_Continue-PalPointers)/8
palid_Ending:		equ (ptr_Pal_Ending-PalPointers)/8
