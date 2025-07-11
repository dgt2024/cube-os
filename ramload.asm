org 0x1000
use16
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov bx, 0x0500
	mov ah, 0x02
	mov al, 2
	mov ch, 0
	mov cl, 3
	mov dh, 0
	mov dl, 0
	int 0x13
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov bx, 0x0960
	mov ah, 0x02
	mov al, 1
	mov ch, 0
	mov cl, 5
	mov dh, 0
	mov dl, 0
	int 0x13
	xor ax, ax
	mov ds, ax
	mov ax, 0x1FE0
	mov es, ax
	mov bx, 0x0000
	mov ah, 0x02
	mov al, 1
	mov ch, 0
	mov cl, 6
	mov dh, 0
	mov dl, 0
	int 0x13
	xor ax, ax
	mov ds, ax
	mov ax, 0x2000
	mov es, ax
	mov bx, 0x0000
	mov ah, 0x02
	mov al, 5
	mov ch, 0
	mov cl, 7
	mov dh, 0
	mov dl, 0
	int 0x13
	retf
times 512 - ($ - $$) db 0