;Module 5: Frame Buffer and Block Operations

clear_buffer:
    push bp
    mov bp, sp
    push ax
    push cx
    push di
    push es

    mov es, [buffer_seg]    ; load add into es
    xor di, di                ; di = 0
    mov al, [bp+4]         ; colour pass through stack
    mov ah, al
    mov cx, 32000
    cld
    rep stosw            ; write word 

    pop es
    pop di
    pop cx
    pop ax
    pop bp
    ret 2

flip_buffer:           ; displa puc in frame 
    push ax
    push cx
    push si
    push di
    push ds
    push es

    mov ax, 0xA000
    mov es, ax
    mov ds, [buffer_seg]
    xor si, si
    xor di, di
    mov cx, 32000
    cld
    rep movsw

    pop es
    pop ds
    pop di
    pop si
    pop cx
    pop ax
    ret
