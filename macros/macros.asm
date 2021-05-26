; This sample shows two ways to print to the screen
; create and use macros



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



CLEAR_SCREEN_KERNAL = $E544

; macro with no parameters to clear screen and 
; leave cursor in upper left
defm clear_screen_mac
        jsr CLEAR_SCREEN_KERNAL
        endm



; Address of Kernal routine to clear screen
PRINT_STRING_BASIC = $AB1E      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro to print a null terminated string via basic routine at 
; current cursor
; /1 is the address of the first char of string to print
defm print_string_basic_mac
        lda #</1        ; LSB of addr of string to print to A
        ldy #>/1        ; MSB of addr of str to print to Y
        jsr PRINT_STRING_BASIC  ; call kernal routine to print the string
        endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


SCREEN_COLS = 40
SCREEN_ROWS = 25
SCREEN_START_ADDR = $0500 ;SCREEN_START + (/1 * 40) + (/2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro to print a string by writing directly to screen memory
; /1 is screen column (x position) to start
; /2 is screen row (y position) to start
; /3 is the address of the first char of string to print
defm print_string_direct_mac
        ldx #0                  ; use x reg as loop index start at 0
StartAddr = SCREEN_START + (/2 * 40) + /1
_DirectLoop
        lda /3,x         ; put a byte from string into accum
        beq _Done                ; if the byte was 0 then we're done 
        sta StartAddr,x ; Store the byte to screen
        inx                     ; inc to next byte and next screen location 
        jmp _DirectLoop          ; Go back for next byte
_Done
        endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StrToPrint
        null "HELLO VIA BASIC"  ; null terminated string to print
                                ; via the BASIC routine

StrToPoke
        null 'hello direct'     ; null terminated string to print
                                ; via copy direct to screen memory


SCREEN_START = $0400            ; The start of c64 screen memory

; we'll write directly to screen starting at a somewhat random
; screen location 
;SCREEN_DIRECT_START = SCREEN_START + $0100; 


; our assembly code will goto this address
*=$1000
        
Main

        ; clear screeen leave cursor upper left
        clear_screen_mac
        
        ; print a string via basic routine
        print_string_basic_mac StrToPrint

        ; print a string by writing to screen memory
        print_string_direct_mac 5, 5, StrToPoke

        ; program done, return
        rts                     



        
