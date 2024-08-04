includealigned: macro file
name:
	binclude file
	if ((*)&$1FFFF)<(name&$1FFFF)
name_length: equ *-name
	rorg -name_length
	align $20000
	binclude file
	endif
	even
	endm

Art_Text:	includealigned	"artunc/menutext.bin" ; text used in level select and debug mode
Art_Text_End:	even
Art_Hud:	includealigned	"artunc/HUD Numbers.bin" ; 8x16 pixel numbers on HUD
Art_LivesNums:	includealigned	"artunc/Lives Counter Numbers.bin" ; 8x8 pixel numbers on lives counter

; ---------------------------------------------------------------------------
; Compressed graphics - primary patterns and block mappings
; ---------------------------------------------------------------------------
Blk16_GHZ:
		if MMD_Is_GHZ||MMD_Is_Title
		includealigned	"map16/GHZ.eni"
		endif
Blk16_LZ:
		if MMD_Is_LZ
		includealigned	"map16/LZ.eni"
		endif
Blk16_MZ:
		if MMD_Is_MZ
		includealigned	"map16/MZ.eni"
		endif
Blk16_SLZ:
		if MMD_Is_SLZ
		includealigned	"map16/SLZ.eni"
		endif
Blk16_SYZ:
		if MMD_Is_SYZ
		includealigned	"map16/SYZ.eni"
		endif
Blk16_SBZ:
		if MMD_Is_SBZ
		includealigned	"map16/SBZ.eni"
		endif
Blk256_GHZ:
		if MMD_Is_GHZ||MMD_Is_Title
		includealigned	"map256/GHZ.kos"
		endif
Blk256_LZ:
		if MMD_Is_LZ
		includealigned	"map256/LZ.kos"
		endif
Blk256_MZ:
		if MMD_Is_MZ
		if Revision=0
		includealigned	"map256/MZ.kos"
		else
		includealigned	"map256/MZ (JP1).kos"
		endif
		endif
Blk256_SLZ:
		if MMD_Is_SLZ
		includealigned	"map256/SLZ.kos"
		endif
Blk256_SYZ:
		if MMD_Is_SYZ
		includealigned	"map256/SYZ.kos"
		endif
Blk256_SBZ:
		if MMD_Is_SBZ
		if Revision=0
		includealigned	"map256/SBZ.kos"
		else
		includealigned	"map256/SBZ (JP1).kos"
		endif
		endif

; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_Shield:	includealigned	"artnem/Shield.nem"
Nem_Stars:	includealigned	"artnem/Invincibility Stars.nem"
		if Revision=0
Nem_LzSonic:	includealigned	"artnem/Unused - LZ Sonic.nem" ; Sonic holding his breath
Nem_Warp:	includealigned	"artnem/Unused - SStage Flash.nem" ; entry to special stage flash
Nem_Goggle:	includealigned	"artnem/Unused - Goggles.nem" ; unused goggles
		endif

; ---------------------------------------------------------------------------
; Compressed graphics - GHZ stuff
; ---------------------------------------------------------------------------
Nem_Stalk:
		if MMD_Is_GHZ
		includealigned	"artnem/GHZ Flower Stalk.nem"
		endif
Nem_Swing:
		if MMD_Is_GHZ
		includealigned	"artnem/GHZ Swinging Platform.nem"
		endif
Nem_Bridge:
		if MMD_Is_GHZ
		includealigned	"artnem/GHZ Bridge.nem"
		endif
Nem_GhzUnkBlock:
		if MMD_Is_GHZ
		includealigned	"artnem/Unused - GHZ Block.nem"
		endif
Nem_Ball:
		if MMD_Is_GHZ
		includealigned	"artnem/GHZ Giant Ball.nem"
		endif
Nem_Spikes:
		includealigned	"artnem/Spikes.nem"
Nem_GhzLog:
		if MMD_Is_GHZ
		includealigned	"artnem/Unused - GHZ Log.nem"
		endif
Nem_SpikePole:
		if MMD_Is_GHZ
		includealigned	"artnem/GHZ Spiked Log.nem"
		endif
