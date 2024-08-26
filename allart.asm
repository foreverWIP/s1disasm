bincludealigned: macro {INTLABEL},filename,cond
	if ("cond"=="")
.condition := 1
	else
.condition := cond
	endif
	if .condition
.file_start := *
	binclude filename
.file_end := *
	if ((*)&$1FFFF)<(.file_start&$1FFFF)
	rorg -(.file_end-.file_start)
	align $20000
__LABEL__ label *
	binclude filename
	else
__LABEL__ label .file_start
	endif
	even
	else
__LABEL__ label *
	endif
	endm

Art_Text:	bincludealigned	"artunc/menutext.bin",MMD_Is_Title ; text used in level select and debug mode
Art_Text_End:	even
Art_Hud:	bincludealigned	"artunc/HUD Numbers.bin" ; 8x16 pixel numbers on HUD
Art_LivesNums:	bincludealigned	"artunc/Lives Counter Numbers.bin" ; 8x8 pixel numbers on lives counter

Eni_Title:	bincludealigned	"tilemaps/Title Screen.eni",MMD_Is_Title ; title screen foreground (mappings)
Nem_TitleFg:	bincludealigned	"artnem/Title Screen Foreground.nem",MMD_Is_Title
Nem_TitleSonic:	bincludealigned	"artnem/Title Screen Sonic.nem",MMD_Is_Title
Nem_TitleTM:	bincludealigned	"artnem/Title Screen TM.nem",MMD_Is_Title

; ---------------------------------------------------------------------------
; Compressed graphics - primary patterns and block mappings
; ---------------------------------------------------------------------------
Blk16_GHZ:	bincludealigned	"map16/GHZ.eni",MMD_Is_GHZ||MMD_Is_Title||MMD_Is_Ending
Blk16_LZ:	bincludealigned	"map16/LZ.eni",MMD_Is_LZ
Blk16_MZ:	bincludealigned	"map16/MZ.eni",MMD_Is_MZ
Blk16_SLZ:	bincludealigned	"map16/SLZ.eni",MMD_Is_SLZ
Blk16_SYZ:	bincludealigned	"map16/SYZ.eni",MMD_Is_SYZ
Blk16_SBZ:	bincludealigned	"map16/SBZ.eni",MMD_Is_SBZ
Blk256_GHZ:	bincludealigned	"map256/GHZ.kos",MMD_Is_GHZ||MMD_Is_Title||MMD_Is_Ending
Blk256_LZ:	bincludealigned	"map256/LZ.kos",MMD_Is_LZ
Blk256_MZ:	bincludealigned	"map256/MZ (JP1).kos",MMD_Is_MZ
Blk256_SLZ:	bincludealigned	"map256/SLZ.kos",MMD_Is_SLZ
Blk256_SYZ:	bincludealigned	"map256/SYZ.kos",MMD_Is_SYZ
Blk256_SBZ:	bincludealigned	"map256/SBZ (JP1).kos",MMD_Is_SBZ

Nem_GHZ_1st:	bincludealigned	"artnem/8x8 - GHZ1.nem",MMD_Is_GHZ||MMD_Is_Title||MMD_Is_Ending
Nem_GHZ_2nd:	bincludealigned	"artnem/8x8 - GHZ2.nem",MMD_Is_GHZ||MMD_Is_Title||MMD_Is_Ending
Nem_LZ:	bincludealigned	"artnem/8x8 - LZ.nem",MMD_Is_LZ
Nem_MZ:	bincludealigned	"artnem/8x8 - MZ.nem",MMD_Is_MZ
Nem_SLZ:	bincludealigned	"artnem/8x8 - SLZ.nem",MMD_Is_SLZ
Nem_SYZ:	bincludealigned	"artnem/8x8 - SYZ.nem",MMD_Is_SYZ
Nem_SBZ:	bincludealigned	"artnem/8x8 - SBZ.nem",MMD_Is_SBZ

; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_Shield:	bincludealigned	"artnem/Shield.nem",MMD_Is_Level
Nem_Stars:	bincludealigned	"artnem/Invincibility Stars.nem",MMD_Is_Level

; ---------------------------------------------------------------------------
; Compressed graphics - GHZ stuff
; ---------------------------------------------------------------------------
Nem_Stalk:	bincludealigned	"artnem/GHZ Flower Stalk.nem",MMD_Is_GHZ||MMD_Is_Ending
Nem_Swing:	bincludealigned	"artnem/GHZ Swinging Platform.nem",MMD_Is_GHZ||MMD_Is_MZ
Nem_Bridge:	bincludealigned	"artnem/GHZ Bridge.nem",MMD_Is_GHZ||MMD_Is_Ending
Nem_GhzUnkBlock:	bincludealigned	"artnem/Unused - GHZ Block.nem",MMD_Is_GHZ||MMD_Is_Ending
Nem_Ball:	bincludealigned	"artnem/GHZ Giant Ball.nem",MMD_Is_GHZ
Nem_Spikes:	bincludealigned	"artnem/Spikes.nem"
Nem_GhzLog:	bincludealigned	"artnem/Unused - GHZ Log.nem",MMD_Is_GHZ
Nem_SpikePole:	bincludealigned	"artnem/GHZ Spiked Log.nem",MMD_Is_GHZ
Nem_PplRock:	bincludealigned	"artnem/GHZ Purple Rock.nem",MMD_Is_GHZ||MMD_Is_Ending
Nem_GhzWall1:	bincludealigned	"artnem/GHZ Breakable Wall.nem",MMD_Is_GHZ
Nem_GhzWall2:	bincludealigned	"artnem/GHZ Edge Wall.nem",MMD_Is_GHZ||MMD_Is_Ending
; ---------------------------------------------------------------------------
; Compressed graphics - LZ stuff
; ---------------------------------------------------------------------------
Nem_Water:	bincludealigned	"artnem/LZ Water Surface.nem",MMD_Is_LZ
Nem_Splash:	bincludealigned	"artnem/LZ Water & Splashes.nem",MMD_Is_LZ
Nem_LzSpikeBall:	bincludealigned	"artnem/LZ Spiked Ball & Chain.nem",MMD_Is_LZ
Nem_FlapDoor:	bincludealigned	"artnem/LZ Flapping Door.nem",MMD_Is_LZ
Nem_Bubbles:	bincludealigned	"artnem/LZ Bubbles & Countdown.nem",MMD_Is_LZ
Nem_LzBlock3:	bincludealigned	"artnem/LZ 32x16 Block.nem",MMD_Is_LZ
Nem_LzDoor1:	bincludealigned	"artnem/LZ Vertical Door.nem",MMD_Is_LZ
Nem_Harpoon:	bincludealigned	"artnem/LZ Harpoon.nem",MMD_Is_LZ
Nem_LzPole:	bincludealigned	"artnem/LZ Breakable Pole.nem",MMD_Is_LZ
Nem_LzDoor2:	bincludealigned	"artnem/LZ Horizontal Door.nem",MMD_Is_LZ
Nem_LzWheel:	bincludealigned	"artnem/LZ Wheel.nem",MMD_Is_LZ
Nem_Gargoyle:	bincludealigned	"artnem/LZ Gargoyle & Fireball.nem",MMD_Is_LZ
Nem_LzBlock2:	bincludealigned	"artnem/LZ Blocks.nem",MMD_Is_LZ
Nem_LzPlatfm:	bincludealigned	"artnem/LZ Rising Platform.nem",MMD_Is_LZ
Nem_Cork:	bincludealigned	"artnem/LZ Cork.nem",MMD_Is_LZ
Nem_LzBlock1:	bincludealigned	"artnem/LZ 32x32 Block.nem",MMD_Is_LZ
; ---------------------------------------------------------------------------
; Compressed graphics - MZ stuff
; ---------------------------------------------------------------------------
Nem_MzMetal:	bincludealigned	"artnem/MZ Metal Blocks.nem",MMD_Is_MZ
Nem_MzSwitch:	bincludealigned	"artnem/MZ Switch.nem",MMD_Is_MZ||MMD_Is_SBZ
Nem_MzGlass:	bincludealigned	"artnem/MZ Green Glass Block.nem",MMD_Is_MZ
Nem_UnkGrass:	bincludealigned	"artnem/Unused - Grass.nem",MMD_Is_MZ
Nem_MzFire:	bincludealigned	"artnem/Fireballs.nem",MMD_Is_MZ
Nem_Lava:	bincludealigned	"artnem/MZ Lava.nem",MMD_Is_MZ
Nem_MzBlock:	bincludealigned	"artnem/MZ Green Pushable Block.nem",MMD_Is_MZ
Nem_MzUnkBlock:	bincludealigned	"artnem/Unused - MZ Background.nem",MMD_Is_MZ
; ---------------------------------------------------------------------------
; Compressed graphics - SLZ stuff
; ---------------------------------------------------------------------------
Nem_Seesaw:	bincludealigned	"artnem/SLZ Seesaw.nem",MMD_Is_SLZ
Nem_SlzSpike:	bincludealigned	"artnem/SLZ Little Spikeball.nem",MMD_Is_SLZ
Nem_Fan:	bincludealigned	"artnem/SLZ Fan.nem",MMD_Is_SLZ
Nem_SlzWall:	bincludealigned	"artnem/SLZ Breakable Wall.nem",MMD_Is_SLZ
Nem_Pylon:	bincludealigned	"artnem/SLZ Pylon.nem",MMD_Is_SLZ
Nem_SlzSwing:	bincludealigned	"artnem/SLZ Swinging Platform.nem",MMD_Is_SLZ||MMD_Is_SBZ
Nem_SlzBlock:	bincludealigned	"artnem/SLZ 32x32 Block.nem",MMD_Is_SLZ
Nem_SlzCannon:	bincludealigned	"artnem/SLZ Cannon.nem",MMD_Is_SLZ
; ---------------------------------------------------------------------------
; Compressed graphics - SYZ stuff
; ---------------------------------------------------------------------------
Nem_Bumper:	bincludealigned	"artnem/SYZ Bumper.nem",MMD_Is_SYZ||MMD_Is_SS
Nem_SyzSpike2:	bincludealigned	"artnem/SYZ Small Spikeball.nem",MMD_Is_SYZ
Nem_LzSwitch:	bincludealigned	"artnem/Switch.nem",MMD_Is_SYZ||MMD_Is_LZ
Nem_SyzSpike1:	bincludealigned	"artnem/SYZ Large Spikeball.nem",MMD_Is_SYZ
; ---------------------------------------------------------------------------
; Compressed graphics - SBZ stuff
; ---------------------------------------------------------------------------
Nem_SbzWheel1:	bincludealigned	"artnem/SBZ Running Disc.nem",MMD_Is_SBZ
Nem_SbzWheel2:	bincludealigned	"artnem/SBZ Junction Wheel.nem",MMD_Is_SBZ
Nem_Cutter:	bincludealigned	"artnem/SBZ Pizza Cutter.nem",MMD_Is_SBZ
Nem_Stomper:	bincludealigned	"artnem/SBZ Stomper.nem",MMD_Is_SBZ
Nem_SpinPform:	bincludealigned	"artnem/SBZ Spinning Platform.nem",MMD_Is_SBZ
Nem_TrapDoor:	bincludealigned	"artnem/SBZ Trapdoor.nem",MMD_Is_SBZ
Nem_SbzFloor:	bincludealigned	"artnem/SBZ Collapsing Floor.nem",MMD_Is_SBZ
Nem_Electric:	bincludealigned	"artnem/SBZ Electrocuter.nem",MMD_Is_SBZ
Nem_SbzBlock:	bincludealigned	"artnem/SBZ Vanishing Block.nem",MMD_Is_SBZ
Nem_FlamePipe:	bincludealigned	"artnem/SBZ Flaming Pipe.nem",MMD_Is_SBZ
Nem_SbzDoor1:	bincludealigned	"artnem/SBZ Small Vertical Door.nem",MMD_Is_SBZ
Nem_SlideFloor:	bincludealigned	"artnem/SBZ Sliding Floor Trap.nem",MMD_Is_SBZ
Nem_SbzDoor2:	bincludealigned	"artnem/SBZ Large Horizontal Door.nem",MMD_Is_SBZ
Nem_Girder:	bincludealigned	"artnem/SBZ Crushing Girder.nem",MMD_Is_SBZ
; ---------------------------------------------------------------------------
; Compressed graphics - enemies
; ---------------------------------------------------------------------------
Nem_BallHog:	bincludealigned	"artnem/Enemy Ball Hog.nem",MMD_Is_SBZ
Nem_Crabmeat:	bincludealigned	"artnem/Enemy Crabmeat.nem",MMD_Is_GHZ||MMD_Is_SYZ
Nem_Buzz:	bincludealigned	"artnem/Enemy Buzz Bomber.nem",MMD_Is_GHZ||MMD_Is_MZ||MMD_Is_SYZ
Nem_Burrobot:	bincludealigned	"artnem/Enemy Burrobot.nem",MMD_Is_LZ
Nem_Chopper:	bincludealigned	"artnem/Enemy Chopper.nem",MMD_Is_GHZ
Nem_Jaws:	bincludealigned	"artnem/Enemy Jaws.nem",MMD_Is_LZ
Nem_Roller:	bincludealigned	"artnem/Enemy Roller.nem",MMD_Is_SYZ
Nem_Motobug:	bincludealigned	"artnem/Enemy Motobug.nem",MMD_Is_GHZ
Nem_Newtron:	bincludealigned	"artnem/Enemy Newtron.nem",MMD_Is_GHZ
Nem_Yadrin:		bincludealigned	"artnem/Enemy Yadrin.nem",MMD_Is_SYZ
Nem_Basaran:	bincludealigned	"artnem/Enemy Basaran.nem",MMD_Is_MZ
Nem_Bomb:	bincludealigned	"artnem/Enemy Bomb.nem",MMD_Is_SLZ||MMD_Is_SBZ
Nem_Orbinaut:	bincludealigned	"artnem/Enemy Orbinaut.nem",MMD_Is_LZ||MMD_Is_SLZ
Nem_Cater:	bincludealigned	"artnem/Enemy Caterkiller.nem",MMD_Is_MZ||MMD_Is_SYZ||MMD_Is_SBZ
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_TitleCard:	bincludealigned	"artnem/Title Cards.nem"
Nem_Hud:	bincludealigned	"artnem/HUD.nem"
Nem_Lives:	bincludealigned	"artnem/HUD - Life Counter Icon.nem",MMD_Is_Level
Nem_Ring:	bincludealigned	"artnem/Rings.nem"
Nem_Monitors:	bincludealigned	"artnem/Monitors.nem",MMD_Is_Level
Nem_Explode:	bincludealigned	"artnem/Explosion.nem",MMD_Is_Level
Nem_Points:	bincludealigned	"artnem/Points.nem"	; points from destroyed enemy or object,MMD_Is_Level
Nem_GameOver:	bincludealigned	"artnem/Game Over.nem"	; game over / time over,MMD_Is_Level
Nem_HSpring:	bincludealigned	"artnem/Spring Horizontal.nem",MMD_Is_Level
Nem_VSpring:	bincludealigned	"artnem/Spring Vertical.nem",MMD_Is_Level
Nem_SignPost:	bincludealigned	"artnem/Signpost.nem"	; end of level signpost,MMD_Is_Level
Nem_Lamp:	bincludealigned	"artnem/Lamppost.nem",MMD_Is_Level
Nem_BigFlash:	bincludealigned	"artnem/Giant Ring Flash.nem",~~MMD_Is_SBZ
Nem_Bonus:	bincludealigned	"artnem/Hidden Bonuses.nem" ; hidden bonuses at end of a level,MMD_Is_Level
; ---------------------------------------------------------------------------
; Compressed graphics - continue screen
; ---------------------------------------------------------------------------
Nem_ContSonic:	bincludealigned	"artnem/Continue Screen Sonic.nem"
Nem_MiniSonic:	bincludealigned	"artnem/Continue Screen Stuff.nem"
; ---------------------------------------------------------------------------
; Compressed graphics - animals
; ---------------------------------------------------------------------------
Nem_Rabbit:	bincludealigned	"artnem/Animal Rabbit.nem",MMD_Is_Ending||MMD_Is_GHZ||MMD_Is_SBZ
Nem_Chicken:	bincludealigned	"artnem/Animal Chicken.nem",MMD_Is_Ending||MMD_Is_SYZ||MMD_Is_SBZ
Nem_Penguin:	bincludealigned	"artnem/Animal Penguin.nem",MMD_Is_Ending||MMD_Is_LZ
Nem_Seal:	bincludealigned	"artnem/Animal Seal.nem",MMD_Is_Ending||MMD_Is_LZ||MMD_Is_MZ
Nem_Pig:	bincludealigned	"artnem/Animal Pig.nem",MMD_Is_Ending||MMD_Is_SLZ||MMD_Is_SYZ
Nem_Flicky:	bincludealigned	"artnem/Animal Flicky.nem",MMD_Is_Ending||MMD_Is_GHZ||MMD_Is_SLZ
Nem_Squirrel:	bincludealigned	"artnem/Animal Squirrel.nem",MMD_Is_Ending||MMD_Is_MZ
; ---------------------------------------------------------------------------
; Animated uncompressed graphics
; ---------------------------------------------------------------------------
Art_GhzWater:	bincludealigned	"artunc/GHZ Waterfall.bin",MMD_Is_GHZ||MMD_Is_Title||MMD_Is_Ending
Art_GhzFlower1:	bincludealigned	"artunc/GHZ Flower Large.bin",MMD_Is_GHZ||MMD_Is_Ending
Art_GhzFlower2:	bincludealigned	"artunc/GHZ Flower Small.bin",MMD_Is_GHZ||MMD_Is_Ending
Art_MzLava1:	bincludealigned	"artunc/MZ Lava Surface.bin",MMD_Is_MZ
Art_MzLava2:	bincludealigned	"artunc/MZ Lava.bin",MMD_Is_MZ
Art_MzTorch:	bincludealigned	"artunc/MZ Background Torch.bin",MMD_Is_MZ
Art_SbzSmoke:	bincludealigned	"artunc/SBZ Background Smoke.bin",MMD_Is_SBZ
Art_BigRing:	bincludealigned	"artunc/Giant Ring.bin",~~MMD_Is_SBZ
Eni_JapNames:	bincludealigned	"tilemaps/Hidden Japanese Credits.eni",MMD_Is_Title
Nem_JapNames:	bincludealigned	"artnem/Hidden Japanese Credits.nem",MMD_Is_Title

