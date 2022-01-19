
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 14,745600 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _flag=R4
	.DEF _flag_msb=R5
	.DEF _hour=R7
	.DEF _mint=R6
	.DEF _sec=R9
	.DEF _day=R8
	.DEF _month=R11
	.DEF _year=R10
	.DEF _sem=R13
	.DEF _rx_wr_index=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
_batman:
	.DB  0x2A,0x0,0x10,0x0,0x0,0x0,0x4,0x4
	.DB  0xC,0xC,0x1C,0x3C,0xFC,0xFC,0xFC,0xFC
	.DB  0xFC,0xFC,0xFC,0xF0,0xE0,0xE0,0xE0,0xFC
	.DB  0xF0,0xFC,0xE0,0xE0,0xE0,0xF0,0xFC,0xFC
	.DB  0xFC,0xFC,0xFC,0xFC,0xFC,0x3C,0x1C,0xC
	.DB  0xC,0x4,0x4,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x3,0x3
	.DB  0x3,0x3,0x3,0x3,0x3,0x3,0x7,0x7
	.DB  0xF,0x1F,0x7F,0x1F,0xF,0x7,0x7,0x3
	.DB  0x3,0x3,0x3,0x3,0x3,0x3,0x3,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_icon:
	.DB  0xF,0x0,0x20,0x0,0x0,0x0,0x0,0x0
	.DB  0xFE,0x7,0x3,0x3,0x3,0x7,0xFE,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0xFF
	.DB  0x0,0xFC,0xFE,0xFC,0x0,0xFF,0x0,0x0
	.DB  0x0,0x0,0xC0,0xE0,0x30,0x98,0xCF,0xE0
	.DB  0xFF,0xFF,0xFF,0xE0,0xCF,0x98,0x30,0xE0
	.DB  0xC0,0xF,0x1F,0x30,0x67,0xCF,0x9F,0x9F
	.DB  0x9F,0x9F,0x9F,0xCF,0x67,0x30,0x1F,0xF
_cel:
	.DB  0x11,0x0,0x1F,0x0,0xFC,0xFE,0x3E,0x3F
	.DB  0x3F,0x3F,0x3F,0x3F,0x3F,0x3F,0x3F,0x3F
	.DB  0x3F,0x3F,0x3E,0xFE,0xFC,0xFF,0xFF,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xFF,0xFF,0x1F
	.DB  0x7F,0x7C,0x7C,0x7C,0x7C,0x7C,0x6C,0x44
	.DB  0x6C,0x7C,0x7C,0x7C,0x7C,0x7C,0x7F,0x1F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G105:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G105:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x3:
	.DB  0xF4,0x1
_0x4:
	.DB  0xD4,0xFE
_0x0:
	.DB  0xA,0x42,0x6C,0x75,0x65,0x74,0x6F,0x6F
	.DB  0x74,0x68,0xA,0x43,0x6F,0x6E,0x65,0x78
	.DB  0x61,0x6F,0xA,0x4F,0x4B,0x2E,0x2E,0x2E
	.DB  0x0,0xA,0x20,0x20,0x49,0x6E,0x69,0x63
	.DB  0x69,0x61,0x6E,0x64,0x6F,0x20,0xA,0x20
	.DB  0x20,0x20,0x44,0x6F,0x77,0x6E,0x6C,0x6F
	.DB  0x61,0x64,0x2E,0x2E,0x0,0xA,0x20,0x20
	.DB  0x44,0x6F,0x77,0x6E,0x6C,0x6F,0x61,0x64
	.DB  0x20,0xA,0x20,0x20,0x20,0x43,0x6F,0x6E
	.DB  0x63,0x6C,0x75,0x69,0x64,0x6F,0x21,0x0
_0x2160060:
	.DB  0x1
_0x2160000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x19
	.DW  _0x25
	.DW  _0x0*2

	.DW  0x1C
	.DW  _0x25+25
	.DW  _0x0*2+25

	.DW  0x1B
	.DW  _0x25+53
	.DW  _0x0*2+53

	.DW  0x01
	.DW  __seed_G10B
	.DW  _0x2160060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : DataLogger
;Version : 1.0
;Date    : 07/07/2016
;Author  : Bleno
;Company : Hewlett-Packard
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 14,745600 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;
;
;Graphic LCD initialization
;The PCD8544 connections are specified in the
;Project|Configure|C Compiler|Libraries|Graphic LCD menu:
;SDIN - PORTC Bit 3
;SCLK - PORTC Bit 5
;D /C - PORTC Bit 4
;/SCE - PORTC Bit 2
;/RES - PORTC Bit 1
;
;I2C Bus initialization
;I2C Port: PORTB
;I2C SDA bit: 0
;I2C SCL bit: 1
;
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// I2C Bus functions
;#include <i2c.h>
;
;// LM75 Temperature Sensor functions
;#include <lm75.h>
;
;// DS1307 Real Time Clock functions
;#include <ds1307.h>
;
;// Graphic LCD functions
;#include <glcd.h>
;
;// Font used for displaying text
;// on the graphic LCD
;#include <font5x7.h>
;
;//FUNÇOES EXTRAS
;#include <delay.h>
;#include "batman.h"
;#include "icon.h"
;#include "iconmin.h"
;#include "iconmax.h"
;#include "iron.h"
;#include "save.h"
;#include "cel.h"
;
;unsigned int flag=0;
;unsigned char hour, mint, sec, day, month, year, sem, msg[18],msgmin[8], msgmax[8], temp[7];
;unsigned int i=0, z, tempmin=500, tempmax=-300, q=0, y=0, comando;

	.DSEG
