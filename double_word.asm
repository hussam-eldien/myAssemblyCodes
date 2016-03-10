.MODEL  SMALL
        .STACK  64
        .DATA
OP1     DD      00020001H   
OP2     DD      00020000H
SUM     DD      00000000H
OP11    DD      00000000H,00000000H
OP12    DD      00000000H,00000000H
SUM1    DD      00000000H,00000000H

SPACE   DB      '  ','$'

        .CODE   
        
;-----------------CLEAR SCREEN FUN

CLEAR   PROC
        MOV     AX,0600H
        MOV     BH,07
        MOV     CX,0000
        MOV     DX,184FH
        INT     10H
        RET
CLEAR   ENDP

;---------------------DISPLAY FUN


DISPLAY   PROC     
          MOV   BX, 10     	;Initializes divisor
          MOV   DX, 0000H   
          MOV   CX, 0000H    
    
     ;Splitting process starts here
.Dloop1:  MOV   DX, 0000H    
          DIV   BX      	;Divides AX by BX
          PUSH  DX     		;Pushes DX(remainder) to stack
          INC   CX      	;Increments counter to track the number of digits
          CMP   AX, 0    	;Checks if there is still something in AX to divide
          JNE .Dloop1     	;Jumps if AX is not zero
    
.Dloop2:  POP   DX      	;Pops from stack to DX
          ADD   DX, 30H    	;Converts to it's ASCII equivalent
          MOV   AH, 02H     
          INT   21H      	;calls DOS to display character
          LOOP .Dloop2    	;Loops till CX equals zero
          RET       		;returns control
DISPLAY  ENDP


;--------------------WRITE SPACE FUN

WRITES  PROC
        MOV     AH,09
        MOV     DX,OFFSET       SPACE
        INT     21H
        RET
WRITES  ENDP       


;--------------------CALC FUN

CALC    PROC
        MOV     SI,OFFSET   OP1
        MOV     DI,OFFSET   OP2
        MOV     BX,OFFSET   SUM
        SUB     DX,DX
        MOV     CX,02H
LOP1:   MOV     DX,[SI]
        MOV     AX,00
        PUSH    CX
        MOV     CX,4 
        MOV     DI,SI
        ADD     DI,08H
LOP2:   ADD     DX,[DI]
        ADC     AX,00
        ADD     DI,08H
        LOOP    LOP2  
        POP     CX
        MOV     [BX],DX
        CMP     CX,CHECK 
        JE      OVER
        ADD     [BX]+2,AX
        ADD     SI,02H        ; MOVE TO THE NEXT WORD IN THE QUAD 
        ADD     BX,02H
        LOOP    LOP1
OVER:   ADD     CARRY,AX
        LOOP    LOP1
                
;--------------------MAIN FUN
MAIN    PROC
        MOV     AX,@DATA
        MOV     DS,AX
        MOV     AH,4CH
        INT     21H
MAIN    ENDP 

        END     MAIN