[BITS 16]										;Tells NASM To Produce 16 BIT Code
[ORG 0x1000]									;NASM Address Location Reference

MOV SI, Hello									;Point SI register to Hello String
CALL PrintString								;CALL PrintString
CLI												;Disable CPU Interupts
JMP $											;Halt Computer

PrintChar:										;PrintChar Point
MOV AH, 0x0E									;0E Subfunction
MOV BH, 0x00									;Set Page Number To Zero
MOV BL, 0x0F									;Set Black Background And White Foreground For Text
INT 0x10										;CALL Interupt 10

PrintString:									;PrintString Point
MOV AL, [SI]									;Move 1 Byte From SI
INC SI											;Shift SI Register To Next Byte
OR AL, AL										;Compare AL With Itself If Empty Will Return Zero
JZ Exit											;If Zero From OR Jump To Exit
CALL PrintChar									;Otherwise Print The Character
JMP PrintString									;Loop To PrintString
Exit:											;Exit Point
RET												;Return Process

Hello DB 'Hello World From Kernel!',0x0D,0		;Hello String

TIMES 512-($-$$) DB 0							;Fill To 512 Bytes