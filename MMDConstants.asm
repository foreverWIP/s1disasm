mmdCounter := 0
mmdCheck macro name
MMD_name = mmdCounter
MMD_Is_name = (MMD==mmdCounter)
mmdCounter := mmdCounter + 1
	endm

mmdZoneCheck macro name
MMD_Is_name = (MMD_Is_name_1||MMD_Is_name_2||MMD_Is_name_3)
	endm

		mmdCheck Title
		mmdCheck GHZ_1
		mmdCheck GHZ_2
		mmdCheck GHZ_3
		mmdZoneCheck GHZ
		mmdCheck MZ_1
		mmdCheck MZ_2
		mmdCheck MZ_3
		mmdZoneCheck MZ
		mmdCheck SYZ_1
		mmdCheck SYZ_2
		mmdCheck SYZ_3
		mmdZoneCheck SYZ
		mmdCheck LZ_1
		mmdCheck LZ_2
		mmdCheck LZ_3
		mmdZoneCheck LZ
		mmdCheck SLZ_1
		mmdCheck SLZ_2
		mmdCheck SLZ_3
		mmdZoneCheck SLZ
		mmdCheck SBZ_1
		mmdCheck SBZ_2
		mmdCheck SBZ_3
		mmdZoneCheck SBZ
		mmdCheck FZ
MMD_Is_Level = (MMD_Is_GHZ||MMD_Is_MZ||MMD_Is_SYZ||MMD_Is_LZ||MMD_Is_SLZ||MMD_Is_SBZ||MMD_Is_FZ)
		mmdCheck GHZ_1Demo
		mmdCheck MZ_1Demo
		mmdCheck SYZ_1Demo
		mmdCheck SS_1Demo
MMD_Is_Demo = (MMD_Is_GHZ_1Demo||MMD_Is_MZ_1Demo||MMD_Is_SYZ_1Demo||MMD_Is_SS_1Demo)
		mmdCheck SS_1
		mmdCheck SS_2
		mmdCheck SS_3
		mmdCheck SS_4
		mmdCheck SS_5
		mmdCheck SS_6
MMD_Is_SS = (MMD_Is_SS_1||MMD_Is_SS_2||MMD_Is_SS_3||MMD_Is_SS_4||MMD_Is_SS_5||MMD_Is_SS_6)
		mmdCheck Continue
		mmdCheck Ending
		mmdCheck Credits
MMD_Has_Sonic = (MMD_Is_Level||MMD_Is_Demo||MMD_Is_SS||MMD_Is_Ending)

		if MMD_Is_Level
MMD_Seq_ID = MMD - MMD_GHZ_1
MMD_Act_ID = (MMD_Seq_ID#3)
		else
		if MMD_Is_SS
MMD_Seq_ID = MMD - MMD_SS_1
MMD_Act_ID = 0
		else
MMD_Seq_ID = 0
MMD_Act_ID = 0
		endif
		endif