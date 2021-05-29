; This sample shows two ways to print to the screen
; 1 Calling a routine in BASIC
; 2 Writing direct to screen memory



*=$0801 ; location to put 1 line basic program so we can just
        ; type run to execute the assembled program.
        ; will just call assembled program at correct location
        ;    10 SYS (4096)

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

; Assembler constants.  Doesn't seem to be a way to declare as const
CLEAR_SCREEN_KERNAL_ADDR = $E544     ; Kernal routine to clear screen
PRINT_STRING_BASIC_ADDR = $AB1E      ; Basic routine to print text

StrToPrint
        null "HELLO VIA BASIC"  ; null terminated string to print
                                ; via the BASIC routine

StrToPoke
        null 'hello direct'     ; null terminated string to print
                                ; via copy direct to screen memory


SCREEN_START_ADDR = $0400            ; The start of c64 screen memory

; we'll write directly to screen starting at a somewhat random
; screen location 
SCREEN_DIRECT_START_ADDR = SCREEN_START_ADDR + $0100; 


; our assembly code will goto this address
*=$1000
        
Main

        ; clear screeen leave cursor upper left
        jsr CLEAR_SCREEN_KERNAL_ADDR 
        
        ; method 1: call basic routine since we cleared screen 
        ; above the string will start in upper left
        lda #<StrToPrint             ; LSB of addr of string to print to A
        ldy #>StrToPrint             ; MSB of addr of str to print to Y
        jsr PRINT_STRING_BASIC_ADDR  ; call kernal routine to print the string


        ; method 2: write direct to screen memory
        ldx #0                         ; use x reg as loop index start at 0
DirectLoop
        lda StrToPoke,x                ; put a byte from string into accum
        beq Done                       ; if the byte was 0 then we're done 
        sta SCREEN_DIRECT_START_ADDR,x ; Store the byte to screen
        inx                            ; inc to next byte and next screen loc 
        jmp DirectLoop                 ; Go back for next byte
Done
        

        rts                     ; program done, return



        
