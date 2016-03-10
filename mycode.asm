            .MODEL SMALL    
            .STACK 64

            .DATA
ARR_SIZE     DW     7      
DOP1         DD     +4      ;00000000H
DOP2         DD     -10      ;00000000H
SUM          DD      0
QOP1         DD     00000000H,00000000H
QOP2         DD     00000000H,00000000H
QSUM         DD     00000000H,00000000H


            .CODE
START:
            MOV     AX,@DATA  
            MOV     DS,AX
            MOV     ES,AX

               
            MOV     SI,OFFSET   DOP1
            MOV     DI,OFFSET   DOP2          

; NUMBER IS COMPUTED IN DX:BX.

        XOR     DX,DX
        XOR     BX,BX
        MOV     CX,02H
        ADD     SI,02H
        ADD     DI,02H

ADDING_LOOP:
        MOV     AX,[SI]
        MOV     BX,[DI]           ; NUMBER IS READ IN AL.
        ;CWD                       ; CBW SIGN-EXTENDS AL TO AX.
        TEST    AX,AX             ; CHECK THE SIGN OF THE ADDEND.
        JS      NEGATIVE

POSITIVE:                         ; THE ADDEND IS POSITIVE.
        ADD     BX,AX             ; ADD.
        ADC     DX,0              ; CARRY.
        JMP     NEXT_NUMBER

NEGATIVE:                         ; THE ADDEND IS NEGATIVE.
        NEG     AX                ; AX = |AX|.
        SUB     BX,AX             ; SUBTRACT.
        SBB     DX,0              ; BORROW.

NEXT_NUMBER:
        SUB     SI,02H
        SUB     DI,02H                ; NEXT NUMBER.
        LOOP    ADDING_LOOP

; RESULT NOW IN DX:BX.

        MOV     AX,BX             ; RESULT NOW IN DX:AX.
        TEST    AX,AX
        JS      EDIT
        JMP     OVER
EDIT:   NEG     AX
OVER:    
    
        END     START