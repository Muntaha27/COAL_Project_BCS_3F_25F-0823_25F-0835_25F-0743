[org 0x0100]

    jmp main_init  

; PHASE 1 - MODULE 1: PROGRAM SKELETON, CONSTANTS & CONFIGURATION

SCREEN_W        equ 320
SCREEN_H        equ 200
TILE_SIZE       equ 16
MAP_COLS        equ 64   ; 64 tiles wide = 1024 px (> 60 tiles min)
MAP_ROWS        equ 12
MAP_SIZE        equ (MAP_COLS * MAP_ROWS)
WORLD_W         equ (MAP_COLS * TILE_SIZE)
MAX_CAMERA_X    equ (WORLD_W - SCREEN_W) ; 1024 - 320 = 704

; PHASE 1 - MODULE 1: DATA & VARIABLES LAYOUT

old_kb_isr:     dd 0  ; Saved INT 09h vector 
old_tmr_isr:    dd 0  ; Saved INT 08h vector 
buffer_seg:     dw 0    ; Segment address of 64KB off-screen frame buffer 

tick_counter:   dw 0            ; Incremented by INT 08h (18.2 Hz) 
sec_ticks:      db 0            ; Sub-second tick accumulator (0..18) 
key_states:     times 128 db 0  ; 1 = pressed, 0 = released 

game_state:     db STATE_TITLE  ; Current game state 
menu_choice:    db 0            ; 0 = START GAME, 1 = EXIT 
state_timer:    dw 0            ; General purpose timer for Dying/LifeLost/Win 