;
;
;char teste[];
;
;// Function used for reading image
;// data from external memory
;unsigned char read_ext_memory(GLCDMEMADDR_t addr)
; 0000 004E {

	.CSEG
; 0000 004F unsigned char data;
; 0000 0050 // Place your code here
; 0000 0051 
; 0000 0052 return data;
;	addr -> Y+1
;	data -> R17
; 0000 0053 }
;
;// Function used for writing image
;// data to external memory
;void write_ext_memory(GLCDMEMADDR_t addr, unsigned char data)
; 0000 0058 {
; 0000 0059 // Place your code here
; 0000 005A 
; 0000 005B }
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 008E {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	RCALL SUBOPT_0x0
; 0000 008F char status,data;
; 0000 0090 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0091 data=UDR;
	IN   R16,12
; 0000 0092 flag=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0093 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x5
; 0000 0094    {
; 0000 0095    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0096 #if RX_BUFFER_SIZE == 256
; 0000 0097    // special case for receiver buffer size=256
; 0000 0098    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0099 #else
; 0000 009A    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0x6
	CLR  R12
; 0000 009B    if (++rx_counter == RX_BUFFER_SIZE)
_0x6:
	LDS  R26,_rx_counter
	SUBI R26,-LOW(1)
	STS  _rx_counter,R26
	CPI  R26,LOW(0x8)
	BRNE _0x7
; 0000 009C       {
; 0000 009D       rx_counter=0;
	LDI  R30,LOW(0)
	STS  _rx_counter,R30
; 0000 009E       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 009F       }
; 0000 00A0 #endif
; 0000 00A1    }
_0x7:
; 0000 00A2 }
_0x5:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x40
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 00A9 {
_getchar:
; .FSTART _getchar
; 0000 00AA char data;
; 0000 00AB while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x8:
	LDS  R30,_rx_counter
	CPI  R30,0
	BREQ _0x8
; 0000 00AC data=rx_buffer[rx_rd_index++];
	LDS  R30,_rx_rd_index
	SUBI R30,-LOW(1)
	STS  _rx_rd_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 00AD #if RX_BUFFER_SIZE != 256
; 0000 00AE if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDS  R26,_rx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0xB
	LDI  R30,LOW(0)
	STS  _rx_rd_index,R30
; 0000 00AF #endif
; 0000 00B0 #asm("cli")
_0xB:
	cli
; 0000 00B1 --rx_counter;
	LDS  R30,_rx_counter
	SUBI R30,LOW(1)
	STS  _rx_counter,R30
; 0000 00B2 #asm("sei")
	sei
; 0000 00B3 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 00B4 }
; .FEND
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 00C4 {
_usart_tx_isr:
; .FSTART _usart_tx_isr
	RCALL SUBOPT_0x0
; 0000 00C5 if (tx_counter)
	RCALL SUBOPT_0x1
	CPI  R30,0
	BREQ _0xC
; 0000 00C6    {
; 0000 00C7    --tx_counter;
	RCALL SUBOPT_0x1
	SUBI R30,LOW(1)
	STS  _tx_counter,R30
; 0000 00C8    UDR=tx_buffer[tx_rd_index++];
	LDS  R30,_tx_rd_index
	SUBI R30,-LOW(1)
	STS  _tx_rd_index,R30
	RCALL SUBOPT_0x2
	LD   R30,Z
	OUT  0xC,R30
; 0000 00C9 #if TX_BUFFER_SIZE != 256
; 0000 00CA    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDS  R26,_tx_rd_index
	CPI  R26,LOW(0x8)
	BRNE _0xD
	LDI  R30,LOW(0)
	STS  _tx_rd_index,R30
; 0000 00CB #endif
; 0000 00CC    }
_0xD:
; 0000 00CD }
_0xC:
_0x40:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00D4 {
_putchar:
; .FSTART _putchar
; 0000 00D5 while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0xE:
	LDS  R26,_tx_counter
	CPI  R26,LOW(0x8)
	BREQ _0xE
; 0000 00D6 #asm("cli")
	cli
; 0000 00D7 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	RCALL SUBOPT_0x1
	CPI  R30,0
	BRNE _0x12
	SBIC 0xB,5
	RJMP _0x11
_0x12:
; 0000 00D8    {
; 0000 00D9    tx_buffer[tx_wr_index++]=c;
	LDS  R30,_tx_wr_index
	SUBI R30,-LOW(1)
	STS  _tx_wr_index,R30
	RCALL SUBOPT_0x2
	LD   R26,Y
	STD  Z+0,R26
; 0000 00DA #if TX_BUFFER_SIZE != 256
; 0000 00DB    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDS  R26,_tx_wr_index
	CPI  R26,LOW(0x8)
	BRNE _0x14
	LDI  R30,LOW(0)
	STS  _tx_wr_index,R30
; 0000 00DC #endif
; 0000 00DD    ++tx_counter;
_0x14:
	RCALL SUBOPT_0x1
	SUBI R30,-LOW(1)
	STS  _tx_counter,R30
; 0000 00DE    }
; 0000 00DF else
	RJMP _0x15
_0x11:
; 0000 00E0    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00E1 #asm("sei")
_0x15:
	sei
; 0000 00E2 }
	RJMP _0x218000C
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;// Declare your global variables here
;unsigned char comand;
;
;//FUNÇÃO PARA RECEBER A HORA E O DIA DO RTC E TRANSFORMAR EM CARACTER DA ASCII
;void horaDia()
; 0000 00ED {
_horaDia:
; .FSTART _horaDia
; 0000 00EE     rtc_get_time(&hour,&mint,&sec);
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	RCALL _rtc_get_time
; 0000 00EF     msg[0]=(hour/10)+48;
	MOV  R26,R7
	RCALL SUBOPT_0x4
	STS  _msg,R30
; 0000 00F0     msg[1]=(hour%10)+48;
	MOV  R26,R7
	RCALL SUBOPT_0x5
	__PUTB1MN _msg,1
; 0000 00F1     msg[2]=':';
	LDI  R30,LOW(58)
	__PUTB1MN _msg,2
; 0000 00F2     msg[3]=(mint/10)+48;
	MOV  R26,R6
	RCALL SUBOPT_0x4
	__PUTB1MN _msg,3
; 0000 00F3     msg[4]=(mint%10)+48;
	MOV  R26,R6
	RCALL SUBOPT_0x5
	__PUTB1MN _msg,4
; 0000 00F4     msg[5]=':';
	LDI  R30,LOW(58)
	__PUTB1MN _msg,5
; 0000 00F5     msg[6]=(sec/10)+48;
	MOV  R26,R9
	RCALL SUBOPT_0x4
	__PUTB1MN _msg,6
; 0000 00F6     msg[7]=(sec%10)+48;
	MOV  R26,R9
	RCALL SUBOPT_0x5
	__PUTB1MN _msg,7
; 0000 00F7 
; 0000 00F8     rtc_get_date(&sem,&day,&month,&year);
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL _rtc_get_date
; 0000 00F9     msg[8]=(day/10)+48;
	MOV  R26,R8
	RCALL SUBOPT_0x4
	__PUTB1MN _msg,8
; 0000 00FA     msg[9]=(day%10)+48;
	MOV  R26,R8
	RCALL SUBOPT_0x5
	__PUTB1MN _msg,9
; 0000 00FB     msg[10]='/';
	LDI  R30,LOW(47)
	__PUTB1MN _msg,10
; 0000 00FC     msg[11]=(month/10)+48;
	MOV  R26,R11
	RCALL SUBOPT_0x4
	__PUTB1MN _msg,11
; 0000 00FD     msg[12]=(month%10)+48;
	MOV  R26,R11
	RCALL SUBOPT_0x5
	__PUTB1MN _msg,12
; 0000 00FE     msg[13]='/';
	LDI  R30,LOW(47)
	__PUTB1MN _msg,13
; 0000 00FF     msg[14]=2+48;
	LDI  R30,LOW(50)
	__PUTB1MN _msg,14
; 0000 0100     msg[15]=48;
	LDI  R30,LOW(48)
	__PUTB1MN _msg,15
; 0000 0101     msg[16]=((year%100)/10)+48;
	MOV  R26,R10
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x6
	__PUTB1MN _msg,16
; 0000 0102     msg[17]=(year%10)+48;
	MOV  R26,R10
	RCALL SUBOPT_0x5
	__PUTB1MN _msg,17
; 0000 0103 
; 0000 0104 }
	RET
; .FEND
;
;//FUNÇÃO PARA RECEBER A TEMPERATURA DO LM75
;void tempt()
; 0000 0108 {
_tempt:
; .FSTART _tempt
; 0000 0109     int temperatura;
; 0000 010A     temp[0]=' ';   //sinal da temperatura
	RCALL __SAVELOCR2
;	temperatura -> R16,R17
	LDI  R30,LOW(32)
	STS  _temp,R30
; 0000 010B     temperatura=lm75_temperature_10(0);  //recebe a temperatura do lm75 multiplicada por 10
	LDI  R26,LOW(0)
	RCALL _lm75_temperature_10
	MOVW R16,R30
; 0000 010C /*
; 0000 010D     if(tempmax<temperatura)
; 0000 010E     {
; 0000 010F         tempmax=temperatura;
; 0000 0110         rtc_get_time(&hour,&mint,&sec);
; 0000 0111         msgmax[0]=(hour/10)+48;
; 0000 0112         msgmax[1]=(hour%10)+48;
; 0000 0113         msgmax[2]=':';
; 0000 0114         msgmax[3]=(mint/10)+48;
; 0000 0115         msgmax[4]=(mint%10)+48;
; 0000 0116         msgmax[5]=':';
; 0000 0117         msgmax[6]=(sec/10)+48;
; 0000 0118         msgmax[7]=(sec%10)+48;
; 0000 0119     }
; 0000 011A 
; 0000 011B 
; 0000 011C     if(tempmin>temperatura)
; 0000 011D     {
; 0000 011E         tempmin=temperatura;
; 0000 011F         rtc_get_time(&hour,&mint,&sec);
; 0000 0120         msgmin[0]=(hour/10)+48;
; 0000 0121         msgmin[1]=(hour%10)+48;
; 0000 0122         msgmin[2]=':';
; 0000 0123         msgmin[3]=(mint/10)+48;
; 0000 0124         msgmin[4]=(mint%10)+48;
; 0000 0125         msgmin[5]=':';
; 0000 0126         msgmin[6]=(sec/10)+48;
; 0000 0127         msgmin[7]=(sec%10)+48;
; 0000 0128     }
; 0000 0129  */
; 0000 012A 
; 0000 012B    if(temperatura<0) //sinal negativo caso temperatura <0
	TST  R17
	BRPL _0x16
; 0000 012C     {
; 0000 012D         temp[0]='-';
	LDI  R30,LOW(45)
	STS  _temp,R30
; 0000 012E         temperatura=-temperatura;
	MOVW R30,R16
	RCALL __ANEGW1
	MOVW R16,R30
; 0000 012F     }
; 0000 0130     if(temperatura<100)
_0x16:
	__CPWRN 16,17,100
	BRGE _0x17
; 0000 0131     temp[1]=' ';
	LDI  R30,LOW(32)
	RJMP _0x3F
; 0000 0132     else
_0x17:
; 0000 0133     temp[1]=(temperatura/100)+48;
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	SUBI R30,-LOW(48)
_0x3F:
	__PUTB1MN _temp,1
; 0000 0134 
; 0000 0135     temp[2]=((temperatura%100)/10)+48;
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x6
	__PUTB1MN _temp,2
; 0000 0136     temp[3]='.';
	LDI  R30,LOW(46)
	__PUTB1MN _temp,3
; 0000 0137     temp[4]=(temperatura%10)+48;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	SUBI R30,-LOW(48)
	__PUTB1MN _temp,4
; 0000 0138     temp[5]=' ';
	LDI  R30,LOW(32)
	__PUTB1MN _temp,5
; 0000 0139     temp[6]='C';
	LDI  R30,LOW(67)
	__PUTB1MN _temp,6
; 0000 013A 
; 0000 013B }
	RJMP _0x218000D
