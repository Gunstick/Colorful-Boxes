; Colorful Boxes
; Kind of 'fullscreen', moving, changing colors
; demo by Gunstick/Unlimited Matricks. jan 2022 using 12 Instructions
  move.w #$7f20,d3        ; SR and colors init in full word and $20 in lower byte for trap and color change speed
  move.b d3,d5            ; set color speed from lower byte and trap number (assuming d5=$0000 at start)
  move.w d5,-(sp)         ; d5=$20 = supervisor
  trap  #1                ; clr.l not needed, stack looks to be fine on startup 
  move.w d3,sr            ; set SR to mask all interrupts (see below for possible values)
vloop:                    ; main loop
  move.w #$164,d0         ; determined by try and error until it looked fine 
loop:                     ; one row 
  move.w d3,$ffff8240.w   ; set color
  rol.w #1,d3             ; next pxel to the right is another color. Can use rol/ror and #1 / #2
  dbf d0,loop             ; do this for the whole chunck of blocks
;  addq.b #1,d1            ; change colors about every 0.3 seconds
;  addq.w #8,d1            ; change colors about every 12 seconds
  add.w d5,d1             ; change colors about every 4 seconds (d5 still contains $20) (we don't care about initial value of d1)
  addx.l d2,d3            ; if overflow, add 1 to the colors (assuming d2 is zero)
  bra.s vloop             ; that's it, that's the whole demo

; lower byte of SR init value (in d3) can be any value, so that's also used for storing $20 and used for color change speed
; whole d3 is used as the color values which are shifted through, giving 16 colors per line
; upper init value of d3 is constrained by the possible SR values to stay in supervisor etc...
; $7f20 was found to five the nicest for the value...
; these are the allowed values for the upper byte of SR: [2367],[67ef]
; $26
; $27
; $2e
; $2f

; $36
; $37
; $3e
; $3f

; $66
; $67
; $6e
; $6f

; $76
; $77
; $7e
; $7f

