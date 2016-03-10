        .MODEL  SMALL
        .STACK  64
        .DATA
OP1     DD      FFFFFFFFH,FFFF0000H   ;DD=8bits .. need edition here for counter sum
OP2     DD      00000001H,00010000H
OP3     DD      0000FFFFH,00000000H
OP4     DD      00000000H,00000000H
OP5     DD      00000000H,00000000H
SUM     DD      00000000H,00000000H
CARRY   DW      0000H 
CHECK   DW      1H
SPACE   DB      '  ','$'
MSG     DB      'CARRY','$'
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
          DIV   BX      
          PUSH  DX     
          INC   CX     		;Increments counter to track the number of digits
          CMP   AX, 0     	;Checks if there is still something in AX to divide
          JNE .Dloop1     
    
.Dloop2:  POP   DX      
          ADD   DX, 30H     	;Converts to it's ASCII equivalent
          MOV   AH, 02H     
          INT   21H      
          LOOP .Dloop2    
          RET       
DISPLAY  ENDP


;--------------------WRITE SPACE FUN

WRITES  PROC
        MOV     AH,09
        MOV     DX,OFFSET       SPACE
        INT     21H
        RET
WRITES  ENDP
;--------------------WRITE CARRY FUN

WRITEC  PROC
        MOV     AH,09
        MOV     DX,OFFSET       MSG
        INT     21H
        RET
WRITEC  ENDP


;--------------------CALC FUN

CALC    PROC
        MOV     SI,OFFSET   OP1
        MOV     DI,OFFSET   OP1
        MOV     BX,OFFSET   SUM
        SUB     DX,DX
        MOV     CX,4
LOP1:   MOV     DX,[SI]
        ;CLC
        MOV     AX,00
        PUSH    CX
        MOV     CX,4 
        MOV     DI,SI
        ADD     DI,08H
LOP2:   ADD     DX,[DI]
        ADC     AX,00 
        ;ADD     [BX+2],AX
        ADD     DI,08H
        LOOP    LOP2  
        POP     CX
        ADD     [BX],DX
        CMP     CX,CHECK 
        JE      OVER
        ADD     [BX]+02H,AX
        ADD     SI,02H        ; MOVE TO THE NEXT WORD IN THE QUAD 
        ADD     BX,02H
        LOOP    LOP1
        JMP     GO1 
        
OVER:   ADD     CARRY,AX
        LOOP    LOP1
        
GO1:    MOV     BX,OFFSET   SUM
        MOV     CX,04H
LOP3:   MOV     AX,[BX]
        PUSH    CX
        PUSH    BX
        CALL    DISPLAY
        POP     BX
        POP     CX
        ADD     BX,02H
        CALL    WRITES
        MOV     AX,00
        LOOP    LOP3
        CALL    WRITES
	    CALL	WRITEC
	    CALL    WRITES
        MOV     AX,CARRY
        CALL    DISPLAY
        CALL    WRITES
        MOV     AH,0
        INT     16H
        
        RET
CALC    ENDP

;--------------------MAIN FUN
      
        
MAIN    PROC    FAR
        MOV     AX,@DATA
        MOV     DS,AX
        CALL    CLEAR
        CALL    CALC
        MOV     AH,00
        MOV     CH,4H
        INT     21H
MAIN    ENDP


        END     MAIN





                