Nem_PplRock:
		if MMD_Is_GHZ
		includealigned	"artnem/GHZ Purple Rock.nem"
		endif
Nem_GhzWall1:
		if MMD_Is_GHZ
		includealigned	"artnem/GHZ Breakable Wall.nem"
		endif
Nem_GhzWall2:
		if MMD_Is_GHZ
		includealigned	"artnem/GHZ Edge Wall.nem"
		endif
; ---------------------------------------------------------------------------
; Compressed graphics - LZ stuff
; ---------------------------------------------------------------------------
Nem_Water:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Water Surface.nem"
		endif
Nem_Splash:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Water & Splashes.nem"
		endif
Nem_LzSpikeBall:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Spiked Ball & Chain.nem"
		endif
Nem_FlapDoor:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Flapping Door.nem"
		endif
Nem_Bubbles:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Bubbles & Countdown.nem"
		endif
Nem_LzBlock3:
		if MMD_Is_LZ
		includealigned	"artnem/LZ 32x16 Block.nem"
		endif
Nem_LzDoor1:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Vertical Door.nem"
		endif
Nem_Harpoon:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Harpoon.nem"
		endif
Nem_LzPole:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Breakable Pole.nem"
		endif
Nem_LzDoor2:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Horizontal Door.nem"
		endif
Nem_LzWheel:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Wheel.nem"
		endif
Nem_Gargoyle:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Gargoyle & Fireball.nem"
		endif
Nem_LzBlock2:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Blocks.nem"
		endif
Nem_LzPlatfm:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Rising Platform.nem"
		endif
Nem_Cork:
		if MMD_Is_LZ
		includealigned	"artnem/LZ Cork.nem"
		endif
Nem_LzBlock1:
		if MMD_Is_LZ
		includealigned	"artnem/LZ 32x32 Block.nem"
		endif
; ---------------------------------------------------------------------------
; Compressed graphics - MZ stuff
; ---------------------------------------------------------------------------
Nem_MzMetal:
		if MMD_Is_MZ
		includealigned	"artnem/MZ Metal Blocks.nem"
		endif
Nem_MzSwitch:
		if MMD_Is_MZ
		includealigned	"artnem/MZ Switch.nem"
		endif
Nem_MzGlass:
		if MMD_Is_MZ
		includealigned	"artnem/MZ Green Glass Block.nem"
		endif
Nem_UnkGrass:
		if MMD_Is_MZ
		includealigned	"artnem/Unused - Grass.nem"
		endif
Nem_MzFire:
		if MMD_Is_MZ
		includealigned	"artnem/Fireballs.nem"
		endif
Nem_Lava:
		if MMD_Is_MZ
		includealigned	"artnem/MZ Lava.nem"
		endif
Nem_MzBlock:
		if MMD_Is_MZ
		includealigned	"artnem/MZ Green Pushable Block.nem"
		endif
Nem_MzUnkBlock:
		if MMD_Is_MZ
		includealigned	"artnem/Unused - MZ Background.nem"
		endif
; ---------------------------------------------------------------------------
; Compressed graphics - SLZ stuff
; ---------------------------------------------------------------------------
Nem_Seesaw:
		if MMD_Is_SLZ
		includealigned	"artnem/SLZ Seesaw.nem"
		endif
Nem_SlzSpike:
		if MMD_Is_SLZ
		includealigned	"artnem/SLZ Little Spikeball.nem"
		endif
Nem_Fan:
		if MMD_Is_SLZ
		includealigned	"artnem/SLZ Fan.nem"
		endif
Nem_SlzWall:
		if MMD_Is_SLZ
		includealigned	"artnem/SLZ Breakable Wall.nem"
		endif
Nem_Pylon:
		if MMD_Is_SLZ
		includealigned	"artnem/SLZ Pylon.nem"
		endif
Nem_SlzSwing:
		if MMD_Is_SLZ
		includealigned	"artnem/SLZ Swinging Platform.nem"
		endif