; .FEND
;
;
;//FUNÇÃO PARA SALVAR NA EEPROM
;void save()
; 0000 0140 {
_save:
; .FSTART _save
; 0000 0141     int p=0;
; 0000 0142     horaDia();
	RCALL __SAVELOCR2
;	p -> R16,R17
	RCALL SUBOPT_0x7
	RCALL _horaDia
; 0000 0143     q=y+8;
	RCALL SUBOPT_0x8
	ADIW R30,8
	RCALL SUBOPT_0x9
; 0000 0144     while(y<q)
_0x19:
	RCALL SUBOPT_0xA
	BRSH _0x1B
; 0000 0145     {
; 0000 0146         teste[y]=msg[p];
	RCALL SUBOPT_0xB
	MOVW R0,R30
	LDI  R26,LOW(_msg)
	LDI  R27,HIGH(_msg)
	RCALL SUBOPT_0xC
; 0000 0147         y++;
	RCALL SUBOPT_0xD
; 0000 0148         p++;
	RCALL SUBOPT_0xE
; 0000 0149     }
	RJMP _0x19
_0x1B:
; 0000 014A 
; 0000 014B     teste[y]=' ';
	RCALL SUBOPT_0xB
	LDI  R26,LOW(32)
	STD  Z+0,R26
; 0000 014C     y++;
	RCALL SUBOPT_0xD
; 0000 014D 
; 0000 014E     tempt();
	RCALL _tempt
; 0000 014F     q=y+7;
	RCALL SUBOPT_0x8
	ADIW R30,7
	RCALL SUBOPT_0x9
; 0000 0150     p=0;
	RCALL SUBOPT_0x7
; 0000 0151     while(y<q)
_0x1C:
	RCALL SUBOPT_0xA
	BRSH _0x1E
; 0000 0152     {
; 0000 0153         teste[y]=temp[p];
	RCALL SUBOPT_0xB
	MOVW R0,R30
	LDI  R26,LOW(_temp)
	LDI  R27,HIGH(_temp)
	RCALL SUBOPT_0xC
; 0000 0154         p++;
	RCALL SUBOPT_0xE
; 0000 0155         y++;
	RCALL SUBOPT_0xD
; 0000 0156     }
	RJMP _0x1C
_0x1E:
; 0000 0157 
; 0000 0158     teste[y]='\n';
	RCALL SUBOPT_0xB
	LDI  R26,LOW(10)
	STD  Z+0,R26
; 0000 0159     y++;
	RCALL SUBOPT_0xD
; 0000 015A 
; 0000 015B }
	RJMP _0x218000D
; .FEND
;
;//FUNÇÃO PARA ENVIAR OS DADOS PELO BLUETOOTH
;void send()
; 0000 015F {
_send:
; .FSTART _send
; 0000 0160     int z=0;
; 0000 0161     for(i=8;i<18;i++)
	RCALL __SAVELOCR2
;	z -> R16,R17
	RCALL SUBOPT_0x7
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _i,R30
	STS  _i+1,R31
_0x20:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,18
	BRSH _0x21
; 0000 0162     {
; 0000 0163         putchar(msg[i]);
	LDS  R30,_i
	LDS  R31,_i+1
	RCALL SUBOPT_0xF
	RCALL _putchar
; 0000 0164     }
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	RCALL SUBOPT_0x10
	RJMP _0x20
_0x21:
; 0000 0165     putchar('\n');
	LDI  R26,LOW(10)
	RCALL _putchar
; 0000 0166 
; 0000 0167     while(z<q)
_0x22:
	LDS  R30,_q
	LDS  R31,_q+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x24
; 0000 0168     {
; 0000 0169         putchar(teste[z]);
	LDI  R26,LOW(_teste)
	LDI  R27,HIGH(_teste)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RCALL _putchar
; 0000 016A         z++;
	RCALL SUBOPT_0xE
; 0000 016B     }
	RJMP _0x22
_0x24:
; 0000 016C }
_0x218000D:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;
;//FUNÇÃO PARA TRATAR A INTERRUPÇÃO VINDA DO BLUETOOTH
;void interrup(char k)
; 0000 0171 {
_interrup:
; .FSTART _interrup
; 0000 0172     comand=k;
	ST   -Y,R26
;	k -> Y+0
	LD   R30,Y
	STS  _comand,R30
; 0000 0173     glcd_clear();
	RCALL _glcd_clear
; 0000 0174     glcd_outtext("\nBluetooth\nConexao\nOK...");
	__POINTW2MN _0x25,0
	RCALL _glcd_outtext
; 0000 0175     glcd_putimagef(65,5,cel, GLCD_PUTCOPY);
	LDI  R30,LOW(65)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(_cel*2)
	LDI  R31,HIGH(_cel*2)
	RCALL SUBOPT_0x11
; 0000 0176     delay_ms(2000);
	RCALL SUBOPT_0x12
; 0000 0177     if(comand=='a')
	LDS  R26,_comand
	CPI  R26,LOW(0x61)
	BRNE _0x26
; 0000 0178     {
; 0000 0179         glcd_clear();
	RCALL _glcd_clear
; 0000 017A         glcd_outtextxy(0,10,"\n  Iniciando \n   Download..");
	RCALL SUBOPT_0x13
	__POINTW2MN _0x25,25
	RCALL _glcd_outtextxy
; 0000 017B         delay_ms(2000);
	RCALL SUBOPT_0x12
; 0000 017C 
; 0000 017D         send();
	RCALL _send
; 0000 017E 
; 0000 017F         glcd_outtextxy(0,10,"\n  Download \n   Concluido!");
	RCALL SUBOPT_0x13
	__POINTW2MN _0x25,53
	RCALL _glcd_outtextxy
; 0000 0180         delay_ms(2000);
	RCALL SUBOPT_0x12
; 0000 0181     }
; 0000 0182 
; 0000 0183     comand='0';
_0x26:
	LDI  R30,LOW(48)
	STS  _comand,R30
; 0000 0184 }
	RJMP _0x218000C
; .FEND

	.DSEG
_0x25:
	.BYTE 0x50
