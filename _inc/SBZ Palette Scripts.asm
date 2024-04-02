; ---------------------------------------------------------------------------
; Scrap Brain Zone palette cycling script
; ---------------------------------------------------------------------------

		if NeoGeo=0
mSBZp:	macro duration,colours,paladdress,ramaddress
	dc.b duration, colours
	dc.w paladdress, ramaddress
	endm
		else
mSBZp:	macro duration,colours,paladdress,ramaddress
	dc.b duration, colours
	dc.l paladdress, ramaddress
	endm
		endif

; duration in frames, number of colours, palette address, RAM address

Pal_SBZCycList1:
	if NeoGeo<>0
	dc.w ((end_SBZCycList1-Pal_SBZCycList1-2)/10)-1
	else
	dc.w ((end_SBZCycList1-Pal_SBZCycList1-2)/6)-1
	endif
	mSBZp	7,8,Pal_SBZCyc1,v_pal_dry+$50
	mSBZp	$D,8,Pal_SBZCyc2,v_pal_dry+$52
	mSBZp	$E,8,Pal_SBZCyc3,v_pal_dry+$6E
	mSBZp	$B,8,Pal_SBZCyc5,v_pal_dry+$70
	mSBZp	7,8,Pal_SBZCyc6,v_pal_dry+$72
	mSBZp	$1C,$10,Pal_SBZCyc7,v_pal_dry+$7E
	mSBZp	3,3,Pal_SBZCyc8,v_pal_dry+$78
	mSBZp	3,3,Pal_SBZCyc8+2,v_pal_dry+$7A
	mSBZp	3,3,Pal_SBZCyc8+4,v_pal_dry+$7C
end_SBZCycList1:
	even

Pal_SBZCycList2:
	if NeoGeo<>0
	dc.w ((end_SBZCycList2-Pal_SBZCycList2-2)/10)-1
	else
	dc.w ((end_SBZCycList2-Pal_SBZCycList2-2)/6)-1
	endif
	mSBZp	7,8,Pal_SBZCyc1,v_pal_dry+$50
	mSBZp	$D,8,Pal_SBZCyc2,v_pal_dry+$52
	mSBZp	9,8,Pal_SBZCyc9,v_pal_dry+$70
	mSBZp	7,8,Pal_SBZCyc6,v_pal_dry+$72
	mSBZp	3,3,Pal_SBZCyc8,v_pal_dry+$78
	mSBZp	3,3,Pal_SBZCyc8+2,v_pal_dry+$7A
	mSBZp	3,3,Pal_SBZCyc8+4,v_pal_dry+$7C
end_SBZCycList2:
	even
