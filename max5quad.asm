        .MODEL  SMALL
        .STACK  64
        .DATA
OP1     DD      00020001H,00040003H   
OP2     DD      00020000H,00040003H
OP3     DD      00020003H,00040003H
OP4     DD      00000000H,00060000H
OP5     DD      00000000H,00050004H
MAX     DW      0000H 
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
          MOV   BX, 10     
          MOV   DX, 0000H   
          MOV   CX, 0000H    
    
     ;Splitting process starts here
.Dloop1:  MOV   DX, 0000H    
          DIV   BX      
          PUSH  DX     
          INC   CX      
          CMP   AX, 0     
          JNE .Dloop1     
    
.Dloop2:  POP   DX      
          ADD   DX, 30H     
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

;--------------------FINDMAX FUN

FINDMAX PROC
        DEC AX
        CMP AX,00
        JE  FINISH
        
        SUB SI,02H
        SUB DI,02H
        
        MOV DX,[SI]
        CMP DX,[DI]
        JG  OVER
        JL  SWAP
        JE  AGAIN
        
AGAIN:  CALL FINDMAX
        ADD  SI,02H
        ADD  DI,02H
        
TOOVER: MOV DX,[SI]
        MOV BX,SI
        JMP FINISH
        
TOSWAP: MOV DX,[DI]
        MOV BX,DI
        JMP FINISH

OVER:   ADD SI,02H
        ADD DI,0AH
        JMP TOOVER

SWAP:   MOV SI,DI
        ADD SI,02H
        ADD DI,0AH
        JMP TOSWAP  
                            
        
FINISH: RET
FINDMAX ENDP                 
        


;--------------------CALC FUN

CALC    PROC
        MOV     SI,OFFSET   OP1
        MOV     DI,OFFSET   OP2
        SUB     DX,DX
        SUB     AX,AX
        SUB     BX,BX
        MOV     CX,04H
        ADD     SI,06H
        ADD     DI,06H
        MOV     DX,[SI]  ;LET DX = MAX
LOP1:   CMP     DX,[DI]        
        JG      GREATER
        JL      LESS
        JE      EQUAL
        
LESS:   MOV     SI,DI
        MOV     DX,[SI]
        ADD     DI,08H
        LOOP    LOP1
        MOV     BX,SI
        JMP     TERM
        
GREATER:ADD     DI,08H
        LOOP    LOP1
        MOV     BX,SI
        JMP     TERM
        
EQUAL:  MOV     AX,04H
        CALL    FINDMAX
        LOOP    LOP1
                      
        
        
TERM:   
        SUB     BX,06H
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