;
;
;void main(void)
; 0000 0188 {

	.CSEG
_main:
; .FSTART _main
; 0000 0189 // Declare your local variables here
; 0000 018A int j=0, w=0, a;
; 0000 018B char k, sign, hourprox;
; 0000 018C 
; 0000 018D // Graphic LCD initialization data
; 0000 018E GLCDINIT_t glcd_init_data;
; 0000 018F 
; 0000 0190 // Input/Output Ports initialization
; 0000 0191 // Port B initialization
; 0000 0192 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0193 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0194 PORTB=0x00;
	SBIW R28,11
;	j -> R16,R17
;	w -> R18,R19
;	a -> R20,R21
;	k -> Y+10
;	sign -> Y+9
;	hourprox -> Y+8
;	glcd_init_data -> Y+0
	RCALL SUBOPT_0x7
	__GETWRN 18,19,0
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0195 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0196 
; 0000 0197 // Port C initialization
; 0000 0198 // Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0199 // State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 019A PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 019B DDRC=0x7F;
	LDI  R30,LOW(127)
	OUT  0x14,R30
; 0000 019C 
; 0000 019D // Port D initialization
; 0000 019E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 019F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01A0 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 01A1 DDRD=0x00;
	OUT  0x11,R30
; 0000 01A2 
; 0000 01A3 // Timer/Counter 0 initialization
; 0000 01A4 // Clock source: System Clock
; 0000 01A5 // Clock value: Timer 0 Stopped
; 0000 01A6 TCCR0=0x00;
	OUT  0x33,R30
; 0000 01A7 TCNT0=0x00;
	OUT  0x32,R30
; 0000 01A8 
; 0000 01A9 // Timer/Counter 1 initialization
; 0000 01AA // Clock source: System Clock
; 0000 01AB // Clock value: Timer1 Stopped
; 0000 01AC // Mode: Normal top=0xFFFF
; 0000 01AD // OC1A output: Discon.
; 0000 01AE // OC1B output: Discon.
; 0000 01AF // Noise Canceler: Off
; 0000 01B0 // Input Capture on Falling Edge
; 0000 01B1 // Timer1 Overflow Interrupt: Off
; 0000 01B2 // Input Capture Interrupt: Off
; 0000 01B3 // Compare A Match Interrupt: Off
; 0000 01B4 // Compare B Match Interrupt: Off
; 0000 01B5 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01B6 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 01B7 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 01B8 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01B9 ICR1H=0x00;
	OUT  0x27,R30
; 0000 01BA ICR1L=0x00;
	OUT  0x26,R30
; 0000 01BB OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01BC OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01BD OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01BE OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01BF 
; 0000 01C0 // Timer/Counter 2 initialization
; 0000 01C1 // Clock source: System Clock
; 0000 01C2 // Clock value: Timer2 Stopped
; 0000 01C3 // Mode: Normal top=0xFF
; 0000 01C4 // OC2 output: Disconnected
; 0000 01C5 ASSR=0x00;
	OUT  0x22,R30
; 0000 01C6 TCCR2=0x00;
	OUT  0x25,R30
; 0000 01C7 TCNT2=0x00;
	OUT  0x24,R30
; 0000 01C8 OCR2=0x00;
	OUT  0x23,R30
; 0000 01C9 
; 0000 01CA // External Interrupt(s) initialization
; 0000 01CB // INT0: Off
; 0000 01CC // INT1: Off
; 0000 01CD MCUCR=0x00;
	OUT  0x35,R30
; 0000 01CE 
; 0000 01CF // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01D0 TIMSK=0x00;
	OUT  0x39,R30
; 0000 01D1 
; 0000 01D2 // USART initialization
; 0000 01D3 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01D4 // USART Receiver: On
; 0000 01D5 // USART Transmitter: On
; 0000 01D6 // USART Mode: Asynchronous
; 0000 01D7 // USART Baud Rate: 19200
; 0000 01D8 UCSRA=0x00;
	OUT  0xB,R30
; 0000 01D9 UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 01DA UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01DB UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01DC UBRRL=0x2F;
	LDI  R30,LOW(47)
	OUT  0x9,R30
; 0000 01DD 
; 0000 01DE // Analog Comparator initialization
; 0000 01DF // Analog Comparator: Off
; 0000 01E0 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01E1 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01E2 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01E3 
; 0000 01E4 // ADC initialization
; 0000 01E5 // ADC disabled
; 0000 01E6 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 01E7 
; 0000 01E8 // SPI initialization
; 0000 01E9 // SPI disabled
; 0000 01EA SPCR=0x00;
	OUT  0xD,R30
; 0000 01EB 
; 0000 01EC // TWI initialization
; 0000 01ED // TWI disabled
; 0000 01EE TWCR=0x00;
	OUT  0x36,R30
; 0000 01EF 
; 0000 01F0 // I2C Bus initialization
; 0000 01F1 // I2C Port: PORTB
; 0000 01F2 // I2C SDA bit: 0
; 0000 01F3 // I2C SCL bit: 1
; 0000 01F4 // Bit Rate: 100 kHz
; 0000 01F5 // Note: I2C settings are specified in the
; 0000 01F6 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 01F7 i2c_init();
	RCALL _i2c_init
; 0000 01F8 
; 0000 01F9 // LM75 Temperature Sensor initialization
; 0000 01FA // thyst: -10°C
; 0000 01FB // tos: 50°C
; 0000 01FC // O.S. polarity: 0
; 0000 01FD lm75_init(0,-10,50,0);
	RCALL SUBOPT_0x14
	LDI  R30,LOW(246)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lm75_init
; 0000 01FE 
; 0000 01FF // DS1307 Real Time Clock initialization
; 0000 0200 // Square wave output on pin SQW/OUT: Off
; 0000 0201 // SQW/OUT pin state: 0
; 0000 0202 rtc_init(0,0,0);
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x14
	LDI  R26,LOW(0)
	RCALL _rtc_init
; 0000 0203 
; 0000 0204 
; 0000 0205 // Specify the current font for displaying text
; 0000 0206 glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0207 // No function is used for reading
; 0000 0208 // image data from external memory
; 0000 0209 glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 020A // No function is used for writing
; 0000 020B // image data to external memory
; 0000 020C glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 020D // Set the LCD temperature coefficient
; 0000 020E glcd_init_data.temp_coef=PCD8544_DEFAULT_TEMP_COEF;
	LDD  R30,Y+6
	ANDI R30,LOW(0xFC)
	STD  Y+6,R30
; 0000 020F // Set the LCD bias
; 0000 0210 glcd_init_data.bias=PCD8544_DEFAULT_BIAS;
	ANDI R30,LOW(0xE3)
	ORI  R30,LOW(0xC)
	STD  Y+6,R30
; 0000 0211 // Set the LCD contrast control voltage VLCD
; 0000 0212 glcd_init_data.vlcd=PCD8544_DEFAULT_VLCD;
	LDD  R30,Y+7
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x32)
	STD  Y+7,R30
; 0000 0213 
; 0000 0214 glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 0215 
; 0000 0216  //AJUSTANDO RTC
; 0000 0217 
; 0000 0218 //day=25;
; 0000 0219 //month=07;
; 0000 021A //year=16;
; 0000 021B //rtc_set_time(16,11,10);
; 0000 021C //rtc_set_date(00,day,month,year);
; 0000 021D 
; 0000 021E 
; 0000 021F 
; 0000 0220 
; 0000 0221 // Global enable interrupts
; 0000 0222 #asm("sei")
	sei
