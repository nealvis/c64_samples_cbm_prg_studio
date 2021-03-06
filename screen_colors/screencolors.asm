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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; program variables here before the main program

; inner loop index/counter
inner_counter
        byte 0

; outer loop index/counter
outer_counter
        byte 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Start of main program
*=$1000
Main

CLEAR_SCREEN_KERNAL_ADDR = $E544     ; Kernal routine to clear screen
BORDER_COLOR_ADDR = $D020
BACKGROUND_COLOR_ADDR = $D021

        jsr CLEAR_SCREEN_KERNAL_ADDR ; clear screeen leave cursor upper left


CrazyBorder
CrazyBorderLoop

; Total iterations will be inner_max * outer_max
_inner_max = $FF        ; number of iterations of inner loop
_outer_max = $B0        ; number of iterations of outer loop

        ; go to next boarder and background color
        inc BORDER_COLOR_ADDR      ; inc val at border color addr
        inc BACKGROUND_COLOR_ADDR  ; inc val at bkgrd color addr

        ; inc inner counter and if hasn't reached max then 
        ; back to top of loop
        inc inner_counter          
        lda #_inner_max
        cmp inner_counter
        bne CrazyBorderLoop 

        ; inner loop finished, reset inner_counter
        ; to zero to prepare for next time through
        lda #00
        sta inner_counter
       
        ; now inc and check outer loop counter
        ; if we've completed all the outer loops then done
        inc outer_counter
        lda #_outer_max
        cmp outer_counter
        beq Done

        ; still more to do, back to top of inner loop
        jmp CrazyBorderLoop
Done
        rts




