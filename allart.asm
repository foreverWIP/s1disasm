includealigned: macro {INTLABEL},filename,cond
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

Art_Text:	includealigned	"artunc/menutext.bin" ; text used in level select and debug mode
Art_Text_End:	even
Art_Hud:	includealigned	"artunc/HUD Numbers.bin" ; 8x16 pixel numbers on HUD
Art_LivesNums:	includealigned	"artunc/Lives Counter Numbers.bin" ; 8x8 pixel numbers on lives counter

Eni_Title:	includealigned	"tilemaps/Title Screen.eni",MMD_Is_Title ; title screen foreground (mappings)
Nem_TitleFg:	includealigned	"artnem/Title Screen Foreground.nem",MMD_Is_Title
Nem_TitleSonic:	includealigned	"artnem/Title Screen Sonic.nem",MMD_Is_Title
Nem_TitleTM:	includealigned	"artnem/Title Screen TM.nem",MMD_Is_Title

; ---------------------------------------------------------------------------
; Compressed graphics - primary patterns and block mappings
; ---------------------------------------------------------------------------
Blk16_GHZ:	includealigned	"map16/GHZ.eni",MMD_Is_GHZ||MMD_Is_Title||MMD_Is_Ending
Blk16_LZ:	includealigned	"map16/LZ.eni",MMD_Is_LZ
Blk16_MZ:	includealigned	"map16/MZ.eni",MMD_Is_MZ
Blk16_SLZ:	includealigned	"map16/SLZ.eni",MMD_Is_SLZ
Blk16_SYZ:	includealigned	"map16/SYZ.eni",MMD_Is_SYZ
Blk16_SBZ:	includealigned	"map16/SBZ.eni",MMD_Is_SBZ
Blk256_GHZ:	includealigned	"map256/GHZ.kos",MMD_Is_GHZ||MMD_Is_Title||MMD_Is_Ending
Blk256_LZ:	includealigned	"map256/LZ.kos",MMD_Is_LZ
Blk256_MZ:	includealigned	"map256/MZ (JP1).kos",MMD_Is_MZ
Blk256_SLZ:	includealigned	"map256/SLZ.kos",MMD_Is_SLZ
Blk256_SYZ:	includealigned	"map256/SYZ.kos",MMD_Is_SYZ
Blk256_SBZ:	includealigned	"map256/SBZ (JP1).kos",MMD_Is_SBZ

Nem_GHZ_1st:	includealigned	"artnem/8x8 - GHZ1.nem",MMD_Is_GHZ||MMD_Is_Title||MMD_Is_Ending
Nem_GHZ_2nd:	includealigned	"artnem/8x8 - GHZ2.nem",MMD_Is_GHZ||MMD_Is_Title||MMD_Is_Ending
Nem_LZ:	includealigned	"artnem/8x8 - LZ.nem",MMD_Is_LZ
Nem_MZ:	includealigned	"artnem/8x8 - MZ.nem",MMD_Is_MZ
Nem_SLZ:	includealigned	"artnem/8x8 - SLZ.nem",MMD_Is_SLZ
Nem_SYZ:	includealigned	"artnem/8x8 - SYZ.nem",MMD_Is_SYZ
Nem_SBZ:	includealigned	"artnem/8x8 - SBZ.nem",MMD_Is_SBZ

; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_Shield:	includealigned	"artnem/Shield.nem",MMD_Is_Level
Nem_Stars:	includealigned	"artnem/Invincibility Stars.nem",MMD_Is_Level

