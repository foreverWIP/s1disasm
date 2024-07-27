; ---------------------------------------------------------------------------
; Object pointers
; ---------------------------------------------------------------------------
objptr macro loc,cond
	ifb cond
	dc.l	loc
	else
	if cond
	dc.l	loc
	else
	dc.l	NullObject
	endif
	endif
	endm
ptr_SonicPlayer:	objptr SonicPlayer,(MMD_Has_Sonic&&(MMD_Is_SS==0))	; $01
ptr_Obj02:	objptr NullObject
ptr_Obj03:	objptr NullObject
ptr_Obj04:	objptr NullObject
ptr_Obj05:	objptr NullObject
ptr_Obj06:	objptr NullObject
ptr_Obj07:	objptr NullObject
ptr_Splash:	objptr Splash,MMD_Is_Level		; $08
ptr_SonicSpecial:	objptr SonicSpecial,MMD_Is_SS
ptr_DrownCount:	objptr DrownCount,MMD_Is_LZ
ptr_Pole:	objptr Pole,MMD_Is_LZ
ptr_FlapDoor:	objptr FlapDoor,MMD_Is_LZ
ptr_Signpost:	objptr Signpost,(MMD_Is_Level&&(MMD_Act_ID<>2))
ptr_TitleSonic:	objptr TitleSonic,MMD_Is_Title
ptr_PSBTM:	objptr PSBTM,MMD_Is_Title
ptr_Obj10:	objptr Obj10,MMD_Is_Level		; $10
ptr_Bridge:	objptr Bridge,MMD_Is_GHZ
ptr_SpinningLight:	objptr SpinningLight,MMD_Is_SYZ
ptr_LavaMaker:	objptr LavaMaker,MMD_Is_MZ
ptr_LavaBall:	objptr LavaBall,MMD_Is_MZ
ptr_SwingingPlatform:	objptr SwingingPlatform,MMD_Is_Level
ptr_Harpoon:	objptr Harpoon,MMD_Is_LZ
ptr_Helix:	objptr Helix,MMD_Is_GHZ
ptr_BasicPlatform:	objptr BasicPlatform,MMD_Is_Level	; $18
ptr_Obj19:	objptr Obj19,MMD_Is_GHZ
ptr_CollapseLedge:	objptr CollapseLedge,MMD_Is_Level
ptr_WaterSurface:	objptr WaterSurface,MMD_Is_LZ
ptr_Scenery:	objptr Scenery,MMD_Is_Level
ptr_MagicSwitch:	objptr NullObject
ptr_BallHog:	objptr BallHog,MMD_Is_SBZ
ptr_Crabmeat:	objptr Crabmeat,MMD_Is_Level
ptr_Cannonball:	objptr Cannonball,MMD_Is_SBZ		; $20
ptr_HUD:	objptr HUD,MMD_Is_Level
ptr_BuzzBomber:	objptr BuzzBomber,MMD_Is_Level
ptr_Missile:	objptr Missile,MMD_Is_Level
ptr_MissileDissolve:	objptr MissileDissolve,MMD_Is_Level
ptr_Rings:	objptr Rings,(MMD_Has_Sonic&&(MMD_Is_Ending==0))
ptr_Monitor:	objptr Monitor,MMD_Is_Level
ptr_ExplosionItem:	objptr ExplosionItem,MMD_Is_Level
ptr_Animals:	objptr Animals,MMD_Is_Level		; $28
ptr_Points:	objptr Points,(MMD_Is_Level||MMD_Is_Demo)&&(MMD_Is_SS==0)
ptr_AutoDoor:	objptr AutoDoor,MMD_Is_SBZ
ptr_Chopper:	objptr Chopper,MMD_Is_GHZ
ptr_Jaws:	objptr Jaws,MMD_Is_LZ
ptr_Burrobot:	objptr Burrobot,MMD_Is_LZ
ptr_PowerUp:	objptr PowerUp,(MMD_Is_Level||MMD_Is_Demo)&&(MMD_Is_SS==0)
ptr_LargeGrass:	objptr LargeGrass,MMD_Is_MZ
ptr_GlassBlock:	objptr GlassBlock,MMD_Is_MZ		; $30
ptr_ChainStomp:	objptr ChainStomp,MMD_Is_MZ
ptr_Button:	objptr Button,MMD_Is_Level
ptr_PushBlock:	objptr PushBlock,MMD_Is_Level
ptr_TitleCard:	objptr TitleCard,MMD_Is_Level
ptr_GrassFire:	objptr GrassFire,MMD_Is_MZ
ptr_Spikes:	objptr Spikes,MMD_Is_Level
ptr_RingLoss:	objptr RingLoss,MMD_Is_Level
ptr_ShieldItem:	objptr ShieldItem,MMD_Is_Level		; $38
ptr_GameOverCard:	objptr GameOverCard,MMD_Is_Level
ptr_GotThroughCard:	objptr GotThroughCard,MMD_Is_Level
ptr_PurpleRock:	objptr PurpleRock,MMD_Is_GHZ
ptr_SmashWall:	objptr SmashWall,MMD_Is_GHZ
ptr_BossGreenHill:	objptr BossGreenHill,MMD_Is_GHZ
ptr_Prison:	objptr Prison,((MMD_Act_ID==3)&&(MMD_Is_SBZ==0))
ptr_ExplosionBomb:	objptr ExplosionBomb,MMD_Is_Level
ptr_MotoBug:	objptr MotoBug,MMD_Is_GHZ		; $40
ptr_Springs:	objptr Springs,MMD_Is_Level
ptr_Newtron:	objptr Newtron,MMD_Is_GHZ
ptr_Roller:	objptr Roller,MMD_Is_SYZ
ptr_EdgeWalls:	objptr EdgeWalls,MMD_Is_GHZ
ptr_SideStomp:	objptr SideStomp,MMD_Is_MZ
ptr_MarbleBrick:	objptr MarbleBrick,MMD_Is_MZ
ptr_Bumper:	objptr Bumper,MMD_Is_SYZ
ptr_BossBall:	objptr BossBall,MMD_Is_GHZ		; $48
ptr_WaterSound:	objptr WaterSound,MMD_Is_GHZ
ptr_VanishSonic:	objptr NullObject
ptr_GiantRing:	objptr GiantRing,MMD_Is_Level
ptr_GeyserMaker:	objptr GeyserMaker,MMD_Is_MZ
ptr_LavaGeyser:	objptr LavaGeyser,MMD_Is_MZ
ptr_LavaWall:	objptr LavaWall,MMD_Is_MZ
ptr_Obj4F:	objptr Obj4F
ptr_Yadrin:	objptr Yadrin,MMD_Is_MZ||MMD_Is_SYZ		; $50
ptr_SmashBlock:	objptr SmashBlock,MMD_Is_MZ
ptr_MovingBlock:	objptr MovingBlock,MMD_Is_Level
ptr_CollapseFloor:	objptr CollapseFloor,MMD_Is_Level
ptr_LavaTag:	objptr LavaTag,MMD_Is_MZ
ptr_Basaran:	objptr Basaran,MMD_Is_Level
ptr_FloatingBlock:	objptr FloatingBlock,MMD_Is_Level
ptr_SpikeBall:	objptr SpikeBall,MMD_Is_Level
ptr_BigSpikeBall:	objptr BigSpikeBall,MMD_Is_Level	; $58
ptr_Elevator:	objptr Elevator,MMD_Is_SLZ
ptr_CirclingPlatform:	objptr CirclingPlatform,MMD_Is_SLZ
ptr_Staircase:	objptr Staircase,MMD_Is_SLZ
ptr_Pylon:	objptr Pylon,MMD_Is_SLZ
ptr_Fan:	objptr Fan,MMD_Is_SLZ
ptr_Seesaw:	objptr Seesaw,MMD_Is_SLZ
ptr_Bomb:	objptr Bomb,MMD_Is_SLZ
ptr_Orbinaut:	objptr Orbinaut,MMD_Is_Level		; $60
ptr_LabyrinthBlock:	objptr LabyrinthBlock,MMD_Is_LZ
ptr_Gargoyle:	objptr Gargoyle,MMD_Is_LZ
ptr_LabyrinthConvey:	objptr LabyrinthConvey,MMD_Is_LZ
ptr_Bubble:	objptr Bubble,MMD_Is_LZ
ptr_Waterfall:	objptr Waterfall,MMD_Is_LZ
ptr_Junction:	objptr Junction,MMD_Is_SBZ
ptr_RunningDisc:	objptr RunningDisc,MMD_Is_SBZ
ptr_Conveyor:	objptr Conveyor,MMD_Is_SBZ		; $68
ptr_SpinPlatform:	objptr SpinPlatform,MMD_Is_SBZ
ptr_Saws:	objptr Saws,MMD_Is_SBZ
ptr_ScrapStomp:	objptr ScrapStomp,MMD_Is_SBZ
ptr_VanishPlatform:	objptr VanishPlatform,MMD_Is_SBZ
ptr_Flamethrower:	objptr Flamethrower,MMD_Is_SBZ
ptr_Electro:	objptr Electro,MMD_Is_SBZ
ptr_SpinConvey:	objptr SpinConvey,MMD_Is_SBZ
ptr_Girder:	objptr Girder,MMD_Is_SBZ		; $70
ptr_Invisibarrier:	objptr Invisibarrier,MMD_Is_Level
ptr_Teleport:	objptr Teleport,MMD_Is_SBZ
ptr_BossMarble:	objptr BossMarble,MMD_Is_MZ
ptr_BossFire:	objptr BossFire,MMD_Is_MZ
ptr_BossSpringYard:	objptr BossSpringYard,MMD_Is_SYZ
ptr_BossBlock:	objptr BossBlock,MMD_Is_SYZ
ptr_BossLabyrinth:	objptr BossLabyrinth,MMD_Is_LZ
ptr_Caterkiller:	objptr Caterkiller,MMD_Is_Level	; $78
ptr_Lamppost:	objptr Lamppost,MMD_Is_Level
ptr_BossStarLight:	objptr BossStarLight,MMD_Is_SLZ
ptr_BossSpikeball:	objptr BossSpikeball,MMD_Is_SLZ
ptr_RingFlash:	objptr RingFlash,MMD_Is_Level
ptr_HiddenBonus:	objptr HiddenBonus,MMD_Is_Level
ptr_SSResult:	objptr SSResult,MMD_Is_SS
ptr_SSRChaos:	objptr SSRChaos,MMD_Is_SS
ptr_ContScrItem:	objptr ContScrItem,MMD_Is_Continue	; $80
ptr_ContSonic:	objptr ContSonic,MMD_Is_Continue
ptr_ScrapEggman:	objptr ScrapEggman,MMD_Is_SBZ
ptr_FalseFloor:	objptr FalseFloor,MMD_Is_SBZ
ptr_EggmanCylinder:	objptr EggmanCylinder,MMD_Is_FZ
ptr_BossFinal:	objptr BossFinal,MMD_Is_FZ
ptr_BossPlasma:	objptr BossPlasma,MMD_Is_FZ
ptr_EndSonic:	objptr EndSonic,MMD_Is_Ending
ptr_EndChaos:	objptr EndChaos,MMD_Is_Ending		; $88
ptr_EndSTH:	objptr EndSTH,MMD_Is_Ending
ptr_CreditsText:	objptr CreditsText,(MMD_Is_Title||MMD_Is_Credits)
ptr_EndEggman:	objptr EndEggman,MMD_Is_Credits
ptr_TryChaos:	objptr TryChaos,MMD_Is_Credits

