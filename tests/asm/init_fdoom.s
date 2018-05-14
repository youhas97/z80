org 0x0000 ; use absolute addresses

aux_addr: equ 0xf000 ; jump here to setup memory mapping

; MENU START
;pc_high: equ 0x9d
;pc_low:  equ 0xc6

; GAME START
pc_high: equ 0xa1
pc_low: equ 0x4e

im 1
ld a, 0x40 ; page B to RAM 0
out (0x07), a

; load instructions to RAM page
ld hl, aux_addr
; ld a, 0x76 ; mem mode to 0
ld (hl), 0x3e
inc hl
ld (hl), 0x76
inc hl
; out (0x04), a
ld (hl), 0xd3
inc hl
ld (hl), 0x04
inc hl
; ld a, 0x07 ; page A to ROM 0f
ld (hl), 0x3e
inc hl
ld (hl), 0x0f
inc hl
; out (0x06), a
ld (hl), 0xd3
inc hl
ld (hl), 0x06
inc hl
; ld a, 0x07 ; page B to RAM 01
ld (hl), 0x3e
inc hl
ld (hl), 0x41
inc hl
; out (0x07), a
ld (hl), 0xd3
inc hl
ld (hl), 0x07
inc hl
; jp 0x9dc6
ld (hl), 0xc3
inc hl
ld (hl), pc_low
inc hl
ld (hl), pc_high

jp aux_addr