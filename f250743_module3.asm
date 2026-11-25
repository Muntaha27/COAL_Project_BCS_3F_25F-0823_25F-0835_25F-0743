; ==============================================================================
; PHASE 1 - MODULE 3: TILE CODES, LEVEL MAP DATA & TILE DRAWING
; ==============================================================================
TILE_SKY        equ 0
TILE_GROUND     equ 1
TILE_BRICK      equ 2
TILE_Q_COIN     equ 3
TILE_Q_MUSH     equ 4
TILE_EMPTY      equ 5
TILE_PIPE_TL    equ 6
TILE_PIPE_TR    equ 7
TILE_PIPE_BL    equ 8
TILE_PIPE_BR    equ 9
TILE_STAIR      equ 10
TILE_COIN       equ 11
TILE_FLAG       equ 12

original_map:
; Row 0 (64 cols): Reserved for HUD (all sky)
times 64 db 0

; Row 1 (64 cols): Sky
times 64 db 0

; Row 2 (64 cols): Goal Flag Pole Top (col 59)
times 59 db 0
db 12, 0, 0, 0, 0

; Row 3 (64 cols): High coins & Goal Pole
times 14 db 0
db 11, 11, 11                   ; cols 14..16 (3)
times 42 db 0                   ; cols 17..58 (42)
db 12, 0, 0, 0, 0               ; cols 59..63 (5)

; Row 4 (64 cols): High platform & Goal Pole
times 13 db 0                   ; cols 0..12 (13)
db 2, 3, 2, 3, 2                ; cols 13..17 (5)
times 22 db 0                   ; cols 18..39 (22)
db 11, 11, 11                   ; cols 40..42 (3)
times 16 db 0                   ; cols 43..58 (16)
db 12, 0, 0, 0, 0               ; cols 59..63 (5)

; Row 5 (64 cols): Stairs step 4 & Goal Pole
times 54 db 0                   ; cols 0..53 (54)
db 10, 10                       ; cols 54..55 (2)
times 3 db 0                    ; cols 56..58 (3)
db 12, 0, 0, 0, 0               ; cols 59..63 (5)

; Row 6 (64 cols): Crate & '?' blocks (3=Coin, 4=Golden Carrot) + Stairs step 3
times 6 db 0                    ; cols 0..5 (6)
db 3, 2, 4, 2, 3                ; cols 6..10 (5): First Golden Carrot at col 8
times 21 db 0                   ; cols 11..31 (21)
db 2, 4, 2, 3                   ; cols 32..35 (4): Second Golden Carrot at col 33
times 17 db 0                   ; cols 36..52 (17)
db 10, 10, 10                   ; cols 53..55 (3)
times 3 db 0                    ; cols 56..58 (3)
db 12, 0, 0, 0, 0               ; cols 59..63 (5)

; Row 7 (64 cols): Tall Log Top (cols 26-27), Coins over Pit 2, Stairs step 2
times 26 db 0                   ; cols 0..25 (26)
db 6, 7                         ; cols 26..27 (2): Tall Emerald Log Top
times 12 db 0                   ; cols 28..39 (12)
db 11, 11                       ; cols 40..41 (2): Coins over Pit 2
times 10 db 0                   ; cols 42..51 (10)
db 10, 10, 10, 10               ; cols 52..55 (4)
times 3 db 0                    ; cols 56..58 (3)
db 12, 0, 0, 0, 0               ; cols 59..63 (5)

; Row 8 (64 cols): Short Log Top (cols 16-17), Coins over Pit 1, Tall Log Body, Stairs step 1
times 16 db 0                   ; cols 0..15 (16)
db 6, 7                         ; cols 16..17 (2): Short Emerald Log Top
times 3 db 0                    ; cols 18..20 (3)
db 11, 11                       ; cols 21..22 (2): Coins over Pit 1
times 3 db 0                    ; cols 23..25 (3)
db 8, 9                         ; cols 26..27 (2): Tall Log Middle
times 23 db 0                   ; cols 28..50 (23)
db 10, 10, 10, 10, 10           ; cols 51..55 (5)
times 3 db 0                    ; cols 56..58 (3)
db 12, 0, 0, 0, 0               ; cols 59..63 (5)

; Row 9 (64 cols): Walking Row (Clear starting runway cols 0..15)
times 16 db 0                   ; cols 0..15 (16)
db 8, 9                         ; cols 16..17 (2): Short Log Base
times 8 db 0                    ; cols 18..25 (8)
db 8, 9                         ; cols 26..27 (2): Tall Log Base
times 31 db 0                   ; cols 28..58 (31)
db 10                           ; col 59 (1): Flag Base Block
times 4 db 0                    ; cols 60..63 (4)

; Row 10 (64 cols): Grassy Ground (Pit 1 at cols 21-22, Pit 2 at cols 40-41)
times 21 db 1                   ; cols 0..20 (21)
db 0, 0                         ; cols 21..22 (2)
times 17 db 1                   ; cols 23..39 (17)
db 0, 0                         ; cols 40..41 (2)
times 22 db 1                   ; cols 42..63 (22)

; Row 11 (64 cols): Deep Ground (matches Row 10)
times 21 db 1                   ; cols 0..20 (21)
db 0, 0                         ; cols 21..22 (2)
times 17 db 1                   ; cols 23..39 (17)
db 0, 0                         ; cols 40..41 (2)
times 22 db 1                   ; cols 42..63 (22)

working_map:    times MAP_SIZE db 0