; 0000 0223 
; 0000 0224 while (1)
_0x27:
; 0000 0225       {
; 0000 0226       horaDia();
	RCALL SUBOPT_0x15
; 0000 0227       hourprox=msg[4]+1;
	SUBI R30,-LOW(1)
	STD  Y+8,R30
; 0000 0228       pcd8544_setvlcd(63); //Ajusta o Contraste
	LDI  R26,LOW(63)
	RCALL _pcd8544_setvlcd
; 0000 0229 
; 0000 022A       //INICIALIZAÇAO
; 0000 022B         /*
; 0000 022C                 // MODO IRON MAN
; 0000 022D       if(j==0)
; 0000 022E       {
; 0000 022F           glcd_setfont(font5x7);
; 0000 0230           j=1;
; 0000 0231           glcd_clear();
; 0000 0232           glcd_outtextxy(20,10,"WELCOME\n\n TO DATALOGGER");
; 0000 0233           delay_ms(2000);
; 0000 0234 
; 0000 0235           while(i<84)
; 0000 0236           {
; 0000 0237             glcd_clear();
; 0000 0238             glcd_putimagef(i,0,iron, GLCD_PUTCOPY);
; 0000 0239             delay_ms(200);
; 0000 023A             i++;
; 0000 023B 
; 0000 023C           }
; 0000 023D 
; 0000 023E       };   */
; 0000 023F 
; 0000 0240 
; 0000 0241       //RELOGIO MODO BATMAN
; 0000 0242 
; 0000 0243       j=0;
	RCALL SUBOPT_0x7
; 0000 0244       while(j<12)
_0x2A:
	__CPWRN 16,17,12
	BRLT PC+2
	RJMP _0x2C
; 0000 0245         {
; 0000 0246             horaDia();
	RCALL SUBOPT_0x15
; 0000 0247             if(hourprox==msg[4] && w==0)
	LDD  R26,Y+8
	CP   R30,R26
	BRNE _0x2E
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BREQ _0x2F
_0x2E:
	RJMP _0x2D
_0x2F:
; 0000 0248             {
; 0000 0249                 save();
	RCALL _save
; 0000 024A                 w=1;
	__GETWRN 18,19,1
; 0000 024B             }
; 0000 024C             if(flag==1)
_0x2D:
	RCALL SUBOPT_0x16
	BRNE _0x30
; 0000 024D             {
; 0000 024E                 k=getchar();
	RCALL SUBOPT_0x17
; 0000 024F                 interrup(k);
; 0000 0250                 flag=0;
; 0000 0251             }
; 0000 0252           glcd_clear();
_0x30:
	RCALL _glcd_clear
; 0000 0253           glcd_putimagef(44,0,batman, GLCD_PUTCOPY);
	LDI  R30,LOW(44)
	ST   -Y,R30
	RCALL SUBOPT_0x14
	LDI  R30,LOW(_batman*2)
	LDI  R31,HIGH(_batman*2)
	RCALL SUBOPT_0x11
; 0000 0254 
; 0000 0255           horaDia();
	RCALL _horaDia
; 0000 0256 
; 0000 0257           //HORA
; 0000 0258             a=18;
	__GETWRN 20,21,18
; 0000 0259             for(z=0;z<8;z++)
	LDI  R30,LOW(0)
	STS  _z,R30
	STS  _z+1,R30
_0x32:
	RCALL SUBOPT_0x18
	SBIW R26,8
	BRSH _0x33
; 0000 025A             {
; 0000 025B                 glcd_putcharxy(a,18,msg[z]);
	ST   -Y,R20
	LDI  R30,LOW(18)
	RCALL SUBOPT_0x19
	RCALL _glcd_putcharxy
; 0000 025C                 a=a+6;
	__ADDWRN 20,21,6
; 0000 025D             }
	LDI  R26,LOW(_z)
	LDI  R27,HIGH(_z)
	RCALL SUBOPT_0x10
	RJMP _0x32
_0x33:
; 0000 025E 
; 0000 025F 
; 0000 0260           //DIA
; 0000 0261             a=14;
	__GETWRN 20,21,14
; 0000 0262             for(z=8;z<18;z++)
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _z,R30
	STS  _z+1,R31
_0x35:
	RCALL SUBOPT_0x18
	SBIW R26,18
	BRSH _0x36
; 0000 0263             {
; 0000 0264                 glcd_putcharxy(a,30,msg[z]);
	ST   -Y,R20
	LDI  R30,LOW(30)
	RCALL SUBOPT_0x19
	RCALL _glcd_putcharxy
; 0000 0265                 a=a+6;
	__ADDWRN 20,21,6
; 0000 0266             }
	LDI  R26,LOW(_z)
	LDI  R27,HIGH(_z)
	RCALL SUBOPT_0x10
	RJMP _0x35
_0x36:
; 0000 0267 
; 0000 0268           delay_ms(500);
	RCALL SUBOPT_0x1A
; 0000 0269           j++;
; 0000 026A         }
	RJMP _0x2A
_0x2C:
; 0000 026B 
; 0000 026C 
; 0000 026D       //TESTE DE CONTRASTE
; 0000 026E       /*
; 0000 026F       while(i<127)
; 0000 0270       {
; 0000 0271        pcd8544_setvlcd(i);
; 0000 0272        j=(char)i;
; 0000 0273        glcd_putcharxy(30, 31, j);
; 0000 0274        delay_ms(300);
; 0000 0275        i++;
; 0000 0276       }  */
; 0000 0277 
; 0000 0278 
; 0000 0279       //DISQUETE
; 0000 027A       /*
; 0000 027B       glcd_clear();
; 0000 027C       glcd_putimagef(0,0,save, GLCD_PUTCOPY);
; 0000 027D       delay_ms(4000);   */
; 0000 027E 
; 0000 027F 
; 0000 0280       //TERMOMETRO IMPLEMENTADO
; 0000 0281 
; 0000 0282       j=0;
	RCALL SUBOPT_0x7
; 0000 0283       while(j<16)
_0x37:
	__CPWRN 16,17,16
	BRLT PC+2
	RJMP _0x39
; 0000 0284         {
; 0000 0285              horaDia();
	RCALL SUBOPT_0x15
; 0000 0286 
; 0000 0287             if(hourprox==msg[4] && w==0)
	LDD  R26,Y+8
	CP   R30,R26
	BRNE _0x3B
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BREQ _0x3C
_0x3B:
	RJMP _0x3A
_0x3C:
; 0000 0288             {
; 0000 0289                 save();
	RCALL _save
; 0000 028A                 w=1;
	__GETWRN 18,19,1
; 0000 028B             }
; 0000 028C 
; 0000 028D             if(flag==1)
_0x3A:
	RCALL SUBOPT_0x16
	BRNE _0x3D
; 0000 028E             {
; 0000 028F                 k=getchar();
	RCALL SUBOPT_0x17
; 0000 0290                 interrup(k);
; 0000 0291                 flag=0;
; 0000 0292             }
; 0000 0293             glcd_clear();
_0x3D:
	RCALL _glcd_clear
; 0000 0294 
; 0000 0295             tempt();
	RCALL _tempt
; 0000 0296 
; 0000 0297             glcd_putcharxy(10,20,temp[0]);
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x1B
	LDS  R26,_temp
	RCALL _glcd_putcharxy
; 0000 0298             glcd_putcharxy(16,20,temp[1]);  //+6    PRIMEIRO NUMERO DA TEMPERATURA
	LDI  R30,LOW(16)
	RCALL SUBOPT_0x1B
	__GETB2MN _temp,1
	RCALL _glcd_putcharxy
; 0000 0299             glcd_putcharxy(22,20,temp[2]);  //+6    SEGUNDO NUMERO DA TEMPERATURA
	LDI  R30,LOW(22)
	RCALL SUBOPT_0x1B
	__GETB2MN _temp,2
	RCALL _glcd_putcharxy
; 0000 029A             glcd_putcharxy(27,21,temp[3]);    //+5
	LDI  R30,LOW(27)
	ST   -Y,R30
	LDI  R30,LOW(21)
	ST   -Y,R30
	__GETB2MN _temp,3
	RCALL _glcd_putcharxy
; 0000 029B             glcd_putcharxy(31,20,temp[4]);   //+4   TERCEIRO NUMERO DA TEMPERATURA
	LDI  R30,LOW(31)
	RCALL SUBOPT_0x1B
	__GETB2MN _temp,4
	RCALL _glcd_putcharxy
; 0000 029C             glcd_putcharxy(36,20,temp[5]);
	LDI  R30,LOW(36)
	RCALL SUBOPT_0x1B
	__GETB2MN _temp,5
	RCALL _glcd_putcharxy
; 0000 029D             glcd_putcharxy(42,20,temp[6]);     //+11
	LDI  R30,LOW(42)
	RCALL SUBOPT_0x1B
	__GETB2MN _temp,6
	RCALL _glcd_putcharxy
; 0000 029E 
; 0000 029F             glcd_putimagef(60,7,icon, GLCD_PUTCOPY);
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(_icon*2)
	LDI  R31,HIGH(_icon*2)
	RCALL SUBOPT_0x11
; 0000 02A0 
; 0000 02A1 
; 0000 02A2 
; 0000 02A3             delay_ms(500);
	RCALL SUBOPT_0x1A
; 0000 02A4             j++;
; 0000 02A5         }
	RJMP _0x37
_0x39:
; 0000 02A6 
; 0000 02A7       w=0;
	__GETWRN 18,19,0
; 0000 02A8       }
	RJMP _0x27
; 0000 02A9 }
_0x3E:
	RJMP _0x3E
; .FEND

	.CSEG
_lm75_set_temp_G100:
; .FSTART _lm75_set_temp_G100
	ST   -Y,R26
	RCALL _i2c_start
	LDD  R26,Y+2
	RCALL _i2c_write
	LDD  R26,Y+1
	RCALL _i2c_write
	LD   R26,Y
	RCALL SUBOPT_0x1C
	RCALL _i2c_stop
	RJMP _0x2180002
; .FEND
_lm75_init:
; .FSTART _lm75_init
	RCALL SUBOPT_0x1D
	LDD  R30,Y+4
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1F
	RCALL _i2c_write
	LDD  R30,Y+1
	LSL  R30
	LSL  R30
	MOV  R26,R30
	RCALL _i2c_write
	RCALL _i2c_stop
	ST   -Y,R17
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _lm75_set_temp_G100
	ST   -Y,R17
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _lm75_set_temp_G100
	LDD  R17,Y+0
	RJMP _0x2180004
; .FEND
_lm75_temperature_10:
; .FSTART _lm75_temperature_10
	ST   -Y,R26
	SBIW R28,2
	ST   -Y,R17
	LDD  R30,Y+3
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1C
	RCALL _i2c_start
	SUBI R17,-LOW(1)
	MOV  R26,R17
	RCALL SUBOPT_0x1F
	RCALL _i2c_read
	STD  Y+2,R30
	LDI  R26,LOW(0)
	RCALL _i2c_read
	STD  Y+1,R30
	RCALL _i2c_stop
	RCALL SUBOPT_0x20
	LDI  R30,LOW(7)
	RCALL __ASRW12
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	RCALL __MULW12
	LDD  R17,Y+0
	RJMP _0x2180001
; .FEND

	.CSEG
_rtc_init:
; .FSTART _rtc_init
	ST   -Y,R26
	LDD  R30,Y+2
	ANDI R30,LOW(0x3)
	STD  Y+2,R30
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2020003
	LDD  R30,Y+2
	ORI  R30,0x10
	STD  Y+2,R30
_0x2020003:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x2020004
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
_0x2020004:
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RCALL _i2c_write
	LDI  R26,LOW(7)
	RCALL _i2c_write
	LDD  R26,Y+2
	RCALL _i2c_write
	RCALL _i2c_stop
	RJMP _0x2180002
; .FEND
_rtc_get_time:
; .FSTART _rtc_get_time
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x26
	ST   X,R30
	RCALL _i2c_stop
	RJMP _0x218000A
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	RCALL SUBOPT_0x21
	RCALL _i2c_write
	LDI  R26,LOW(3)
	RCALL _i2c_write
	RCALL SUBOPT_0x22
	RCALL _i2c_read
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x27
	ST   X,R30
	RCALL _i2c_stop
	RJMP _0x2180007
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_pcd8544_delay_G102:
; .FSTART _pcd8544_delay_G102
	RET
; .FEND
_pcd8544_wrbus_G102:
; .FSTART _pcd8544_wrbus_G102
	RCALL SUBOPT_0x1D
	CBI  0x15,2
	LDI  R17,LOW(8)
_0x2040004:
	RCALL _pcd8544_delay_G102
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	BREQ _0x2040006
	SBI  0x15,3
	RJMP _0x2040007
_0x2040006:
	CBI  0x15,3
