mmdCounter := 0
mmdCheck macro name
MMD_name = mmdCounter
MMD_Is_name = (MMD_ID==mmdCounter)
mmdCounter := mmdCounter + 1
	endm

		mmdCheck Title
		mmdCheck GHZ
		mmdCheck MZ
		mmdCheck SYZ
		mmdCheck LZ
		mmdCheck SLZ
		mmdCheck SBZ
		mmdCheck FZ
MMD_Is_Level = MMD_Is_GHZ||MMD_Is_MZ||MMD_Is_SYZ||MMD_Is_LZ||MMD_Is_SLZ||MMD_Is_SBZ||MMD_Is_FZ
		mmdCheck SS
		mmdCheck Continue
		mmdCheck Ending
		mmdCheck Credits
MMD_Has_Sonic = (MMD_Is_Level||MMD_Is_SS||MMD_Is_Ending)