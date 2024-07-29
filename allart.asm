Art_Text:	binclude	"artunc/menutext.bin" ; text used in level select and debug mode
Art_Text_End:	even
Art_Hud:	binclude	"artunc/HUD Numbers.bin" ; 8x16 pixel numbers on HUD
		even
Art_LivesNums:	binclude	"artunc/Lives Counter Numbers.bin" ; 8x8 pixel numbers on lives counter
		even
; ---------------------------------------------------------------------------
; Uncompressed graphics	- Sonic
; ---------------------------------------------------------------------------
Art_Sonic:	binclude	"artunc/Sonic.bin"	; Sonic
		even
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
		if Revision=0
Nem_Smoke:	binclude	"artnem/Unused - Smoke.nem"
		even
Nem_SyzSparkle:	binclude	"artnem/Unused - SYZ Sparkles.nem"
		even
		endif
Nem_Shield:	binclude	"artnem/Shield.nem"
		even
Nem_Stars:	binclude	"artnem/Invincibility Stars.nem"
		even
		if Revision=0
Nem_LzSonic:	binclude	"artnem/Unused - LZ Sonic.nem" ; Sonic holding his breath
		even
Nem_UnkFire:	binclude	"artnem/Unused - Fireball.nem" ; unused fireball
		even
Nem_Warp:	binclude	"artnem/Unused - SStage Flash.nem" ; entry to special stage flash
		even
Nem_Goggle:	binclude	"artnem/Unused - Goggles.nem" ; unused goggles
		even
		endif

Map_SSWalls:	include	"_maps/SS Walls.asm"

; ---------------------------------------------------------------------------
; Compressed graphics - special stage
; ---------------------------------------------------------------------------
Nem_SSWalls:	binclude	"artnem/Special Walls.nem" ; special stage walls
		even
Eni_SSBg1:	binclude	"tilemaps/SS Background 1.eni" ; special stage background (mappings)
		even
Nem_SSBgFish:	binclude	"artnem/Special Birds & Fish.nem" ; special stage birds and fish background
		even
Eni_SSBg2:	binclude	"tilemaps/SS Background 2.eni" ; special stage background (mappings)
		even
Nem_SSBgCloud:	binclude	"artnem/Special Clouds.nem" ; special stage clouds background
		even
Nem_SSGOAL:	binclude	"artnem/Special GOAL.nem" ; special stage GOAL block
		even
Nem_SSRBlock:	binclude	"artnem/Special R.nem"	; special stage R block
		even
Nem_SS1UpBlock:	binclude	"artnem/Special 1UP.nem" ; special stage 1UP block
		even
Nem_SSEmStars:	binclude	"artnem/Special Emerald Twinkle.nem" ; special stage stars from a collected emerald
		even
Nem_SSRedWhite:	binclude	"artnem/Special Red-White.nem" ; special stage red/white block
		even
Nem_SSZone1:	binclude	"artnem/Special ZONE1.nem" ; special stage ZONE1 block
		even
Nem_SSZone2:	binclude	"artnem/Special ZONE2.nem" ; ZONE2 block
		even
Nem_SSZone3:	binclude	"artnem/Special ZONE3.nem" ; ZONE3 block
		even
Nem_SSZone4:	binclude	"artnem/Special ZONE4.nem" ; ZONE4 block
		even
Nem_SSZone5:	binclude	"artnem/Special ZONE5.nem" ; ZONE5 block
		even
Nem_SSZone6:	binclude	"artnem/Special ZONE6.nem" ; ZONE6 block
		even
Nem_SSUpDown:	binclude	"artnem/Special UP-DOWN.nem" ; special stage UP/DOWN block
		even
Nem_SSEmerald:	binclude	"artnem/Special Emeralds.nem" ; special stage chaos emeralds
		even
Nem_SSGhost:	binclude	"artnem/Special Ghost.nem" ; special stage ghost block
		even
Nem_SSWBlock:	binclude	"artnem/Special W.nem"	; special stage W block
		even