Map_SSWalls:
				if MMD_Is_SS
				include			"_maps/SS Walls.asm"
				endif

; ---------------------------------------------------------------------------
; Compressed graphics - special stage
; ---------------------------------------------------------------------------
Nem_SSWalls:	bincludealigned	"artnem/Special Walls.nem",MMD_Is_SS
Eni_SSBg1:	bincludealigned	"tilemaps/SS Background 1.eni",MMD_Is_SS
Nem_SSBgFish:	bincludealigned	"artnem/Special Birds & Fish.nem",MMD_Is_SS
Eni_SSBg2:	bincludealigned	"tilemaps/SS Background 2.eni",MMD_Is_SS
Nem_SSBgCloud:	bincludealigned	"artnem/Special Clouds.nem",MMD_Is_SS
Nem_SSGOAL:	bincludealigned	"artnem/Special GOAL.nem",MMD_Is_SS
Nem_SSRBlock:	bincludealigned	"artnem/Special R.nem",MMD_Is_SS
Nem_SS1UpBlock:	bincludealigned	"artnem/Special 1UP.nem",MMD_Is_SS
Nem_SSEmStars:	bincludealigned	"artnem/Special Emerald Twinkle.nem",MMD_Is_SS
Nem_SSRedWhite:	bincludealigned	"artnem/Special Red-White.nem",MMD_Is_SS
Nem_SSZone1:	bincludealigned	"artnem/Special ZONE1.nem",MMD_Is_SS
Nem_SSZone2:	bincludealigned	"artnem/Special ZONE2.nem",MMD_Is_SS
Nem_SSZone3:	bincludealigned	"artnem/Special ZONE3.nem",MMD_Is_SS
Nem_SSZone4:	bincludealigned	"artnem/Special ZONE4.nem",MMD_Is_SS
Nem_SSZone5:	bincludealigned	"artnem/Special ZONE5.nem",MMD_Is_SS
Nem_SSZone6:	bincludealigned	"artnem/Special ZONE6.nem",MMD_Is_SS
Nem_SSUpDown:	bincludealigned	"artnem/Special UP-DOWN.nem",MMD_Is_SS
Nem_SSEmerald:	bincludealigned	"artnem/Special Emeralds.nem",MMD_Is_SS
Nem_SSGhost:	bincludealigned	"artnem/Special Ghost.nem",MMD_Is_SS
Nem_SSWBlock:	bincludealigned	"artnem/Special W.nem",MMD_Is_SS
Nem_SSGlass:	bincludealigned	"artnem/Special Glass.nem",MMD_Is_SS
Nem_ResultEm:	bincludealigned	"artnem/Special Result Emeralds.nem",MMD_Is_SS