_0x2040007:
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
	RCALL _pcd8544_delay_G102
	SBI  0x15,5
	RCALL _pcd8544_delay_G102
	CBI  0x15,5
	SUBI R17,LOW(1)
	BRNE _0x2040004
	SBI  0x15,2
	LDD  R17,Y+0
	RJMP _0x2180003
; .FEND
_pcd8544_wrcmd:
; .FSTART _pcd8544_wrcmd
	ST   -Y,R26
	CBI  0x15,4
	LD   R26,Y
	RCALL _pcd8544_wrbus_G102
	RJMP _0x218000C
; .FEND
_pcd8544_wrdata_G102:
; .FSTART _pcd8544_wrdata_G102
	ST   -Y,R26
	SBI  0x15,4
	LD   R26,Y
	RCALL _pcd8544_wrbus_G102
	RJMP _0x218000C
; .FEND
_pcd8544_setaddr_G102:
; .FSTART _pcd8544_setaddr_G102
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x28
	MOV  R17,R30
	LDI  R30,LOW(84)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	RCALL SUBOPT_0x29
	STS  _gfx_addr_G102,R30
	STS  _gfx_addr_G102+1,R31
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2180002
; .FEND
_pcd8544_gotoxy:
; .FSTART _pcd8544_gotoxy
	ST   -Y,R26
	LDD  R30,Y+1
	RCALL SUBOPT_0x2A
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_setaddr_G102
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	RJMP _0x2180003
; .FEND
_pcd8544_rdbyte:
; .FSTART _pcd8544_rdbyte
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _pcd8544_gotoxy
	LDS  R30,_gfx_addr_G102
	LDS  R31,_gfx_addr_G102+1
	RCALL SUBOPT_0x2B
	LD   R30,Z
	RJMP _0x2180003
; .FEND
_pcd8544_wrbyte:
; .FSTART _pcd8544_wrbyte
	ST   -Y,R26
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	LD   R26,Y
	STD  Z+0,R26
	RCALL _pcd8544_wrdata_G102
	RJMP _0x218000C
; .FEND
_glcd_init:
; .FSTART _glcd_init
	RCALL SUBOPT_0x2E
	RCALL __SAVELOCR4
	SBI  0x14,2
	SBI  0x15,2
	SBI  0x14,5
	CBI  0x15,5
	SBI  0x14,3
	SBI  0x14,4
	SBI  0x14,1
	CBI  0x15,1
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
	SBI  0x15,1
	RCALL SUBOPT_0x2F
	SBIW R30,0
	BREQ _0x2040008
	RCALL SUBOPT_0x2F
	LDD  R30,Z+6
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	RCALL SUBOPT_0x2F
	LDD  R30,Z+6
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x7)
	MOV  R16,R30
	RCALL SUBOPT_0x2F
	LDD  R30,Z+7
	ANDI R30,0x7F
	MOV  R19,R30
	RCALL SUBOPT_0x26
	RCALL __GETW1P
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x26
	ADIW R26,2
	RCALL __GETW1P
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x26
	ADIW R26,4
	RCALL __GETW1P
	RJMP _0x20400A0
_0x2040008:
	LDI  R17,LOW(0)
	LDI  R16,LOW(3)
	LDI  R19,LOW(50)
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x32
_0x20400A0:
	__PUTW1MN _glcd_state,27
	LDI  R26,LOW(33)
	RCALL _pcd8544_wrcmd
	MOV  R30,R17
	ORI  R30,4
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R16
	ORI  R30,0x10
	MOV  R26,R30
	RCALL _pcd8544_wrcmd
	MOV  R30,R19
	RCALL SUBOPT_0x2A
	LDI  R26,LOW(32)
	RCALL _pcd8544_wrcmd
	LDI  R26,LOW(1)
	RCALL _glcd_display
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	RCALL SUBOPT_0x3
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	RCALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	RCALL __LOADLOCR4
	RJMP _0x218000A
; .FEND
_pcd8544_setvlcd:
; .FSTART _pcd8544_setvlcd
	ST   -Y,R26
	LDI  R26,LOW(33)
	RCALL _pcd8544_wrcmd
	LD   R30,Y
	RCALL SUBOPT_0x2A
	LDI  R26,LOW(32)
	RJMP _0x218000B
; .FEND
_glcd_display:
; .FSTART _glcd_display
	ST   -Y,R26
	LD   R30,Y
	CPI  R30,0
	BREQ _0x204000A
	LDI  R30,LOW(12)
	RJMP _0x204000B
_0x204000A:
	LDI  R30,LOW(8)
_0x204000B:
	MOV  R26,R30
_0x218000B:
	RCALL _pcd8544_wrcmd
_0x218000C:
	ADIW R28,1
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	RCALL __SAVELOCR4
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x204000D
	LDI  R19,LOW(255)
_0x204000D:
	RCALL SUBOPT_0x14
	LDI  R26,LOW(0)
	RCALL _pcd8544_gotoxy
	__GETWRN 16,17,504
_0x204000E:
	MOVW R30,R16
	__SUBWRN 16,17,1
	SBIW R30,0
	BREQ _0x2040010
	MOV  R26,R19
	RCALL _pcd8544_wrbyte
	RJMP _0x204000E
_0x2040010:
	RCALL SUBOPT_0x14
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	RCALL __LOADLOCR4
	RJMP _0x2180001
; .FEND
_pcd8544_wrmasked_G102:
; .FSTART _pcd8544_wrmasked_G102
	RCALL SUBOPT_0x1D
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _pcd8544_rdbyte
	MOV  R17,R30
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2040020
	CPI  R30,LOW(0x8)
	BRNE _0x2040021
_0x2040020:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x2040022
_0x2040021:
	CPI  R30,LOW(0x3)
	BRNE _0x2040024
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2040025
_0x2040024:
	CPI  R30,0
	BRNE _0x2040026
_0x2040025:
_0x2040022:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2040027
_0x2040026:
	CPI  R30,LOW(0x2)
	BRNE _0x2040028
_0x2040027:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x204001E
_0x2040028:
	CPI  R30,LOW(0x1)
	BRNE _0x2040029
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x204001E
_0x2040029:
	CPI  R30,LOW(0x4)
	BRNE _0x204001E
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x204001E:
	MOV  R26,R17
	RCALL _pcd8544_wrbyte
	LDD  R17,Y+0
_0x218000A:
	ADIW R28,6
	RET
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	RCALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x54)
	BRSH _0x204002C
	LDD  R26,Y+15
	CPI  R26,LOW(0x30)
	BRSH _0x204002C
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x204002C
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x204002B
_0x204002C:
	RJMP _0x2180009
_0x204002B:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	RCALL SUBOPT_0x33
	CPI  R26,LOW(0x55)
	LDI  R30,HIGH(0x55)
	CPC  R27,R30
	BRLO _0x204002E
	LDD  R26,Y+16
	LDI  R30,LOW(84)
	SUB  R30,R26
	STD  Y+14,R30
_0x204002E:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	RCALL SUBOPT_0x33
	SBIW R26,49
	BRLO _0x204002F
	LDD  R26,Y+15
	LDI  R30,LOW(48)
	SUB  R30,R26
	STD  Y+13,R30
_0x204002F:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x2040030
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x2040034
	RJMP _0x2180009
_0x2040034:
	CPI  R30,LOW(0x3)
	BRNE _0x2040037
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2040036
	RJMP _0x2180009
_0x2040036:
_0x2040037:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2040039
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2040038
_0x2040039:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	RCALL SUBOPT_0x34
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x35
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x204003B:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x204003D
	MOV  R17,R16
_0x204003E:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2040040
	RCALL SUBOPT_0x36
	RJMP _0x204003E
_0x2040040:
	RJMP _0x204003B
_0x204003D:
_0x2040038:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x2040041
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x35
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x2040042
	SUBI R19,-LOW(1)
_0x2040042:
	LDI  R18,LOW(0)
_0x2040043:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2040045
	LDD  R17,Y+14
_0x2040046:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2040048
	RCALL SUBOPT_0x36
	RJMP _0x2040046
_0x2040048:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x35
	RJMP _0x2040043
_0x2040045:
_0x2040041:
_0x2040030:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2040049:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x204004B
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x35
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x204004C
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x204004D
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x2040052
	CPI  R30,LOW(0x3)
	BRNE _0x2040053
_0x2040052:
	RJMP _0x2040054
_0x2040053:
	CPI  R30,LOW(0x7)
	BRNE _0x2040055
_0x2040054:
	RJMP _0x2040056
_0x2040055:
	CPI  R30,LOW(0x8)
	BRNE _0x2040057
_0x2040056:
	RJMP _0x2040058
_0x2040057:
	CPI  R30,LOW(0x9)
	BRNE _0x2040059
_0x2040058:
	RJMP _0x204005A