Nem_SlzBlock:
		if MMD_Is_SLZ
		includealigned	"artnem/SLZ 32x32 Block.nem"
		endif
Nem_SlzCannon:
		if MMD_Is_SLZ
		includealigned	"artnem/SLZ Cannon.nem"
		endif
; ---------------------------------------------------------------------------
; Compressed graphics - SYZ stuff
; ---------------------------------------------------------------------------
Nem_Bumper:
		if MMD_Is_SYZ
		includealigned	"artnem/SYZ Bumper.nem"
		endif
Nem_SyzSpike2:
		if MMD_Is_SYZ
		includealigned	"artnem/SYZ Small Spikeball.nem"
		endif
Nem_LzSwitch:
		if MMD_Is_SYZ
		includealigned	"artnem/Switch.nem"
		endif
Nem_SyzSpike1:
		if MMD_Is_SYZ
		includealigned	"artnem/SYZ Large Spikeball.nem"
		endif
; ---------------------------------------------------------------------------
; Compressed graphics - SBZ stuff
; ---------------------------------------------------------------------------
Nem_SbzWheel1:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Running Disc.nem"
		endif
Nem_SbzWheel2:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Junction Wheel.nem"
		endif
Nem_Cutter:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Pizza Cutter.nem"
		endif
Nem_Stomper:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Stomper.nem"
		endif
Nem_SpinPform:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Spinning Platform.nem"
		endif
Nem_TrapDoor:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Trapdoor.nem"
		endif
Nem_SbzFloor:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Collapsing Floor.nem"
		endif
Nem_Electric:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Electrocuter.nem"
		endif
Nem_SbzBlock:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Vanishing Block.nem"
		endif
Nem_FlamePipe:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Flaming Pipe.nem"
		endif
Nem_SbzDoor1:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Small Vertical Door.nem"
		endif
Nem_SlideFloor:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Sliding Floor Trap.nem"
		endif
Nem_SbzDoor2:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Large Horizontal Door.nem"
		endif
Nem_Girder:
		if MMD_Is_SBZ
		includealigned	"artnem/SBZ Crushing Girder.nem"
		endif
; ---------------------------------------------------------------------------
; Compressed graphics - enemies
; ---------------------------------------------------------------------------
Nem_BallHog:
		if MMD_Is_SBZ
		includealigned	"artnem/Enemy Ball Hog.nem"
		endif
Nem_Crabmeat:
		if MMD_Is_GHZ||MMD_Is_SYZ
		includealigned	"artnem/Enemy Crabmeat.nem"
		endif
Nem_Buzz:
		if MMD_Is_GHZ||MMD_Is_MZ
		includealigned	"artnem/Enemy Buzz Bomber.nem"
		endif
Nem_Burrobot:
		if MMD_Is_LZ
		includealigned	"artnem/Enemy Burrobot.nem"
		endif
Nem_Chopper:
		if MMD_Is_GHZ
		includealigned	"artnem/Enemy Chopper.nem"
		endif
Nem_Jaws:
		if MMD_Is_LZ
		includealigned	"artnem/Enemy Jaws.nem"
		endif
Nem_Roller:
		if MMD_Is_SYZ
		includealigned	"artnem/Enemy Roller.nem"
		endif
Nem_Motobug:
		if MMD_Is_GHZ
		includealigned	"artnem/Enemy Motobug.nem"
		endif
Nem_Newtron:
		if MMD_Is_GHZ
		includealigned	"artnem/Enemy Newtron.nem"
		endif
Nem_Yadrin:	
		if MMD_Is_SYZ
		includealigned	"artnem/Enemy Yadrin.nem"
		endif
Nem_Basaran:
		includealigned	"artnem/Enemy Basaran.nem"
Nem_Bomb:
		if MMD_Is_SLZ
		includealigned	"artnem/Enemy Bomb.nem"
		endif
Nem_Orbinaut:
		if MMD_Is_LZ||MMD_Is_SLZ
		includealigned	"artnem/Enemy Orbinaut.nem"
		endif