; ---------------------------------------------------------------------------
; Compressed graphics - bosses and ending sequence
; ---------------------------------------------------------------------------
Nem_Eggman:	bincludealigned	"artnem/Boss - Main.nem",MMD_Is_Level
Nem_Weapons:	bincludealigned	"artnem/Boss - Weapons.nem",MMD_Is_Level
Nem_Prison:	bincludealigned	"artnem/Prison Capsule.nem",~~MMD_Is_SBZ
Nem_Sbz2Eggman:	bincludealigned	"artnem/Boss - Eggman in SBZ2 & FZ.nem",MMD_Is_SBZ
Nem_FzBoss:	bincludealigned	"artnem/Boss - Final Zone.nem",MMD_Is_SBZ
Nem_FzEggman:	bincludealigned	"artnem/Boss - Eggman after FZ Fight.nem",MMD_Is_SBZ
Nem_Exhaust:	bincludealigned	"artnem/Boss - Exhaust Flame.nem",MMD_Is_Level
Nem_EndEm:	bincludealigned	"artnem/Ending - Emeralds.nem",MMD_Is_Ending
Nem_EndSonic:	bincludealigned	"artnem/Ending - Sonic.nem",MMD_Is_Ending
Nem_TryAgain:	bincludealigned	"artnem/Ending - Try Again.nem",MMD_Is_Ending
Nem_EndEggman:	bincludealigned	"artnem/Unused - Eggman Ending.nem",MMD_Is_Ending
Kos_EndFlowers:	bincludealigned	"artkos/Flowers at Ending.kos",MMD_Is_Ending
Nem_EndFlower:	bincludealigned	"artnem/Ending - Flowers.nem",MMD_Is_Ending
Nem_CreditText:	bincludealigned	"artnem/Ending - Credits.nem",MMD_Is_Title||MMD_Is_Credits
Nem_EndStH:	bincludealigned	"artnem/Ending - StH Logo.nem",MMD_Is_Ending

; ---------------------------------------------------------------------------
; Uncompressed graphics	- Sonic
; ---------------------------------------------------------------------------
Art_Sonic:	bincludealigned	"artunc/Sonic.bin",MMD_Has_Sonic