_0x2040059:
	CPI  R30,LOW(0xA)
	BRNE _0x204005B
_0x204005A:
	RCALL SUBOPT_0x37
	RCALL _pcd8544_gotoxy
	RJMP _0x2040050
_0x204005B:
	CPI  R30,LOW(0x6)
	BRNE _0x2040050
	RCALL SUBOPT_0x37
	RCALL _pcd8544_setaddr_G102
_0x2040050:
_0x204005D:
	PUSH R17
	RCALL SUBOPT_0x38
	POP  R26
	CP   R26,R30
	BRSH _0x204005F
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x2040060
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	LD   R26,Z
	RCALL _glcd_writemem
	RJMP _0x2040061
_0x2040060:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2040065
	LDI  R21,LOW(0)
	RJMP _0x2040066
_0x2040065:
	CPI  R30,LOW(0xA)
	BRNE _0x2040064
	LDI  R21,LOW(255)
	RJMP _0x2040066
_0x2040064:
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x3A
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x204006D
	CPI  R30,LOW(0x8)
	BRNE _0x204006E
_0x204006D:
_0x2040066:
	RCALL SUBOPT_0x3B
	MOV  R21,R30
	RJMP _0x204006F
_0x204006E:
	CPI  R30,LOW(0x3)
	BRNE _0x2040071
	COM  R21
	RJMP _0x2040072
_0x2040071:
	CPI  R30,0
	BRNE _0x2040074
_0x2040072:
_0x204006F:
	MOV  R26,R21
	RCALL _pcd8544_wrdata_G102
	RJMP _0x204006B
_0x2040074:
	RCALL SUBOPT_0x3C
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _pcd8544_wrmasked_G102
_0x204006B:
_0x2040061:
	RJMP _0x204005D
_0x204005F:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2040075
_0x204004D:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2040076
_0x204004C:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2040077
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2040078
_0x2040077:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2040078:
	ST   -Y,R19
	MOV  R26,R18
	RCALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x204007C
	RCALL SUBOPT_0x37
	RCALL _pcd8544_setaddr_G102
_0x204007D:
	PUSH R17
	RCALL SUBOPT_0x38
	POP  R26
	CP   R26,R30
	BRSH _0x204007F
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSRB12
	RCALL SUBOPT_0x3D
	MOV  R30,R19
	MOV  R26,R20
	RCALL __LSRB12
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3
	MOV  R26,R21
	RCALL _glcd_writemem
	RJMP _0x204007D
_0x204007F:
	RJMP _0x204007B
_0x204007C:
	CPI  R30,LOW(0x9)
	BRNE _0x2040080
	LDI  R21,LOW(0)
	RJMP _0x2040081
_0x2040080:
	CPI  R30,LOW(0xA)
	BRNE _0x2040087
	LDI  R21,LOW(255)
_0x2040081:
	RCALL SUBOPT_0x3B
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSLB12
	MOV  R21,R30
_0x2040084:
	PUSH R17
	RCALL SUBOPT_0x38
	POP  R26
	CP   R26,R30
	BRSH _0x2040086
	RCALL SUBOPT_0x3C
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G102
	RJMP _0x2040084
_0x2040086:
	RJMP _0x204007B
_0x2040087:
_0x2040088:
	PUSH R17
	RCALL SUBOPT_0x38
	POP  R26
	CP   R26,R30
	BRSH _0x204008A
	RCALL SUBOPT_0x3F
	MOV  R26,R30
	MOV  R30,R19
	RCALL __LSLB12
	RCALL SUBOPT_0x40
	RJMP _0x2040088
_0x204008A:
_0x204007B:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x204008B
	RJMP _0x204004B
_0x204008B:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x204008C
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20400A1
_0x204008C:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20400A1:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x35
_0x2040076:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2040091
	RCALL SUBOPT_0x37
	RCALL _pcd8544_setaddr_G102
_0x2040092:
	PUSH R17
	RCALL SUBOPT_0x38
	POP  R26
	CP   R26,R30
	BRSH _0x2040094
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	LD   R30,Z
	AND  R30,R20
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSLB12
	RCALL SUBOPT_0x3D
	MOV  R30,R18
	MOV  R26,R20
	RCALL __LSLB12
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3
	MOV  R26,R21
	RCALL _glcd_writemem
	RJMP _0x2040092
_0x2040094:
	RJMP _0x2040090
_0x2040091:
	CPI  R30,LOW(0x9)
	BRNE _0x2040095
	LDI  R21,LOW(0)
	RJMP _0x2040096
_0x2040095:
	CPI  R30,LOW(0xA)
	BRNE _0x204009C
	LDI  R21,LOW(255)
_0x2040096:
	RCALL SUBOPT_0x3B
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSRB12
	MOV  R21,R30
_0x2040099:
	PUSH R17
	RCALL SUBOPT_0x38
	POP  R26
	CP   R26,R30
	BRSH _0x204009B
	RCALL SUBOPT_0x3C
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _pcd8544_wrmasked_G102
	RJMP _0x2040099
_0x204009B:
	RJMP _0x2040090
_0x204009C:
_0x204009D:
	PUSH R17
	RCALL SUBOPT_0x38
	POP  R26
	CP   R26,R30
	BRSH _0x204009F
	RCALL SUBOPT_0x3F
	MOV  R26,R30
	MOV  R30,R18
	RCALL __LSRB12
	RCALL SUBOPT_0x40
	RJMP _0x204009D
_0x204009F:
_0x2040090:
_0x2040075:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x29
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2040049
_0x204004B:
_0x2180009:
	RCALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x27
	RCALL __CPW02
	BRLT _0x2060003
	RCALL SUBOPT_0x32
	RJMP _0x2180003
_0x2060003:
	RCALL SUBOPT_0x27
	CPI  R26,LOW(0x54)
	LDI  R30,HIGH(0x54)
	CPC  R27,R30
	BRLT _0x2060004
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	RJMP _0x2180003
_0x2060004:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2180003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	RCALL SUBOPT_0x2E
	RCALL SUBOPT_0x27
	RCALL __CPW02
	BRLT _0x2060005
	RCALL SUBOPT_0x32
	RJMP _0x2180003
_0x2060005:
	RCALL SUBOPT_0x27
	SBIW R26,48
	BRLT _0x2060006
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	RJMP _0x2180003
_0x2060006:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2180003
; .FEND
_glcd_imagesize:
; .FSTART _glcd_imagesize
	RCALL SUBOPT_0x1D
	LDD  R26,Y+2
	CPI  R26,LOW(0x54)
	BRSH _0x2060008
	LDD  R26,Y+1
	CPI  R26,LOW(0x30)
	BRLO _0x2060007
_0x2060008:
	RCALL SUBOPT_0x41
	LDD  R17,Y+0
	RJMP _0x2180002
_0x2060007:
	LDD  R30,Y+1
	ANDI R30,LOW(0x7)
	MOV  R17,R30
	RCALL SUBOPT_0x28
	STD  Y+1,R30
	CPI  R17,0
	BREQ _0x206000A
	SUBI R30,-LOW(1)
	STD  Y+1,R30
_0x206000A:
	LDD  R26,Y+2
	CLR  R27
	CLR  R24
	CLR  R25
	LDD  R30,Y+1
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __MULD12U
	__ADDD1N 4
	LDD  R17,Y+0
	RJMP _0x2180002
; .FEND
_glcd_getcharw_G103:
; .FSTART _glcd_getcharw_G103
	RCALL SUBOPT_0x2E
	SBIW R28,3
	RCALL SUBOPT_0x42
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x206000B
	RCALL SUBOPT_0x32
	RJMP _0x2180008
_0x206000B:
	RCALL SUBOPT_0x43
	LPM  R0,Z
	STD  Y+7,R0
	RCALL SUBOPT_0x43
	LPM  R0,Z
	STD  Y+6,R0
	RCALL SUBOPT_0x43
	LPM  R0,Z
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x206000C
	RCALL SUBOPT_0x32
	RJMP _0x2180008
_0x206000C:
	RCALL SUBOPT_0x43
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x206000D
	RCALL SUBOPT_0x32
	RJMP _0x2180008
_0x206000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x206000E
	SUBI R20,-LOW(1)
_0x206000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x206000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	RCALL SUBOPT_0x34
	MOVW R26,R30
	MOV  R30,R20
	RCALL SUBOPT_0x34
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x2180008
_0x206000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2060010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2060012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	RCALL SUBOPT_0x34
	__ADDWRR 16,17,30,31
	RJMP _0x2060010
_0x2060012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x2180008:
	RCALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G103:
; .FSTART _glcd_new_line_G103
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x33
	__GETB1MN _glcd_state,7
	RCALL SUBOPT_0x33
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	RCALL SUBOPT_0x42
	SBIW R30,0
	BRNE PC+2
	RJMP _0x206001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2060020
	RJMP _0x2060021
