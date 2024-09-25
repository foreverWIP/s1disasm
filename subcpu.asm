; -------------------------------------------------------------------------
; Sonic CD Disassembly
; By Ralakimus 2021
; -------------------------------------------------------------------------
; Sub CPU definitions
; -------------------------------------------------------------------------

SUBCPU		EQU	1

; -------------------------------------------------------------------------
; Addresses
; -------------------------------------------------------------------------

; PRG-RAM
PRGRAM		EQU	$000000			; PRG-RAM start
PRGRAME		EQU	$080000			; PRG-RAM end
PRGRAMS		EQU	PRGRAME-PRGRAM		; PRG-RAM size
SPSTART		EQU	PRGRAM+$6000		; System program start

; Word RAM
WORDRAM2M	EQU	$080000			; Word RAM start (2M)
WORDRAM2ME	EQU	$0C0000			; Word RAM end (2M)
WORDRAM2MS	EQU	WORDRAM2ME-WORDRAM2M	; Word RAM size (2M)
WORDRAM1M	EQU	$0C0000			; Word RAM start (1M/1M)
WORDRAM1ME	EQU	$0E0000			; Word RAM end (1M/1M)
WORDRAM1MS	EQU	WORDRAM1ME-WORDRAM1M	; Word RAM size (1M/1M)

; PCM registers
PCMREGS		EQU	$FF0000			; PCM chip base
PCMENV		EQU	PCMREGS+($0000*2+1)	; Volume
PCMPAN		EQU	PCMREGS+($0001*2+1)	; Pan
PCMFDL		EQU	PCMREGS+($0002*2+1)	; Frequency (low)
PCMFDH		EQU	PCMREGS+($0003*2+1)	; Frequency (high)
PCMLSL		EQU	PCMREGS+($0004*2+1)	; Wave memory stop address (low)
PCMLSH		EQU	PCMREGS+($0005*2+1)	; Wave memory stop address (high)
PCMST		EQU	PCMREGS+($0006*2+1)	; Wave memory start address
PCMCTRL		EQU	PCMREGS+($0007*2+1)	; Control
PCMONOFF	EQU	PCMREGS+($0008*2+1)	; On/Off
PCMADDR		EQU	PCMREGS+($0010*2+1)	; Wave address
PCMADDR1L	EQU	PCMADDR			; PCM1 address (low)
PCMADDR1H	EQU	PCMADDR+2		; PCM1 address (high)
PCMADDR2L	EQU	PCMADDR+4		; PCM2 address (low)
PCMADDR2H	EQU	PCMADDR+6		; PCM2 address (high)
PCMADDR3L	EQU	PCMADDR+8		; PCM2 address (low)
PCMADDR3H	EQU	PCMADDR+$A		; PCM2 address (high)
PCMADDR4L	EQU	PCMADDR+$C		; PCM2 address (low)
PCMADDR4H	EQU	PCMADDR+$E		; PCM2 address (high)
PCMADDR5L	EQU	PCMADDR+$10		; PCM2 address (low)
PCMADDR5H	EQU	PCMADDR+$12		; PCM2 address (high)
PCMADDR6L	EQU	PCMADDR+$14		; PCM2 address (low)
PCMADDR6H	EQU	PCMADDR+$16		; PCM2 address (high)
PCMADDR7L	EQU	PCMADDR+$18		; PCM2 address (low)
PCMADDR7H	EQU	PCMADDR+$1A		; PCM2 address (high)
PCMADDR8L	EQU	PCMADDR+$1C		; PCM2 address (low)
PCMADDR8H	EQU	PCMADDR+$1E		; PCM2 address (high)
PCMWAVE		EQU	PCMREGS+($1000*2+1)	; Wave RAM