; ---------------------------------------------------------------------------
; Compressed graphics - GHZ stuff
; ---------------------------------------------------------------------------
Nem_Stalk:	includealigned	"artnem/GHZ Flower Stalk.nem",MMD_Is_GHZ||MMD_Is_Ending
Nem_Swing:	includealigned	"artnem/GHZ Swinging Platform.nem",MMD_Is_GHZ
Nem_Bridge:	includealigned	"artnem/GHZ Bridge.nem",MMD_Is_GHZ||MMD_Is_Ending
Nem_GhzUnkBlock:	includealigned	"artnem/Unused - GHZ Block.nem",MMD_Is_GHZ||MMD_Is_Ending
Nem_Ball:	includealigned	"artnem/GHZ Giant Ball.nem",MMD_Is_GHZ
Nem_Spikes:	includealigned	"artnem/Spikes.nem"
Nem_GhzLog:	includealigned	"artnem/Unused - GHZ Log.nem",MMD_Is_GHZ
Nem_SpikePole:	includealigned	"artnem/GHZ Spiked Log.nem",MMD_Is_GHZ
Nem_PplRock:	includealigned	"artnem/GHZ Purple Rock.nem",MMD_Is_GHZ||MMD_Is_Ending
Nem_GhzWall1:	includealigned	"artnem/GHZ Breakable Wall.nem",MMD_Is_GHZ
Nem_GhzWall2:	includealigned	"artnem/GHZ Edge Wall.nem",MMD_Is_GHZ||MMD_Is_Ending
; ---------------------------------------------------------------------------
; Compressed graphics - LZ stuff
; ---------------------------------------------------------------------------
Nem_Water:	includealigned	"artnem/LZ Water Surface.nem",MMD_Is_LZ
Nem_Splash:	includealigned	"artnem/LZ Water & Splashes.nem",MMD_Is_LZ
Nem_LzSpikeBall:	includealigned	"artnem/LZ Spiked Ball & Chain.nem",MMD_Is_LZ
Nem_FlapDoor:	includealigned	"artnem/LZ Flapping Door.nem",MMD_Is_LZ
Nem_Bubbles:	includealigned	"artnem/LZ Bubbles & Countdown.nem",MMD_Is_LZ
Nem_LzBlock3:	includealigned	"artnem/LZ 32x16 Block.nem",MMD_Is_LZ
Nem_LzDoor1:	includealigned	"artnem/LZ Vertical Door.nem",MMD_Is_LZ
Nem_Harpoon:	includealigned	"artnem/LZ Harpoon.nem",MMD_Is_LZ
Nem_LzPole:	includealigned	"artnem/LZ Breakable Pole.nem",MMD_Is_LZ
Nem_LzDoor2:	includealigned	"artnem/LZ Horizontal Door.nem",MMD_Is_LZ
Nem_LzWheel:	includealigned	"artnem/LZ Wheel.nem",MMD_Is_LZ
Nem_Gargoyle:	includealigned	"artnem/LZ Gargoyle & Fireball.nem",MMD_Is_LZ
Nem_LzBlock2:	includealigned	"artnem/LZ Blocks.nem",MMD_Is_LZ
Nem_LzPlatfm:	includealigned	"artnem/LZ Rising Platform.nem",MMD_Is_LZ
Nem_Cork:	includealigned	"artnem/LZ Cork.nem",MMD_Is_LZ
Nem_LzBlock1:	includealigned	"artnem/LZ 32x32 Block.nem",MMD_Is_LZ
; ---------------------------------------------------------------------------
; Compressed graphics - MZ stuff
; ---------------------------------------------------------------------------
Nem_MzMetal:	includealigned	"artnem/MZ Metal Blocks.nem",MMD_Is_MZ
Nem_MzSwitch:	includealigned	"artnem/MZ Switch.nem",MMD_Is_MZ
Nem_MzGlass:	includealigned	"artnem/MZ Green Glass Block.nem",MMD_Is_MZ
Nem_UnkGrass:	includealigned	"artnem/Unused - Grass.nem",MMD_Is_MZ
Nem_MzFire:	includealigned	"artnem/Fireballs.nem",MMD_Is_MZ
Nem_Lava:	includealigned	"artnem/MZ Lava.nem",MMD_Is_MZ
Nem_MzBlock:	includealigned	"artnem/MZ Green Pushable Block.nem",MMD_Is_MZ
Nem_MzUnkBlock:	includealigned	"artnem/Unused - MZ Background.nem",MMD_Is_MZ
; ---------------------------------------------------------------------------
; Compressed graphics - SLZ stuff
; ---------------------------------------------------------------------------
Nem_Seesaw:	includealigned	"artnem/SLZ Seesaw.nem",MMD_Is_SLZ
Nem_SlzSpike:	includealigned	"artnem/SLZ Little Spikeball.nem",MMD_Is_SLZ
Nem_Fan:	includealigned	"artnem/SLZ Fan.nem",MMD_Is_SLZ
Nem_SlzWall:	includealigned	"artnem/SLZ Breakable Wall.nem",MMD_Is_SLZ
Nem_Pylon:	includealigned	"artnem/SLZ Pylon.nem",MMD_Is_SLZ
Nem_SlzSwing:	includealigned	"artnem/SLZ Swinging Platform.nem",MMD_Is_SLZ
Nem_SlzBlock:	includealigned	"artnem/SLZ 32x32 Block.nem",MMD_Is_SLZ
Nem_SlzCannon:	includealigned	"artnem/SLZ Cannon.nem",MMD_Is_SLZ
; ---------------------------------------------------------------------------
; Compressed graphics - SYZ stuff
; ---------------------------------------------------------------------------
Nem_Bumper:	includealigned	"artnem/SYZ Bumper.nem",MMD_Is_SYZ||MMD_Is_SS
Nem_SyzSpike2:	includealigned	"artnem/SYZ Small Spikeball.nem",MMD_Is_SYZ
Nem_LzSwitch:	includealigned	"artnem/Switch.nem",MMD_Is_SYZ||MMD_Is_LZ
Nem_SyzSpike1:	includealigned	"artnem/SYZ Large Spikeball.nem",MMD_Is_SYZ
; ---------------------------------------------------------------------------
; Compressed graphics - SBZ stuff
; ---------------------------------------------------------------------------
Nem_SbzWheel1:	includealigned	"artnem/SBZ Running Disc.nem",MMD_Is_SBZ
Nem_SbzWheel2:	includealigned	"artnem/SBZ Junction Wheel.nem",MMD_Is_SBZ
Nem_Cutter:	includealigned	"artnem/SBZ Pizza Cutter.nem",MMD_Is_SBZ
Nem_Stomper:	includealigned	"artnem/SBZ Stomper.nem",MMD_Is_SBZ
Nem_SpinPform:	includealigned	"artnem/SBZ Spinning Platform.nem",MMD_Is_SBZ
Nem_TrapDoor:	includealigned	"artnem/SBZ Trapdoor.nem",MMD_Is_SBZ
Nem_SbzFloor:	includealigned	"artnem/SBZ Collapsing Floor.nem",MMD_Is_SBZ
Nem_Electric:	includealigned	"artnem/SBZ Electrocuter.nem",MMD_Is_SBZ
Nem_SbzBlock:	includealigned	"artnem/SBZ Vanishing Block.nem",MMD_Is_SBZ
Nem_FlamePipe:	includealigned	"artnem/SBZ Flaming Pipe.nem",MMD_Is_SBZ
Nem_SbzDoor1:	includealigned	"artnem/SBZ Small Vertical Door.nem",MMD_Is_SBZ
Nem_SlideFloor:	includealigned	"artnem/SBZ Sliding Floor Trap.nem",MMD_Is_SBZ
Nem_SbzDoor2:	includealigned	"artnem/SBZ Large Horizontal Door.nem",MMD_Is_SBZ
Nem_Girder:	includealigned	"artnem/SBZ Crushing Girder.nem",MMD_Is_SBZ
; ---------------------------------------------------------------------------
; Compressed graphics - enemies
; ---------------------------------------------------------------------------
Nem_BallHog:	includealigned	"artnem/Enemy Ball Hog.nem",MMD_Is_SBZ
Nem_Crabmeat:	includealigned	"artnem/Enemy Crabmeat.nem",MMD_Is_GHZ||MMD_Is_SYZ
Nem_Buzz:	includealigned	"artnem/Enemy Buzz Bomber.nem",MMD_Is_GHZ||MMD_Is_MZ||MMD_Is_SYZ
Nem_Burrobot:	includealigned	"artnem/Enemy Burrobot.nem",MMD_Is_LZ
Nem_Chopper:	includealigned	"artnem/Enemy Chopper.nem",MMD_Is_GHZ
Nem_Jaws:	includealigned	"artnem/Enemy Jaws.nem",MMD_Is_LZ
Nem_Roller:	includealigned	"artnem/Enemy Roller.nem",MMD_Is_SYZ
Nem_Motobug:	includealigned	"artnem/Enemy Motobug.nem",MMD_Is_GHZ
Nem_Newtron:	includealigned	"artnem/Enemy Newtron.nem",MMD_Is_GHZ
Nem_Yadrin:		includealigned	"artnem/Enemy Yadrin.nem",MMD_Is_SYZ
Nem_Basaran:	includealigned	"artnem/Enemy Basaran.nem",MMD_Is_MZ
Nem_Bomb:	includealigned	"artnem/Enemy Bomb.nem",MMD_Is_SLZ
Nem_Orbinaut:	includealigned	"artnem/Enemy Orbinaut.nem",MMD_Is_LZ||MMD_Is_SLZ
Nem_Cater:	includealigned	"artnem/Enemy Caterkiller.nem",MMD_Is_MZ||MMD_Is_SYZ
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_TitleCard:	includealigned	"artnem/Title Cards.nem"
Nem_Hud:	includealigned	"artnem/HUD.nem"
Nem_Lives:	includealigned	"artnem/HUD - Life Counter Icon.nem",MMD_Is_Level
Nem_Ring:	includealigned	"artnem/Rings.nem"
Nem_Monitors:	includealigned	"artnem/Monitors.nem",MMD_Is_Level
Nem_Explode:	includealigned	"artnem/Explosion.nem",MMD_Is_Level
Nem_Points:	includealigned	"artnem/Points.nem"	; points from destroyed enemy or object,MMD_Is_Level
Nem_GameOver:	includealigned	"artnem/Game Over.nem"	; game over / time over,MMD_Is_Level
Nem_HSpring:	includealigned	"artnem/Spring Horizontal.nem",MMD_Is_Level
Nem_VSpring:	includealigned	"artnem/Spring Vertical.nem",MMD_Is_Level
Nem_SignPost:	includealigned	"artnem/Signpost.nem"	; end of level signpost,MMD_Is_Level
Nem_Lamp:	includealigned	"artnem/Lamppost.nem",MMD_Is_Level
Nem_BigFlash:	includealigned	"artnem/Giant Ring Flash.nem",~~MMD_Is_SBZ
Nem_Bonus:	includealigned	"artnem/Hidden Bonuses.nem" ; hidden bonuses at end of a level,MMD_Is_Level
; ---------------------------------------------------------------------------
; Compressed graphics - continue screen
; ---------------------------------------------------------------------------
Nem_ContSonic:	includealigned	"artnem/Continue Screen Sonic.nem",MMD_Is_Continue
Nem_MiniSonic:	includealigned	"artnem/Continue Screen Stuff.nem",MMD_Is_Continue
; ---------------------------------------------------------------------------
; Compressed graphics - animals
; ---------------------------------------------------------------------------
Nem_Rabbit:	includealigned	"artnem/Animal Rabbit.nem"
Nem_Chicken:	includealigned	"artnem/Animal Chicken.nem"
Nem_Penguin:	includealigned	"artnem/Animal Penguin.nem"
Nem_Seal:	includealigned	"artnem/Animal Seal.nem"
Nem_Pig:	includealigned	"artnem/Animal Pig.nem"
Nem_Flicky:	includealigned	"artnem/Animal Flicky.nem"
Nem_Squirrel:	includealigned	"artnem/Animal Squirrel.nem"
; ---------------------------------------------------------------------------
; Animated uncompressed graphics
; ---------------------------------------------------------------------------
Art_GhzWater:	includealigned	"artunc/GHZ Waterfall.bin",MMD_Is_GHZ||MMD_Is_Title||MMD_Is_Ending
Art_GhzFlower1:	includealigned	"artunc/GHZ Flower Large.bin",MMD_Is_GHZ||MMD_Is_Ending
Art_GhzFlower2:	includealigned	"artunc/GHZ Flower Small.bin",MMD_Is_GHZ||MMD_Is_Ending
Art_MzLava1:	includealigned	"artunc/MZ Lava Surface.bin",MMD_Is_MZ
Art_MzLava2:	includealigned	"artunc/MZ Lava.bin",MMD_Is_MZ
Art_MzTorch:	includealigned	"artunc/MZ Background Torch.bin",MMD_Is_MZ
Art_SbzSmoke:	includealigned	"artunc/SBZ Background Smoke.bin",MMD_Is_SBZ
Art_BigRing:	includealigned	"artunc/Giant Ring.bin",~~MMD_Is_SBZ
Eni_JapNames:	includealigned	"tilemaps/Hidden Japanese Credits.eni",MMD_Is_Title
Nem_JapNames:	includealigned	"artnem/Hidden Japanese Credits.nem",MMD_Is_Title

