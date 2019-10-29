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
MOV AL, [SI]									;Move Byte From SI Pointer
INC SI											;Shift SI Register To Next Byte
OR AL, AL										;Compare AL With Itself If Empty Will Return Zero
JZ Exit											;If Zero From OR Jump To Exit
CALL PrintChar									;Otherwise Print The Character
JMP PrintString									;Loop To PrintString
Exit:											;Exit Point
RET												;Return Process

EnterPM:
MOV AX, 0x2401
XOR AH, AH
INT 0x15
JC EnterPM

MOV AX, 0x03
INT 0x10

CLI
LGDT [GDT_POINTER]
MOV EAX, CR0
OR EAX, CR0
MOV CR0, EAX									;Switch To PM
STI


GDT_START:										;Global Table
	DQ 0x0
GDT_CODE:
	DW 0xFFFF
	DW 0x0
	DB 0x0
	DB 10011010b
	DB 11001111b
	DB 0x0
GDT_DATA:
	DW 0xFFFF
	DW 0x0
	DB 0x0
	DB 10010010b
	DB 11001111b
	DB 0x0
GDT_END:

GDT_POINTER:
	DW GDT_END - GDT_START
	DD GDT_START
CODE_SEG equ GDT_CODE - GDT_START
DATA_SEG equ GDT_DATA - GDT_START



Hello DB 'Hello World From Kernel!',0x0D,0		;Hello String

TIMES 512-($-$$) DB 0							;Fill To 512 Bytes