; Gate array
GATEARRAY	EQU	$FFFF8000		; Gate array base
GALEDCTRL	EQU	GATEARRAY+$0000		; LED control
GACDRESET	EQU	GATEARRAY+$0001		; Reset
GAWRPROTECT	EQU	GATEARRAY+$0002		; Write protection
GAMEMMODE	EQU	GATEARRAY+$0003		; Memory mode
GACDCDEVICE	EQU	GATEARRAY+$0004		; CDC device destination
GACDCCRS0	EQU	GATEARRAY+$0005		; CDC register address
GACDCCRS1	EQU	GATEARRAY+$0007		; CDC register data
GACDCHOST	EQU	GATEARRAY+$0008		; 16-bit CDC data to host
GADMAADDR	EQU	GATEARRAY+$000A		; DMA offset into destination area
GASTOPWATCH	EQU	GATEARRAY+$000C		; Stopwatch
GACOMFLAGS	EQU	GATEARRAY+$000E		; Communication flags
GAMAINFLAG	EQU	GATEARRAY+$000E		; Main CPU communication flag
GASUBFLAG	EQU	GATEARRAY+$000F		; Sub CPU communication flag
GACOMCMDS	EQU	GATEARRAY+$0010		; Communication commands
GACOMCMD0	EQU	GATEARRAY+$0010		; Communication command 0
GACOMCMD1	EQU	GATEARRAY+$0011		; Communication command 1
GACOMCMD2	EQU	GATEARRAY+$0012		; Communication command 2
GACOMCMD3	EQU	GATEARRAY+$0013		; Communication command 3
GACOMCMD4	EQU	GATEARRAY+$0014		; Communication command 4
GACOMCMD5	EQU	GATEARRAY+$0015		; Communication command 5
GACOMCMD6	EQU	GATEARRAY+$0016		; Communication command 6
GACOMCMD7	EQU	GATEARRAY+$0017		; Communication command 7
GACOMCMD8	EQU	GATEARRAY+$0018		; Communication command 8
GACOMCMD9	EQU	GATEARRAY+$0019		; Communication command 9
GACOMCMDA	EQU	GATEARRAY+$001A		; Communication command A
GACOMCMDB	EQU	GATEARRAY+$001B		; Communication command B
GACOMCMDC	EQU	GATEARRAY+$001C		; Communication command C
GACOMCMDD	EQU	GATEARRAY+$001D		; Communication command D
GACOMCMDE	EQU	GATEARRAY+$001E		; Communication command E
GACOMCMDF	EQU	GATEARRAY+$001F		; Communication command F
GACOMSTATS	EQU	GATEARRAY+$0020		; Communication statuses
GACOMSTAT0	EQU	GATEARRAY+$0020		; Communication status 0
GACOMSTAT1	EQU	GATEARRAY+$0021		; Communication status 1
GACOMSTAT2	EQU	GATEARRAY+$0022		; Communication status 2
GACOMSTAT3	EQU	GATEARRAY+$0023		; Communication status 3
GACOMSTAT4	EQU	GATEARRAY+$0024		; Communication status 4
GACOMSTAT5	EQU	GATEARRAY+$0025		; Communication status 5
GACOMSTAT6	EQU	GATEARRAY+$0026		; Communication status 6
GACOMSTAT7	EQU	GATEARRAY+$0027		; Communication status 7
GACOMSTAT8	EQU	GATEARRAY+$0028		; Communication status 8
GACOMSTAT9	EQU	GATEARRAY+$0029		; Communication status 9
GACOMSTATA	EQU	GATEARRAY+$002A		; Communication status A
GACOMSTATB	EQU	GATEARRAY+$002B		; Communication status B
GACOMSTATC	EQU	GATEARRAY+$002C		; Communication status C
GACOMSTATD	EQU	GATEARRAY+$002D		; Communication status D
GACOMSTATE	EQU	GATEARRAY+$002E		; Communication status E
GACOMSTATF	EQU	GATEARRAY+$002F		; Communication status F
GAIRQ3TIME	EQU	GATEARRAY+$0031 	; Interrupt 3 timer
GAIRQMASK	EQU	GATEARRAY+$0033 	; Interrupt mask
GACDFADER	EQU	GATEARRAY+$0034 	; Fader control/Spindle speed
GACDDTYPE	EQU	GATEARRAY+$0036 	; CDD data type
GACDDCTRL	EQU	GATEARRAY+$0037 	; CDD control
GACDDCOM	EQU	GATEARRAY+$0038 	; CDD communication
GACDDSTAT0	EQU	GATEARRAY+$0038 	; CDD receive status 0
GACDDSTAT1	EQU	GATEARRAY+$0039 	; CDD receive status 1
GACDDSTAT2	EQU	GATEARRAY+$003A 	; CDD receive status 2
GACDDSTAT3	EQU	GATEARRAY+$003B 	; CDD receive status 3
GACDDSTAT4	EQU	GATEARRAY+$003C 	; CDD receive status 4
GACDDSTAT5	EQU	GATEARRAY+$003D 	; CDD receive status 5
GACDDSTAT6	EQU	GATEARRAY+$003E 	; CDD receive status 6
GACDDSTAT7	EQU	GATEARRAY+$003F 	; CDD receive status 7
GACDDSTAT8	EQU	GATEARRAY+$0040 	; CDD receive status 8
GACDDSTAT9	EQU	GATEARRAY+$0041 	; CDD receive status 9
GACDDCMD0	EQU	GATEARRAY+$0042 	; CDD transfer command 0
GACDDCMD1	EQU	GATEARRAY+$0043 	; CDD transfer command 1
GACDDCMD2	EQU	GATEARRAY+$0044 	; CDD transfer command 2
GACDDCMD3	EQU	GATEARRAY+$0045 	; CDD transfer command 3
GACDDCMD4	EQU	GATEARRAY+$0046 	; CDD transfer command 4
GACDDCMD5	EQU	GATEARRAY+$0047 	; CDD transfer command 5
GACDDCMD6	EQU	GATEARRAY+$0048 	; CDD transfer command 6
GACDDCMD7	EQU	GATEARRAY+$0049 	; CDD transfer command 7
GACDDCMD8	EQU	GATEARRAY+$004A 	; CDD transfer command 8
GACDDCMD9	EQU	GATEARRAY+$004B 	; CDD transfer command 9
GAFONTCOLOR	EQU	GATEARRAY+$004C 	; Font color
GAFONTBIT	EQU	GATEARRAY+$004E 	; Font bit
GAFONTDATA	EQU	GATEARRAY+$0056 	; Font data
GASTAMPSIZE	EQU	GATEARRAY+$0058 	; Stamp size/Map size
GASTAMPMAP	EQU	GATEARRAY+$005A 	; Stamp map base address
GAIMGVCELL	EQU	GATEARRAY+$005C 	; Image buffer height in tiles
GAIMGSTART	EQU	GATEARRAY+$005E 	; Image buffer start address
GAIMGOFFSET	EQU	GATEARRAY+$0060 	; Image buffer offset
GAIMGHDOT	EQU	GATEARRAY+$0062 	; Image buffer width in pixels
GAIMGVDOT	EQU	GATEARRAY+$0064 	; Image buffer height in pixels
GAIMGTRACE	EQU	GATEARRAY+$0066 	; Trace vector base address
GASUBADDR	EQU	GATEARRAY+$0068 	; Subcode top address
GASUBCODE	EQU	GATEARRAY+$0100 	; 64 word subcode buffer
GASUBIMAGE	EQU	GATEARRAY+$0180 	; Image of subcode buffer