Map_SSWalls:	includealigned	"_maps/SS Walls.asm",MMD_Is_SS

; ---------------------------------------------------------------------------
; Compressed graphics - special stage
; ---------------------------------------------------------------------------
Nem_SSWalls:	includealigned	"artnem/Special Walls.nem",MMD_Is_SS
Eni_SSBg1:	includealigned	"tilemaps/SS Background 1.eni",MMD_Is_SS
Nem_SSBgFish:	includealigned	"artnem/Special Birds & Fish.nem",MMD_Is_SS
Eni_SSBg2:	includealigned	"tilemaps/SS Background 2.eni",MMD_Is_SS
Nem_SSBgCloud:	includealigned	"artnem/Special Clouds.nem",MMD_Is_SS
Nem_SSGOAL:	includealigned	"artnem/Special GOAL.nem",MMD_Is_SS
Nem_SSRBlock:	includealigned	"artnem/Special R.nem",MMD_Is_SS
Nem_SS1UpBlock:	includealigned	"artnem/Special 1UP.nem",MMD_Is_SS
Nem_SSEmStars:	includealigned	"artnem/Special Emerald Twinkle.nem",MMD_Is_SS
Nem_SSRedWhite:	includealigned	"artnem/Special Red-White.nem",MMD_Is_SS
Nem_SSZone1:	includealigned	"artnem/Special ZONE1.nem",MMD_Is_SS
Nem_SSZone2:	includealigned	"artnem/Special ZONE2.nem",MMD_Is_SS
Nem_SSZone3:	includealigned	"artnem/Special ZONE3.nem",MMD_Is_SS
Nem_SSZone4:	includealigned	"artnem/Special ZONE4.nem",MMD_Is_SS
Nem_SSZone5:	includealigned	"artnem/Special ZONE5.nem",MMD_Is_SS
Nem_SSZone6:	includealigned	"artnem/Special ZONE6.nem",MMD_Is_SS
Nem_SSUpDown:	includealigned	"artnem/Special UP-DOWN.nem",MMD_Is_SS
Nem_SSEmerald:	includealigned	"artnem/Special Emeralds.nem",MMD_Is_SS
Nem_SSGhost:	includealigned	"artnem/Special Ghost.nem",MMD_Is_SS
Nem_SSWBlock:	includealigned	"artnem/Special W.nem",MMD_Is_SS
Nem_SSGlass:	includealigned	"artnem/Special Glass.nem",MMD_Is_SS
Nem_ResultEm:	includealigned	"artnem/Special Result Emeralds.nem",MMD_Is_SS