Nem_SSGlass:	binclude	"artnem/Special Glass.nem" ; special stage destroyable glass block
		even
Nem_ResultEm:	binclude	"artnem/Special Result Emeralds.nem" ; chaos emeralds on special stage results screen
		even
; ---------------------------------------------------------------------------
; Compressed graphics - GHZ stuff
; ---------------------------------------------------------------------------
Nem_Stalk:	binclude	"artnem/GHZ Flower Stalk.nem"
		even
Nem_Swing:	binclude	"artnem/GHZ Swinging Platform.nem"
		even
Nem_Bridge:	binclude	"artnem/GHZ Bridge.nem"
		even
Nem_GhzUnkBlock:binclude	"artnem/Unused - GHZ Block.nem"
		even
Nem_Ball:	binclude	"artnem/GHZ Giant Ball.nem"
		even
Nem_Spikes:	binclude	"artnem/Spikes.nem"
		even
Nem_GhzLog:	binclude	"artnem/Unused - GHZ Log.nem"
		even
Nem_SpikePole:	binclude	"artnem/GHZ Spiked Log.nem"
		even
Nem_PplRock:	binclude	"artnem/GHZ Purple Rock.nem"
		even
Nem_GhzWall1:	binclude	"artnem/GHZ Breakable Wall.nem"
		even
Nem_GhzWall2:	binclude	"artnem/GHZ Edge Wall.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - LZ stuff
; ---------------------------------------------------------------------------
Nem_Water:	binclude	"artnem/LZ Water Surface.nem"
		even
Nem_Splash:	binclude	"artnem/LZ Water & Splashes.nem"
		even
Nem_LzSpikeBall:binclude	"artnem/LZ Spiked Ball & Chain.nem"
		even
Nem_FlapDoor:	binclude	"artnem/LZ Flapping Door.nem"
		even
Nem_Bubbles:	binclude	"artnem/LZ Bubbles & Countdown.nem"
		even
Nem_LzBlock3:	binclude	"artnem/LZ 32x16 Block.nem"
		even
Nem_LzDoor1:	binclude	"artnem/LZ Vertical Door.nem"
		even
Nem_Harpoon:	binclude	"artnem/LZ Harpoon.nem"
		even
Nem_LzPole:	binclude	"artnem/LZ Breakable Pole.nem"
		even
Nem_LzDoor2:	binclude	"artnem/LZ Horizontal Door.nem"
		even
Nem_LzWheel:	binclude	"artnem/LZ Wheel.nem"
		even
Nem_Gargoyle:	binclude	"artnem/LZ Gargoyle & Fireball.nem"
		even
Nem_LzBlock2:	binclude	"artnem/LZ Blocks.nem"
		even
Nem_LzPlatfm:	binclude	"artnem/LZ Rising Platform.nem"
		even
Nem_Cork:	binclude	"artnem/LZ Cork.nem"
		even
Nem_LzBlock1:	binclude	"artnem/LZ 32x32 Block.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - MZ stuff
; ---------------------------------------------------------------------------
Nem_MzMetal:	binclude	"artnem/MZ Metal Blocks.nem"
		even
Nem_MzSwitch:	binclude	"artnem/MZ Switch.nem"
		even
Nem_MzGlass:	binclude	"artnem/MZ Green Glass Block.nem"
		even
Nem_UnkGrass:	binclude	"artnem/Unused - Grass.nem"
		even
Nem_MzFire:	binclude	"artnem/Fireballs.nem"
		even
Nem_Lava:	binclude	"artnem/MZ Lava.nem"
		even
Nem_MzBlock:	binclude	"artnem/MZ Green Pushable Block.nem"
		even
Nem_MzUnkBlock:	binclude	"artnem/Unused - MZ Background.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - SLZ stuff
; ---------------------------------------------------------------------------
Nem_Seesaw:	binclude	"artnem/SLZ Seesaw.nem"
		even
