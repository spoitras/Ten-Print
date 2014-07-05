;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Inspired by the book 10 PRINT CHR$(205.5+RND(1));:GOTO 10         ;;
;; tenprint-page.asm outputs an entire screen at a time, instead of  ;;
;; line by line. The refresh rate can be set in seconds by adjusting ;;
;; the delay variable (default = 0.5 second).                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!cpu 6502
!to "build/tenprint-page.prg",cbm

; I'm using the labels from Mapping the 64
FREHI3 = $d40f
RANDOM = $d41b
TIME = $a2
VICSCN = $0400
VCREG3 = $d412

delay = 30 	; wait delay/60 seconds

* = $0801	; BASIC starts at #2049 = $0801

!byte $0d,$08,$dc,$07,$9e,$20,$34,$39   ; BASIC to load $c000 inserts 
!byte $31,$35,$32,$00,$00,$00           ; BASIC line: 2012 SYS 49152


* = VICSCN
!fill 1000,$4d	;fill screen with "\"


*=$c000

jmp start

rnd lda RANDOM  ; load random value from voice 3
    and #1      ; keep only the low bit and add it to
    adc #$4d    ; the value of "\"
    rts

print ldx #0
ploop jsr rnd 	    ; get random "\" or "/"
      sta $0400,x   ; place it on screen
      jsr rnd
      sta $0500,x 
      jsr rnd
      sta $0600,x 
      jsr rnd
      sta $06e8,x 
      inx           ; increment X
      bne ploop     ; did X turn to zero yet?
                    ; if not, continue with the loop
      rts           ; return from this subroutine


wait  lda #0
      sta TIME
wloop lda TIME
      cmp #delay  
      bne wloop
      rts

start lda #$80
      sta FREHI3	; set voice 3 frequency (high byte)
      sta VCREG3	; select noise waveform on voice 3
main  jsr print   ; print screen of random "/" or "\"
      jsr wait    ; wait for delay/60 seconds
      jmp main	  ; to infinity