; ------------------------------------------------------------------------------
; Procedure: reset_map
; Phase / Module: Phase 1 - Module 3 (Level Map and Tile Drawing)
; Purpose: Restores working_map (768 bytes) from original_map using REP MOVSB.
; Inputs: original_map
; Outputs: Overwrites working_map with clean initial level tiles
; Registers Changed: None (all preserved)
; ------------------------------------------------------------------------------
reset_map:
    push cx
    push si
    push di
    push ds
    push es

    push cs
    pop ds
    push cs
    pop es
    mov si, original_map
    mov di, working_map
    mov cx, MAP_SIZE
    cld
    rep movsb

    pop es
    pop ds
    pop di
    pop si
    pop cx
    ret

; ------------------------------------------------------------------------------
; Procedure: get_tile
; Phase / Module: Phase 1 - Module 3 (Level Map and Tile Drawing)
; Purpose: Converts world pixel coordinates (px, py) to tile indices and
;          returns the tile code from working_map.
; Inputs: [bp+6]=world_x, [bp+4]=world_y
; Outputs: AX = tile code (0 if out of bounds)
; Registers Changed: AX
; ------------------------------------------------------------------------------
get_tile:
    push bp
    mov bp, sp
    push bx
    push dx

    mov ax, [bp+4]
    cmp ax, 0
    jl .out_bounds
    cmp ax, 192
    jge .out_bounds

    shr ax, 4
    shl ax, 6
    mov bx, ax

    mov dx, [bp+6]
    cmp dx, 0
    jl .out_bounds
    cmp dx, WORLD_W
    jge .out_bounds
    shr dx, 4
    add bx, dx

    mov al, [working_map + bx]
    xor ah, ah
    jmp .gt_done

.out_bounds:
    xor ax, ax

.gt_done:
    pop dx
    pop bx
    pop bp
    ret 4

; ------------------------------------------------------------------------------
; Procedure: set_tile
; Phase / Module: Phase 1 - Module 3 (Level Map and Tile Drawing)
; Purpose: Updates a tile in working_map at world pixel coordinates (px, py).
; Inputs: [bp+8]=world_x, [bp+6]=world_y, [bp+4]=tile_code
; Outputs: Modifies working_map entry
; Registers Changed: None (all preserved)
; ------------------------------------------------------------------------------
set_tile:
    push bp
    mov bp, sp
    push ax
    push bx
    push dx

    mov ax, [bp+6]
    cmp ax, 0
    jl .st_done
    cmp ax, 192
    jge .st_done

    shr ax, 4
    shl ax, 6
    mov bx, ax

    mov dx, [bp+8]
    shr dx, 4
    add bx, dx

    mov al, [bp+4]
    mov [working_map + bx], al

.st_done:
    pop dx
    pop bx
    pop ax
    pop bp
    ret 6

; ------------------------------------------------------------------------------
; Procedure: draw_tile_at
; Phase / Module: Phase 1 - Module 3 (Level Map and Tile Drawing)
; Purpose: Renders a single 16x16 map tile (ground, brick, '?' block, pipe,
;          stair, coin, or flag pole) at screen coordinates (sx, sy).
; Inputs: [bp+8]=screen_x, [bp+6]=screen_y, [bp+4]=tile_code
; Outputs: Draws tile graphics into buffer_seg
; Registers Changed: None (all preserved)
; ------------------------------------------------------------------------------
draw_tile_at:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx

    mov al, [bp+4]
    cmp al, TILE_SKY
    jne .dt_not_sky
    jmp .dt_done
.dt_not_sky:

    mov bx, [bp+8]
    mov cx, [bp+6]

    cmp al, TILE_COIN
    jne .not_coin
    push bx
    push cx
    push 16
    push spr_coin
    push 0
    call draw_sprite
    jmp .dt_done

.not_coin:
    cmp al, TILE_FLAG
    jne .not_flag
    add bx, 7
    push bx
    push cx
    push 2
    push 16
    push COL_WHITE
    call fill_rect
    add bx, 2
    push bx
    push cx
    push 6
    push 8
    push COL_ORANGE
    call fill_rect
    jmp .dt_done

.not_flag:
    cmp al, TILE_GROUND
    jne .not_ground
    push bx
    push cx
    push 16
    push 16
    push COL_BROWN
    call fill_rect

    push bx
    push cx
    push 16
    push 4
    push COL_GREEN_LIGHT
    call fill_rect
    jmp .dt_done

.not_ground:
    mov ah, COL_WOOD_DARK
    cmp al, TILE_Q_COIN
    je .set_yellow
    cmp al, TILE_Q_MUSH
    je .set_yellow
    cmp al, TILE_EMPTY
    je .set_gray
    cmp al, TILE_PIPE_TL
    je .set_green
    cmp al, TILE_PIPE_TR
    je .set_green
    cmp al, TILE_PIPE_BL
    je .set_green
    cmp al, TILE_PIPE_BR
    je .set_green
    cmp al, TILE_STAIR
    je .set_stair
    jmp .draw_block

.set_yellow:
    mov ah, COL_YELLOW
    jmp .draw_block
.set_gray:
    mov ah, COL_DARK_GRAY
    jmp .draw_block
.set_green:
    mov ah, COL_GREEN
    jmp .draw_block
.set_stair:
    mov ah, COL_GRAY

.draw_block:
    push bx
    push cx
    push 16
    push 16
    xor dx, dx
    mov dl, ah
    push dx
    call fill_rect

    push bx
    push cx
    push 16
    push 1
    push COL_BLACK
    call fill_rect

    mov al, [bp+4]
    cmp al, TILE_Q_COIN
    je .draw_q
    cmp al, TILE_Q_MUSH
    jne .dt_done
.draw_q:
    add bx, 4
    add cx, 4
    push bx
    push cx
    push '?'
    push COL_BLACK
    call draw_char_8x8

.dt_done:
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6