Nem_SlzSpike:	binclude	"artnem/SLZ Little Spikeball.nem"
		even
Nem_Fan:	binclude	"artnem/SLZ Fan.nem"
		even
Nem_SlzWall:	binclude	"artnem/SLZ Breakable Wall.nem"
		even
Nem_Pylon:	binclude	"artnem/SLZ Pylon.nem"
		even
Nem_SlzSwing:	binclude	"artnem/SLZ Swinging Platform.nem"
		even
Nem_SlzBlock:	binclude	"artnem/SLZ 32x32 Block.nem"
		even
Nem_SlzCannon:	binclude	"artnem/SLZ Cannon.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - SYZ stuff
; ---------------------------------------------------------------------------
Nem_Bumper:	binclude	"artnem/SYZ Bumper.nem"
		even
Nem_SyzSpike2:	binclude	"artnem/SYZ Small Spikeball.nem"
		even
Nem_LzSwitch:	binclude	"artnem/Switch.nem"
		even
Nem_SyzSpike1:	binclude	"artnem/SYZ Large Spikeball.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - SBZ stuff
; ---------------------------------------------------------------------------
Nem_SbzWheel1:	binclude	"artnem/SBZ Running Disc.nem"
		even
Nem_SbzWheel2:	binclude	"artnem/SBZ Junction Wheel.nem"
		even
Nem_Cutter:	binclude	"artnem/SBZ Pizza Cutter.nem"
		even
Nem_Stomper:	binclude	"artnem/SBZ Stomper.nem"
		even
Nem_SpinPform:	binclude	"artnem/SBZ Spinning Platform.nem"
		even
Nem_TrapDoor:	binclude	"artnem/SBZ Trapdoor.nem"
		even
Nem_SbzFloor:	binclude	"artnem/SBZ Collapsing Floor.nem"
		even
Nem_Electric:	binclude	"artnem/SBZ Electrocuter.nem"
		even
Nem_SbzBlock:	binclude	"artnem/SBZ Vanishing Block.nem"
		even
Nem_FlamePipe:	binclude	"artnem/SBZ Flaming Pipe.nem"
		even
Nem_SbzDoor1:	binclude	"artnem/SBZ Small Vertical Door.nem"
		even
Nem_SlideFloor:	binclude	"artnem/SBZ Sliding Floor Trap.nem"
		even
Nem_SbzDoor2:	binclude	"artnem/SBZ Large Horizontal Door.nem"
		even
Nem_Girder:	binclude	"artnem/SBZ Crushing Girder.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - enemies
; ---------------------------------------------------------------------------
Nem_BallHog:	binclude	"artnem/Enemy Ball Hog.nem"
		even
Nem_Crabmeat:	binclude	"artnem/Enemy Crabmeat.nem"
		even
Nem_Buzz:	binclude	"artnem/Enemy Buzz Bomber.nem"
		even
Nem_UnkExplode:	binclude	"artnem/Unused - Explosion.nem"
		even
Nem_Burrobot:	binclude	"artnem/Enemy Burrobot.nem"
		even
Nem_Chopper:	binclude	"artnem/Enemy Chopper.nem"
		even
Nem_Jaws:	binclude	"artnem/Enemy Jaws.nem"
		even
Nem_Roller:	binclude	"artnem/Enemy Roller.nem"
		even
Nem_Motobug:	binclude	"artnem/Enemy Motobug.nem"
		even
Nem_Newtron:	binclude	"artnem/Enemy Newtron.nem"
		even
Nem_Yadrin:	binclude	"artnem/Enemy Yadrin.nem"
		even
Nem_Basaran:	binclude	"artnem/Enemy Basaran.nem"
		even
Nem_Splats:	binclude	"artnem/Enemy Splats.nem"
		even
Nem_Bomb:	binclude	"artnem/Enemy Bomb.nem"
		even
Nem_Orbinaut:	binclude	"artnem/Enemy Orbinaut.nem"
		even
