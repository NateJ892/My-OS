[BITS 16]				;Tells NASM To Produce 16 BIT Code
[ORG 0x7C00]			;Set NASM Data Addresses

Start:					;Start Function
XOR AX, AX				;Zero AX Register
MOV DS, AX				;Move 0 into DS from AX register
MOV ES, AX				;Move 0 into ES from AX register
MOV BX, 0x8000			;Move 0x8000 into BX for stack

MOV SS, BX				;Stack Setup
MOV SP, AX				;Stack Setup

DiskOperationStart:		;DiskOperationStart Point
MOV AH, 0x00			;Subfunction 0
INT 0x13				;BIOS Interupt 13
JC DiskOperationStart	;If Error Retry At DiskOperationStart

MOV AX, 0x00			;Temp for ES
MOV ES, AX				;Set Data Buffer For ES
MOV BX, 0x1000			;Set Data Buffer for RAM

MOV AH, 0x02			;Subfunction 2
MOV AL, 1				;Read 1 Sector (512 bytes)
MOV CH, 0				;Disk Setup
MOV CL, 2				;Read The Second Sector
MOV DH, 0				;Disk Setup
INT 0x13				;BIOS Interupt 13
JC DiskOperationStart	;Error? Jump Back To DiskOperationStart

JMP 0x0:0x1000			;Jump To RAM Location

TIMES 510-($-$$) DB 0	;Fill To 510 bytes
DW 0xAA55				;Fill last 2 bytes with Magic Boot Number