; -------------------------------------------------------------------------
; BIOS function codes
; -------------------------------------------------------------------------

MSCSTOP		EQU	$02
MSCPAUSEON	EQU	$03
MSCPAUSEOFF	EQU	$04
MSCSCANFF	EQU	$05
MSCSCANFR	EQU	$06
MSCSCANOFF	EQU	$07

ROMPAUSEON	EQU	$08
ROMPAUSEOFF	EQU	$09

DRVOPEN		EQU	$0A
DRVINIT		EQU	$10

MSCPLAY		EQU	$11
MSCPLAY1	EQU	$12
MSCPLAYR	EQU	$13
MSCPLAYT	EQU	$14
MSCSEEK		EQU	$15
MSCSEEKT	EQU	$16

ROMREAD		EQU	$17
ROMSEEK		EQU	$18

MSCSEEK1	EQU	$19
TESTENTRY	EQU	$1E
TESTENTRYLOOP	EQU	$1F

ROMREADN	EQU	$20
ROMREADE	EQU	$21

CDBCHK		EQU	$80
CDBSTAT		EQU	$81
CDBTOCWRITE	EQU	$82
CDBTOCREAD	EQU	$83
CDBPAUSE	EQU	$84

FDRSET		EQU	$85
FDRCHG		EQU	$86

CDCSTART	EQU	$87
CDCSTARTP	EQU	$88
CDCSTOP		EQU	$89
CDCSTAT		EQU	$8A
CDCREAD		EQU	$8B
CDCTRN		EQU	$8C
CDCACK		EQU	$8D

SCDINIT		EQU	$8E
SCDSTART	EQU	$8F
SCDSTOP		EQU	$90
SCDSTAT		EQU	$91
SCDREAD		EQU	$92
SCDPQ		EQU	$93
SCDPQL		EQU	$94

LEDSET		EQU	$95

CDCSETMODE	EQU	$96

WONDERREQ	EQU	$97
WONDERCHK	EQU	$98

CBTINIT		EQU	$00
CBTINT		EQU	$01
CBTOPENDISC	EQU	$02
CBTOPENSTAT	EQU	$03
CBTCHKDISC	EQU	$04
CBTCHKSTAT	EQU	$05
CBTIPDISC	EQU	$06
CBTIPSTAT	EQU	$07
CBTSPDISC	EQU	$08
CBTSPSTAT	EQU	$09

BRMINIT		EQU	$00
BRMSTAT		EQU	$01
BRMSERCH	EQU	$02
BRMREAD		EQU	$03
BRMWRITE	EQU	$04
BRMDEL		EQU	$05
BRMFORMAT	EQU	$06
BRMDIR		EQU	$07
BRMVERIFY	EQU	$08

; -------------------------------------------------------------------------
; BIOS entry points
; -------------------------------------------------------------------------

_USERCALL0	EQU	$005F28
_USERCALL1	EQU	$005F2E
_USERCALL2	EQU	$005F34
_USERCALL3	EQU	$005F3A
_USERMODE	EQU	$005EA6
_WAITVSYNC	EQU	$005F10

; -------------------------------------------------------------------------
