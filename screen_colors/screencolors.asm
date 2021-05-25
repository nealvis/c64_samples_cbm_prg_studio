; 10 SYS (4096)

*=$0801

        ; These bytes are a one line basic program that will 
        ; do a sys call to assembly language portion of
        ; of the program which will be at $1000 or 4096 decimal
        ; basic line is: 
        ; 10 SYS (4096)
        BYTE $0E, $08           ; Forward address to next basic line
        BYTE $0A, $00           ; this will be line 10 ($0A)
        BYTE $9E                ; basic token for SYS
        BYTE $20, $28,  $34, $30, $39, $36, $29 ; ASCII for " (4096)"
        BYTE $00, $00, $00      ; end of basic program (addr $080E from above)


CLEAR_SCREEN_KERNAL = $E544     ; Kernal routine to clear screen

PRINT_STRING_BASIC = $AB1E      ; Basic routine to print text


counter
        byte 0, 0

count2
        byte 0, 0

*=$1000
BORDER_COLOR_ADDR = $D020
BACKGROUND_COLOR_ADDR = $D021



      
Main
        jsr CLEAR_SCREEN_KERNAL ; clear screeen leave cursor upper left
        jsr PrintHello


CrazyBorder
CrazyBorderLoop
        inc BORDER_COLOR_ADDR
        ;inc BACKGROUND_COLOR_ADDR

        ;jsr PrintHello

        inc counter
        lda #$FF
        cmp counter
        bne CrazyBorderLoop

        lda #00
        sta counter
       
        inc count2
        lda #$80
        cmp count2
        beq Done
        jmp CrazyBorderLoop
Done
        rts




HelloStr
        null "PRINTING HELLO 2"    ; string to print


PrintHello
        lda #<HelloStr        ; lsB of addr of string to print to A
        ldy #>HelloStr        ; msB of addr of str to print to Y
        jsr PRINT_STRING_BASIC  ; call kernal routine to print the string
        rts