Nem_Cater:
		if MMD_Is_MZ||MMD_Is_SYZ
		includealigned	"artnem/Enemy Caterkiller.nem"
		endif
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_TitleCard:	includealigned	"artnem/Title Cards.nem"
Nem_Hud:	includealigned	"artnem/HUD.nem"	; HUD (rings, time, score)
Nem_Lives:	includealigned	"artnem/HUD - Life Counter Icon.nem"
Nem_Ring:	includealigned	"artnem/Rings.nem"
Nem_Monitors:	includealigned	"artnem/Monitors.nem"
Nem_Explode:	includealigned	"artnem/Explosion.nem"
Nem_Points:	includealigned	"artnem/Points.nem"	; points from destroyed enemy or object
Nem_GameOver:	includealigned	"artnem/Game Over.nem"	; game over / time over
Nem_HSpring:	includealigned	"artnem/Spring Horizontal.nem"
Nem_VSpring:	includealigned	"artnem/Spring Vertical.nem"
Nem_SignPost:	includealigned	"artnem/Signpost.nem"	; end of level signpost
Nem_Lamp:	includealigned	"artnem/Lamppost.nem"
Nem_BigFlash:	includealigned	"artnem/Giant Ring Flash.nem"
Nem_Bonus:	includealigned	"artnem/Hidden Bonuses.nem" ; hidden bonuses at end of a level
; ---------------------------------------------------------------------------
; Compressed graphics - continue screen
; ---------------------------------------------------------------------------
Nem_ContSonic:
		if MMD_Is_Continue
		includealigned	"artnem/Continue Screen Sonic.nem"
		endif
Nem_MiniSonic:	
		if MMD_Is_Continue
		includealigned	"artnem/Continue Screen Stuff.nem"
		endif
; ---------------------------------------------------------------------------
; Compressed graphics - animals
; ---------------------------------------------------------------------------
Nem_Rabbit:
		if MMD_Is_GHZ||MMD_Is_SBZ||MMD_Is_Ending
		includealigned	"artnem/Animal Rabbit.nem"
		endif
Nem_Chicken:
		if MMD_Is_SYZ||MMD_Is_SBZ||MMD_Is_Ending
		includealigned	"artnem/Animal Chicken.nem"
		endif
Nem_Penguin:
		if MMD_Is_LZ||MMD_Is_SBZ||MMD_Is_Ending
		includealigned	"artnem/Animal Penguin.nem"
		endif
Nem_Seal:
		if MMD_Is_MZ||MMD_Is_LZ||MMD_Is_SBZ||MMD_Is_Ending
		includealigned	"artnem/Animal Seal.nem"
		endif
Nem_Pig:
		if MMD_Is_SYZ||MMD_Is_SLZ||MMD_Is_Ending
		includealigned	"artnem/Animal Pig.nem"
		endif
Nem_Flicky:
		if MMD_Is_GHZ||MMD_Is_SLZ||MMD_Is_Ending
		includealigned	"artnem/Animal Flicky.nem"
		endif
Nem_Squirrel:
		if MMD_Is_MZ||MMD_Is_Ending
		includealigned	"artnem/Animal Squirrel.nem"
		endif
; ---------------------------------------------------------------------------
; Animated uncompressed graphics
; ---------------------------------------------------------------------------
Art_GhzWater:
		if MMD_Is_GHZ
		includealigned	"artunc/GHZ Waterfall.bin"
		endif
Art_GhzFlower1:
		if MMD_Is_GHZ
		includealigned	"artunc/GHZ Flower Large.bin"
		endif
Art_GhzFlower2:
		if MMD_Is_GHZ
		includealigned	"artunc/GHZ Flower Small.bin"
		endif
Art_MzLava1:
		if MMD_Is_MZ
		includealigned	"artunc/MZ Lava Surface.bin"
		endif
Art_MzLava2:
		if MMD_Is_MZ
		includealigned	"artunc/MZ Lava.bin"
		endif
Art_MzTorch:
		if MMD_Is_MZ
		includealigned	"artunc/MZ Background Torch.bin"
		endif