_0x2060020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G103
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2060022
	RJMP _0x2180006
_0x2060022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	RCALL SUBOPT_0x29
	MOVW R16,R30
	__CPWRN 16,17,85
	BRLO _0x2060023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G103
_0x2060023:
	__GETB1MN _glcd_state,2
	RCALL SUBOPT_0x45
	LDD  R30,Y+8
	ST   -Y,R30
	RCALL SUBOPT_0x44
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	RCALL SUBOPT_0x45
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	RCALL SUBOPT_0x44
	ST   -Y,R30
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x46
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	RCALL SUBOPT_0x44
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	ST   -Y,R30
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x46
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2060024
_0x2060021:
	RCALL _glcd_new_line_G103
	RJMP _0x2180006
_0x2060024:
_0x206001F:
	__PUTBMRN _glcd_state,2,16
_0x2180006:
	RCALL __LOADLOCR6
_0x2180007:
	ADIW R28,8
	RET
; .FEND
_glcd_putcharxy:
; .FSTART _glcd_putcharxy
	ST   -Y,R26
	LDD  R30,Y+2
	ST   -Y,R30
	LDD  R26,Y+2
	RCALL _glcd_moveto
	LD   R26,Y
	RCALL _glcd_putchar
	RJMP _0x2180002
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	RCALL SUBOPT_0x2E
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2060025:
	RCALL SUBOPT_0x47
	BREQ _0x2060027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2060025
_0x2060027:
	LDD  R17,Y+0
	RJMP _0x2180004
; .FEND
_glcd_outtext:
; .FSTART _glcd_outtext
	RCALL SUBOPT_0x2E
	ST   -Y,R17
_0x206002E:
	RCALL SUBOPT_0x47
	BREQ _0x2060030
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x206002E
_0x2060030:
	LDD  R17,Y+0
	RJMP _0x2180002
; .FEND
_glcd_putimagef:
; .FSTART _glcd_putimagef
	ST   -Y,R26
	RCALL __SAVELOCR4
	LDD  R26,Y+4
	CPI  R26,LOW(0x5)
	BRSH _0x2060038
	RCALL SUBOPT_0x48
	LPM  R16,Z+
	RCALL SUBOPT_0x49
	LPM  R17,Z+
	RCALL SUBOPT_0x49
	LPM  R18,Z+
	RCALL SUBOPT_0x49
	LPM  R19,Z+
	STD  Y+5,R30
	STD  Y+5+1,R31
	LDD  R30,Y+8
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	ST   -Y,R16
	ST   -Y,R18
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0x3
	LDD  R26,Y+11
	RCALL _glcd_block
	ST   -Y,R16
	MOV  R26,R18
	RCALL _glcd_imagesize
	RJMP _0x2180005
_0x2060038:
	RCALL SUBOPT_0x41
_0x2180005:
	RCALL __LOADLOCR4
	ADIW R28,9
	RET
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RJMP _0x2180003
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	RCALL SUBOPT_0x2E
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2180004:
	ADIW R28,5
	RET
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	RCALL __LSLB12
_0x2180003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	RCALL SUBOPT_0x1D
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x2100007
	CPI  R30,LOW(0xA)
	BRNE _0x2100008
_0x2100007:
	LDS  R17,_glcd_state
	RJMP _0x2100009
_0x2100008:
	CPI  R30,LOW(0x9)
	BRNE _0x210000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x2100009
_0x210000B:
	CPI  R30,LOW(0x8)
	BRNE _0x2100005
	__GETBRMN 17,_glcd_state,16
_0x2100009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x210000E
	CPI  R17,0
	BREQ _0x210000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2180002
_0x210000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2180002
_0x210000E:
	CPI  R17,0
	BRNE _0x2100011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2180002
_0x2100011:
_0x2100005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2180002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	RCALL SUBOPT_0x2E
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x2100015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2180002
_0x2100015:
	CPI  R30,LOW(0x2)
	BRNE _0x2100016
	RCALL SUBOPT_0x27
	RCALL __EEPROMRDB
	RJMP _0x2180002
_0x2100016:
	CPI  R30,LOW(0x3)
	BRNE _0x2100018
	RCALL SUBOPT_0x27
	__CALL1MN _glcd_state,25
	RJMP _0x2180002
_0x2100018:
	RCALL SUBOPT_0x27
	LD   R30,X
_0x2180002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x210001C
	LD   R30,Y
	RCALL SUBOPT_0x20
	ST   X,R30
	RJMP _0x210001B
_0x210001C:
	CPI  R30,LOW(0x2)
	BRNE _0x210001D
	LD   R30,Y
	RCALL SUBOPT_0x20
	RCALL __EEPROMWRB
	RJMP _0x210001B
_0x210001D:
	CPI  R30,LOW(0x3)
	BRNE _0x210001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL SUBOPT_0x3
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x210001B:
_0x2180001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_msg:
	.BYTE 0x12
_temp:
	.BYTE 0x7
_i:
	.BYTE 0x2
_z:
	.BYTE 0x2
_q:
	.BYTE 0x2
_y:
	.BYTE 0x2
_teste:
	.BYTE 0x1
_rx_buffer:
	.BYTE 0x8
_rx_rd_index:
	.BYTE 0x1
_rx_counter:
	.BYTE 0x1
_tx_buffer:
	.BYTE 0x8
_tx_wr_index:
	.BYTE 0x1
_tx_rd_index:
	.BYTE 0x1
_tx_counter:
	.BYTE 0x1
_comand:
	.BYTE 0x1
_gfx_addr_G102:
	.BYTE 0x2
_gfx_buffer_G102:
	.BYTE 0x1F8
__seed_G10B:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDS  R30,_tx_counter
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x4:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	SUBI R30,-LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	SUBI R30,-LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	SUBI R30,-LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8:
	LDS  R30,_y
	LDS  R31,_y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	STS  _q,R30
	STS  _q+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDS  R30,_q
	LDS  R31,_q+1
	LDS  R26,_y
	LDS  R27,_y+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0x8
	SUBI R30,LOW(-_teste)
	SBCI R31,HIGH(-_teste)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_y)
	LDI  R27,HIGH(_y)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	SUBI R30,LOW(-_msg)
	SBCI R31,HIGH(-_msg)
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x10:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0x3
	LDI  R26,LOW(0)
	RJMP _glcd_putimagef

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	RCALL _horaDia
	__GETB1MN _msg,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	RCALL _getchar
	STD  Y+10,R30
	LDD  R26,Y+10
	RCALL _interrup
	CLR  R4
	CLR  R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDS  R26,_z
	LDS  R27,_z+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	ST   -Y,R30
	LDS  R30,_z
	LDS  R31,_z+1
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1B:
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	RCALL _i2c_write
	LDI  R26,LOW(0)
	RJMP _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	ST   -Y,R26
	ST   -Y,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LSL  R30
	ORI  R30,LOW(0x90)
	MOV  R17,R30
	RCALL _i2c_start
	MOV  R26,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	RCALL _i2c_write
	LDI  R26,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	ST   -Y,R27
	ST   -Y,R26
	RCALL _i2c_start
	LDI  R26,LOW(208)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	RCALL _i2c_stop
	RCALL _i2c_start
	LDI  R26,LOW(209)
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x23:
	RCALL _i2c_read
	MOV  R26,R30
	RJMP _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	ST   X,R30
	LDI  R26,LOW(1)
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDD  R30,Y+1
	LSR  R30
	LSR  R30
	LSR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	ORI  R30,0x80
	MOV  R26,R30
	RJMP _pcd8544_wrcmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	SUBI R30,LOW(-_gfx_buffer_G102)
	SBCI R31,HIGH(-_gfx_buffer_G102)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(_gfx_addr_G102)
	LDI  R27,HIGH(_gfx_addr_G102)
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	SBIW R30,1
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	__PUTW1MN _glcd_state,25
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDI  R31,0
	RCALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x35:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x36:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RCALL SUBOPT_0x3
	LDI  R26,LOW(0)
	RJMP _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	ST   -Y,R16
	LDD  R26,Y+16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x38:
	SUBI R17,-1
	LDD  R30,Y+14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x39:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3A:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	RJMP _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3B:
	ST   -Y,R21
	LDD  R26,Y+10
	RJMP _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3C:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3D:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	RCALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	COM  R30
	AND  R30,R1
	OR   R21,R30
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3F:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RJMP _pcd8544_wrmasked_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x42:
	RCALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	MOVW R30,R16
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x44:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x3
	LDI  R26,LOW(9)
	RJMP _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	RCALL SUBOPT_0x20
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x49:
	STD  Y+5,R30
	STD  Y+5+1,R31
	RJMP SUBOPT_0x48


	.CSEG
	.equ __sda_bit=0
	.equ __scl_bit=1
	.equ __i2c_port=0x18 ;PORTB
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,25
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,49
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
