
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 8,000000 MHz
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
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
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
	.DEF _t1=R7
	.DEF _t2=R6
	.DEF _t3=R9
	.DEF _i=R8
	.DEF _wait_timer1=R11
	.DEF _wait_timer_for_termostat=R10
	.DEF _counter_buzzer=R13
	.DEF _screen=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0010
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x14

_0x3:
	.DB  0x5,0xDD,0x43,0x51,0x99,0x31,0x21,0x5D
	.DB  0x1,0x11,0x85,0x31,0xA3,0xB,0x27,0xE1
	.DB  0xA7,0x89,0xE9,0x2B
_0x4:
	.DB  0xE8,0x3

__GLOBAL_INI_TBL:
	.DW  0x03
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  0x0C
	.DW  __REG_VARS*2

	.DW  0x14
	.DW  _kod_G000
	.DW  _0x3*2

	.DW  0x02
	.DW  _adc
	.DW  _0x4*2

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
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Termostat
;Version : v 3.0
;Date    : 21.04.2018
;Author  : Ivan Peredriy
;Company :
;Comments:
;Термостат  для олимпиады
;
;
;Chip type               : ATmega8A
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
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
;#include <delay.h>
;
;// Declare your global variables here
;
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;#define coeff_beta 15
;#define coeff_alpha 1
;#define N 4
;eeprom signed char P4;
;eeprom signed int P1=20, P2=150;
;eeprom unsigned char P0, P3, P5, P6;
;
;/*
;PD0 = A
;PD1 = F
;PD2 = B
;PD3 = E
;PD4 = D
;PD5 = G
;PD6 = C
;PD7 = H
;*/
;
;unsigned static char kod[20]={0x05, 0xDD, 0x43, 0x51, 0x99, 0x31, 0x21, 0x5D, 0x01, 0x11, 0x85, 0x31, 0xA3, 0x0B, 0x27,  ...

	.DSEG
;unsigned char t1,t2,t3,i;
;unsigned char wait_timer1, wait_timer_for_termostat, counter_buzzer=20;
;signed char screen=0;
;int par, buffer, minus=0, buzzer;
;int adc=1000;
;int filterin, wait_timer2=0, currtemp;
;bit knopka_left, knopka_right, knopka_middle, avariya_datchik_ne_podkluchen=0, show_temp=1, show_termostat=0, show_ustav ...
;P00=0, P01=0, P02=0, P03=0, P04=0, P05=0, P06=0, exit=0, show_par=0, flag_enter=0, OVERHEAT=0, flag_minus=0, flag_perekl ...
;
;int getkodes(signed int x) {
; 0000 003C int getkodes(signed int x) {

	.CSEG
_getkodes:
; .FSTART _getkodes
; 0000 003D  char c1, c2, c3;
; 0000 003E 
; 0000 003F                 c1=x%10;
	ST   -Y,R27
	ST   -Y,R26
	RCALL __SAVELOCR4
;	x -> Y+4
;	c1 -> R17
;	c2 -> R16
;	c3 -> R19
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOV  R17,R30
; 0000 0040                 c2=(x%100)/10;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOV  R16,R30
; 0000 0041                 c3=(x%1000)/100;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOV  R19,R30
; 0000 0042 
; 0000 0043                                 switch(c1) {
	MOV  R30,R17
	RCALL SUBOPT_0x0
; 0000 0044                             case 0: {t1=kod[0]; break;}
	BRNE _0x8
	LDS  R7,_kod_G000
	RJMP _0x7
; 0000 0045                             case 1: {t1=kod[1]; break;}
_0x8:
	RCALL SUBOPT_0x1
	BRNE _0x9
	__GETBRMN 7,_kod_G000,1
	RJMP _0x7
; 0000 0046                             case 2: {t1=kod[2]; break;}
_0x9:
	RCALL SUBOPT_0x2
	BRNE _0xA
	__GETBRMN 7,_kod_G000,2
	RJMP _0x7
; 0000 0047                             case 3: {t1=kod[3]; break;}
_0xA:
	RCALL SUBOPT_0x3
	BRNE _0xB
	__GETBRMN 7,_kod_G000,3
	RJMP _0x7
; 0000 0048                             case 4: {t1=kod[4]; break;}
_0xB:
	RCALL SUBOPT_0x4
	BRNE _0xC
	__GETBRMN 7,_kod_G000,4
	RJMP _0x7
; 0000 0049                             case 5: {t1=kod[5]; break;}
_0xC:
	RCALL SUBOPT_0x5
	BRNE _0xD
	__GETBRMN 7,_kod_G000,5
	RJMP _0x7
; 0000 004A                             case 6: {t1=kod[6]; break;}
_0xD:
	RCALL SUBOPT_0x6
	BRNE _0xE
	__GETBRMN 7,_kod_G000,6
	RJMP _0x7
; 0000 004B                             case 7: {t1=kod[7]; break;}
_0xE:
	RCALL SUBOPT_0x7
	BRNE _0xF
	__GETBRMN 7,_kod_G000,7
	RJMP _0x7
; 0000 004C                             case 8: {t1=kod[8]; break;}
_0xF:
	RCALL SUBOPT_0x8
	BRNE _0x10
	__GETBRMN 7,_kod_G000,8
	RJMP _0x7
; 0000 004D                             case 9: {t1=kod[9]; break;}
_0x10:
	RCALL SUBOPT_0x9
	BRNE _0x7
	__GETBRMN 7,_kod_G000,9
; 0000 004E                             }
_0x7:
; 0000 004F 
; 0000 0050                                 switch(c2) {
	MOV  R30,R16
	RCALL SUBOPT_0x0
; 0000 0051                             case 0: {t2=kod[0]; break;}
	BRNE _0x15
	RCALL SUBOPT_0xA
	RJMP _0x14
; 0000 0052                             case 1: {t2=kod[1]; break;}
_0x15:
	RCALL SUBOPT_0x1
	BRNE _0x16
	__GETBRMN 6,_kod_G000,1
	RJMP _0x14
; 0000 0053                             case 2: {t2=kod[2]; break;}
_0x16:
	RCALL SUBOPT_0x2
	BRNE _0x17
	__GETBRMN 6,_kod_G000,2
	RJMP _0x14
; 0000 0054                             case 3: {t2=kod[3]; break;}
_0x17:
	RCALL SUBOPT_0x3
	BRNE _0x18
	__GETBRMN 6,_kod_G000,3
	RJMP _0x14
; 0000 0055                             case 4: {t2=kod[4]; break;}
_0x18:
	RCALL SUBOPT_0x4
	BRNE _0x19
	__GETBRMN 6,_kod_G000,4
	RJMP _0x14
; 0000 0056                             case 5: {t2=kod[5]; break;}
_0x19:
	RCALL SUBOPT_0x5
	BRNE _0x1A
	__GETBRMN 6,_kod_G000,5
	RJMP _0x14
; 0000 0057                             case 6: {t2=kod[6]; break;}
_0x1A:
	RCALL SUBOPT_0x6
	BRNE _0x1B
	__GETBRMN 6,_kod_G000,6
	RJMP _0x14
; 0000 0058                             case 7: {t2=kod[7]; break;}
_0x1B:
	RCALL SUBOPT_0x7
	BRNE _0x1C
	__GETBRMN 6,_kod_G000,7
	RJMP _0x14
; 0000 0059                             case 8: {t2=kod[8]; break;}
_0x1C:
	RCALL SUBOPT_0x8
	BRNE _0x1D
	__GETBRMN 6,_kod_G000,8
	RJMP _0x14
; 0000 005A                             case 9: {t2=kod[9]; break;}
_0x1D:
	RCALL SUBOPT_0x9
	BRNE _0x14
	__GETBRMN 6,_kod_G000,9
; 0000 005B                             }
_0x14:
; 0000 005C 
; 0000 005D                                 switch(c3) {
	MOV  R30,R19
	RCALL SUBOPT_0x0
; 0000 005E                             case 0: {t3=kod[0]; break;}
	BRNE _0x22
	RCALL SUBOPT_0xB
	RJMP _0x21
; 0000 005F                             case 1: {t3=kod[1]; break;}
_0x22:
	RCALL SUBOPT_0x1
	BRNE _0x23
	__GETBRMN 9,_kod_G000,1
	RJMP _0x21
; 0000 0060                             case 2: {t3=kod[2]; break;}
_0x23:
	RCALL SUBOPT_0x2
	BRNE _0x24
	__GETBRMN 9,_kod_G000,2
	RJMP _0x21
; 0000 0061                             case 3: {t3=kod[3]; break;}
_0x24:
	RCALL SUBOPT_0x3
	BRNE _0x25
	__GETBRMN 9,_kod_G000,3
	RJMP _0x21
; 0000 0062                             case 4: {t3=kod[4]; break;}
_0x25:
	RCALL SUBOPT_0x4
	BRNE _0x26
	__GETBRMN 9,_kod_G000,4
	RJMP _0x21
; 0000 0063                             case 5: {t3=kod[5]; break;}
_0x26:
	RCALL SUBOPT_0x5
	BRNE _0x27
	__GETBRMN 9,_kod_G000,5
	RJMP _0x21
; 0000 0064                             case 6: {t3=kod[6]; break;}
_0x27:
	RCALL SUBOPT_0x6
	BRNE _0x28
	__GETBRMN 9,_kod_G000,6
	RJMP _0x21
; 0000 0065                             case 7: {t3=kod[7]; break;}
_0x28:
	RCALL SUBOPT_0x7
	BRNE _0x29
	__GETBRMN 9,_kod_G000,7
	RJMP _0x21
; 0000 0066                             case 8: {t3=kod[8]; break;}
_0x29:
	RCALL SUBOPT_0x8
	BRNE _0x2A
	__GETBRMN 9,_kod_G000,8
	RJMP _0x21
; 0000 0067                             case 9: {t3=kod[9]; break;}
_0x2A:
	RCALL SUBOPT_0x9
	BRNE _0x21
	__GETBRMN 9,_kod_G000,9
; 0000 0068                             }
_0x21:
; 0000 0069 
; 0000 006A            return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; 0000 006B 
; 0000 006C }
; .FEND
;
;unsigned int read_adc(unsigned char adc_input)
; 0000 006F {
_read_adc:
; .FSTART _read_adc
; 0000 0070 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0071 delay_us(10);
	__DELAY_USB 27
; 0000 0072 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0073 while ((ADCSRA & (1<<ADIF))==0);
_0x2C:
	SBIS 0x6,4
	RJMP _0x2C
; 0000 0074 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0075 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0076 }
; .FEND
;
;float readtemp()
; 0000 0079 {
_readtemp:
; .FSTART _readtemp
; 0000 007A float temper;
; 0000 007B   if(adc < 10)
	SBIW R28,4
;	temper -> Y+0
	RCALL SUBOPT_0xC
	SBIW R26,10
	BRGE _0x2F
; 0000 007C     {
; 0000 007D      OVERHEAT=1;
	SET
	BLD  R4,2
; 0000 007E     };
_0x2F:
; 0000 007F 
; 0000 0080   if (adc > 17 && adc < 21)
	RCALL SUBOPT_0xC
	SBIW R26,18
	BRLT _0x31
	RCALL SUBOPT_0xC
	SBIW R26,21
	BRLT _0x32
_0x31:
	RJMP _0x30
_0x32:
; 0000 0081     {
; 0000 0082      temper=(145)+(21-adc)*2.22;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	RCALL SUBOPT_0xD
	__GETD2N 0x400E147B
	RCALL __MULF12
	__GETD2N 0x43110000
	RCALL SUBOPT_0xE
; 0000 0083     }
; 0000 0084 
; 0000 0085   if (adc > 20 && adc < 23)
_0x30:
	RCALL SUBOPT_0xC
	SBIW R26,21
	BRLT _0x34
	RCALL SUBOPT_0xC
	SBIW R26,23
	BRLT _0x35
_0x34:
	RJMP _0x33
_0x35:
; 0000 0086     {
; 0000 0087      temper=(140)+(23-adc)*1.93;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	RCALL SUBOPT_0xD
	__GETD2N 0x3FF70A3D
	RCALL __MULF12
	__GETD2N 0x430C0000
	RCALL SUBOPT_0xE
; 0000 0088     }
; 0000 0089 
; 0000 008A   if (adc > 22 && adc < 26)
_0x33:
	RCALL SUBOPT_0xC
	SBIW R26,23
	BRLT _0x37
	RCALL SUBOPT_0xC
	SBIW R26,26
	BRLT _0x38
_0x37:
	RJMP _0x36
_0x38:
; 0000 008B     {
; 0000 008C      temper=(135)+(26-adc)*1.68;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	RCALL SUBOPT_0xD
	__GETD2N 0x3FD70A3D
	RCALL __MULF12
	__GETD2N 0x43070000
	RCALL SUBOPT_0xE
; 0000 008D     }
; 0000 008E 
; 0000 008F   if (adc > 25 && adc < 30)
_0x36:
	RCALL SUBOPT_0xC
	SBIW R26,26
	BRLT _0x3A
	RCALL SUBOPT_0xC
	SBIW R26,30
	BRLT _0x3B
_0x3A:
	RJMP _0x39
_0x3B:
; 0000 0090     {
; 0000 0091      temper=(130)+(30-adc)*1.46;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RCALL SUBOPT_0xD
	__GETD2N 0x3FBAE148
	RCALL __MULF12
	__GETD2N 0x43020000
	RCALL SUBOPT_0xE
; 0000 0092     }
; 0000 0093 
; 0000 0094   if (adc > 29 && adc < 34)
_0x39:
	RCALL SUBOPT_0xC
	SBIW R26,30
	BRLT _0x3D
	RCALL SUBOPT_0xC
	SBIW R26,34
	BRLT _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
; 0000 0095     {
; 0000 0096      temper=(125)+(34-adc)*1.27;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	RCALL SUBOPT_0xD
	__GETD2N 0x3FA28F5C
	RCALL __MULF12
	__GETD2N 0x42FA0000
	RCALL SUBOPT_0xE
; 0000 0097     }
; 0000 0098 
; 0000 0099   if (adc > 33 && adc < 38)
_0x3C:
	RCALL SUBOPT_0xC
	SBIW R26,34
	BRLT _0x40
	RCALL SUBOPT_0xC
	SBIW R26,38
	BRLT _0x41
_0x40:
	RJMP _0x3F
_0x41:
; 0000 009A     {
; 0000 009B      temper=(120)+(38-adc)*1.09;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	RCALL SUBOPT_0xD
	__GETD2N 0x3F8B851F
	RCALL __MULF12
	__GETD2N 0x42F00000
	RCALL SUBOPT_0xE
; 0000 009C     }
; 0000 009D 
; 0000 009E   if (adc > 37 && adc < 43)
_0x3F:
	RCALL SUBOPT_0xC
	SBIW R26,38
	BRLT _0x43
	RCALL SUBOPT_0xC
	SBIW R26,43
	BRLT _0x44
_0x43:
	RJMP _0x42
_0x44:
; 0000 009F     {
; 0000 00A0      temper=(115)+(43-adc)*0.95;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	RCALL SUBOPT_0xD
	__GETD2N 0x3F733333
	RCALL __MULF12
	__GETD2N 0x42E60000
	RCALL SUBOPT_0xE
; 0000 00A1     }
; 0000 00A2 
; 0000 00A3   if (adc > 42 && adc < 50)
_0x42:
	RCALL SUBOPT_0xC
	SBIW R26,43
	BRLT _0x46
	RCALL SUBOPT_0xC
	SBIW R26,50
	BRLT _0x47
_0x46:
	RJMP _0x45
_0x47:
; 0000 00A4     {
; 0000 00A5      temper=(110)+(50-adc)*0.82;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0xD
	__GETD2N 0x3F51EB85
	RCALL __MULF12
	__GETD2N 0x42DC0000
	RCALL SUBOPT_0xE
; 0000 00A6     }
; 0000 00A7 
; 0000 00A8   if (adc > 49 && adc < 57)
_0x45:
	RCALL SUBOPT_0xC
	SBIW R26,50
	BRLT _0x49
	RCALL SUBOPT_0xC
	SBIW R26,57
	BRLT _0x4A
_0x49:
	RJMP _0x48
_0x4A:
; 0000 00A9     {
; 0000 00AA      temper=(105)+(57-adc)*0.70;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	RCALL SUBOPT_0xD
	__GETD2N 0x3F333333
	RCALL __MULF12
	__GETD2N 0x42D20000
	RCALL SUBOPT_0xE
; 0000 00AB     }
; 0000 00AC 
; 0000 00AD   if (adc > 56 && adc < 65)
_0x48:
	RCALL SUBOPT_0xC
	SBIW R26,57
	BRLT _0x4C
	RCALL SUBOPT_0xF
	BRLT _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
; 0000 00AE     {
; 0000 00AF      temper=(100)+(65-adc)*0.60;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	RCALL SUBOPT_0xD
	__GETD2N 0x3F19999A
	RCALL __MULF12
	__GETD2N 0x42C80000
	RCALL SUBOPT_0xE
; 0000 00B0     }
; 0000 00B1 
; 0000 00B2   if (adc > 64 && adc < 75)
_0x4B:
	RCALL SUBOPT_0xF
	BRLT _0x4F
	RCALL SUBOPT_0x10
	BRLT _0x50
_0x4F:
	RJMP _0x4E
_0x50:
; 0000 00B3     {
; 0000 00B4      temper=(95)+(75-adc)*0.58;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	RCALL SUBOPT_0xD
	__GETD2N 0x3F147AE1
	RCALL __MULF12
	__GETD2N 0x42BE0000
	RCALL SUBOPT_0xE
; 0000 00B5     }
; 0000 00B6 
; 0000 00B7   if (adc > 74 && adc < 86)
_0x4E:
	RCALL SUBOPT_0x10
	BRLT _0x52
	RCALL SUBOPT_0x11
	BRLT _0x53
_0x52:
	RJMP _0x51
_0x53:
; 0000 00B8     {
; 0000 00B9      temper=(90)+(86-adc)*0.44;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	RCALL SUBOPT_0xD
	__GETD2N 0x3EE147AE
	RCALL __MULF12
	__GETD2N 0x42B40000
	RCALL SUBOPT_0xE
; 0000 00BA     }
; 0000 00BB   if (adc > 85 && adc < 99)
_0x51:
	RCALL SUBOPT_0x11
	BRLT _0x55
	RCALL SUBOPT_0x12
	BRLT _0x56
_0x55:
	RJMP _0x54
_0x56:
; 0000 00BC     {
; 0000 00BD      temper=(85)+(99-adc)*0.38;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	RCALL SUBOPT_0xD
	__GETD2N 0x3EC28F5C
	RCALL __MULF12
	__GETD2N 0x42AA0000
	RCALL SUBOPT_0xE
; 0000 00BE     }
; 0000 00BF 
; 0000 00C0   if (adc > 98 && adc < 114)
_0x54:
	RCALL SUBOPT_0x12
	BRLT _0x58
	RCALL SUBOPT_0x13
	BRLT _0x59
_0x58:
	RJMP _0x57
_0x59:
; 0000 00C1     {
; 0000 00C2      temper=(80)+(114-adc)*0.33;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	RCALL SUBOPT_0xD
	__GETD2N 0x3EA8F5C3
	RCALL __MULF12
	__GETD2N 0x42A00000
	RCALL SUBOPT_0xE
; 0000 00C3     }
; 0000 00C4 
; 0000 00C5   if (adc > 113 && adc < 132)
_0x57:
	RCALL SUBOPT_0x13
	BRLT _0x5B
	RCALL SUBOPT_0x14
	BRLT _0x5C
_0x5B:
	RJMP _0x5A
_0x5C:
; 0000 00C6     {
; 0000 00C7      temper=(75)+(132-adc)*0.28;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	RCALL SUBOPT_0xD
	__GETD2N 0x3E8F5C29
	RCALL __MULF12
	__GETD2N 0x42960000
	RCALL SUBOPT_0xE
; 0000 00C8     }
; 0000 00C9 
; 0000 00CA   if (adc > 131 && adc < 153)
_0x5A:
	RCALL SUBOPT_0x14
	BRLT _0x5E
	RCALL SUBOPT_0x15
	BRLT _0x5F
_0x5E:
	RJMP _0x5D
_0x5F:
; 0000 00CB     {
; 0000 00CC      temper=(70)+(153-adc)*0.24;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(153)
	LDI  R31,HIGH(153)
	RCALL SUBOPT_0xD
	__GETD2N 0x3E75C28F
	RCALL __MULF12
	__GETD2N 0x428C0000
	RCALL SUBOPT_0xE
; 0000 00CD     }
; 0000 00CE   if (adc > 152 && adc < 177)
_0x5D:
	RCALL SUBOPT_0x15
	BRLT _0x61
	RCALL SUBOPT_0x16
	BRLT _0x62
_0x61:
	RJMP _0x60
_0x62:
; 0000 00CF     {
; 0000 00D0      temper=(65)+(177-adc)*0.21;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(177)
	LDI  R31,HIGH(177)
	RCALL SUBOPT_0xD
	__GETD2N 0x3E570A3D
	RCALL __MULF12
	__GETD2N 0x42820000
	RCALL SUBOPT_0xE
; 0000 00D1     };
_0x60:
; 0000 00D2 
; 0000 00D3   if (adc > 176 && adc < 204)
	RCALL SUBOPT_0x16
	BRLT _0x64
	RCALL SUBOPT_0x17
	BRLT _0x65
_0x64:
	RJMP _0x63
_0x65:
; 0000 00D4     {
; 0000 00D5      temper=(60)+(204-adc)*0.18;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(204)
	LDI  R31,HIGH(204)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x18
	__GETD2N 0x42700000
	RCALL SUBOPT_0xE
; 0000 00D6     };
_0x63:
; 0000 00D7 
; 0000 00D8   if (adc > 203 && adc < 236)
	RCALL SUBOPT_0x17
	BRLT _0x67
	RCALL SUBOPT_0x19
	BRLT _0x68
_0x67:
	RJMP _0x66
_0x68:
; 0000 00D9     {
; 0000 00DA      temper=(55)+(236-adc)*0.16;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(236)
	LDI  R31,HIGH(236)
	RCALL SUBOPT_0xD
	__GETD2N 0x3E23D70A
	RCALL __MULF12
	__GETD2N 0x425C0000
	RCALL SUBOPT_0xE
; 0000 00DB     };
_0x66:
; 0000 00DC 
; 0000 00DD   if (adc > 235 && adc < 271)
	RCALL SUBOPT_0x19
	BRLT _0x6A
	RCALL SUBOPT_0x1A
	BRLT _0x6B
_0x6A:
	RJMP _0x69
_0x6B:
; 0000 00DE     {
; 0000 00DF      temper=(50)+(271-adc)*0.14;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(271)
	LDI  R31,HIGH(271)
	RCALL SUBOPT_0xD
	__GETD2N 0x3E0F5C29
	RCALL __MULF12
	__GETD2N 0x42480000
	RCALL SUBOPT_0xE
; 0000 00E0     };
_0x69:
; 0000 00E1 
; 0000 00E2   if (adc > 270 && adc < 312)
	RCALL SUBOPT_0x1A
	BRLT _0x6D
	RCALL SUBOPT_0x1B
	BRLT _0x6E
_0x6D:
	RJMP _0x6C
_0x6E:
; 0000 00E3     {
; 0000 00E4      temper=(45)+(312-adc)*0.12;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(312)
	LDI  R31,HIGH(312)
	RCALL SUBOPT_0xD
	__GETD2N 0x3DF5C28F
	RCALL __MULF12
	__GETD2N 0x42340000
	RCALL SUBOPT_0xE
; 0000 00E5     };
_0x6C:
; 0000 00E6 
; 0000 00E7   if (adc > 311 && adc < 356)
	RCALL SUBOPT_0x1B
	BRLT _0x70
	RCALL SUBOPT_0x1C
	BRLT _0x71
_0x70:
	RJMP _0x6F
_0x71:
; 0000 00E8     {
; 0000 00E9      temper=(40)+(356-adc)*0.11;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(356)
	LDI  R31,HIGH(356)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1D
	__GETD2N 0x42200000
	RCALL SUBOPT_0xE
; 0000 00EA     };
_0x6F:
; 0000 00EB 
; 0000 00EC   if (adc > 355 && adc < 405)
	RCALL SUBOPT_0x1C
	BRLT _0x73
	RCALL SUBOPT_0x1E
	BRLT _0x74
_0x73:
	RJMP _0x72
_0x74:
; 0000 00ED     {
; 0000 00EE      temper=(35)+(405-adc)*0.10;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(405)
	LDI  R31,HIGH(405)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1F
	__GETD2N 0x420C0000
	RCALL SUBOPT_0xE
; 0000 00EF     };
_0x72:
; 0000 00F0 
; 0000 00F1   if (adc > 404 && adc < 457)
	RCALL SUBOPT_0x1E
	BRLT _0x76
	RCALL SUBOPT_0x20
	BRLT _0x77
_0x76:
	RJMP _0x75
_0x77:
; 0000 00F2     {
; 0000 00F3      temper=(30)+(457-adc)*0.10;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(457)
	LDI  R31,HIGH(457)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1F
	__GETD2N 0x41F00000
	RCALL SUBOPT_0xE
; 0000 00F4     };
_0x75:
; 0000 00F5 
; 0000 00F6   if (adc > 456 && adc < 469)
	RCALL SUBOPT_0x20
	BRLT _0x79
	RCALL SUBOPT_0x21
	BRLT _0x7A
_0x79:
	RJMP _0x78
_0x7A:
; 0000 00F7     {
; 0000 00F8      temper=(29)+(469-adc)*0.08;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(469)
	LDI  R31,HIGH(469)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x22
	__GETD2N 0x41E80000
	RCALL SUBOPT_0xE
; 0000 00F9     };
_0x78:
; 0000 00FA 
; 0000 00FB   if (adc > 468 && adc < 480)
	RCALL SUBOPT_0x21
	BRLT _0x7C
	RCALL SUBOPT_0x23
	BRLT _0x7D
_0x7C:
	RJMP _0x7B
_0x7D:
; 0000 00FC     {
; 0000 00FD      temper=(28)+(480-adc)*0.09;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(480)
	LDI  R31,HIGH(480)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x24
	__GETD2N 0x41E00000
	RCALL SUBOPT_0xE
; 0000 00FE     };
_0x7B:
; 0000 00FF 
; 0000 0100   if (adc > 479 && adc < 491)
	RCALL SUBOPT_0x23
	BRLT _0x7F
	RCALL SUBOPT_0x25
	BRLT _0x80
_0x7F:
	RJMP _0x7E
_0x80:
; 0000 0101     {
; 0000 0102      temper=(27)+(491-adc)*0.09;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(491)
	LDI  R31,HIGH(491)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x24
	__GETD2N 0x41D80000
	RCALL SUBOPT_0xE
; 0000 0103     };
_0x7E:
; 0000 0104 
; 0000 0105   if (adc > 490 && adc < 502)
	RCALL SUBOPT_0x25
	BRLT _0x82
	RCALL SUBOPT_0x26
	BRLT _0x83
_0x82:
	RJMP _0x81
_0x83:
; 0000 0106     {
; 0000 0107      temper=(float)(26)+(502-adc)*0.09;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(502)
	LDI  R31,HIGH(502)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x24
	__GETD2N 0x41D00000
	RCALL SUBOPT_0xE
; 0000 0108     };
_0x81:
; 0000 0109 
; 0000 010A   if (adc > 501 && adc < 512)
	RCALL SUBOPT_0x26
	BRLT _0x85
	RCALL SUBOPT_0x27
	BRLT _0x86
_0x85:
	RJMP _0x84
_0x86:
; 0000 010B     {
; 0000 010C      temper=(float)(25)+(512-adc)*0.10;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1F
	__GETD2N 0x41C80000
	RCALL SUBOPT_0xE
; 0000 010D     };
_0x84:
; 0000 010E 
; 0000 010F   if (adc > 511 && adc < 524)
	RCALL SUBOPT_0x27
	BRLT _0x88
	RCALL SUBOPT_0x28
	BRLT _0x89
_0x88:
	RJMP _0x87
_0x89:
; 0000 0110     {
; 0000 0111      temper=(float)(24)+(524-adc)*0.08;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(524)
	LDI  R31,HIGH(524)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x22
	__GETD2N 0x41C00000
	RCALL SUBOPT_0xE
; 0000 0112     };
_0x87:
; 0000 0113 
; 0000 0114   if (adc > 523 && adc < 536)
	RCALL SUBOPT_0x28
	BRLT _0x8B
	RCALL SUBOPT_0x29
	BRLT _0x8C
_0x8B:
	RJMP _0x8A
_0x8C:
; 0000 0115     {
; 0000 0116      temper=(23)+(536-adc)*0.08;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(536)
	LDI  R31,HIGH(536)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x22
	__GETD2N 0x41B80000
	RCALL SUBOPT_0xE
; 0000 0117     };
_0x8A:
; 0000 0118 
; 0000 0119   if (adc > 535 && adc < 548)
	RCALL SUBOPT_0x29
	BRLT _0x8E
	RCALL SUBOPT_0x2A
	BRLT _0x8F
_0x8E:
	RJMP _0x8D
_0x8F:
; 0000 011A     {
; 0000 011B      temper=(22)+(548-adc)*0.09;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(548)
	LDI  R31,HIGH(548)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x24
	__GETD2N 0x41B00000
	RCALL SUBOPT_0xE
; 0000 011C     };
_0x8D:
; 0000 011D 
; 0000 011E   if (adc > 547 && adc < 558)
	RCALL SUBOPT_0x2A
	BRLT _0x91
	RCALL SUBOPT_0x2B
	BRLT _0x92
_0x91:
	RJMP _0x90
_0x92:
; 0000 011F     {
; 0000 0120      temper=(21)+(558-adc)*0.09;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(558)
	LDI  R31,HIGH(558)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x24
	__GETD2N 0x41A80000
	RCALL SUBOPT_0xE
; 0000 0121     };
_0x90:
; 0000 0122 
; 0000 0123   if (adc > 557 && adc < 569)
	RCALL SUBOPT_0x2B
	BRLT _0x94
	RCALL SUBOPT_0x2C
	BRLT _0x95
_0x94:
	RJMP _0x93
_0x95:
; 0000 0124     {
; 0000 0125      temper=(20)+(569-adc)*0.10;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(569)
	LDI  R31,HIGH(569)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1F
	__GETD2N 0x41A00000
	RCALL SUBOPT_0xE
; 0000 0126     };
_0x93:
; 0000 0127 
; 0000 0128   if (adc > 568 && adc < 581)
	RCALL SUBOPT_0x2C
	BRLT _0x97
	RCALL SUBOPT_0x2D
	BRLT _0x98
_0x97:
	RJMP _0x96
_0x98:
; 0000 0129     {
; 0000 012A      temper=(19)+(581-adc)*0.08;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(581)
	LDI  R31,HIGH(581)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x22
	__GETD2N 0x41980000
	RCALL SUBOPT_0xE
; 0000 012B     };
_0x96:
; 0000 012C 
; 0000 012D   if (adc > 580 && adc < 593)
	RCALL SUBOPT_0x2D
	BRLT _0x9A
	RCALL SUBOPT_0x2E
	BRLT _0x9B
_0x9A:
	RJMP _0x99
_0x9B:
; 0000 012E     {
; 0000 012F      temper=(18)+(593-adc)*0.08;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(593)
	LDI  R31,HIGH(593)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x22
	__GETD2N 0x41900000
	RCALL SUBOPT_0xE
; 0000 0130     };
_0x99:
; 0000 0131 
; 0000 0132   if (adc > 592 && adc < 605)
	RCALL SUBOPT_0x2E
	BRLT _0x9D
	RCALL SUBOPT_0x2F
	BRLT _0x9E
_0x9D:
	RJMP _0x9C
_0x9E:
; 0000 0133     {
; 0000 0134      temper=(17)+(605-adc)*0.09;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(605)
	LDI  R31,HIGH(605)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x24
	__GETD2N 0x41880000
	RCALL SUBOPT_0xE
; 0000 0135     };
_0x9C:
; 0000 0136 
; 0000 0137   if (adc > 604 && adc < 615)
	RCALL SUBOPT_0x2F
	BRLT _0xA0
	RCALL SUBOPT_0x30
	BRLT _0xA1
_0xA0:
	RJMP _0x9F
_0xA1:
; 0000 0138     {
; 0000 0139      temper=(16)+(615-adc)*0.09;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(615)
	LDI  R31,HIGH(615)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x24
	__GETD2N 0x41800000
	RCALL SUBOPT_0xE
; 0000 013A     };
_0x9F:
; 0000 013B 
; 0000 013C   if (adc > 614 && adc < 628)
	RCALL SUBOPT_0x30
	BRLT _0xA3
	RCALL SUBOPT_0x31
	BRLT _0xA4
_0xA3:
	RJMP _0xA2
_0xA4:
; 0000 013D     {
; 0000 013E      temper=(15)+(626-adc)*0.10;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(626)
	LDI  R31,HIGH(626)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1F
	__GETD2N 0x41700000
	RCALL SUBOPT_0xE
; 0000 013F     };
_0xA2:
; 0000 0140 
; 0000 0141   if (adc > 627 && adc < 638)
	RCALL SUBOPT_0x31
	BRLT _0xA6
	RCALL SUBOPT_0x32
	BRLT _0xA7
_0xA6:
	RJMP _0xA5
_0xA7:
; 0000 0142     {
; 0000 0143      temper=(14)+(638-adc)*0.08;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(638)
	LDI  R31,HIGH(638)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x22
	__GETD2N 0x41600000
	RCALL SUBOPT_0xE
; 0000 0144     };
_0xA5:
; 0000 0145 
; 0000 0146   if (adc > 637 && adc < 650)
	RCALL SUBOPT_0x32
	BRLT _0xA9
	RCALL SUBOPT_0x33
	BRLT _0xAA
_0xA9:
	RJMP _0xA8
_0xAA:
; 0000 0147     {
; 0000 0148      temper=(13)+(650-adc)*0.08;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(650)
	LDI  R31,HIGH(650)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x22
	__GETD2N 0x41500000
	RCALL SUBOPT_0xE
; 0000 0149     };
_0xA8:
; 0000 014A 
; 0000 014B   if (adc > 649 && adc < 661)
	RCALL SUBOPT_0x33
	BRLT _0xAC
	RCALL SUBOPT_0x34
	BRLT _0xAD
_0xAC:
	RJMP _0xAB
_0xAD:
; 0000 014C     {
; 0000 014D      temper=(12)+(661-adc)*0.09;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(661)
	LDI  R31,HIGH(661)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x24
	__GETD2N 0x41400000
	RCALL SUBOPT_0xE
; 0000 014E     };
_0xAB:
; 0000 014F 
; 0000 0150   if (adc > 660 && adc < 671)
	RCALL SUBOPT_0x34
	BRLT _0xAF
	RCALL SUBOPT_0x35
	BRLT _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
; 0000 0151     {
; 0000 0152      temper=(11)+(671-adc)*0.10;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(671)
	LDI  R31,HIGH(671)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1F
	__GETD2N 0x41300000
	RCALL SUBOPT_0xE
; 0000 0153     };
_0xAE:
; 0000 0154 
; 0000 0155   if (adc > 670 && adc < 681)
	RCALL SUBOPT_0x35
	BRLT _0xB2
	RCALL SUBOPT_0x36
	BRLT _0xB3
_0xB2:
	RJMP _0xB1
_0xB3:
; 0000 0156     {
; 0000 0157      temper=(10)+(681-adc)*0.10;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(681)
	LDI  R31,HIGH(681)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0xE
; 0000 0158     };
_0xB1:
; 0000 0159 
; 0000 015A   if (adc > 680 && adc < 734)
	RCALL SUBOPT_0x36
	BRLT _0xB5
	RCALL SUBOPT_0x38
	BRLT _0xB6
_0xB5:
	RJMP _0xB4
_0xB6:
; 0000 015B     {
; 0000 015C      temper=(5)+(734-adc)*0.09;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(734)
	LDI  R31,HIGH(734)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x24
	__GETD2N 0x40A00000
	RCALL SUBOPT_0xE
; 0000 015D     };
_0xB4:
; 0000 015E 
; 0000 015F   if (adc > 733 && adc < 783)
	RCALL SUBOPT_0x38
	BRLT _0xB8
	RCALL SUBOPT_0x39
	BRLT _0xB9
_0xB8:
	RJMP _0xB7
_0xB9:
; 0000 0160     {
; 0000 0161      temper=(0)+(783-adc)*0.10;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(783)
	LDI  R31,HIGH(783)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1F
	__GETD2N 0x0
	RCALL SUBOPT_0xE
; 0000 0162     };
_0xB7:
; 0000 0163 
; 0000 0164   if (adc > 782 && adc < 828)
	RCALL SUBOPT_0x39
	BRLT _0xBB
	RCALL SUBOPT_0x3A
	BRLT _0xBC
_0xBB:
	RJMP _0xBA
_0xBC:
; 0000 0165     {
; 0000 0166      temper=(-5)+(828-adc)*0.11;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(828)
	LDI  R31,HIGH(828)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1D
	__GETD2N 0xC0A00000
	RCALL SUBOPT_0xE
; 0000 0167     };
_0xBA:
; 0000 0168 
; 0000 0169   if (adc > 827 && adc < 867)
	RCALL SUBOPT_0x3A
	BRLT _0xBE
	RCALL SUBOPT_0x3B
	BRLT _0xBF
_0xBE:
	RJMP _0xBD
_0xBF:
; 0000 016A     {
; 0000 016B      temper=(-10)+(867-adc)*0.13;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(867)
	LDI  R31,HIGH(867)
	RCALL SUBOPT_0xD
	__GETD2N 0x3E051EB8
	RCALL __MULF12
	__GETD2N 0xC1200000
	RCALL SUBOPT_0xE
; 0000 016C     };
_0xBD:
; 0000 016D 
; 0000 016E   if (adc > 866 && adc < 900)
	RCALL SUBOPT_0x3B
	BRLT _0xC1
	RCALL SUBOPT_0x3C
	BRLT _0xC2
_0xC1:
	RJMP _0xC0
_0xC2:
; 0000 016F     {
; 0000 0170      temper=(-15)+(900-adc)*0.15;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	RCALL SUBOPT_0xD
	__GETD2N 0x3E19999A
	RCALL __MULF12
	__GETD2N 0xC1700000
	RCALL SUBOPT_0xE
; 0000 0171     };
_0xC0:
; 0000 0172 
; 0000 0173   if (adc > 899 && adc < 928)
	RCALL SUBOPT_0x3C
	BRLT _0xC4
	RCALL SUBOPT_0x3D
	BRLT _0xC5
_0xC4:
	RJMP _0xC3
_0xC5:
; 0000 0174     {
; 0000 0175      temper=(-20)+(928-adc)*0.18;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(928)
	LDI  R31,HIGH(928)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x18
	__GETD2N 0xC1A00000
	RCALL SUBOPT_0xE
; 0000 0176     };
_0xC3:
; 0000 0177 
; 0000 0178   if (adc > 927 && adc < 950)
	RCALL SUBOPT_0x3D
	BRLT _0xC7
	RCALL SUBOPT_0x3E
	BRLT _0xC8
_0xC7:
	RJMP _0xC6
_0xC8:
; 0000 0179     {
; 0000 017A      temper=(-25)+(950-adc)*0.22;
	RCALL SUBOPT_0xC
	LDI  R30,LOW(950)
	LDI  R31,HIGH(950)
	RCALL SUBOPT_0xD
	__GETD2N 0x3E6147AE
	RCALL __MULF12
	__GETD2N 0xC1C80000
	RCALL SUBOPT_0xE
; 0000 017B     };
_0xC6:
; 0000 017C 
; 0000 017D   if (adc > 949)
	RCALL SUBOPT_0x3E
	BRLT _0xC9
; 0000 017E     {
; 0000 017F       avariya_datchik_ne_podkluchen=1;
	SET
	BLD  R2,3
; 0000 0180     };
_0xC9:
; 0000 0181   return temper;
	RCALL __GETD1S0
	ADIW R28,4
	RET
; 0000 0182 }
; .FEND
;// Timer 0 период 3,2 мс
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0185 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0186 TCNT0=0x9C;
	LDI  R30,LOW(156)
	OUT  0x32,R30
; 0000 0187 
; 0000 0188    if(show_temp==1)
	SBRS R2,4
	RJMP _0xCA
; 0000 0189      {
; 0000 018A        if(buffer<100)
	RCALL SUBOPT_0x3F
	BRGE _0xCB
; 0000 018B         switch(i)
	MOV  R30,R8
	RCALL SUBOPT_0x0
; 0000 018C           {
; 0000 018D            case 0:{PORTD=t1;            PORTB.0=0; PORTB.6=0; PORTB.7=1; break;}
	BRNE _0xCF
	RCALL SUBOPT_0x40
	RJMP _0xCE
; 0000 018E            case 1:{PORTD=t2; PORTD.0=0; PORTB.0=0; PORTB.6=1; PORTB.7=0; break;}
_0xCF:
	RCALL SUBOPT_0x1
	BRNE _0xD6
	OUT  0x12,R6
	CBI  0x12,0
	CBI  0x18,0
	SBI  0x18,6
	RJMP _0x1D8
; 0000 018F            case 2:{PORTD=t3;            PORTB.0=1; PORTB.6=0; PORTB.7=0; break;}
_0xD6:
	RCALL SUBOPT_0x2
	BRNE _0xCE
	RCALL SUBOPT_0x41
_0x1D8:
	CBI  0x18,7
; 0000 0190           }
_0xCE:
; 0000 0191         if(buffer>99)
_0xCB:
	RCALL SUBOPT_0x3F
	BRLT _0xE6
; 0000 0192          switch(i)
	MOV  R30,R8
	RCALL SUBOPT_0x0
; 0000 0193            {
; 0000 0194             case 0:{PORTD=t1; PORTB.0=0; PORTB.6=0; PORTB.7=1; break;}
	BRNE _0xEA
	RCALL SUBOPT_0x40
	RJMP _0xE9
; 0000 0195             case 1:{PORTD=t2; PORTB.0=0; PORTB.6=1; PORTB.7=0; break;}
_0xEA:
	RCALL SUBOPT_0x1
	BRNE _0xF1
	OUT  0x12,R6
	CBI  0x18,0
	SBI  0x18,6
	RJMP _0x1D9
; 0000 0196             case 2:{PORTD=t3; PORTB.0=1; PORTB.6=0; PORTB.7=0; break;}
_0xF1:
	RCALL SUBOPT_0x2
	BRNE _0xE9
	RCALL SUBOPT_0x41
_0x1D9:
	CBI  0x18,7
; 0000 0197            }
_0xE9:
; 0000 0198 
; 0000 0199      };
_0xE6:
_0xCA:
; 0000 019A    if(show_termostat==1 | show_ustavku==1 | par_ust==1 | show_par==1)
	RCALL SUBOPT_0x42
	MOV  R0,R30
	LDI  R26,0
	SBRC R2,6
	LDI  R26,1
	LDI  R30,LOW(1)
	RCALL __EQB12
	OR   R0,R30
	LDI  R26,0
	SBRC R2,7
	LDI  R26,1
	LDI  R30,LOW(1)
	RCALL __EQB12
	OR   R0,R30
	LDI  R26,0
	SBRC R4,0
	LDI  R26,1
	LDI  R30,LOW(1)
	RCALL __EQB12
	OR   R30,R0
	BREQ _0xFF
; 0000 019B      {
; 0000 019C 
; 0000 019D       if (t3==0x05 & exit==0 & P03==0)
	MOV  R26,R9
	LDI  R30,LOW(5)
	RCALL __EQB12
	MOV  R0,R30
	LDI  R26,0
	SBRC R3,7
	LDI  R26,1
	LDI  R30,LOW(0)
	RCALL __EQB12
	AND  R0,R30
	LDI  R26,0
	SBRC R3,3
	LDI  R26,1
	LDI  R30,LOW(0)
	RCALL __EQB12
	AND  R30,R0
	BREQ _0x100
; 0000 019E        {
; 0000 019F        t3=0xFF;
	LDI  R30,LOW(255)
	MOV  R9,R30
; 0000 01A0        };
_0x100:
; 0000 01A1       if(flag_minus==1)
	SBRS R4,3
	RJMP _0x101
; 0000 01A2        {
; 0000 01A3        t3=PORTD.2=0b11111011;
	SBI  0x12,2
	LDI  R30,LOW(251)
	MOV  R9,R30
; 0000 01A4        };
_0x101:
; 0000 01A5 
; 0000 01A6       switch(i)
	MOV  R30,R8
	RCALL SUBOPT_0x0
; 0000 01A7             {
; 0000 01A8             case 0:{PORTD=t1; PORTB.0=0; PORTB.6=0; PORTB.7=1; break;}
	BRNE _0x107
	RCALL SUBOPT_0x40
	RJMP _0x106
; 0000 01A9             case 1:{PORTD=t2; if(screen==24){PORTD.0=0;}; PORTB.0=0; PORTB.6=1; PORTB.7=0; break;}
_0x107:
	RCALL SUBOPT_0x1
	BRNE _0x10E
	OUT  0x12,R6
	LDI  R30,LOW(24)
	CP   R30,R12
	BRNE _0x10F
	CBI  0x12,0
_0x10F:
	CBI  0x18,0
	SBI  0x18,6
	RJMP _0x1DA
; 0000 01AA             case 2:{PORTD=t3; PORTB.0=1; PORTB.6=0; PORTB.7=0; break;}
_0x10E:
	RCALL SUBOPT_0x2
	BRNE _0x106
	RCALL SUBOPT_0x41
_0x1DA:
	CBI  0x18,7
; 0000 01AB             }
_0x106:
; 0000 01AC      };
_0xFF:
; 0000 01AD 
; 0000 01AE 
; 0000 01AF    i++;
	INC  R8
; 0000 01B0    if(i>2)
	LDI  R30,LOW(2)
	CP   R30,R8
	BRSH _0x11F
; 0000 01B1    i=0;
	CLR  R8
; 0000 01B2 }
_0x11F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Timer1 период 10 мс
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 01B6 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 01B7 TCNT1H=0xD8F0 >> 8;
	RCALL SUBOPT_0x43
; 0000 01B8 TCNT1L=0xD8F0 & 0xff;
; 0000 01B9 wait_timer_for_termostat++;
	INC  R10
; 0000 01BA wait_timer1++;
	INC  R11
; 0000 01BB buzzer++;
	LDI  R26,LOW(_buzzer)
	LDI  R27,HIGH(_buzzer)
	RCALL SUBOPT_0x44
; 0000 01BC 
; 0000 01BD if(wait_timer1==5 || wait_timer1==10 || wait_timer1==15 || wait_timer1==20)         // Каждые 50 мс - декодирование
	LDI  R30,LOW(5)
	CP   R30,R11
	BREQ _0x121
	LDI  R30,LOW(10)
	CP   R30,R11
	BREQ _0x121
	LDI  R30,LOW(15)
	CP   R30,R11
	BREQ _0x121
	LDI  R30,LOW(20)
	CP   R30,R11
	BREQ _0x121
	RJMP _0x120
_0x121:
; 0000 01BE   {
; 0000 01BF     if (show_temp==1)
	SBRS R2,4
	RJMP _0x123
; 0000 01C0       {
; 0000 01C1         buffer=readtemp();
	RCALL SUBOPT_0x45
; 0000 01C2         if(buffer<100)
	RCALL SUBOPT_0x3F
	BRGE _0x124
; 0000 01C3           {
; 0000 01C4             currtemp=10*readtemp();
	RCALL _readtemp
	RCALL SUBOPT_0x37
	RCALL __MULF12
	RCALL SUBOPT_0x46
; 0000 01C5             getkodes(currtemp);
; 0000 01C6           }
; 0000 01C7         if(buffer>99)
_0x124:
	RCALL SUBOPT_0x3F
	BRLT _0x125
; 0000 01C8           {
; 0000 01C9             currtemp=readtemp();
	RCALL _readtemp
	RCALL SUBOPT_0x46
; 0000 01CA             getkodes(currtemp);
; 0000 01CB           }
; 0000 01CC       }
_0x125:
; 0000 01CD 
; 0000 01CE     if (show_termostat==1)
_0x123:
	SBRS R2,5
	RJMP _0x126
; 0000 01CF       {
; 0000 01D0         if(flag_pereklu4==1)
	SBRS R4,4
	RJMP _0x127
; 0000 01D1           {
; 0000 01D2            getkodes(P6);
	RCALL SUBOPT_0x47
	MOVW R26,R30
	RCALL _getkodes
; 0000 01D3            buffer=readtemp();
	RCALL SUBOPT_0x45
; 0000 01D4           };
_0x127:
; 0000 01D5         if(flag_pereklu4==0)
	SBRC R4,4
	RJMP _0x128
; 0000 01D6           {
; 0000 01D7            getkodes(readtemp());
	RCALL _readtemp
	RCALL __CFD1
	MOVW R26,R30
	RCALL _getkodes
; 0000 01D8            buffer=readtemp();
	RCALL SUBOPT_0x45
; 0000 01D9           };
_0x128:
; 0000 01DA       }
; 0000 01DB     if (show_ustavku==1)
_0x126:
	SBRS R2,6
	RJMP _0x129
; 0000 01DC       {
; 0000 01DD        t1=kod[12]; t2=kod[11]; t3=kod[10];    // USt
	__GETBRMN 7,_kod_G000,12
	__GETBRMN 6,_kod_G000,11
	__GETBRMN 9,_kod_G000,10
; 0000 01DE       };
_0x129:
; 0000 01DF     if (par_ust==1)
	SBRS R2,7
	RJMP _0x12A
; 0000 01E0       {
; 0000 01E1        if(P00==1)
	SBRS R3,0
	RJMP _0x12B
; 0000 01E2          {
; 0000 01E3           t1=kod[0]; t2=kod[0]; t3=kod[13];
	LDS  R7,_kod_G000
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x48
; 0000 01E4          };
_0x12B:
; 0000 01E5        if(P01==1)
	SBRS R3,1
	RJMP _0x12C
; 0000 01E6          {
; 0000 01E7           t1=kod[1]; t2=kod[0]; t3=kod[13];
	__GETBRMN 7,_kod_G000,1
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x48
; 0000 01E8          };
_0x12C:
; 0000 01E9        if(P02==1)
	SBRS R3,2
	RJMP _0x12D
; 0000 01EA          {
; 0000 01EB           t1=kod[2]; t2=kod[0]; t3=kod[13];
	__GETBRMN 7,_kod_G000,2
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x48
; 0000 01EC          };
_0x12D:
; 0000 01ED        if(P03==1)
	SBRS R3,3
	RJMP _0x12E
; 0000 01EE          {
; 0000 01EF           t1=kod[3]; t2=kod[0]; t3=kod[13];
	__GETBRMN 7,_kod_G000,3
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x48
; 0000 01F0          };
_0x12E:
; 0000 01F1        if(P04==1)
	SBRS R3,4
	RJMP _0x12F
; 0000 01F2          {
; 0000 01F3           t1=kod[4]; t2=kod[0]; t3=kod[13];
	__GETBRMN 7,_kod_G000,4
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x48
; 0000 01F4          };
_0x12F:
; 0000 01F5        if(P05==1)
	SBRS R3,5
	RJMP _0x130
; 0000 01F6          {
; 0000 01F7           t1=kod[5]; t2=kod[0]; t3=kod[13];
	__GETBRMN 7,_kod_G000,5
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x48
; 0000 01F8          };
_0x130:
; 0000 01F9        if(P06==1)
	SBRS R3,6
	RJMP _0x131
; 0000 01FA          {
; 0000 01FB           t1=kod[6]; t2=kod[0]; t3=kod[13];
	__GETBRMN 7,_kod_G000,6
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x48
; 0000 01FC          };
_0x131:
; 0000 01FD        if(exit==1)
	SBRS R3,7
	RJMP _0x132
; 0000 01FE          {
; 0000 01FF           t1=kod[12]; t2=kod[10]; t3=kod[0];
	__GETBRMN 7,_kod_G000,12
	__GETBRMN 6,_kod_G000,10
	RCALL SUBOPT_0xB
; 0000 0200          };
_0x132:
; 0000 0201       };
_0x12A:
; 0000 0202     if (show_par==1)
	SBRS R4,0
	RJMP _0x133
; 0000 0203       {   if(flag_minus==0)
	SBRC R4,3
	RJMP _0x134
; 0000 0204             {
; 0000 0205              getkodes(par);
	RCALL SUBOPT_0x49
	RCALL _getkodes
; 0000 0206             };
_0x134:
; 0000 0207           if(flag_minus==1)
	SBRS R4,3
	RJMP _0x135
; 0000 0208             {
; 0000 0209             getkodes(minus);
	LDS  R26,_minus
	LDS  R27,_minus+1
	RCALL _getkodes
; 0000 020A             };
_0x135:
; 0000 020B       };
_0x133:
; 0000 020C  };
_0x120:
; 0000 020D 
; 0000 020E 
; 0000 020F if(wait_timer1==10 || wait_timer1==20 && show_temp==1)         // Каждые 100 мс - Опрос АЦП.
	LDI  R30,LOW(10)
	CP   R30,R11
	BREQ _0x137
	LDI  R30,LOW(20)
	CP   R30,R11
	BRNE _0x138
	SBRC R2,4
	RJMP _0x137
_0x138:
	RJMP _0x136
_0x137:
; 0000 0210   {
; 0000 0211    filterin=read_adc(5);
	LDI  R26,LOW(5)
	RCALL _read_adc
	STS  _filterin,R30
	STS  _filterin+1,R31
; 0000 0212    adc=(coeff_beta * adc + filterin  * coeff_alpha) >> N; // Рекурсивный филтр 1 порядка
	LDS  R30,_adc
	LDS  R31,_adc+1
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RCALL __MULW12
	LDS  R26,_filterin
	LDS  R27,_filterin+1
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R26
	RCALL __ASRW4
	STS  _adc,R30
	STS  _adc+1,R31
; 0000 0213   };
_0x136:
; 0000 0214 
; 0000 0215 
; 0000 0216 if(wait_timer1==20)         // Каждые 200 мс - опрос кнопок
	LDI  R30,LOW(20)
	CP   R30,R11
	BRNE _0x13B
; 0000 0217   {
; 0000 0218    if(PINB.1==0)
	SBIC 0x16,1
	RJMP _0x13C
; 0000 0219      {
; 0000 021A       knopka_left=1;
	SET
	BLD  R2,0
; 0000 021B      };
_0x13C:
; 0000 021C    if(PINB.2==0)
	SBIC 0x16,2
	RJMP _0x13D
; 0000 021D      {
; 0000 021E       knopka_middle=1;
	SET
	BLD  R2,2
; 0000 021F      };
_0x13D:
; 0000 0220    if(PINB.3==0)
	SBIC 0x16,3
	RJMP _0x13E
; 0000 0221      {
; 0000 0222       knopka_right=1;
	SET
	BLD  R2,1
; 0000 0223      };
_0x13E:
; 0000 0224    wait_timer1=0;
	CLR  R11
; 0000 0225   };
_0x13B:
; 0000 0226 
; 0000 0227 if(wait_timer_for_termostat==255)
	LDI  R30,LOW(255)
	CP   R30,R10
	BRNE _0x13F
; 0000 0228  {
; 0000 0229   flag_pereklu4= !flag_pereklu4;
	LDI  R30,LOW(16)
	EOR  R4,R30
; 0000 022A   wait_timer_for_termostat=0;
	CLR  R10
; 0000 022B  }
; 0000 022C 
; 0000 022D if(counter_buzzer<10 && flag_enter==1 && P3==1)
_0x13F:
	LDI  R30,LOW(10)
	CP   R13,R30
	BRSH _0x141
	SBRS R4,1
	RJMP _0x141
	RCALL SUBOPT_0x4A
	BREQ _0x142
_0x141:
	RJMP _0x140
_0x142:
; 0000 022E     {
; 0000 022F      if(buzzer==50)
	RCALL SUBOPT_0x4B
	SBIW R26,50
	BRNE _0x143
; 0000 0230       {
; 0000 0231       PORTC.0=1;
	SBI  0x15,0
; 0000 0232       counter_buzzer++;
	INC  R13
; 0000 0233       }
; 0000 0234      if(buzzer==100)
_0x143:
	RCALL SUBOPT_0x4B
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRNE _0x146
; 0000 0235       {
; 0000 0236       PORTC.0=0;
	CBI  0x15,0
; 0000 0237       counter_buzzer++;
	INC  R13
; 0000 0238       };
_0x146:
; 0000 0239 
; 0000 023A     };
_0x140:
; 0000 023B 
; 0000 023C if(buzzer>100)
	RCALL SUBOPT_0x4B
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x149
; 0000 023D  {
; 0000 023E   buzzer=0;
	LDI  R30,LOW(0)
	STS  _buzzer,R30
	STS  _buzzer+1,R30
; 0000 023F   PORTC.0=0;
	CBI  0x15,0
; 0000 0240  }
; 0000 0241 }
_0x149:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Timer2 период 200 мкс
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0245 {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0246 // Reinitialize Timer2 value
; 0000 0247 TCNT2=0x38;
	LDI  R30,LOW(56)
	OUT  0x24,R30
; 0000 0248 wait_timer2++;
	LDI  R26,LOW(_wait_timer2)
	LDI  R27,HIGH(_wait_timer2)
	RCALL SUBOPT_0x44
; 0000 0249 switch(screen)                // Меню
	MOV  R30,R12
	LDI  R31,0
	SBRC R30,7
	SER  R31
; 0000 024A  {
; 0000 024B        case 0:                            // Вывод температуры
	SBIW R30,0
	BRNE _0x14F
; 0000 024C           {
; 0000 024D            show_termostat=0;
	RCALL SUBOPT_0x4C
; 0000 024E            show_ustavku=0;
	RCALL SUBOPT_0x4D
; 0000 024F            show_temp=1;
	SET
	BLD  R2,4
; 0000 0250            if (knopka_left==1)
	SBRC R2,0
; 0000 0251              {
; 0000 0252               screen++;
	RCALL SUBOPT_0x4E
; 0000 0253               knopka_left=0;
; 0000 0254              };
; 0000 0255            if (knopka_right==1)
	SBRS R2,1
	RJMP _0x151
; 0000 0256              {
; 0000 0257               screen--;
	RCALL SUBOPT_0x4F
; 0000 0258               knopka_right=0;
; 0000 0259               if (screen<0)
	LDI  R30,LOW(0)
	CP   R12,R30
	BRGE _0x152
; 0000 025A                 screen=2;
	LDI  R30,LOW(2)
	MOV  R12,R30
; 0000 025B              };
_0x152:
_0x151:
; 0000 025C            if (knopka_middle==1)
	SBRC R2,2
; 0000 025D              knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 025E            break;
	RJMP _0x14E
; 0000 025F            };
; 0000 0260 
; 0000 0261        case 1:                            // Работа термостата
_0x14F:
	RCALL SUBOPT_0x1
	BRNE _0x154
; 0000 0262            {
; 0000 0263             show_termostat=1;
	SET
	BLD  R2,5
; 0000 0264             show_ustavku=0;
	RCALL SUBOPT_0x4D
; 0000 0265             show_temp=0;
	RCALL SUBOPT_0x51
; 0000 0266             if (knopka_left==1)
	SBRC R2,0
; 0000 0267               {
; 0000 0268                screen++;
	RCALL SUBOPT_0x4E
; 0000 0269                knopka_left=0;
; 0000 026A               };
; 0000 026B             if (knopka_right==1)
	SBRC R2,1
; 0000 026C               {
; 0000 026D                screen--;
	RCALL SUBOPT_0x4F
; 0000 026E                knopka_right=0;
; 0000 026F               };
; 0000 0270              if (knopka_middle==1)
	SBRC R2,2
; 0000 0271              knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 0272             break;
	RJMP _0x14E
; 0000 0273            };
; 0000 0274 
; 0000 0275        case 2:                            // Вход в меню уставки
_0x154:
	RCALL SUBOPT_0x2
	BRNE _0x158
; 0000 0276            {
; 0000 0277             show_termostat=0;
	RCALL SUBOPT_0x4C
; 0000 0278             show_ustavku=1;
	SET
	BLD  R2,6
; 0000 0279             show_temp=0;
	RCALL SUBOPT_0x51
; 0000 027A             if (knopka_right==1)
	SBRC R2,1
; 0000 027B               {
; 0000 027C                screen--;
	RCALL SUBOPT_0x4F
; 0000 027D                knopka_right=0;
; 0000 027E               };
; 0000 027F             if (knopka_left==1)
	SBRS R2,0
	RJMP _0x15A
; 0000 0280               {
; 0000 0281                screen++;
	RCALL SUBOPT_0x4E
; 0000 0282                knopka_left=0;
; 0000 0283                if(screen>2)
	LDI  R30,LOW(2)
	CP   R30,R12
	BRGE _0x15B
; 0000 0284                  screen=0;
	CLR  R12
; 0000 0285               };
_0x15B:
_0x15A:
; 0000 0286             if (knopka_middle==1)
	SBRS R2,2
	RJMP _0x15C
; 0000 0287              {
; 0000 0288               screen=4;
	LDI  R30,LOW(4)
	MOV  R12,R30
; 0000 0289               par_ust=1;
	RCALL SUBOPT_0x52
; 0000 028A               knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 028B              };
_0x15C:
; 0000 028C             break;
	RJMP _0x14E
; 0000 028D            };
; 0000 028E 
; 0000 028F        case 4:                            // Режим работы (нагрев\охлаждение)
_0x158:
	RCALL SUBOPT_0x4
	BRNE _0x15D
; 0000 0290            {
; 0000 0291             show_termostat=0;
	RCALL SUBOPT_0x4C
; 0000 0292             show_ustavku=0;
	RCALL SUBOPT_0x4D
; 0000 0293             show_temp=0;
	RCALL SUBOPT_0x51
; 0000 0294             exit=0;
	CLT
	BLD  R3,7
; 0000 0295             P00=1;
	SET
	BLD  R3,0
; 0000 0296             P01=0;
	RCALL SUBOPT_0x53
; 0000 0297             par_ust=1;
	RCALL SUBOPT_0x52
; 0000 0298             if (knopka_right==1)
	SBRC R2,1
; 0000 0299               {
; 0000 029A                screen++;
	RCALL SUBOPT_0x54
; 0000 029B                knopka_right=0;
; 0000 029C               };
; 0000 029D             if (knopka_left==1)
	SBRS R2,0
	RJMP _0x15F
; 0000 029E               {
; 0000 029F                 screen--;
	DEC  R12
; 0000 02A0                 if(screen<4)
	LDI  R30,LOW(4)
	CP   R12,R30
	BRGE _0x160
; 0000 02A1                   screen=11;
	LDI  R30,LOW(11)
	MOV  R12,R30
; 0000 02A2                 knopka_left=0;
_0x160:
	RCALL SUBOPT_0x55
; 0000 02A3               };
_0x15F:
; 0000 02A4             if (knopka_middle==1)
	SBRS R2,2
	RJMP _0x161
; 0000 02A5             {
; 0000 02A6              knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 02A7              screen=20;
	LDI  R30,LOW(20)
	MOV  R12,R30
; 0000 02A8             };
_0x161:
; 0000 02A9             break;
	RJMP _0x14E
; 0000 02AA            };
; 0000 02AB 
; 0000 02AC        case 5:                            // Температура срабатывания. Нижний порог
_0x15D:
	RCALL SUBOPT_0x5
	BRNE _0x162
; 0000 02AD            {
; 0000 02AE             show_termostat=0;
	RCALL SUBOPT_0x4C
; 0000 02AF             show_ustavku=0;
	RCALL SUBOPT_0x4D
; 0000 02B0             show_temp=0;
	RCALL SUBOPT_0x51
; 0000 02B1             P00=0;
	CLT
	BLD  R3,0
; 0000 02B2             P01=1;
	SET
	BLD  R3,1
; 0000 02B3             P02=0;
	CLT
	BLD  R3,2
; 0000 02B4             par_ust=1;
	RCALL SUBOPT_0x52
; 0000 02B5             if (knopka_left==1)
	SBRC R2,0
; 0000 02B6               {
; 0000 02B7                 screen--;
	RCALL SUBOPT_0x56
; 0000 02B8                 knopka_left=0;
; 0000 02B9               };
; 0000 02BA             if (knopka_right==1)
	SBRC R2,1
; 0000 02BB               {
; 0000 02BC                screen++;
	RCALL SUBOPT_0x54
; 0000 02BD                knopka_right=0;
; 0000 02BE               };
; 0000 02BF             if (knopka_middle==1)
	SBRS R2,2
	RJMP _0x165
; 0000 02C0               {
; 0000 02C1                knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 02C2                screen=21;
	LDI  R30,LOW(21)
	MOV  R12,R30
; 0000 02C3               };
_0x165:
; 0000 02C4             break;
	RJMP _0x14E
; 0000 02C5            };
; 0000 02C6 
; 0000 02C7        case 6:                            // Температура срабатывания. Верхний порог.
_0x162:
	RCALL SUBOPT_0x6
	BRNE _0x166
; 0000 02C8            {
; 0000 02C9             show_termostat=0;
	RCALL SUBOPT_0x4C
; 0000 02CA             show_ustavku=0;
	RCALL SUBOPT_0x4D
; 0000 02CB             show_temp=0;
	RCALL SUBOPT_0x51
; 0000 02CC             P01=0;
	RCALL SUBOPT_0x53
; 0000 02CD             P02=1;
	SET
	BLD  R3,2
; 0000 02CE             P03=0;
	CLT
	BLD  R3,3
; 0000 02CF             par_ust=1;
	RCALL SUBOPT_0x52
; 0000 02D0             if (knopka_left==1)
	SBRC R2,0
; 0000 02D1               {
; 0000 02D2                 screen--;
	RCALL SUBOPT_0x56
; 0000 02D3                 knopka_left=0;
; 0000 02D4               };
; 0000 02D5             if (knopka_right==1)
	SBRC R2,1
; 0000 02D6               {
; 0000 02D7                screen++;
	RCALL SUBOPT_0x54
; 0000 02D8                knopka_right=0;
; 0000 02D9               };
; 0000 02DA             if (knopka_middle==1)
	SBRS R2,2
	RJMP _0x169
; 0000 02DB               {
; 0000 02DC                knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 02DD                screen=22;
	LDI  R30,LOW(22)
	MOV  R12,R30
; 0000 02DE               };
_0x169:
; 0000 02DF             break;
	RJMP _0x14E
; 0000 02E0            };
; 0000 02E1 
; 0000 02E2        case 7:                            // Вкл\Выкл буззер
_0x166:
	RCALL SUBOPT_0x7
	BRNE _0x16A
; 0000 02E3            {
; 0000 02E4             show_termostat=0;
	RCALL SUBOPT_0x4C
; 0000 02E5             show_ustavku=0;
	RCALL SUBOPT_0x4D
; 0000 02E6             show_temp=0;
	RCALL SUBOPT_0x51
; 0000 02E7             P02=0;
	CLT
	BLD  R3,2
; 0000 02E8             P03=1;
	SET
	BLD  R3,3
; 0000 02E9             P04=0;
	CLT
	BLD  R3,4
; 0000 02EA             par_ust=1;
	RCALL SUBOPT_0x52
; 0000 02EB             if (knopka_left==1)
	SBRC R2,0
; 0000 02EC               {
; 0000 02ED                 screen--;
	RCALL SUBOPT_0x56
; 0000 02EE                 knopka_left=0;
; 0000 02EF               };
; 0000 02F0             if (knopka_right==1)
	SBRC R2,1
; 0000 02F1               {
; 0000 02F2                screen++;
	RCALL SUBOPT_0x54
; 0000 02F3                knopka_right=0;
; 0000 02F4               };
; 0000 02F5             if (knopka_middle==1)
	SBRS R2,2
	RJMP _0x16D
; 0000 02F6             {
; 0000 02F7              knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 02F8              screen=23;
	LDI  R30,LOW(23)
	MOV  R12,R30
; 0000 02F9             };
_0x16D:
; 0000 02FA             break;
	RJMP _0x14E
; 0000 02FB            };
; 0000 02FC 
; 0000 02FD        case 8:                            // Коррекция температуры
_0x16A:
	RCALL SUBOPT_0x8
	BRNE _0x16E
; 0000 02FE            {
; 0000 02FF             show_termostat=0;
	RCALL SUBOPT_0x4C
; 0000 0300             show_ustavku=0;
	RCALL SUBOPT_0x4D
; 0000 0301             show_temp=0;
	RCALL SUBOPT_0x51
; 0000 0302             P03=0;
	CLT
	BLD  R3,3
; 0000 0303             P04=1;
	SET
	BLD  R3,4
; 0000 0304             P05=0;
	CLT
	BLD  R3,5
; 0000 0305             par_ust=1;
	RCALL SUBOPT_0x52
; 0000 0306             if (knopka_left==1)
	SBRC R2,0
; 0000 0307               {
; 0000 0308                 screen--;
	RCALL SUBOPT_0x56
; 0000 0309                 knopka_left=0;
; 0000 030A               };
; 0000 030B             if (knopka_right==1)
	SBRC R2,1
; 0000 030C               {
; 0000 030D                screen++;
	RCALL SUBOPT_0x54
; 0000 030E                knopka_right=0;
; 0000 030F               };
; 0000 0310             if (knopka_middle==1)
	SBRS R2,2
	RJMP _0x171
; 0000 0311               {
; 0000 0312                knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 0313                screen=24;
	LDI  R30,LOW(24)
	MOV  R12,R30
; 0000 0314               };
_0x171:
; 0000 0315             break;
	RJMP _0x14E
; 0000 0316            };
; 0000 0317 
; 0000 0318        case 9:                            // Гистерезис
_0x16E:
	RCALL SUBOPT_0x9
	BRNE _0x172
; 0000 0319            {
; 0000 031A             show_termostat=0;
	RCALL SUBOPT_0x4C
; 0000 031B             show_ustavku=0;
	RCALL SUBOPT_0x4D
; 0000 031C             show_temp=0;
	RCALL SUBOPT_0x51
; 0000 031D             P04=0;
	CLT
	BLD  R3,4
; 0000 031E             P05=1;
	SET
	BLD  R3,5
; 0000 031F             P06=0;
	CLT
	BLD  R3,6
; 0000 0320             par_ust=1;
	RCALL SUBOPT_0x52
; 0000 0321             if (knopka_left==1)
	SBRC R2,0
; 0000 0322               {
; 0000 0323                 screen--;
	RCALL SUBOPT_0x56
; 0000 0324                 knopka_left=0;
; 0000 0325               };
; 0000 0326             if (knopka_right==1)
	SBRC R2,1
; 0000 0327               {
; 0000 0328                screen++;
	RCALL SUBOPT_0x54
; 0000 0329                knopka_right=0;
; 0000 032A               };
; 0000 032B             if (knopka_middle==1)
	SBRS R2,2
	RJMP _0x175
; 0000 032C               {
; 0000 032D                knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 032E                screen=25;
	LDI  R30,LOW(25)
	MOV  R12,R30
; 0000 032F               };
_0x175:
; 0000 0330             break;
	RJMP _0x14E
; 0000 0331            };
; 0000 0332 
; 0000 0333        case 10:                            // Уставка температуры
_0x172:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x176
; 0000 0334            {
; 0000 0335             show_termostat=0;
	RCALL SUBOPT_0x4C
; 0000 0336             show_ustavku=0;
	RCALL SUBOPT_0x4D
; 0000 0337             show_temp=0;
	RCALL SUBOPT_0x51
; 0000 0338             P05=0;
	CLT
	BLD  R3,5
; 0000 0339             P06=1;
	SET
	BLD  R3,6
; 0000 033A             exit=0;
	CLT
	BLD  R3,7
; 0000 033B             par_ust=1;
	RCALL SUBOPT_0x52
; 0000 033C             if (knopka_left==1)
	SBRC R2,0
; 0000 033D               {
; 0000 033E                 screen--;
	RCALL SUBOPT_0x56
; 0000 033F                 knopka_left=0;
; 0000 0340               };
; 0000 0341             if (knopka_right==1)
	SBRC R2,1
; 0000 0342               {
; 0000 0343                screen++;
	RCALL SUBOPT_0x54
; 0000 0344                knopka_right=0;
; 0000 0345               };
; 0000 0346             if (knopka_middle==1)
	SBRS R2,2
	RJMP _0x179
; 0000 0347               {
; 0000 0348                knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 0349                screen=26;
	LDI  R30,LOW(26)
	MOV  R12,R30
; 0000 034A               };
_0x179:
; 0000 034B             break;
	RJMP _0x14E
; 0000 034C            };
; 0000 034D 
; 0000 034E        case 11:                            // Возможность выйти
_0x176:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x17A
; 0000 034F            {
; 0000 0350             show_termostat=0;
	RCALL SUBOPT_0x4C
; 0000 0351             show_ustavku=0;
	RCALL SUBOPT_0x4D
; 0000 0352             show_temp=0;
	RCALL SUBOPT_0x51
; 0000 0353             par_ust=1;
	RCALL SUBOPT_0x52
; 0000 0354             P06=0;
	CLT
	BLD  R3,6
; 0000 0355             exit=1;
	SET
	BLD  R3,7
; 0000 0356             P00=0;
	CLT
	BLD  R3,0
; 0000 0357             if (knopka_left==1)
	SBRC R2,0
; 0000 0358               {
; 0000 0359                 screen--;
	RCALL SUBOPT_0x56
; 0000 035A                 knopka_left=0;
; 0000 035B               };
; 0000 035C             if (knopka_right==1)
	SBRS R2,1
	RJMP _0x17C
; 0000 035D               {
; 0000 035E                screen++;
	INC  R12
; 0000 035F                if(screen>11)
	LDI  R30,LOW(11)
	CP   R30,R12
	BRGE _0x17D
; 0000 0360                  screen=4;
	LDI  R30,LOW(4)
	MOV  R12,R30
; 0000 0361                knopka_right=0;
_0x17D:
	RCALL SUBOPT_0x57
; 0000 0362               };
_0x17C:
; 0000 0363             if (knopka_middle==1)
	SBRS R2,2
	RJMP _0x17E
; 0000 0364              {
; 0000 0365               show_termostat=0;
	RCALL SUBOPT_0x4C
; 0000 0366               show_ustavku=0;
	RCALL SUBOPT_0x4D
; 0000 0367               show_temp=1;
	SET
	BLD  R2,4
; 0000 0368               par_ust=0;
	RCALL SUBOPT_0x58
; 0000 0369               screen=0;
	CLR  R12
; 0000 036A               exit=0;
	CLT
	BLD  R3,7
; 0000 036B               knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 036C              };
_0x17E:
; 0000 036D             break;
	RJMP _0x14E
; 0000 036E            };
; 0000 036F 
; 0000 0370        case 20:                            // Режим работы
_0x17A:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x17F
; 0000 0371            {
; 0000 0372             par_ust=0;
	RCALL SUBOPT_0x58
; 0000 0373             show_par=1;
	RCALL SUBOPT_0x59
; 0000 0374             if(P0==1)                      // HOT
	RCALL SUBOPT_0x5A
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x180
; 0000 0375               {
; 0000 0376                t1=kod[12];
	__GETBRMN 7,_kod_G000,12
; 0000 0377                t2=kod[15];
	__GETBRMN 6,_kod_G000,15
; 0000 0378                t3=kod[17];
	__GETBRMN 9,_kod_G000,17
; 0000 0379               }
; 0000 037A             else                           // COLD
	RJMP _0x181
_0x180:
; 0000 037B               {
; 0000 037C                t1=kod[16];
	__GETBRMN 7,_kod_G000,16
; 0000 037D                t2=kod[15];
	__GETBRMN 6,_kod_G000,15
; 0000 037E                t3=kod[14];
	__GETBRMN 9,_kod_G000,14
; 0000 037F               };
_0x181:
; 0000 0380             if(knopka_left==1)
	SBRS R2,0
	RJMP _0x182
; 0000 0381               {
; 0000 0382                knopka_left=0;
	RCALL SUBOPT_0x55
; 0000 0383                P0=0;
	RCALL SUBOPT_0x5A
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 0384               };
_0x182:
; 0000 0385             if(knopka_right==1)
	SBRS R2,1
	RJMP _0x183
; 0000 0386               {
; 0000 0387                knopka_right=0;
	RCALL SUBOPT_0x57
; 0000 0388                P0=1;
	RCALL SUBOPT_0x5A
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 0389               };
_0x183:
; 0000 038A             if(knopka_middle==1)
	SBRS R2,2
	RJMP _0x184
; 0000 038B               {
; 0000 038C                knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 038D                screen=4;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x5B
; 0000 038E                P00=0;
	BLD  R3,0
; 0000 038F                show_par=0;
	RCALL SUBOPT_0x5C
; 0000 0390               };
_0x184:
; 0000 0391             break;
	RJMP _0x14E
; 0000 0392            };
; 0000 0393 
; 0000 0394        case 21:                            // Нижний порог температуры срабатывания
_0x17F:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0x185
; 0000 0395            {
; 0000 0396             par_ust=0;
	RCALL SUBOPT_0x58
; 0000 0397             show_par=1;
	RCALL SUBOPT_0x59
; 0000 0398              if(flag_enter==0)
	SBRC R4,1
	RJMP _0x186
; 0000 0399              {
; 0000 039A               par=P1;
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x5E
; 0000 039B               flag_enter=1;
; 0000 039C              }
; 0000 039D             if(knopka_left==1)
_0x186:
	SBRS R2,0
	RJMP _0x187
; 0000 039E               {
; 0000 039F                knopka_left=0;
	RCALL SUBOPT_0x55
; 0000 03A0                par-=5;
	RCALL SUBOPT_0x5F
	RCALL SUBOPT_0x60
; 0000 03A1                if (par < 0)
	BRPL _0x188
; 0000 03A2                   par = 150;
	RCALL SUBOPT_0x61
; 0000 03A3               };
_0x188:
_0x187:
; 0000 03A4             if(knopka_right==1)
	SBRS R2,1
	RJMP _0x189
; 0000 03A5               {
; 0000 03A6                knopka_right=0;
	RCALL SUBOPT_0x57
; 0000 03A7                par+=5;
	RCALL SUBOPT_0x62
; 0000 03A8                if (par>150)
	BRLT _0x18A
; 0000 03A9                   par = 0;
	RCALL SUBOPT_0x63
; 0000 03AA               };
_0x18A:
_0x189:
; 0000 03AB             if(knopka_middle==1)
	SBRS R2,2
	RJMP _0x18B
; 0000 03AC               {
; 0000 03AD                knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 03AE                screen=5;
	LDI  R30,LOW(5)
	MOV  R12,R30
; 0000 03AF                P01=0;
	RCALL SUBOPT_0x53
; 0000 03B0                show_par=0;
	RCALL SUBOPT_0x5C
; 0000 03B1                flag_enter=0;
	CLT
	BLD  R4,1
; 0000 03B2                P1=par;
	RCALL SUBOPT_0x5F
	RCALL SUBOPT_0x5D
	RCALL __EEPROMWRW
; 0000 03B3               };
_0x18B:
; 0000 03B4             break;
	RJMP _0x14E
; 0000 03B5            };
; 0000 03B6 
; 0000 03B7        case 22:                            // Верхний порог температуры срабатывания
_0x185:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0x18C
; 0000 03B8            {
; 0000 03B9             par_ust=0;
	RCALL SUBOPT_0x58
; 0000 03BA             show_par=1;
	RCALL SUBOPT_0x59
; 0000 03BB             if(flag_enter==0)
	SBRC R4,1
	RJMP _0x18D
; 0000 03BC              {
; 0000 03BD               par=P2;
	RCALL SUBOPT_0x64
	RCALL SUBOPT_0x5E
; 0000 03BE               flag_enter=1;
; 0000 03BF              }
; 0000 03C0             if(knopka_left==1)
_0x18D:
	SBRS R2,0
	RJMP _0x18E
; 0000 03C1               {
; 0000 03C2                knopka_left=0;
	RCALL SUBOPT_0x55
; 0000 03C3                par-=5;
	RCALL SUBOPT_0x5F
	RCALL SUBOPT_0x60
; 0000 03C4                if (par < 0)
	BRPL _0x18F
; 0000 03C5                   par = 150;
	RCALL SUBOPT_0x61
; 0000 03C6               };
_0x18F:
_0x18E:
; 0000 03C7             if(knopka_right==1)
	SBRS R2,1
	RJMP _0x190
; 0000 03C8               {
; 0000 03C9                knopka_right=0;
	RCALL SUBOPT_0x57
; 0000 03CA                par+=5;
	RCALL SUBOPT_0x62
; 0000 03CB                if (par>150)
	BRLT _0x191
; 0000 03CC                   par = 0;
	RCALL SUBOPT_0x63
; 0000 03CD               };
_0x191:
_0x190:
; 0000 03CE             if(knopka_middle==1)
	SBRS R2,2
	RJMP _0x192
; 0000 03CF               {
; 0000 03D0                knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 03D1                screen=6;
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x5B
; 0000 03D2                P02=0;
	BLD  R3,2
; 0000 03D3                show_par=0;
	RCALL SUBOPT_0x5C
; 0000 03D4                flag_enter=0;
	RCALL SUBOPT_0x65
; 0000 03D5                P2=par;
	RCALL SUBOPT_0x5F
	RCALL SUBOPT_0x64
	RCALL __EEPROMWRW
; 0000 03D6               };
_0x192:
; 0000 03D7             break;
	RJMP _0x14E
; 0000 03D8            };
; 0000 03D9 
; 0000 03DA        case 23:                            // Вкл\Выкл буззер
_0x18C:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0x193
; 0000 03DB            {
; 0000 03DC             par_ust=0;
	RCALL SUBOPT_0x58
; 0000 03DD             show_par=1;
	RCALL SUBOPT_0x59
; 0000 03DE             if(P3==1)
	RCALL SUBOPT_0x4A
	BRNE _0x194
; 0000 03DF               {
; 0000 03E0                t1=0xFF;
	LDI  R30,LOW(255)
	MOV  R7,R30
; 0000 03E1                t2=kod[18];
	__GETBRMN 6,_kod_G000,18
; 0000 03E2                t3=kod[0];
	RCALL SUBOPT_0xB
; 0000 03E3               };
_0x194:
; 0000 03E4 
; 0000 03E5             if(P3==0)
	LDI  R26,LOW(_P3)
	LDI  R27,HIGH(_P3)
	RCALL __EEPROMRDB
	CPI  R30,0
	BRNE _0x195
; 0000 03E6               {
; 0000 03E7                t1=kod[19];
	__GETBRMN 7,_kod_G000,19
; 0000 03E8                t2=kod[19];
	__GETBRMN 6,_kod_G000,19
; 0000 03E9                t3=kod[0];
	RCALL SUBOPT_0xB
; 0000 03EA               };
_0x195:
; 0000 03EB             if(knopka_left==1)
	SBRS R2,0
	RJMP _0x196
; 0000 03EC               {
; 0000 03ED                knopka_left=0;
	RCALL SUBOPT_0x55
; 0000 03EE                P3=1;
	LDI  R26,LOW(_P3)
	LDI  R27,HIGH(_P3)
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
; 0000 03EF               };
_0x196:
; 0000 03F0             if(knopka_right==1)
	SBRS R2,1
	RJMP _0x197
; 0000 03F1               {
; 0000 03F2                knopka_right=0;
	RCALL SUBOPT_0x57
; 0000 03F3                P3=0;
	LDI  R26,LOW(_P3)
	LDI  R27,HIGH(_P3)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 03F4               };
_0x197:
; 0000 03F5             if(knopka_middle==1)
	SBRS R2,2
	RJMP _0x198
; 0000 03F6               {
; 0000 03F7                knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 03F8                screen=7;
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x5B
; 0000 03F9                P03=0;
	BLD  R3,3
; 0000 03FA                show_par=0;
	RCALL SUBOPT_0x5C
; 0000 03FB               };
_0x198:
; 0000 03FC             break;
	RJMP _0x14E
; 0000 03FD            };
; 0000 03FE 
; 0000 03FF        case 24:                            // Коррекция температуры
_0x193:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x199
; 0000 0400            {
; 0000 0401             par_ust=0;
	RCALL SUBOPT_0x58
; 0000 0402             show_par=1;
	RCALL SUBOPT_0x59
; 0000 0403             if(flag_enter==0)
	SBRC R4,1
	RJMP _0x19A
; 0000 0404              {
; 0000 0405               par=P4;
	LDI  R26,LOW(_P4)
	LDI  R27,HIGH(_P4)
	RCALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RCALL SUBOPT_0x66
; 0000 0406               flag_enter=1;
	RCALL SUBOPT_0x67
; 0000 0407               minus=par;
	RCALL SUBOPT_0x68
; 0000 0408              }
; 0000 0409             if(knopka_left==1)
_0x19A:
	SBRS R2,0
	RJMP _0x19B
; 0000 040A              {
; 0000 040B               knopka_left=0;
	RCALL SUBOPT_0x55
; 0000 040C               par--;
	LDI  R26,LOW(_par)
	LDI  R27,HIGH(_par)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 040D               minus=par;
	RCALL SUBOPT_0x68
; 0000 040E               if(par < 0)
	RCALL SUBOPT_0x69
	BRPL _0x19C
; 0000 040F                 {
; 0000 0410                 flag_minus=1;
	RCALL SUBOPT_0x6A
; 0000 0411                 minus=(-par);
; 0000 0412                  if (par<-90)
	RCALL SUBOPT_0x49
	CPI  R26,LOW(0xFFA6)
	LDI  R30,HIGH(0xFFA6)
	CPC  R27,R30
	BRGE _0x19D
; 0000 0413                    {
; 0000 0414                    par=90;
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RCALL SUBOPT_0x66
; 0000 0415                    minus=par;
	RCALL SUBOPT_0x68
; 0000 0416                    };
_0x19D:
; 0000 0417 
; 0000 0418                 }
; 0000 0419              };
_0x19C:
_0x19B:
; 0000 041A             if(knopka_right==1)
	SBRS R2,1
	RJMP _0x19E
; 0000 041B              {
; 0000 041C               knopka_right=0;
	RCALL SUBOPT_0x57
; 0000 041D               par++;
	LDI  R26,LOW(_par)
	LDI  R27,HIGH(_par)
	RCALL SUBOPT_0x44
; 0000 041E               minus=par;
	RCALL SUBOPT_0x68
; 0000 041F               if(par<0)
	RCALL SUBOPT_0x69
	BRPL _0x19F
; 0000 0420                 {
; 0000 0421                  flag_minus=1;
	RCALL SUBOPT_0x6A
; 0000 0422                  minus=-par;
; 0000 0423                 };
_0x19F:
; 0000 0424               if(par>90)
	RCALL SUBOPT_0x49
	CPI  R26,LOW(0x5B)
	LDI  R30,HIGH(0x5B)
	CPC  R27,R30
	BRLT _0x1A0
; 0000 0425                 {
; 0000 0426                  par=-90;
	LDI  R30,LOW(65446)
	LDI  R31,HIGH(65446)
	RCALL SUBOPT_0x66
; 0000 0427                  minus=-par;
	RCALL SUBOPT_0x5F
	RCALL __ANEGW1
	STS  _minus,R30
	STS  _minus+1,R31
; 0000 0428                  flag_minus=1;
	SET
	BLD  R4,3
; 0000 0429                 };
_0x1A0:
; 0000 042A              };
_0x19E:
; 0000 042B             if(par>0)
	RCALL SUBOPT_0x49
	RCALL __CPW02
	BRGE _0x1A1
; 0000 042C               flag_minus=0;
	CLT
	BLD  R4,3
; 0000 042D             if(knopka_middle==1)
_0x1A1:
	SBRS R2,2
	RJMP _0x1A2
; 0000 042E              {
; 0000 042F               knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 0430               screen=8;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x5B
; 0000 0431               P04=0;
	BLD  R3,4
; 0000 0432               show_par=0;
	RCALL SUBOPT_0x5C
; 0000 0433               flag_enter=0;
	RCALL SUBOPT_0x65
; 0000 0434               P4=par;
	LDS  R30,_par
	LDI  R26,LOW(_P4)
	LDI  R27,HIGH(_P4)
	RCALL __EEPROMWRB
; 0000 0435              };
_0x1A2:
; 0000 0436             break;
	RJMP _0x14E
; 0000 0437            };
; 0000 0438 
; 0000 0439        case 25:                            // Гистерезис
_0x199:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0x1A3
; 0000 043A            {
; 0000 043B             par_ust=0;
	RCALL SUBOPT_0x58
; 0000 043C             show_par=1;
	RCALL SUBOPT_0x59
; 0000 043D             if(flag_enter==0)
	SBRC R4,1
	RJMP _0x1A4
; 0000 043E               {
; 0000 043F                par=P5;
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x6C
	RCALL SUBOPT_0x66
; 0000 0440                flag_enter=1;
	RCALL SUBOPT_0x67
; 0000 0441               }
; 0000 0442             if(knopka_left==1)
_0x1A4:
	SBRS R2,0
	RJMP _0x1A5
; 0000 0443               {
; 0000 0444                knopka_left=0;
	RCALL SUBOPT_0x55
; 0000 0445                par-=2;
	RCALL SUBOPT_0x5F
	SBIW R30,2
	RCALL SUBOPT_0x66
; 0000 0446                if(par<0)
	RCALL SUBOPT_0x69
	BRPL _0x1A6
; 0000 0447                  par=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x66
; 0000 0448               };
_0x1A6:
_0x1A5:
; 0000 0449             if(knopka_right==1)
	SBRS R2,1
	RJMP _0x1A7
; 0000 044A               {
; 0000 044B                knopka_right=0;
	RCALL SUBOPT_0x57
; 0000 044C                par+=2;
	RCALL SUBOPT_0x5F
	ADIW R30,2
	RCALL SUBOPT_0x66
; 0000 044D                if(par>10)
	RCALL SUBOPT_0x49
	SBIW R26,11
	BRLT _0x1A8
; 0000 044E                  par=0;
	RCALL SUBOPT_0x63
; 0000 044F               };
_0x1A8:
_0x1A7:
; 0000 0450             if(knopka_middle==1)
	SBRS R2,2
	RJMP _0x1A9
; 0000 0451               {
; 0000 0452                knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 0453                screen=9;
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x5B
; 0000 0454                P05=0;
	BLD  R3,5
; 0000 0455                show_par=0;
	RCALL SUBOPT_0x5C
; 0000 0456                flag_enter=0;
	RCALL SUBOPT_0x65
; 0000 0457                P5=par/2;
	RCALL SUBOPT_0x49
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __DIVW21
	RCALL SUBOPT_0x6B
	RCALL __EEPROMWRB
; 0000 0458               };
_0x1A9:
; 0000 0459             break;
	RJMP _0x14E
; 0000 045A            };
; 0000 045B 
; 0000 045C        case 26:                            // Уставка температуры
_0x1A3:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0x14E
; 0000 045D            {
; 0000 045E             par_ust=0;
	RCALL SUBOPT_0x58
; 0000 045F             show_par=1;
	RCALL SUBOPT_0x59
; 0000 0460             if(flag_enter==0)
	SBRC R4,1
	RJMP _0x1AB
; 0000 0461               {
; 0000 0462                par=P6;
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x66
; 0000 0463                flag_enter=1;
	RCALL SUBOPT_0x67
; 0000 0464               }
; 0000 0465             if(knopka_left==1)
_0x1AB:
	SBRS R2,0
	RJMP _0x1AC
; 0000 0466               {
; 0000 0467                knopka_left=0;
	RCALL SUBOPT_0x55
; 0000 0468                par-=5;
	RCALL SUBOPT_0x5F
	SBIW R30,5
	RCALL SUBOPT_0x66
; 0000 0469                if(par<P1)
	RCALL SUBOPT_0x5D
	RCALL __EEPROMRDW
	RCALL SUBOPT_0x49
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x1AD
; 0000 046A                  par=P2;
	RCALL SUBOPT_0x64
	RCALL __EEPROMRDW
	RCALL SUBOPT_0x66
; 0000 046B               };
_0x1AD:
_0x1AC:
; 0000 046C             if(knopka_right==1)
	SBRS R2,1
	RJMP _0x1AE
; 0000 046D               {
; 0000 046E                knopka_right=0;
	RCALL SUBOPT_0x57
; 0000 046F                par+=5;
	RCALL SUBOPT_0x5F
	ADIW R30,5
	RCALL SUBOPT_0x66
; 0000 0470                if(par>P2)
	RCALL SUBOPT_0x64
	RCALL __EEPROMRDW
	RCALL SUBOPT_0x49
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x1AF
; 0000 0471                  par=P1;
	RCALL SUBOPT_0x5D
	RCALL __EEPROMRDW
	RCALL SUBOPT_0x66
; 0000 0472               };
_0x1AF:
_0x1AE:
; 0000 0473             if(knopka_middle==1)
	SBRS R2,2
	RJMP _0x1B0
; 0000 0474               {
; 0000 0475                knopka_middle=0;
	RCALL SUBOPT_0x50
; 0000 0476                screen=10;
	LDI  R30,LOW(10)
	MOV  R12,R30
; 0000 0477                P01=0;
	RCALL SUBOPT_0x53
; 0000 0478                show_par=0;
	RCALL SUBOPT_0x5C
; 0000 0479                flag_enter=0;
	RCALL SUBOPT_0x65
; 0000 047A                P6=par;
	LDS  R30,_par
	RCALL SUBOPT_0x6D
	RCALL __EEPROMWRB
; 0000 047B               };
_0x1B0:
; 0000 047C             break;
; 0000 047D            };
; 0000 047E       }
_0x14E:
; 0000 047F 
; 0000 0480 if(show_termostat==0)
	SBRC R2,5
	RJMP _0x1B1
; 0000 0481  {
; 0000 0482   PORTC.1=0;
	CBI  0x15,1
; 0000 0483   PORTC.2=0;
	CBI  0x15,2
; 0000 0484   PORTB.5=0;
	CBI  0x18,5
; 0000 0485  };
_0x1B1:
; 0000 0486 
; 0000 0487 if(P0==0 & show_termostat==1)
	RCALL SUBOPT_0x5A
	RCALL __EEPROMRDB
	LDI  R26,LOW(0)
	RCALL __EQB12
	MOV  R0,R30
	RCALL SUBOPT_0x42
	AND  R30,R0
	BREQ _0x1B8
; 0000 0488   {
; 0000 0489    if((buffer-P5)<P6)
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x6F
	RCALL SUBOPT_0x70
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x1B9
; 0000 048A      {
; 0000 048B       PORTB.5=0;
	CBI  0x18,5
; 0000 048C       PORTC.2=0;
	CBI  0x15,2
; 0000 048D       flag_enter=0;
	RCALL SUBOPT_0x65
; 0000 048E       PORTC.0=0;
	CBI  0x15,0
; 0000 048F      };
_0x1B9:
; 0000 0490    if((buffer+P5)>P6)
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x71
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x1C0
; 0000 0491      {
; 0000 0492       PORTB.5=1;
	SBI  0x18,5
; 0000 0493       PORTC.2=1;
	SBI  0x15,2
; 0000 0494       if(flag_enter==0)
	SBRC R4,1
	RJMP _0x1C5
; 0000 0495         {
; 0000 0496          counter_buzzer=0;
	CLR  R13
; 0000 0497          flag_enter=1;
	RCALL SUBOPT_0x67
; 0000 0498         };
_0x1C5:
; 0000 0499      };
_0x1C0:
; 0000 049A   };
_0x1B8:
; 0000 049B 
; 0000 049C if(P0==1 & show_termostat==1)
	RCALL SUBOPT_0x5A
	RCALL __EEPROMRDB
	LDI  R26,LOW(1)
	RCALL __EQB12
	MOV  R0,R30
	RCALL SUBOPT_0x42
	AND  R30,R0
	BREQ _0x1C6
; 0000 049D   {
; 0000 049E    if((buffer+P5)<P6)
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x71
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x1C7
; 0000 049F      {
; 0000 04A0       PORTB.5=1;
	SBI  0x18,5
; 0000 04A1       PORTC.1=1;
	SBI  0x15,1
; 0000 04A2       if(flag_enter==0)
	SBRC R4,1
	RJMP _0x1CC
; 0000 04A3         {
; 0000 04A4          counter_buzzer=0;
	CLR  R13
; 0000 04A5          flag_enter=1;
	RCALL SUBOPT_0x67
; 0000 04A6         };
_0x1CC:
; 0000 04A7      };
_0x1C7:
; 0000 04A8    if((buffer-P5)>P6)
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x6F
	RCALL SUBOPT_0x70
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x1CD
; 0000 04A9      {
; 0000 04AA       PORTB.5=0;
	CBI  0x18,5
; 0000 04AB       PORTC.1=0;
	CBI  0x15,1
; 0000 04AC       flag_enter=0;
	RCALL SUBOPT_0x65
; 0000 04AD       PORTC.0=0;
	CBI  0x15,0
; 0000 04AE      }
; 0000 04AF   };
_0x1CD:
_0x1C6:
; 0000 04B0 
; 0000 04B1 /*if(buzzer==50 && P3 == 1)
; 0000 04B2   {
; 0000 04B3      if(counter_buzzer<10 && flag_enter==1)
; 0000 04B4      {
; 0000 04B5       PORTC.0 = 1;
; 0000 04B6       counter_buzzer++;
; 0000 04B7      };
; 0000 04B8   };
; 0000 04B9 
; 0000 04BA if(buzzer==100 && P3 == 1)
; 0000 04BB   {
; 0000 04BC    if(counter_buzzer<10 && flag_enter==1)
; 0000 04BD      {
; 0000 04BE       PORTC.0 = 0;
; 0000 04BF       counter_buzzer++;
; 0000 04C0      };
; 0000 04C1   };
; 0000 04C2   if (counter_buzzer>10)
; 0000 04C3    {PORTC.0 = 0;};  */
; 0000 04C4 
; 0000 04C5 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;
;
;
;
;
;
;void main(void)
; 0000 04CF {
_main:
; .FSTART _main
; 0000 04D0 // Declare your local variables here
; 0000 04D1 
; 0000 04D2 // Input/Output Ports initialization
; 0000 04D3 // Port B initialization
; 0000 04D4 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 04D5 DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(225)
	OUT  0x17,R30
; 0000 04D6 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=T Bit3=P Bit2=P Bit1=P Bit0=0
; 0000 04D7 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(14)
	OUT  0x18,R30
; 0000 04D8 
; 0000 04D9 // Port C initialization
; 0000 04DA // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 04DB DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 04DC // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 04DD PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 04DE 
; 0000 04DF // Port D initialization
; 0000 04E0 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 04E1 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 04E2 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 04E3 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 04E4 
; 0000 04E5 // Timer/Counter 0 initialization
; 0000 04E6 // Clock source: System Clock
; 0000 04E7 // Clock value: 31,250 kHz
; 0000 04E8 TCCR0=(1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 04E9 TCNT0=0x9C;
	LDI  R30,LOW(156)
	OUT  0x32,R30
; 0000 04EA 
; 0000 04EB // Timer/Counter 1 initialization
; 0000 04EC // Clock source: System Clock
; 0000 04ED // Clock value: 1000,000 kHz
; 0000 04EE // Mode: Normal top=0xFFFF
; 0000 04EF // OC1A output: Disconnected
; 0000 04F0 // OC1B output: Disconnected
; 0000 04F1 // Noise Canceler: Off
; 0000 04F2 // Input Capture on Falling Edge
; 0000 04F3 // Timer Period: 10 ms
; 0000 04F4 // Timer1 Overflow Interrupt: On
; 0000 04F5 // Input Capture Interrupt: Off
; 0000 04F6 // Compare A Match Interrupt: Off
; 0000 04F7 // Compare B Match Interrupt: Off
; 0000 04F8 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 04F9 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 04FA TCNT1H=0xD8;
	RCALL SUBOPT_0x43
; 0000 04FB TCNT1L=0xF0;
; 0000 04FC ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 04FD ICR1L=0x00;
	OUT  0x26,R30
; 0000 04FE OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 04FF OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0500 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0501 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0502 
; 0000 0503 // Timer/Counter 2 initialization
; 0000 0504 // Clock source: System Clock
; 0000 0505 // Clock value: 1000,000 kHz
; 0000 0506 // Mode: Normal top=0xFF
; 0000 0507 // OC2 output: Disconnected
; 0000 0508 // Timer Period: 0,2 ms
; 0000 0509 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 050A TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (1<<CS21) | (0<<CS20);
	LDI  R30,LOW(2)
	OUT  0x25,R30
; 0000 050B TCNT2=0x38;
	LDI  R30,LOW(56)
	OUT  0x24,R30
; 0000 050C OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 050D 
; 0000 050E // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 050F TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(69)
	OUT  0x39,R30
; 0000 0510 
; 0000 0511 // External Interrupt(s) initialization
; 0000 0512 // INT0: Off
; 0000 0513 // INT1: Off
; 0000 0514 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0515 
; 0000 0516 // USART initialization
; 0000 0517 // USART disabled
; 0000 0518 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0519 
; 0000 051A // Analog Comparator initialization
; 0000 051B // Analog Comparator: Off
; 0000 051C // The Analog Comparator's positive input is
; 0000 051D // connected to the AIN0 pin
; 0000 051E // The Analog Comparator's negative input is
; 0000 051F // connected to the AIN1 pin
; 0000 0520 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0521 
; 0000 0522 // ADC initialization
; 0000 0523 // ADC Clock frequency: 125,000 kHz
; 0000 0524 // ADC Voltage Reference: AVCC pin
; 0000 0525 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0526 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 0527 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0528 
; 0000 0529 // Global enable interrupts
; 0000 052A #asm("sei")
	sei
; 0000 052B 
; 0000 052C while (1)
_0x1D4:
; 0000 052D       {
; 0000 052E       }
	RJMP _0x1D4
; 0000 052F }
_0x1D7:
	RJMP _0x1D7
; .FEND
;
;

	.ESEG
_P4:
	.BYTE 0x1
_P1:
	.DB  0x14,0x0
_P2:
	.DB  0x96,0x0
_P0:
	.BYTE 0x1
_P3:
	.BYTE 0x1
_P5:
	.BYTE 0x1
_P6:
	.BYTE 0x1

	.DSEG
_kod_G000:
	.BYTE 0x14
_par:
	.BYTE 0x2
_buffer:
	.BYTE 0x2
_minus:
	.BYTE 0x2
_buzzer:
	.BYTE 0x2
_adc:
	.BYTE 0x2
_filterin:
	.BYTE 0x2
_wait_timer2:
	.BYTE 0x2
_currtemp:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LDS  R6,_kod_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDS  R9,_kod_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 155 TIMES, CODE SIZE REDUCTION:460 WORDS
SUBOPT_0xC:
	LDS  R26,_adc
	LDS  R27,_adc+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 51 TIMES, CODE SIZE REDUCTION:198 WORDS
SUBOPT_0xD:
	SUB  R30,R26
	SBC  R31,R27
	RCALL __CWD1
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 51 TIMES, CODE SIZE REDUCTION:198 WORDS
SUBOPT_0xE:
	RCALL __ADDF12
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x4B)
	LDI  R30,HIGH(0x4B)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x56)
	LDI  R30,HIGH(0x56)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x63)
	LDI  R30,HIGH(0x63)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x72)
	LDI  R30,HIGH(0x72)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x84)
	LDI  R30,HIGH(0x84)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x99)
	LDI  R30,HIGH(0x99)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0xB1)
	LDI  R30,HIGH(0xB1)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0xCC)
	LDI  R30,HIGH(0xCC)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	__GETD2N 0x3E3851EC
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0xEC)
	LDI  R30,HIGH(0xEC)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x10F)
	LDI  R30,HIGH(0x10F)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x138)
	LDI  R30,HIGH(0x138)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x164)
	LDI  R30,HIGH(0x164)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	__GETD2N 0x3DE147AE
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x195)
	LDI  R30,HIGH(0x195)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x1F:
	__GETD2N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x1C9)
	LDI  R30,HIGH(0x1C9)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x1D5)
	LDI  R30,HIGH(0x1D5)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x22:
	__GETD2N 0x3DA3D70A
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x1E0)
	LDI  R30,HIGH(0x1E0)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x24:
	__GETD2N 0x3DB851EC
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x1EB)
	LDI  R30,HIGH(0x1EB)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x1F6)
	LDI  R30,HIGH(0x1F6)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x200)
	LDI  R30,HIGH(0x200)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x20C)
	LDI  R30,HIGH(0x20C)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x218)
	LDI  R30,HIGH(0x218)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x224)
	LDI  R30,HIGH(0x224)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x22E)
	LDI  R30,HIGH(0x22E)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x239)
	LDI  R30,HIGH(0x239)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x245)
	LDI  R30,HIGH(0x245)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x251)
	LDI  R30,HIGH(0x251)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x25D)
	LDI  R30,HIGH(0x25D)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x267)
	LDI  R30,HIGH(0x267)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x274)
	LDI  R30,HIGH(0x274)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x27E)
	LDI  R30,HIGH(0x27E)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x28A)
	LDI  R30,HIGH(0x28A)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x295)
	LDI  R30,HIGH(0x295)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x29F)
	LDI  R30,HIGH(0x29F)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x2A9)
	LDI  R30,HIGH(0x2A9)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	__GETD2N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x2DE)
	LDI  R30,HIGH(0x2DE)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x30F)
	LDI  R30,HIGH(0x30F)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x33C)
	LDI  R30,HIGH(0x33C)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x363)
	LDI  R30,HIGH(0x363)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x384)
	LDI  R30,HIGH(0x384)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x3A0)
	LDI  R30,HIGH(0x3A0)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x3B6)
	LDI  R30,HIGH(0x3B6)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x3F:
	LDS  R26,_buffer
	LDS  R27,_buffer+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x40:
	OUT  0x12,R7
	CBI  0x18,0
	CBI  0x18,6
	SBI  0x18,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	OUT  0x12,R9
	SBI  0x18,0
	CBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x42:
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	LDI  R30,LOW(1)
	RCALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	LDI  R30,LOW(216)
	OUT  0x2D,R30
	LDI  R30,LOW(240)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x44:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x45:
	RCALL _readtemp
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	RCALL __CFD1
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x46:
	LDI  R26,LOW(_currtemp)
	LDI  R27,HIGH(_currtemp)
	RCALL __CFD1
	ST   X+,R30
	ST   X,R31
	LDS  R26,_currtemp
	LDS  R27,_currtemp+1
	RJMP _getkodes

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	LDI  R26,LOW(_P6)
	LDI  R27,HIGH(_P6)
	RCALL __EEPROMRDB
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x48:
	__GETBRMN 9,_kod_G000,13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x49:
	LDS  R26,_par
	LDS  R27,_par+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	LDI  R26,LOW(_P3)
	LDI  R27,HIGH(_P3)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4B:
	LDS  R26,_buzzer
	LDS  R27,_buzzer+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4C:
	CLT
	BLD  R2,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4D:
	CLT
	BLD  R2,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4E:
	INC  R12
	CLT
	BLD  R2,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4F:
	DEC  R12
	CLT
	BLD  R2,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x50:
	CLT
	BLD  R2,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x51:
	CLT
	BLD  R2,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x52:
	SET
	BLD  R2,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	CLT
	BLD  R3,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x54:
	INC  R12
	CLT
	BLD  R2,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x55:
	CLT
	BLD  R2,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x56:
	DEC  R12
	RJMP SUBOPT_0x55

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x57:
	CLT
	BLD  R2,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x58:
	CLT
	BLD  R2,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x59:
	SET
	BLD  R4,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5A:
	LDI  R26,LOW(_P0)
	LDI  R27,HIGH(_P0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5B:
	MOV  R12,R30
	CLT
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5C:
	CLT
	BLD  R4,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	LDI  R26,LOW(_P1)
	LDI  R27,HIGH(_P1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5E:
	RCALL __EEPROMRDW
	STS  _par,R30
	STS  _par+1,R31
	SET
	BLD  R4,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x5F:
	LDS  R30,_par
	LDS  R31,_par+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x60:
	SBIW R30,5
	STS  _par,R30
	STS  _par+1,R31
	LDS  R26,_par+1
	TST  R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	STS  _par,R30
	STS  _par+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x62:
	RCALL SUBOPT_0x5F
	ADIW R30,5
	STS  _par,R30
	STS  _par+1,R31
	RCALL SUBOPT_0x49
	CPI  R26,LOW(0x97)
	LDI  R30,HIGH(0x97)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x63:
	LDI  R30,LOW(0)
	STS  _par,R30
	STS  _par+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	LDI  R26,LOW(_P2)
	LDI  R27,HIGH(_P2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x65:
	CLT
	BLD  R4,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x66:
	STS  _par,R30
	STS  _par+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x67:
	SET
	BLD  R4,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x68:
	RCALL SUBOPT_0x5F
	STS  _minus,R30
	STS  _minus+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x69:
	LDS  R26,_par+1
	TST  R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6A:
	SET
	BLD  R4,3
	RCALL SUBOPT_0x5F
	RCALL __ANEGW1
	STS  _minus,R30
	STS  _minus+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	LDI  R26,LOW(_P5)
	LDI  R27,HIGH(_P5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6C:
	RCALL __EEPROMRDB
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6D:
	LDI  R26,LOW(_P6)
	LDI  R27,HIGH(_P6)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	RCALL SUBOPT_0x6B
	RJMP SUBOPT_0x6C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6F:
	LDS  R26,_buffer
	LDS  R27,_buffer+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x70:
	SUB  R26,R30
	SBC  R27,R31
	MOVW R0,R26
	RCALL SUBOPT_0x6D
	RCALL __EEPROMRDB
	MOVW R26,R0
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x71:
	RCALL SUBOPT_0x6F
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RCALL SUBOPT_0x6D
	RCALL __EEPROMRDB
	MOVW R26,R0
	LDI  R31,0
	RET


	.CSEG
__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
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

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

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

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