Art_SbzSmoke:
		if MMD_Is_SBZ
		includealigned	"artunc/SBZ Background Smoke.bin"
		endif
Art_BigRing:
		if ~~MMD_Is_SBZ
		includealigned	"artunc/Giant Ring.bin"
		endif
Eni_Title:
		if MMD_Is_Title
		includealigned	"tilemaps/Title Screen.eni" ; title screen foreground (mappings)
		endif
Nem_TitleFg:
		if MMD_Is_Title
		includealigned	"artnem/Title Screen Foreground.nem"
		endif
Nem_TitleSonic:
		if MMD_Is_Title
		includealigned	"artnem/Title Screen Sonic.nem"
		endif
Nem_TitleTM:
		if MMD_Is_Title
		includealigned	"artnem/Title Screen TM.nem"
		endif
Eni_JapNames:
		if MMD_Is_Title
		includealigned	"tilemaps/Hidden Japanese Credits.eni" ; Japanese credits (mappings)
		endif
Nem_JapNames:
		if MMD_Is_Title
		includealigned	"artnem/Hidden Japanese Credits.nem"
		endif

Map_SSWalls:
		if MMD_Is_SS
		include	"_maps/SS Walls.asm"
		endif

; ---------------------------------------------------------------------------
; Compressed graphics - special stage
; ---------------------------------------------------------------------------
Nem_SSWalls:
		if MMD_Is_SS
		includealigned	"artnem/Special Walls.nem" ; special stage walls
		endif
Eni_SSBg1:
		if MMD_Is_SS
		includealigned	"tilemaps/SS Background 1.eni" ; special stage background (mappings)
		endif
Nem_SSBgFish:
		if MMD_Is_SS
		includealigned	"artnem/Special Birds & Fish.nem" ; special stage birds and fish background
		endif
Eni_SSBg2:
		if MMD_Is_SS
		includealigned	"tilemaps/SS Background 2.eni" ; special stage background (mappings)
		endif
Nem_SSBgCloud:
		if MMD_Is_SS
		includealigned	"artnem/Special Clouds.nem" ; special stage clouds background
		endif
Nem_SSGOAL:
		if MMD_Is_SS
		includealigned	"artnem/Special GOAL.nem" ; special stage GOAL block
		endif
Nem_SSRBlock:
		if MMD_Is_SS
		includealigned	"artnem/Special R.nem"	; special stage R block
		endif
Nem_SS1UpBlock:
		if MMD_Is_SS
		includealigned	"artnem/Special 1UP.nem" ; special stage 1UP block
		endif
Nem_SSEmStars:
		if MMD_Is_SS
		includealigned	"artnem/Special Emerald Twinkle.nem" ; special stage stars from a collected emerald
		endif
Nem_SSRedWhite:
		if MMD_Is_SS
		includealigned	"artnem/Special Red-White.nem" ; special stage red/white block
		endif
Nem_SSZone1:
		if MMD_Is_SS
		includealigned	"artnem/Special ZONE1.nem" ; special stage ZONE1 block
		endif
Nem_SSZone2:
		if MMD_Is_SS
		includealigned	"artnem/Special ZONE2.nem" ; ZONE2 block
		endif
Nem_SSZone3:
		if MMD_Is_SS
		includealigned	"artnem/Special ZONE3.nem" ; ZONE3 block
		endif
Nem_SSZone4:
		if MMD_Is_SS
		includealigned	"artnem/Special ZONE4.nem" ; ZONE4 block
		endif
Nem_SSZone5:
		if MMD_Is_SS
		includealigned	"artnem/Special ZONE5.nem" ; ZONE5 block
		endif
Nem_SSZone6:
		if MMD_Is_SS
		includealigned	"artnem/Special ZONE6.nem" ; ZONE6 block
		endif
Nem_SSUpDown:
		if MMD_Is_SS
		includealigned	"artnem/Special UP-DOWN.nem" ; special stage UP/DOWN block
		endif
Nem_SSEmerald:
		if MMD_Is_SS
		includealigned	"artnem/Special Emeralds.nem" ; special stage chaos emeralds
		endif
