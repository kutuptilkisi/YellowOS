	BITS 16

start:
	mov a	BITS 16

start:
	mov ax, 07C0h		; Set up 4K sta [BITS 16]                                                  ; Işlemciye kod türü belirtilir
           JMP SHORT Yukleyici_Basla
           NOP
 Yukleyici_Basla:
           MOV ax, 07C0h  
           ADD ax, 544
           CLI
           MOV ss, ax
           MOV sp, 4096
           STI
           MOV ax, 07C0h
           MOV ds, ax
           MOV dl, 0
           MOV dh, 0
           CALL ImlecTasi
           MOV si, Metin1
           CALL Yazdir
           MOV dl, 5
           MOV dh, 1
           CALL ImlecTasi
           MOV si, Metin2
           CALL Yazdir
           JMP $
 ; Imlec tasınır  
 ; G: dl = x, dh = y       
 ; Ç: bos  
 ImlecTasi:  
      PUSHA  
      MOV bh, 0  
      MOV ah, 2  
      INT 0x10  
      POPA  
      RET  
 ; Ekrana yazı yazdırılır
 ; G: si = yazi
 ; Ç: bos
 Yazdir:
      PUSHA
      MOV ah, 0x0E
      MOV bh, 0
 .birSonrakiKarakter:
      LODSB
      CMP al, 0
      JE .Bitir
      INT 0x10
      JMP .birSonrakiKarakter
 .Bitir:
      POPA
      RET
 Metin1               db               'YellowOS - v1.0', 0
 Metin2               db               'Merhaba', 0
 TIMES 510 - ($ - $$) db 0                         ; 510 byte tamamlanır  
 dw 0xAA55ck space after this bootloader
	add ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax


	mov si, metin1	; Put string position into SI
	mov si, metin2
	call metin	; Call our string-printing routine

	jmp $			; Jump here - infinite loop!


	metin1 db 'YellowOS - v1.0', 0
	metin2 db 'Merhaba', 0


metin:			; Routine: output string in SI to screen
	mov ah, 0Eh		; int 10h 'print char' function

.repeat:
	lodsb			; Get character from string
	cmp al, 0
	je .done		; If char is zero, end of string
	int 10h			; Otherwise, print it
	jmp .repeat

.done:
	ret


	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55		; The standard PC boot signaturex, 07C0h
