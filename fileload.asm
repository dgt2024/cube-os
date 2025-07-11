org 0x5000
db 11111111b
dw 0x0000
times 17 - ($ - $$) db 0
Main_Loop:
	call get_current_address
	xor si, si
	lodsb
	and al, 0x0F
	mov dx, 0x1000
	mov es, dx
	mov cx, 3200
	xor di, di
	rep stosb
	call get_current_address
	mov al, byte [0]
	and al, 00100000b
	jz .MainTextSkip
	mov bx, 0x1028
	mov es, bx
	mov si, 0x0F
	mov di, 0x01
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
	mov al, byte [0]
	and al, 10010000b
	cmp al, 10010000b
	je .setExtensionCXE
	cmp al, 00010000b
	je .setExtensionBIN
	cmp al, 00000000b
	je .setExtensionTXT
	jmp .setExtensionFILE
.setExtensionCXE:
	mov ax, 0x0002
	call backBufferingTexture
	mov ax, 0x3B2B
	call backBufferingTexture
	mov ax, 0x5AAD
	call backBufferingTexture
	mov ax, 0x79E7
	call backBufferingTexture
	jmp .setExtensionFILE
.setExtensionBIN:
	mov ax, 0x0002
	call backBufferingTexture
	mov ax, 0x6BAE
	call backBufferingTexture
	mov ax, 0x7497
	call backBufferingTexture
	mov ax, 0x2B6D
	call backBufferingTexture
	jmp .setExtensionFILE
.setExtensionTXT:
	mov ax, 0x0002
	call backBufferingTexture
	mov ax, 0x7492
	call backBufferingTexture
	mov ax, 0x5AAD
	call backBufferingTexture
	mov ax, 0x7492
	call backBufferingTexture
.setExtensionFILE:
.MainTextSkip:
	call config
	call frontBuffering
	jmp Main_Loop
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
	xor cx, cx
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
RAMLoad5:
	cli
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov bx, 0x1000
	mov ah, 0x02
	mov al, 1
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, 0
	int 0x13
	call 0x0000:0x1000
	ret
get_current_address:
	xor ax, ax
	mov ds, ax
	mov di, word [0x0960]
	mov ax, word [di]
	mov ds, ax
	ret
config:
	call get_current_address
	mov al, byte [0]
	and al, 10010000b
	cmp al, 10010000b
	je .configCXE
	cmp al, 00010000b
	je .configBIN
	cmp al, 00000000b
	je .configTXT
	ret
.configCXE:
	call get_current_address
	push ds
	push 0x0011
	retf
.configBIN:
	xor ax, ax
	mov ds, ax
	mov ax, word [0x960]
	mov word [0x962], ax
	mov word [0x960], 0x504
	jmp config
.configTXT:
	xor ax, ax
	mov ds, ax
	mov ax, word [0x0960]
	mov word [0x0962], ax
	mov word [0x0960], 0x502
	push 0x1FE0
	push 0x0011
	retf
	jmp config
times 512 - ($ - $$) db 0