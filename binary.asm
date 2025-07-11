db 11110010b
dw 0x6BAE
dw 0x7497
dw 0x2B6D
dw 0x2BED
dw 0x6BAD
dw 0x5A92
times 17 - ($ - $$) db 0
	mov di, 3200
FEPrint:
	mov ax, 0x1000
	mov es, ax
	mov al, 0x00
	stosb
	cmp di, 64000
	jne FEPrint
	xor ax, ax
	mov ds, ax
	jmp FECntn
GetKeyInput:
	mov ah, 0x00
	int 0x16
	cmp ah, 0x01
	je BNEnd
	jmp GetKeyInput
FECntn:
	call frontBuffering
	mov ax, 0x0C70
	mov bx, 0xA0F0
	mov es, bx
	mov si, 0x04
	mov di, 0x02
	call backBufferingTexture
	xor ax, ax
	mov ds, ax
	mov bx, word [0x0A00]
	mov bx, word [bx]
	mov ds, bx
	mov bx, 0xA0F0
	mov es, bx
	mov si, 0x04
	call FEReload
	mov cx, 30
	push 0xA0F0
FEPrinting:
	xor ax, ax
	mov ds, ax
	mov ax, word [0x0A00]
	add ax, 2
	mov word [0x0A00], ax
	mov bx, word [0x0A00]
	mov bx, word [bx]
	mov ds, bx
	pop bx
	add bx, 0x78
	mov es, bx
	push bx
	mov si, 0x0F
	push cx
	call FEReload
	pop cx
	dec cx
	jnz FEPrinting
	xor ax, ax
	mov ds, ax
	mov ax, [0x0A00]
	sub ax, 60
	mov [0x0A00], ax
	jmp GetKeyInput
	ret
FEReload:
	mov al, byte [0]
	and al, 01000000b
	jz .MainTextSkip
	mov di, 0x0F
	mov cx, 8 ; Max Name Size
	mov bx, 1
.MainToptextLoop:
	mov ax, word [bx]
	call backBufferingTexture
	add bx, 2
	cmp ax, 0x0000
	je .MainToptextEnd
	loop .MainToptextLoop
.MainToptextEnd:
	ret
BNEnd:
	xor ax, ax
	mov ds, ax
	mov word [0x0960], 0x500
	mov word [0x0962], 0
	push 0x1FE0
	push 0x0011
	retf
backBufferingTexture: ; Loads a Hexadecimal Texture
	push cx
	push bx
	mov cx, 100000000000000b
	mov dl, 0
	mov dh, 0
.backBufferingTextureRepeat3: ; Prints a Row
	mov bx, ax
	and bx, cx
	shr cx, 1
	inc di
	cmp bx, 0
	je .backBufferingTextureSkip
	mov [es:di], si
.backBufferingTextureSkip: ; Goes to next row
	inc dl
	cmp dl, 3
	jne .backBufferingTextureRepeat3
	add di, 317
	inc dh
	cmp dh, 5
	jne .backBufferingTextureRedo
	cmp dh, 5
	je .backBufferingTextureFinish
.backBufferingTextureRedo:
	mov dl, 0
	jmp .backBufferingTextureRepeat3
.backBufferingTextureFinish:
	pop bx
	pop cx
	sub di, 1596
	ret
frontBuffering:
	mov cx, 0
	call .frontBufferingLoop
.frontBufferingLoop:
	mov ax, 0x1000
	mov es, ax
	mov ax, 0xA000
	mov ds, ax
	mov di, cx
	mov al, [es:di]
	mov [ds:di], al
	inc cx
	cmp cx, 64000
	jne .frontBufferingLoop
	ret
times 512 - ($ - $$) db 0