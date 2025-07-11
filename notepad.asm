org 0x7000
db 11110111b
dw 0x2B6D
dw 0x7B6F
dw 0x7492
dw 0x79E7
dw 0x6BA4
dw 0x2BED
dw 0x6B6E
times 17 - ($ - $$) db 0
	mov di, 3200
NTPrint:
	mov ax, 0x1000
	mov es, ax
	mov al, 0x00
	stosb
	cmp di, 64000
	jne NTPrint
	jmp NTContinue
Loop_:
	mov ah, 0x00
	int 0x16
	cmp ah, 0x01
	je NTEscape
	jmp Loop_
NTContinue:
	call frontBuffering
	mov di, 0x01
	mov bx, 0xA0F0
	mov es, bx
	mov dx, 40
	push 0x10
NTPrinting:	
	xor ax, ax
	mov ds, ax
	mov si, word [0x962] ; ds = address of txt
	mov si, 0x2100
	mov ds, si
	pop si ; offset
	add si, 2
	dec dx
	cmp dx, 0
	je NTDownward
NTDownnext:
	mov al, byte [ds:si] ; al = data in txt
	cmp al, 0
	je Loop_
	push si
	mov cx, word [0x504]
	mov ds, cx ; ds = 0x2080
	mov si, ax ; bx = data in t xt
	mov ax, word [ds:si] ; data in 0x20411 y
	mov si, 0x0F
	call backBufferingTexture
	jmp Loop_
NTDownward:
	mov dx, es	
	add dx, 0x14
	mov es, dx
	mov dx, 0x40
	mov di, 0x01
	jmp NTDownnext
NTEscape:
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