; ---------------------------------------------------------------------------
; Compressed graphics - bosses and ending sequence
; ---------------------------------------------------------------------------
Nem_Eggman:	includealigned	"artnem/Boss - Main.nem",MMD_Is_Level
Nem_Weapons:	includealigned	"artnem/Boss - Weapons.nem",MMD_Is_Level
Nem_Prison:	includealigned	"artnem/Prison Capsule.nem",~~MMD_Is_SBZ
Nem_Sbz2Eggman:	includealigned	"artnem/Boss - Eggman in SBZ2 & FZ.nem",MMD_Is_SBZ
Nem_FzBoss:	includealigned	"artnem/Boss - Final Zone.nem",MMD_Is_SBZ
Nem_FzEggman:	includealigned	"artnem/Boss - Eggman after FZ Fight.nem",MMD_Is_SBZ
Nem_Exhaust:	includealigned	"artnem/Boss - Exhaust Flame.nem",MMD_Is_Level
Nem_EndEm:	includealigned	"artnem/Ending - Emeralds.nem",MMD_Is_Ending
Nem_EndSonic:	includealigned	"artnem/Ending - Sonic.nem",MMD_Is_Ending
Nem_TryAgain:	includealigned	"artnem/Ending - Try Again.nem",MMD_Is_Ending
Nem_EndEggman:	includealigned	"artnem/Unused - Eggman Ending.nem"
Kos_EndFlowers:	includealigned	"artkos/Flowers at Ending.kos",MMD_Is_Ending
Nem_EndFlower:	includealigned	"artnem/Ending - Flowers.nem",MMD_Is_Ending
Nem_CreditText:	includealigned	"artnem/Ending - Credits.nem",MMD_Is_Title||MMD_Is_Credits
Nem_EndStH:	includealigned	"artnem/Ending - StH Logo.nem",MMD_Is_Ending

; ---------------------------------------------------------------------------
; Uncompressed graphics	- Sonic
; ---------------------------------------------------------------------------
Art_Sonic:	includealigned	"artunc/Sonic.bin",MMD_Has_Sonic