Nem_SSGhost:
		if MMD_Is_SS
		includealigned	"artnem/Special Ghost.nem" ; special stage ghost block
		endif
Nem_SSWBlock:
		if MMD_Is_SS
		includealigned	"artnem/Special W.nem"	; special stage W block
		endif
Nem_SSGlass:
		if MMD_Is_SS
		includealigned	"artnem/Special Glass.nem" ; special stage destroyable glass block
		endif
Nem_ResultEm:
		if MMD_Is_SS
		includealigned	"artnem/Special Result Emeralds.nem" ; chaos emeralds on special stage results screen
		endif

; ---------------------------------------------------------------------------
; Compressed graphics - bosses and ending sequence
; ---------------------------------------------------------------------------
Nem_Eggman:
		includealigned	"artnem/Boss - Main.nem"
Nem_Weapons:
		includealigned	"artnem/Boss - Weapons.nem"
Nem_Prison:
		includealigned	"artnem/Prison Capsule.nem"
Nem_Sbz2Eggman:
		if MMD_Is_SBZ
		includealigned	"artnem/Boss - Eggman in SBZ2 & FZ.nem"
		endif
Nem_FzBoss:
		if MMD_Is_FZ
		includealigned	"artnem/Boss - Final Zone.nem"
		endif
Nem_FzEggman:
		if MMD_Is_FZ
		includealigned	"artnem/Boss - Eggman after FZ Fight.nem"
		endif
Nem_Exhaust:
		includealigned	"artnem/Boss - Exhaust Flame.nem"
Nem_EndEm:
		if MMD_Is_Ending
		includealigned	"artnem/Ending - Emeralds.nem"
		endif
Nem_EndSonic:
		if MMD_Is_Ending
		includealigned	"artnem/Ending - Sonic.nem"
		endif
Nem_TryAgain:
		if MMD_Is_Ending
		includealigned	"artnem/Ending - Try Again.nem"
		endif
Nem_EndEggman:
		if Revision=0
		includealigned	"artnem/Unused - Eggman Ending.nem"
		endif
Kos_EndFlowers:
		if MMD_Is_Ending
		includealigned	"artkos/Flowers at Ending.kos" ; ending sequence animated flowers
		endif
Nem_EndFlower:
		if MMD_Is_Ending
		includealigned	"artnem/Ending - Flowers.nem"
		endif
Nem_CreditText:
		if MMD_Is_Title||MMD_Is_Credits
		includealigned	"artnem/Ending - Credits.nem"
		endif
Nem_EndStH:
		if MMD_Is_Ending
		includealigned	"artnem/Ending - StH Logo.nem"
		endif

Nem_GHZ_1st:
		if MMD_Is_GHZ||MMD_Is_Title
		includealigned	"artnem/8x8 - GHZ1.nem"	; GHZ primary patterns
		endif
Nem_GHZ_2nd:
		if MMD_Is_GHZ||MMD_Is_Title
		includealigned	"artnem/8x8 - GHZ2.nem"	; GHZ secondary patterns
		endif
Nem_LZ:
		if MMD_Is_LZ
		includealigned	"artnem/8x8 - LZ.nem"	; LZ primary patterns
		endif
Nem_MZ:
		if MMD_Is_MZ
		includealigned	"artnem/8x8 - MZ.nem"	; MZ primary patterns
		endif
Nem_SLZ:
		if MMD_Is_SLZ
		includealigned	"artnem/8x8 - SLZ.nem"	; SLZ primary patterns
		endif
Nem_SYZ:
		if MMD_Is_SYZ
		includealigned	"artnem/8x8 - SYZ.nem"	; SYZ primary patterns
		endif
Nem_SBZ:
		if MMD_Is_SBZ
		includealigned	"artnem/8x8 - SBZ.nem"	; SBZ primary patterns
		endif

		if MMD_Has_Sonic
; ---------------------------------------------------------------------------
; Uncompressed graphics	- Sonic
; ---------------------------------------------------------------------------
Art_Sonic:	includealigned	"artunc/Sonic.bin"	; Sonic
		endif