Nem_Cater:	binclude	"artnem/Enemy Caterkiller.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_TitleCard:	binclude	"artnem/Title Cards.nem"
		even
Nem_Hud:	binclude	"artnem/HUD.nem"	; HUD (rings, time, score)
		even
Nem_Lives:	binclude	"artnem/HUD - Life Counter Icon.nem"
		even
Nem_Ring:	binclude	"artnem/Rings.nem"
		even
Nem_Monitors:	binclude	"artnem/Monitors.nem"
		even
Nem_Explode:	binclude	"artnem/Explosion.nem"
		even
Nem_Points:	binclude	"artnem/Points.nem"	; points from destroyed enemy or object
		even
Nem_GameOver:	binclude	"artnem/Game Over.nem"	; game over / time over
		even
Nem_HSpring:	binclude	"artnem/Spring Horizontal.nem"
		even
Nem_VSpring:	binclude	"artnem/Spring Vertical.nem"
		even
Nem_SignPost:	binclude	"artnem/Signpost.nem"	; end of level signpost
		even
Nem_Lamp:	binclude	"artnem/Lamppost.nem"
		even
Nem_BigFlash:	binclude	"artnem/Giant Ring Flash.nem"
		even
Nem_Bonus:	binclude	"artnem/Hidden Bonuses.nem" ; hidden bonuses at end of a level
		even
; ---------------------------------------------------------------------------
; Compressed graphics - continue screen
; ---------------------------------------------------------------------------
Nem_ContSonic:	binclude	"artnem/Continue Screen Sonic.nem"
		even
Nem_MiniSonic:	binclude	"artnem/Continue Screen Stuff.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - animals
; ---------------------------------------------------------------------------
Nem_Rabbit:	binclude	"artnem/Animal Rabbit.nem"
		even
Nem_Chicken:	binclude	"artnem/Animal Chicken.nem"
		even
Nem_Penguin:	binclude	"artnem/Animal Penguin.nem"
		even
Nem_Seal:	binclude	"artnem/Animal Seal.nem"
		even
Nem_Pig:	binclude	"artnem/Animal Pig.nem"
		even
Nem_Flicky:	binclude	"artnem/Animal Flicky.nem"
		even
Nem_Squirrel:	binclude	"artnem/Animal Squirrel.nem"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - primary patterns and block mappings
; ---------------------------------------------------------------------------
Blk16_GHZ:	binclude	"map16/GHZ.eni"
		even
Nem_GHZ_1st:	binclude	"artnem/8x8 - GHZ1.nem"	; GHZ primary patterns
		even
Nem_GHZ_2nd:	binclude	"artnem/8x8 - GHZ2.nem"	; GHZ secondary patterns
		even
Blk256_GHZ:	binclude	"map256/GHZ.kos"
		even
Blk16_LZ:	binclude	"map16/LZ.eni"
		even
Nem_LZ:		binclude	"artnem/8x8 - LZ.nem"	; LZ primary patterns
		even
Blk256_LZ:	binclude	"map256/LZ.kos"
		even
Blk16_MZ:	binclude	"map16/MZ.eni"
		even
Nem_MZ:		binclude	"artnem/8x8 - MZ.nem"	; MZ primary patterns
		even
Blk256_MZ:	if Revision=0
		binclude	"map256/MZ.kos"
		else
		binclude	"map256/MZ (JP1).kos"
		endif
		even
Blk16_SLZ:	binclude	"map16/SLZ.eni"
		even
Nem_SLZ:	binclude	"artnem/8x8 - SLZ.nem"	; SLZ primary patterns
		even
Blk256_SLZ:	binclude	"map256/SLZ.kos"
		even
Blk16_SYZ:	binclude	"map16/SYZ.eni"
		even
Nem_SYZ:	binclude	"artnem/8x8 - SYZ.nem"	; SYZ primary patterns
		even
Blk256_SYZ:	binclude	"map256/SYZ.kos"
		even
Blk16_SBZ:	binclude	"map16/SBZ.eni"
		even
