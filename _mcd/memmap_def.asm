;/**
; * [ M E G A D E V ]   a Sega Mega CD devkit
; *
; * @file memmap_def.h
; * @brief Main CPU side hardware memory map & system vectors
; *
; * @note All bit definitions are byte relative and should be applied to the
; * registers cast to an 8 bit type.
; */

SYSTEMUSE_BASE: equ $fffd00

;/**
; * Work RAM
; */
_WRKRAM: equ $ff0000

;/**
; * @brief Base address of Word RAM in 2M mode
; *
; */
_WRDRAM: equ $200000

;/**
; * @brief Base address of Word RAM in 1M mode
; *
; */
_WRDRAM_1M_0: equ $200000

;/**
; * @brief Base address of VDP tiles in 1M mode
; *
; */
_WRDRAM_1M_1: equ $220000

;/**
; * @brief Bass address for Sub CPU PRG RAM 1M mapping
; */
_PRGRAM: equ $20000

;/**
; * Initial Program (IP) enntry
; */
_IP_ENTRY: equ $ff0000

;/**
; * System Jump Table
; */
_RESET: equ $fffd00
_MLEVEL6: equ $fffd06 ;/* VBLANK interrupt */
_MLEVEL4: equ $fffd0c ;/* HBLANK interrupt */
_MLEVEL2: equ $fffd12 ;/* External port interrupt */
_MTRAP00: equ $fffd18
_MTRAP01: equ $fffd1e
_MTRAP02: equ $fffd24
_MTRAP03: equ $fffd2a
_MTRAP04: equ $fffd30
_MTRAP05: equ $fffd36
_MTRAP06: equ $fffd3c
_MTRAP07: equ $fffd42
_MTRAP08: equ $fffd48
_MTRAP09: equ $fffd4e
_MTRAP10: equ $fffd54
_MTRAP11: equ $fffd5a
_MTRAP12: equ $fffd60
_MTRAP13: equ $fffd66
_MTRAP14: equ $fffd6c
_MTRAP15: equ $fffd72
_MONKERR: equ $fffd78 ;// CHK Instruction
;// the duplicate addresses on the next two entries is intentional
_MADRERR: equ $fffd7e
_MCODERR: equ $fffd7e
_MDIVERR: equ $fffd84 ;// Zero Divide
_MTRPERR: equ $fffd8a ;// TRAPV Instruction
_MNOCOD0: equ $fffd90 ;// Line 1010
_MNOCOD1: equ $fffd96 ;// Line 1111
_MSPVERR: equ $fffd9c ;// Priv. Violation
_MTRACE: equ $fffda2	;// Trace
_VINT_EX: equ $fffda8
_MBURAM: equ $fffdae