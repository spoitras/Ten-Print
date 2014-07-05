;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Inspired by the book 10 PRINT CHR$(205.5+RND(1));:GOTO 10         ;;
;; tenprint-col.asm outputs column by column, instead of line by     ;;
;; line. The refresh rate can be set in seconds by adjusting the     ;;
;; delay variable (default = 0.25 second).                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!cpu 6502
!to "build/tenprint-col.prg",cbm

; I'm using the labels from Leemon's Mapping the Commodore 64
CHROUT = $f1ca
FREHI3 = $d40f
PLOT = $e50a
RANDOM = $d41b
TIME = $a2
VCREG3 = $d412
VICSCN = $0400


delay = 15 	; wait delay/60 seconds

* = $0801	; BASIC starts at $0801

!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC to load $c000 inserts 
!byte $31,$35,$32,$00,$00,$00           ; BASIC line: 2012 SYS 49152


* = VICSCN
!fill 1000,$20	;clear screen


* = $c000

jmp start

rnd lda RANDOM  ; load random value from voice 3
    and #1      ; keep only the low bit and add it to
    adc #$6d    ; the value of "\"
    rts

print clc
      jsr PLOT
      jsr rnd     ; get random "\" or "/"
      jsr CHROUT  ; output char in A to screen
      rts         ; return from this subroutine


wait  lda #0
      sta TIME
.loop lda TIME
      cmp #delay 	
      bne .loop
      rts

start lda #$80
      sta FREHI3	; set voice 3 frequency (high byte)
      sta VCREG3	; select noise waveform on voice 3
main  ldx #0
      ldy #1
loopc 
loopr jsr print
      inx
      cpx #25
      bne loopr
      jsr wait
      ldx #0
      iny
      cpy #39
      bne loopc
      jmp main