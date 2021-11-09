; Name: Mohab Mohamed Maher  
; Course code: EEE3431
; Experiment/Assignment No: Experiment #1 Basic IO and Arithmetic
; Emulator version: 2.1.20  
; Optimum system clock: 12.0 MHz
; Optimum update frequency: 1
; # Glossary of terms: 
; 1. Light "X": The traffic lights on the right, aka P1.0 ~ P1.2.
; 2. Light "Y": The traffic lights on the left, aka P1.3 ~ P1.5.
; 3. DISP-0: The 1st 7-segment display from the right. This one is used for the one's digit of the countdown.
; 4. DISP-1: The 2nd 7-segment display from the right. This one is used for the ten's digit of the countdown.
; 5. 0B3H: The bit address for P3.3.
; # Notes: 
; Ignore the 7-segment display (DISP-2) while LIGHTS is executing. 
; Ignore LEDs when 7-segment display (DISP-0 and DISP-1) is executing COUNTDOWN_SUB.

START:
CLR P3.3 ;| Initializing to choose DISP-2 (the ignored one).
SETB P3.4 ;|
LIGHTS:
MOV P1, #11110110B ; #1 Initialize LEDs as both RED.
CALL DELAY_LONG ; #2
MOV P1, #11011110B ; #3 Change light Y from red to green.
CALL DELAY_SHORT ; #4
CALL COUNTDOWN_SUB ; #5, 6, 7
MOV P1, #11101110B ; #8 Change Y from green to yellow
CALL DELAY_LONG ; #9
MOV P1, #11110110B ; #10 Change Y from yellow to red.
CALL DELAY_LONG ; #11
MOV P1, #11110011B ; #12 Change light X from red to green.
CALL DELAY_SHORT ; #13
CALL COUNTDOWN_SUB ; #14, 15, 16
MOV P1, #11110101B ; #17 Change X from green to yellow.
CALL DELAY_LONG ; #18
JMP LIGHTS ; Retvrn.

;---

COUNTDOWN_SUB:  
; Ignore lights while 7-seg countdown.
MOV P1, #11111111B ; Reset the 7-segment display to all-off.  

; Count down from 12 to 10.
SETB P3.3
CLR P3.4 
MOV P1, #11111001B ; Put 1 on DISP-1.
MOV P1, #11111111B ; Reset the 7-segment display to all-off. Prevent shifting display between DISP-1 and DISP-2.  
CLR P3.3
CLR P3.4
MOV P1, #10100100B ; Put 2 on DISP-0. This makes "12". 
;CALL DELAY_1S
MOV P1, #11111111B ; Reset the 7-segment display to all-off. Prevent shifting display between DISP-1 and DISP-2.  

SETB P3.3
CLR P3.4 
MOV P1, #11111001B ; Put 1 on DISP-1.
MOV P1, #11111111B ; Reset the 7-segment display to all-off. Prevent shifting display between DISP-1 and DISP-2.  
CLR P3.3
CLR P3.4
MOV P1, #11111001B ; Put 1 on DISP-1. This makes "11".
;CALL DELAY_1S
MOV P1, #11111111B ; Reset the 7-segment display to all-off. Prevent shifting display between DISP-1 and DISP-2.  

SETB P3.3
CLR P3.4 
MOV P1, #11111001B ; Put 1 on DISP-1.
MOV P1, #11111111B ; Reset the 7-segment display to all-off. Prevent shifting display between DISP-1 and DISP-2.  
CLR P3.3
CLR P3.4
MOV P1, #11000000B ; Put 0 on DISP-0. This makes "10". 
CALL DELAY_1S


; Countdown from 9 t0 0. 
CLR P3.3 ; #5, 14 Switch to DISP-0 only.
CLR P3.4
MOV P1, #10010000B ; Put 9 on DISP-0.
CALL DELAY_SHORT
MOV P1, #10000000B ; Put 8 on DISP-0.
CALL DELAY_SHORT
MOV P1, #11111000B ; Put 7 on DISP-0.
CALL DELAY_SHORT
MOV P1, #10000010B ; Put 6 on DISP-0.
CALL DELAY_SHORT
MOV P1, #10010010B ; Put 5 on DISP-0.
CALL DELAY_SHORT
MOV P1, #10011001B ; Put 4 on DISP-0.
CALL DELAY_SHORT
MOV P1, #10110000B ; Put 3 on DISP-0.
CALL DELAY_SHORT
MOV P1, #10100100B ; Put 2 on DISP-0.
CALL DELAY_SHORT
MOV P1, #11111001B ; Put 1 on DISP-0.
CALL DELAY_SHORT
MOV P1, #11000000B ; Put 0 on DISP-0.
CALL DELAY_SHORT
CLR P3.3 ;| Choose DISP-2 (the ignored one).
SETB P3.4 ;|
RET

;---

DELAY_1S: 
MOV R0, #1H
DJNZ R0, $
RET

DELAY_SHORT:  
MOV R0, #2H
DJNZ R0, $
RET  

DELAY_LONG:  
MOV R0, #5H  
DJNZ R0, $
RET

; # Log
; - Mistake: accidentally reversed the 7-seg binary number.
; - Made a mistake, shouldn't have used "CPL" for light switching
; or else it will be interferred by operations on the 7-seg, messing
; bits in P1.  
; - Small error: Small messy display on DISP-0 transferred from DISP-1 before the 9 ~ 0 countdown. Fixed.