NullObject:
		jmp	(DeleteObject).l	; It would be safer to have this instruction here, but instead it just falls through to ObjectFall

id_SonicPlayer:		equ ((ptr_SonicPlayer-Obj_Index)/4)+1		; $01
id_Obj02:		equ ((ptr_Obj02-Obj_Index)/4)+1
id_Obj03:		equ ((ptr_Obj03-Obj_Index)/4)+1
id_Obj04:		equ ((ptr_Obj04-Obj_Index)/4)+1
id_Obj05:		equ ((ptr_Obj05-Obj_Index)/4)+1
id_Obj06:		equ ((ptr_Obj06-Obj_Index)/4)+1
id_Obj07:		equ ((ptr_Obj07-Obj_Index)/4)+1
id_Splash:		equ ((ptr_Splash-Obj_Index)/4)+1		; $08
id_SonicSpecial:	equ ((ptr_SonicSpecial-Obj_Index)/4)+1
id_DrownCount:		equ ((ptr_DrownCount-Obj_Index)/4)+1
id_Pole:		equ ((ptr_Pole-Obj_Index)/4)+1
id_FlapDoor:		equ ((ptr_FlapDoor-Obj_Index)/4)+1
id_Signpost:		equ ((ptr_Signpost-Obj_Index)/4)+1
id_TitleSonic:		equ ((ptr_TitleSonic-Obj_Index)/4)+1
id_PSBTM:		equ ((ptr_PSBTM-Obj_Index)/4)+1
id_Obj10:		equ ((ptr_Obj10-Obj_Index)/4)+1			; $10
id_Bridge:		equ ((ptr_Bridge-Obj_Index)/4)+1
id_SpinningLight:	equ ((ptr_SpinningLight-Obj_Index)/4)+1
id_LavaMaker:		equ ((ptr_LavaMaker-Obj_Index)/4)+1
id_LavaBall:		equ ((ptr_LavaBall-Obj_Index)/4)+1
id_SwingingPlatform:	equ ((ptr_SwingingPlatform-Obj_Index)/4)+1
id_Harpoon:		equ ((ptr_Harpoon-Obj_Index)/4)+1
id_Helix:		equ ((ptr_Helix-Obj_Index)/4)+1
id_BasicPlatform:	equ ((ptr_BasicPlatform-Obj_Index)/4)+1		; $18
id_Obj19:		equ ((ptr_Obj19-Obj_Index)/4)+1
id_CollapseLedge:	equ ((ptr_CollapseLedge-Obj_Index)/4)+1
id_WaterSurface:	equ ((ptr_WaterSurface-Obj_Index)/4)+1
id_Scenery:		equ ((ptr_Scenery-Obj_Index)/4)+1
id_MagicSwitch:		equ ((ptr_MagicSwitch-Obj_Index)/4)+1
id_BallHog:		equ ((ptr_BallHog-Obj_Index)/4)+1
id_Crabmeat:		equ ((ptr_Crabmeat-Obj_Index)/4)+1
id_Cannonball:		equ ((ptr_Cannonball-Obj_Index)/4)+1		; $20
id_HUD:			equ ((ptr_HUD-Obj_Index)/4)+1
id_BuzzBomber:		equ ((ptr_BuzzBomber-Obj_Index)/4)+1
id_Missile:		equ ((ptr_Missile-Obj_Index)/4)+1
id_MissileDissolve:	equ ((ptr_MissileDissolve-Obj_Index)/4)+1
id_Rings:		equ ((ptr_Rings-Obj_Index)/4)+1
id_Monitor:		equ ((ptr_Monitor-Obj_Index)/4)+1
id_ExplosionItem:	equ ((ptr_ExplosionItem-Obj_Index)/4)+1
id_Animals:		equ ((ptr_Animals-Obj_Index)/4)+1		; $28
id_Points:		equ ((ptr_Points-Obj_Index)/4)+1
id_AutoDoor:		equ ((ptr_AutoDoor-Obj_Index)/4)+1
id_Chopper:		equ ((ptr_Chopper-Obj_Index)/4)+1
id_Jaws:		equ ((ptr_Jaws-Obj_Index)/4)+1
id_Burrobot:		equ ((ptr_Burrobot-Obj_Index)/4)+1
id_PowerUp:		equ ((ptr_PowerUp-Obj_Index)/4)+1
id_LargeGrass:		equ ((ptr_LargeGrass-Obj_Index)/4)+1
id_GlassBlock:		equ ((ptr_GlassBlock-Obj_Index)/4)+1		; $30
id_ChainStomp:		equ ((ptr_ChainStomp-Obj_Index)/4)+1
id_Button:		equ ((ptr_Button-Obj_Index)/4)+1
id_PushBlock:		equ ((ptr_PushBlock-Obj_Index)/4)+1
id_TitleCard:		equ ((ptr_TitleCard-Obj_Index)/4)+1
id_GrassFire:		equ ((ptr_GrassFire-Obj_Index)/4)+1
id_Spikes:		equ ((ptr_Spikes-Obj_Index)/4)+1
id_RingLoss:		equ ((ptr_RingLoss-Obj_Index)/4)+1
id_ShieldItem:		equ ((ptr_ShieldItem-Obj_Index)/4)+1		; $38
id_GameOverCard:	equ ((ptr_GameOverCard-Obj_Index)/4)+1
id_GotThroughCard:	equ ((ptr_GotThroughCard-Obj_Index)/4)+1
id_PurpleRock:		equ ((ptr_PurpleRock-Obj_Index)/4)+1
id_SmashWall:		equ ((ptr_SmashWall-Obj_Index)/4)+1
id_BossGreenHill:	equ ((ptr_BossGreenHill-Obj_Index)/4)+1
id_Prison:		equ ((ptr_Prison-Obj_Index)/4)+1
id_ExplosionBomb:	equ ((ptr_ExplosionBomb-Obj_Index)/4)+1
id_MotoBug:		equ ((ptr_MotoBug-Obj_Index)/4)+1		; $40
id_Springs:		equ ((ptr_Springs-Obj_Index)/4)+1
id_Newtron:		equ ((ptr_Newtron-Obj_Index)/4)+1
id_Roller:		equ ((ptr_Roller-Obj_Index)/4)+1
id_EdgeWalls:		equ ((ptr_EdgeWalls-Obj_Index)/4)+1
id_SideStomp:		equ ((ptr_SideStomp-Obj_Index)/4)+1
id_MarbleBrick:		equ ((ptr_MarbleBrick-Obj_Index)/4)+1
id_Bumper:		equ ((ptr_Bumper-Obj_Index)/4)+1
id_BossBall:		equ ((ptr_BossBall-Obj_Index)/4)+1		; $48
id_WaterSound:		equ ((ptr_WaterSound-Obj_Index)/4)+1
id_VanishSonic:		equ ((ptr_VanishSonic-Obj_Index)/4)+1
id_GiantRing:		equ ((ptr_GiantRing-Obj_Index)/4)+1
id_GeyserMaker:		equ ((ptr_GeyserMaker-Obj_Index)/4)+1
id_LavaGeyser:		equ ((ptr_LavaGeyser-Obj_Index)/4)+1
id_LavaWall:		equ ((ptr_LavaWall-Obj_Index)/4)+1
id_Obj4F:		equ ((ptr_Obj4F-Obj_Index)/4)+1
id_Yadrin:		equ ((ptr_Yadrin-Obj_Index)/4)+1		; $50
id_SmashBlock:		equ ((ptr_SmashBlock-Obj_Index)/4)+1
id_MovingBlock:		equ ((ptr_MovingBlock-Obj_Index)/4)+1
id_CollapseFloor:	equ ((ptr_CollapseFloor-Obj_Index)/4)+1
id_LavaTag:		equ ((ptr_LavaTag-Obj_Index)/4)+1
id_Basaran:		equ ((ptr_Basaran-Obj_Index)/4)+1
id_FloatingBlock:	equ ((ptr_FloatingBlock-Obj_Index)/4)+1
id_SpikeBall:		equ ((ptr_SpikeBall-Obj_Index)/4)+1
id_BigSpikeBall:	equ ((ptr_BigSpikeBall-Obj_Index)/4)+1		; $58
id_Elevator:		equ ((ptr_Elevator-Obj_Index)/4)+1
id_CirclingPlatform:	equ ((ptr_CirclingPlatform-Obj_Index)/4)+1
id_Staircase:		equ ((ptr_Staircase-Obj_Index)/4)+1
id_Pylon:		equ ((ptr_Pylon-Obj_Index)/4)+1
id_Fan:			equ ((ptr_Fan-Obj_Index)/4)+1
id_Seesaw:		equ ((ptr_Seesaw-Obj_Index)/4)+1
id_Bomb:		equ ((ptr_Bomb-Obj_Index)/4)+1
id_Orbinaut:		equ ((ptr_Orbinaut-Obj_Index)/4)+1		; $60
id_LabyrinthBlock:	equ ((ptr_LabyrinthBlock-Obj_Index)/4)+1
id_Gargoyle:		equ ((ptr_Gargoyle-Obj_Index)/4)+1
id_LabyrinthConvey:	equ ((ptr_LabyrinthConvey-Obj_Index)/4)+1
id_Bubble:		equ ((ptr_Bubble-Obj_Index)/4)+1
id_Waterfall:		equ ((ptr_Waterfall-Obj_Index)/4)+1
id_Junction:		equ ((ptr_Junction-Obj_Index)/4)+1
id_RunningDisc:		equ ((ptr_RunningDisc-Obj_Index)/4)+1
id_Conveyor:		equ ((ptr_Conveyor-Obj_Index)/4)+1		; $68
id_SpinPlatform:	equ ((ptr_SpinPlatform-Obj_Index)/4)+1
id_Saws:		equ ((ptr_Saws-Obj_Index)/4)+1
id_ScrapStomp:		equ ((ptr_ScrapStomp-Obj_Index)/4)+1
id_VanishPlatform:	equ ((ptr_VanishPlatform-Obj_Index)/4)+1
id_Flamethrower:	equ ((ptr_Flamethrower-Obj_Index)/4)+1
id_Electro:		equ ((ptr_Electro-Obj_Index)/4)+1
id_SpinConvey:		equ ((ptr_SpinConvey-Obj_Index)/4)+1
id_Girder:		equ ((ptr_Girder-Obj_Index)/4)+1		; $70
id_Invisibarrier:	equ ((ptr_Invisibarrier-Obj_Index)/4)+1
id_Teleport:		equ ((ptr_Teleport-Obj_Index)/4)+1
id_BossMarble:		equ ((ptr_BossMarble-Obj_Index)/4)+1
id_BossFire:		equ ((ptr_BossFire-Obj_Index)/4)+1
id_BossSpringYard:	equ ((ptr_BossSpringYard-Obj_Index)/4)+1
id_BossBlock:		equ ((ptr_BossBlock-Obj_Index)/4)+1
id_BossLabyrinth:	equ ((ptr_BossLabyrinth-Obj_Index)/4)+1
id_Caterkiller:		equ ((ptr_Caterkiller-Obj_Index)/4)+1		; $78
id_Lamppost:		equ ((ptr_Lamppost-Obj_Index)/4)+1
id_BossStarLight:	equ ((ptr_BossStarLight-Obj_Index)/4)+1
id_BossSpikeball:	equ ((ptr_BossSpikeball-Obj_Index)/4)+1
id_RingFlash:		equ ((ptr_RingFlash-Obj_Index)/4)+1
id_HiddenBonus:		equ ((ptr_HiddenBonus-Obj_Index)/4)+1
id_SSResult:		equ ((ptr_SSResult-Obj_Index)/4)+1
id_SSRChaos:		equ ((ptr_SSRChaos-Obj_Index)/4)+1
id_ContScrItem:		equ ((ptr_ContScrItem-Obj_Index)/4)+1		; $80
id_ContSonic:		equ ((ptr_ContSonic-Obj_Index)/4)+1
id_ScrapEggman:		equ ((ptr_ScrapEggman-Obj_Index)/4)+1
id_FalseFloor:		equ ((ptr_FalseFloor-Obj_Index)/4)+1
id_EggmanCylinder:	equ ((ptr_EggmanCylinder-Obj_Index)/4)+1
id_BossFinal:		equ ((ptr_BossFinal-Obj_Index)/4)+1
id_BossPlasma:		equ ((ptr_BossPlasma-Obj_Index)/4)+1
id_EndSonic:		equ ((ptr_EndSonic-Obj_Index)/4)+1
id_EndChaos:		equ ((ptr_EndChaos-Obj_Index)/4)+1		; $88
id_EndSTH:		equ ((ptr_EndSTH-Obj_Index)/4)+1
id_CreditsText:		equ ((ptr_CreditsText-Obj_Index)/4)+1
id_EndEggman:		equ ((ptr_EndEggman-Obj_Index)/4)+1
id_TryChaos:		equ ((ptr_TryChaos-Obj_Index)/4)+1