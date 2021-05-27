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


; address of the Kernal routine to clear the screen
CLEAR_SCREEN_KERNAL = $E544

; macro with no parameters to clear screen and 
; leave cursor in upper left
defm clear_screen_mac
        jsr CLEAR_SCREEN_KERNAL
        endm



; Address of BASIC routine to print a string at 
; current cursor location
PRINT_STRING_BASIC = $AB1E      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro to print a null terminated string via basic routine at 
; current cursor
; /1 is the address of the first char of string to print
defm print_string_basic_mac
        lda #</1                ; LSB of addr of string to print to A
        ldy #>/1                ; MSB of addr of str to print to Y
        jsr PRINT_STRING_BASIC  ; call kernal routine to print the string
        endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Some constants for screen 
SCREEN_START = $0400            ; The start of c64 screen memory
SCREEN_COLS = 40                ; chars across
SCREEN_ROWS = 25                ; chars down


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; macro to print a string by writing directly to screen memory
; /1 is the screen location for first character of string
; /2 is the address of the first char of string to print
defm print_string_direct_mac
        ldx #0          ; use x reg as loop index start at 0
@DirectLoop
        lda /2,x        ; put a byte from string into accum
        beq @Done       ; if the byte was 0 then we're done 
        sta /1,x        ; Store the byte to screen
        inx             ; inc X to next byte and next screen location 
        jmp @DirectLoop ; Loop back to write next byte
@Done
        endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; some data for our program.  This will be directly after
; the sys(4096) BASIC program but before the start of 
; the assembly program below

; null terminated strings to print via basic routine
StrHelloBasic
        null "HELLO VIA BASIC   "  

StrGoodbyeBasic
        null "GOODBYE VIA BASIC"
           

; null terminated strings to print direct to screen memory
StrHelloDirect
        null 'hello direct'

StrGoodbyeDirect
        null 'goodbye direct'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; our assembly code will start at this address
*=$1000
        
Main

        ; clear screeen leave cursor upper left
        clear_screen_mac
        
        ; print a string via basic routine
        print_string_basic_mac StrHelloBasic

        ; print a string starting at x=5, y=5 
        ; by writing to screen memory
screen_addr1 = SCREEN_START + (5 * SCREEN_COLS) + 5
        print_string_direct_mac screen_addr1, StrHelloDirect

        ; print a string via basic routine
        print_string_basic_mac StrGoodByeBasic

        ; print a string starting at to x=6, y=6 
        ; by writing to screen memory
screen_addr2 = SCREEN_START + (6 * SCREEN_COLS) + 6
        print_string_direct_mac screen_addr2, StrGoodbyeDirect


        ; program done, return
        rts                     



        