Nem_SBZ:	binclude	"artnem/8x8 - SBZ.nem"	; SBZ primary patterns
		even
Blk256_SBZ:	if Revision=0
		binclude	"map256/SBZ.kos"
		else
		binclude	"map256/SBZ (JP1).kos"
		endif
		even
; ---------------------------------------------------------------------------
; Compressed graphics - bosses and ending sequence
; ---------------------------------------------------------------------------
Nem_Eggman:	binclude	"artnem/Boss - Main.nem"
		even
Nem_Weapons:	binclude	"artnem/Boss - Weapons.nem"
		even
Nem_Prison:	binclude	"artnem/Prison Capsule.nem"
		even
Nem_Sbz2Eggman:	binclude	"artnem/Boss - Eggman in SBZ2 & FZ.nem"
		even
Nem_FzBoss:	binclude	"artnem/Boss - Final Zone.nem"
		even
Nem_FzEggman:	binclude	"artnem/Boss - Eggman after FZ Fight.nem"
		even
Nem_Exhaust:	binclude	"artnem/Boss - Exhaust Flame.nem"
		even
Nem_EndEm:	binclude	"artnem/Ending - Emeralds.nem"
		even
Nem_EndSonic:	binclude	"artnem/Ending - Sonic.nem"
		even
Nem_TryAgain:	binclude	"artnem/Ending - Try Again.nem"
		even
Nem_EndEggman:	if Revision=0
		binclude	"artnem/Unused - Eggman Ending.nem"
		endif
		even
Kos_EndFlowers:	binclude	"artkos/Flowers at Ending.kos" ; ending sequence animated flowers
		even
Nem_EndFlower:	binclude	"artnem/Ending - Flowers.nem"
		even
Nem_CreditText:	binclude	"artnem/Ending - Credits.nem"
		even
Nem_EndStH:	binclude	"artnem/Ending - StH Logo.nem"
		even
; ---------------------------------------------------------------------------
; Animated uncompressed graphics
; ---------------------------------------------------------------------------
Art_GhzWater:	binclude	"artunc/GHZ Waterfall.bin"
		even
Art_GhzFlower1:	binclude	"artunc/GHZ Flower Large.bin"
		even
Art_GhzFlower2:	binclude	"artunc/GHZ Flower Small.bin"
		even
Art_MzLava1:	binclude	"artunc/MZ Lava Surface.bin"
		even
Art_MzLava2:	binclude	"artunc/MZ Lava.bin"
		even
Art_MzTorch:	binclude	"artunc/MZ Background Torch.bin"
		even
Art_SbzSmoke:	binclude	"artunc/SBZ Background Smoke.bin"
		even
Art_BigRing:	binclude	"artunc/Giant Ring.bin"
		even
		if Revision=0
Nem_SegaLogo:	binclude	"artnem/Sega Logo.nem"	; large Sega logo
		even
Eni_SegaLogo:	binclude	"tilemaps/Sega Logo.eni" ; large Sega logo (mappings)
		even
		else
		rept $300
			dc.b	$FF
		endm
Nem_SegaLogo:	binclude	"artnem/Sega Logo (JP1).nem" ; large Sega logo
			even
Eni_SegaLogo:	binclude	"tilemaps/Sega Logo (JP1).eni" ; large Sega logo (mappings)
			even
		endif
Eni_Title:	binclude	"tilemaps/Title Screen.eni" ; title screen foreground (mappings)
		even
Nem_TitleFg:	binclude	"artnem/Title Screen Foreground.nem"
		even
Nem_TitleSonic:	binclude	"artnem/Title Screen Sonic.nem"
		even
Nem_TitleTM:	binclude	"artnem/Title Screen TM.nem"
		even
Eni_JapNames:	binclude	"tilemaps/Hidden Japanese Credits.eni" ; Japanese credits (mappings)
		even
Nem_JapNames:	binclude	"artnem/Hidden Japanese Credits.nem"
		even