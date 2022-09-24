 [BITS 16]                                                  ; Işlemciye kod türü belirtilir
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
           MOV dl, 4
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
 dw 0xAA55
