
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 8.001000 MHz
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

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _cmp=R4
	.DEF _cmp_msb=R5
	.DEF _c=R6
	.DEF _c_msb=R7
	.DEF _k=R8
	.DEF _k_msb=R9
	.DEF _i=R10
	.DEF _i_msb=R11
	.DEF _num=R12
	.DEF _num_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10/3/2019
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 8.001000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;// I2C Bus functions
;#include <i2c.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// Declare your global variables here
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0029 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 002A ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 002B // Delay needed for the stabilization of the ADC input voltage
; 0000 002C delay_us(10);
	__DELAY_USB 27
; 0000 002D // Start the AD conversion
; 0000 002E ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 002F // Wait for the AD conversion to complete
; 0000 0030 while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0031 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0032 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2020001
; 0000 0033 }
; .FEND
;
;
;#define EEPROM_BUS_ADDRESS 0xc0
;
;int cmp,c=0;
;int k;
;/* read/ a byte from the EEPROM */
;
;unsigned char compass_read(unsigned char address)
; 0000 003D {
_compass_read:
; .FSTART _compass_read
; 0000 003E 
; 0000 003F unsigned char data;
; 0000 0040 delay_us(100);
	ST   -Y,R26
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	CALL SUBOPT_0x0
; 0000 0041 i2c_start();
	CALL _i2c_start
; 0000 0042 delay_us(100);
	CALL SUBOPT_0x0
; 0000 0043 i2c_write(EEPROM_BUS_ADDRESS);
	LDI  R26,LOW(192)
	CALL SUBOPT_0x1
; 0000 0044 delay_us(100);
; 0000 0045 i2c_write(address);
	LDD  R26,Y+1
	CALL SUBOPT_0x1
; 0000 0046 delay_us(100);
; 0000 0047 i2c_start();
	CALL _i2c_start
; 0000 0048 delay_us(100);
	CALL SUBOPT_0x0
; 0000 0049 i2c_write(EEPROM_BUS_ADDRESS | 1);
	LDI  R26,LOW(193)
	CALL SUBOPT_0x1
; 0000 004A delay_us(100);
; 0000 004B data=i2c_read(0);
	LDI  R26,LOW(0)
	CALL _i2c_read
	MOV  R17,R30
; 0000 004C delay_us(100);
	CALL SUBOPT_0x0
; 0000 004D i2c_stop();
	CALL _i2c_stop
; 0000 004E delay_us(100);
	CALL SUBOPT_0x0
; 0000 004F return data;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x2020002
; 0000 0050 
; 0000 0051 }
; .FEND
;
;
;
;
;void readcmp()
; 0000 0057 
; 0000 0058 {
_readcmp:
; .FSTART _readcmp
; 0000 0059 
; 0000 005A       cmp=compass_read(1)-c;
	LDI  R26,LOW(1)
	RCALL _compass_read
	LDI  R31,0
	SUB  R30,R6
	SBC  R31,R7
	MOVW R4,R30
; 0000 005B 
; 0000 005C  if(cmp<0)    cmp=cmp;
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0x6
	MOVW R4,R4
; 0000 005D 
; 0000 005E       if(cmp>128)  cmp=cmp-255;
_0x6:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x7
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	__SUBWRR 4,5,30,31
; 0000 005F 
; 0000 0060   if(cmp<-128) cmp=cmp+255;
_0x7:
	LDI  R30,LOW(65408)
	LDI  R31,HIGH(65408)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x8
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	MOVW R4,R30
; 0000 0061       if(cmp>=0)
_0x8:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRLT _0x9
; 0000 0062 
; 0000 0063       {
; 0000 0064 
; 0000 0065 	lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x2
; 0000 0066 
; 0000 0067 	lcd_putchar('+');
	LDI  R26,LOW(43)
	CALL _lcd_putchar
; 0000 0068 
; 0000 0069 	lcd_putchar((cmp/100)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x3
; 0000 006A 
; 0000 006B 	lcd_putchar((cmp/10)%10+'0');
	MOVW R26,R4
	CALL SUBOPT_0x4
; 0000 006C 
; 0000 006D 	lcd_putchar((cmp/1)%10+'0');
	MOVW R26,R4
	RJMP _0x90
; 0000 006E 
; 0000 006F 	}
; 0000 0070 
; 0000 0071 	else if(cmp<0)
_0x9:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	BRGE _0xB
; 0000 0072 
; 0000 0073 	{
; 0000 0074 
; 0000 0075 	lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x2
; 0000 0076 
; 0000 0077       lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL _lcd_putchar
; 0000 0078 
; 0000 0079       lcd_putchar((-cmp/100)%10+'0');
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
; 0000 007A 
; 0000 007B       lcd_putchar((-cmp/10)%10+'0');
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4
; 0000 007C 
; 0000 007D       lcd_putchar((-cmp/1)%10+'0');
	CALL SUBOPT_0x5
_0x90:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x6
; 0000 007E 
; 0000 007F       }
; 0000 0080 
; 0000 0081    if(cmp<20 && cmp>-20) cmp*=3;
_0xB:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0xD
	LDI  R30,LOW(65516)
	LDI  R31,HIGH(65516)
	CP   R30,R4
	CPC  R31,R5
	BRLT _0xE
_0xD:
	RJMP _0xC
_0xE:
	MOVW R30,R4
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12
	MOVW R4,R30
; 0000 0082    else  cmp*=2;
	RJMP _0xF
_0xC:
	LSL  R4
	ROL  R5
; 0000 0083       cmp*=-1;
_0xF:
	MOVW R30,R4
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	MOVW R4,R30
; 0000 0084 
; 0000 0085       }
	RET
; .FEND
;
;
;
;
;
;
;
;
;
;
;int i,num,tsop,shb,shr,shl,k;
;
;void sensor()
; 0000 0093     {
_sensor:
; .FSTART _sensor
; 0000 0094     tsop = 1023;
	LDI  R30,LOW(1023)
	LDI  R31,HIGH(1023)
	STS  _tsop,R30
	STS  _tsop+1,R31
; 0000 0095     for(i = 0; i < 16; i++)
	CLR  R10
	CLR  R11
_0x11:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x12
; 0000 0096         {
; 0000 0097         PORTB.7 = (i / 8) % 2;
	MOVW R26,R10
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x7
	BRNE _0x13
	CBI  0x18,7
	RJMP _0x14
_0x13:
	SBI  0x18,7
_0x14:
; 0000 0098         PORTB.6 = (i / 4) % 2;
	MOVW R26,R10
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x7
	BRNE _0x15
	CBI  0x18,6
	RJMP _0x16
_0x15:
	SBI  0x18,6
_0x16:
; 0000 0099         PORTB.5 = (i / 2) % 2;
	MOVW R26,R10
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x7
	BRNE _0x17
	CBI  0x18,5
	RJMP _0x18
_0x17:
	SBI  0x18,5
_0x18:
; 0000 009A         PORTB.4 = (i / 1) % 2;
	MOVW R30,R10
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	CPI  R30,0
	BRNE _0x19
	CBI  0x18,4
	RJMP _0x1A
_0x19:
	SBI  0x18,4
_0x1A:
; 0000 009B         if(read_adc(0) < tsop)
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R26,R30
	LDS  R30,_tsop
	LDS  R31,_tsop+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x1B
; 0000 009C             {
; 0000 009D             tsop = read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	STS  _tsop,R30
	STS  _tsop+1,R31
; 0000 009E             num = i;
	MOVW R12,R10
; 0000 009F             }
; 0000 00A0         }
_0x1B:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x11
_0x12:
; 0000 00A1     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2
; 0000 00A2     lcd_putchar((num / 10) % 10 + '0');
	MOVW R26,R12
	CALL SUBOPT_0x4
; 0000 00A3     lcd_putchar((num / 1) % 10 + '0');
	MOVW R26,R12
	CALL SUBOPT_0x8
; 0000 00A4     lcd_putchar('=');
	LDI  R26,LOW(61)
	CALL _lcd_putchar
; 0000 00A5     lcd_putchar((tsop / 1000) % 10 + '0');
	CALL SUBOPT_0x9
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	MOVW R26,R30
	CALL SUBOPT_0x8
; 0000 00A6     lcd_putchar((tsop / 100) % 10 + '0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x3
; 0000 00A7     lcd_putchar((tsop / 10) % 10 + '0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x4
; 0000 00A8     lcd_putchar((tsop / 1) % 10 + '0');
	CALL SUBOPT_0x9
	CALL SUBOPT_0x8
; 0000 00A9     shr=read_adc(6);
	LDI  R26,LOW(6)
	RCALL _read_adc
	STS  _shr,R30
	STS  _shr+1,R31
; 0000 00AA     lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0xA
; 0000 00AB     lcd_putchar((shr/100)%10+'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x3
; 0000 00AC     lcd_putchar((shr/10)%10+'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x4
; 0000 00AD     lcd_putchar((shr/1)%10+'0');
	CALL SUBOPT_0xB
	CALL SUBOPT_0x8
; 0000 00AE 
; 0000 00AF 
; 0000 00B0     shl=read_adc(5);
	LDI  R26,LOW(5)
	RCALL _read_adc
	STS  _shl,R30
	STS  _shl+1,R31
; 0000 00B1     lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xA
; 0000 00B2     lcd_putchar((shl/100)%10+'0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x3
; 0000 00B3     lcd_putchar((shl/10)%10+'0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x4
; 0000 00B4     lcd_putchar((shl/1)%10+'0');
	CALL SUBOPT_0xC
	CALL SUBOPT_0x8
; 0000 00B5 
; 0000 00B6     shb=read_adc(7);
	LDI  R26,LOW(7)
	RCALL _read_adc
	STS  _shb,R30
	STS  _shb+1,R31
; 0000 00B7     lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0xA
; 0000 00B8     lcd_putchar((shb/100)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x3
; 0000 00B9     lcd_putchar((shb/10)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x4
; 0000 00BA     lcd_putchar((shb/1)%10+'0');
	CALL SUBOPT_0xD
	CALL SUBOPT_0x8
; 0000 00BB     k=shl-shr;
	CALL SUBOPT_0xB
	LDS  R30,_shl
	LDS  R31,_shl+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R8,R30
; 0000 00BC     }
	RET
; .FEND
;
;void motor(int L1,int L2,int R2,int R1)
; 0000 00BF     {
_motor:
; .FSTART _motor
; 0000 00C0     if(L1 > 255) L1 = 255;
	ST   -Y,R27
	ST   -Y,R26
;	L1 -> Y+6
;	L2 -> Y+4
;	R2 -> Y+2
;	R1 -> Y+0
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1C
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00C1     if(L2 > 255) L2 = 255;
_0x1C:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1D
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00C2     if(R1 > 255) R1 = 255;
_0x1D:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1E
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00C3     if(R2 > 255) R2 = 255;
_0x1E:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1F
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00C4 
; 0000 00C5     if(L1 < -255) L1 = -255;
_0x1F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x20
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00C6     if(L2 < -255) L2 = -255;
_0x20:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x21
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 00C7     if(R1 < -255) R1 = -255;
_0x21:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x22
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00C8     if(R2 < -255) R2 = -255;
_0x22:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x23
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00C9 
; 0000 00CA     ////////////////////Motor Left 1
; 0000 00CB     if(L1 >= 0)
_0x23:
	LDD  R26,Y+7
	TST  R26
	BRMI _0x24
; 0000 00CC         {
; 0000 00CD         PORTD.0 = 0;
	CBI  0x12,0
; 0000 00CE         OCR0 = L1;
	LDD  R30,Y+6
	RJMP _0x91
; 0000 00CF         }
; 0000 00D0     else
_0x24:
; 0000 00D1         {
; 0000 00D2         PORTD.0 = 1;
	SBI  0x12,0
; 0000 00D3         OCR0 = 255 + L1;
	LDD  R30,Y+6
	SUBI R30,-LOW(255)
_0x91:
	OUT  0x3C,R30
; 0000 00D4         }
; 0000 00D5     ////////////////////Motor Left 2
; 0000 00D6     if(L2 >= 0)
	LDD  R26,Y+5
	TST  R26
	BRMI _0x2A
; 0000 00D7         {
; 0000 00D8         PORTD.1 = 0;
	CBI  0x12,1
; 0000 00D9         OCR1B = L2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x92
; 0000 00DA         }
; 0000 00DB     else
_0x2A:
; 0000 00DC         {
; 0000 00DD         PORTD.1 = 1;
	SBI  0x12,1
; 0000 00DE         OCR1B = 255 + L2;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x92:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00DF         }
; 0000 00E0     ////////////////////Motor Right 2
; 0000 00E1     if(R2 >= 0)
	LDD  R26,Y+3
	TST  R26
	BRMI _0x30
; 0000 00E2         {
; 0000 00E3         PORTD.2 = 0;
	CBI  0x12,2
; 0000 00E4         OCR1A = R2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0x93
; 0000 00E5         }
; 0000 00E6     else
_0x30:
; 0000 00E7         {
; 0000 00E8         PORTD.2 = 1;
	SBI  0x12,2
; 0000 00E9         OCR1A = 255 + R2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
_0x93:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00EA         }
; 0000 00EB     ////////////////////Motor Right 1
; 0000 00EC     if(R1 >= 0)
	LDD  R26,Y+1
	TST  R26
	BRMI _0x36
; 0000 00ED         {
; 0000 00EE         PORTD.3 = 0;
	CBI  0x12,3
; 0000 00EF         OCR2 = R1;
	LD   R30,Y
	RJMP _0x94
; 0000 00F0         }
; 0000 00F1     else
_0x36:
; 0000 00F2         {
; 0000 00F3         PORTD.3 = 1;
	SBI  0x12,3
; 0000 00F4         OCR2 = 255 + R1;
	LD   R30,Y
	SUBI R30,-LOW(255)
_0x94:
	OUT  0x23,R30
; 0000 00F5         }
; 0000 00F6 
; 0000 00F7     }
	ADIW R28,8
	RET
; .FEND
;
;void move(int a)
; 0000 00FA {
_move:
; .FSTART _move
; 0000 00FB if(a==0)   motor(255,255,-255,-255);
	ST   -Y,R27
	ST   -Y,R26
;	a -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x3C
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(65281)
	LDI  R27,HIGH(65281)
	RJMP _0x95
; 0000 00FC         else if(a==4)   motor(255+cmp,-255+cmp,-255+cmp,255+cmp);
_0x3C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,4
	BRNE _0x3E
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL SUBOPT_0xF
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x95
; 0000 00FD         else if(a==6)   motor(0+cmp,-255+cmp,0+cmp,255+cmp);
_0x3E:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,6
	BRNE _0x40
	CALL SUBOPT_0x10
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x95
; 0000 00FE         else if(a==8)   motor(-255+cmp,-255+cmp,255+cmp,255+cmp);
_0x40:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,8
	BRNE _0x42
	CALL SUBOPT_0xF
	CALL SUBOPT_0x11
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x95
; 0000 00FF         else if(a==10)   motor(-255+cmp,0+cmp,255+cmp,0+cmp);
_0x42:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,10
	BRNE _0x44
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	CALL SUBOPT_0xE
	MOVW R26,R4
	ADIW R26,0
	RJMP _0x95
; 0000 0100         else if(a==12)  motor(-255+cmp,255+cmp,255+cmp,-255+cmp);
_0x44:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,12
	BRNE _0x46
	CALL SUBOPT_0xF
	CALL SUBOPT_0xE
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	RJMP _0x96
; 0000 0101         else if(a==14)  motor(0+cmp,255+cmp,0+cmp,-255+cmp);
_0x46:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,14
	BRNE _0x48
	CALL SUBOPT_0x10
	CALL SUBOPT_0xE
	MOVW R30,R4
	ADIW R30,0
	RJMP _0x96
; 0000 0102         else if(a==1)  motor(255+cmp,128+cmp,-255+cmp,-128+cmp);
_0x48:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x4A
	CALL SUBOPT_0xE
	CALL SUBOPT_0x12
	MOVW R26,R4
	SUBI R26,LOW(-65408)
	SBCI R27,HIGH(-65408)
	RJMP _0x95
; 0000 0103         else if(a==3)  motor(255+cmp,-128+cmp,-255+cmp,128+cmp);
_0x4A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x4C
	CALL SUBOPT_0xE
	CALL SUBOPT_0x13
	CALL SUBOPT_0xF
	MOVW R26,R4
	SUBI R26,LOW(-128)
	SBCI R27,HIGH(-128)
	RJMP _0x95
; 0000 0104         else if(a==5)  motor(128+cmp,-255+cmp,-128+cmp,255+cmp);
_0x4C:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,5
	BRNE _0x4E
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x95
; 0000 0105         else if(a==7)  motor(-128+cmp,-255+cmp,128+cmp,255+cmp);
_0x4E:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BRNE _0x50
	CALL SUBOPT_0x13
	CALL SUBOPT_0xF
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R4
	SUBI R26,LOW(-255)
	SBCI R27,HIGH(-255)
	RJMP _0x95
; 0000 0106         else if(a==9)  motor(-255+cmp,-128+cmp,255+cmp,128+cmp);
_0x50:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,9
	BRNE _0x52
	CALL SUBOPT_0xF
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0x11
	MOVW R26,R4
	SUBI R26,LOW(-128)
	SBCI R27,HIGH(-128)
	RJMP _0x95
; 0000 0107         else if(a==11)  motor(-255+cmp,128+cmp,255+cmp,-128+cmp);
_0x52:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,11
	BRNE _0x54
	CALL SUBOPT_0xF
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	CALL SUBOPT_0x11
	MOVW R26,R4
	SUBI R26,LOW(-65408)
	SBCI R27,HIGH(-65408)
	RJMP _0x95
; 0000 0108         else if(a==13)  motor(-128+cmp,255+cmp,128+cmp,-255+cmp);
_0x54:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,13
	BRNE _0x56
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	CALL SUBOPT_0x11
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	RJMP _0x96
; 0000 0109         else if(a==15)  motor(128+cmp,255+cmp,-128+cmp,-255+cmp);
_0x56:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,15
	BRNE _0x58
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	CALL SUBOPT_0x11
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
_0x96:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R4
	SUBI R26,LOW(-65281)
	SBCI R27,HIGH(-65281)
_0x95:
	RCALL _motor
; 0000 010A }
_0x58:
	RJMP _0x2020002
; .FEND
;
;
;void main(void)
; 0000 010E {
_main:
; .FSTART _main
; 0000 010F // Declare your local variables here
; 0000 0110 
; 0000 0111 // Input/Output Ports initialization
; 0000 0112 // Port A initialization
; 0000 0113 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0114 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0115 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0116 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0117 
; 0000 0118 // Port B initialization
; 0000 0119 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 011A DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 011B // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 011C PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 011D 
; 0000 011E // Port C initialization
; 0000 011F // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0120 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0121 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0122 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 0123 
; 0000 0124 // Port D initialization
; 0000 0125 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0126 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0127 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0128 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0129 
; 0000 012A // Timer/Counter 0 initialization
; 0000 012B // Clock source: System Clock
; 0000 012C // Clock value: 125.016 kHz
; 0000 012D // Mode: Fast PWM top=0xFF
; 0000 012E // OC0 output: Non-Inverted PWM
; 0000 012F // Timer Period: 2.0477 ms
; 0000 0130 // Output Pulse(s):
; 0000 0131 // OC0 Period: 2.0477 ms Width: 0 us
; 0000 0132 TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(107)
	OUT  0x33,R30
; 0000 0133 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0134 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0135 
; 0000 0136 // Timer/Counter 1 initialization
; 0000 0137 // Clock source: System Clock
; 0000 0138 // Clock value: 125.016 kHz
; 0000 0139 // Mode: Fast PWM top=0x00FF
; 0000 013A // OC1A output: Non-Inverted PWM
; 0000 013B // OC1B output: Non-Inverted PWM
; 0000 013C // Noise Canceler: Off
; 0000 013D // Input Capture on Falling Edge
; 0000 013E // Timer Period: 2.0477 ms
; 0000 013F // Output Pulse(s):
; 0000 0140 // OC1A Period: 2.0477 ms Width: 0 us
; 0000 0141 // OC1B Period: 2.0477 ms Width: 0 us
; 0000 0142 // Timer1 Overflow Interrupt: Off
; 0000 0143 // Input Capture Interrupt: Off
; 0000 0144 // Compare A Match Interrupt: Off
; 0000 0145 // Compare B Match Interrupt: Off
; 0000 0146 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (1<<WGM10);
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0147 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(11)
	OUT  0x2E,R30
; 0000 0148 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0149 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 014A ICR1H=0x00;
	OUT  0x27,R30
; 0000 014B ICR1L=0x00;
	OUT  0x26,R30
; 0000 014C OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 014D OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 014E OCR1BH=0x00;
	OUT  0x29,R30
; 0000 014F OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0150 
; 0000 0151 // Timer/Counter 2 initialization
; 0000 0152 // Clock source: System Clock
; 0000 0153 // Clock value: 125.016 kHz
; 0000 0154 // Mode: Fast PWM top=0xFF
; 0000 0155 // OC2 output: Non-Inverted PWM
; 0000 0156 // Timer Period: 2.0477 ms
; 0000 0157 // Output Pulse(s):
; 0000 0158 // OC2 Period: 2.0477 ms Width: 0 us
; 0000 0159 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 015A TCCR2=(1<<PWM2) | (1<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(108)
	OUT  0x25,R30
; 0000 015B TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 015C OCR2=0x00;
	OUT  0x23,R30
; 0000 015D 
; 0000 015E // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 015F TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0160 
; 0000 0161 // External Interrupt(s) initialization
; 0000 0162 // INT0: Off
; 0000 0163 // INT1: Off
; 0000 0164 // INT2: Off
; 0000 0165 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0166 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0167 
; 0000 0168 // USART initialization
; 0000 0169 // USART disabled
; 0000 016A UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 016B 
; 0000 016C // Analog Comparator initialization
; 0000 016D // Analog Comparator: Off
; 0000 016E // The Analog Comparator's positive input is
; 0000 016F // connected to the AIN0 pin
; 0000 0170 // The Analog Comparator's negative input is
; 0000 0171 // connected to the AIN1 pin
; 0000 0172 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0173 
; 0000 0174 // ADC initialization
; 0000 0175 // ADC Clock frequency: 62.508 kHz
; 0000 0176 // ADC Voltage Reference: AVCC pin
; 0000 0177 // ADC Auto Trigger Source: ADC Stopped
; 0000 0178 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0179 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 017A SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 017B 
; 0000 017C // SPI initialization
; 0000 017D // SPI disabled
; 0000 017E SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 017F 
; 0000 0180 // TWI initialization
; 0000 0181 // TWI disabled
; 0000 0182 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0183 
; 0000 0184 // Bit-Banged I2C Bus initialization
; 0000 0185 // I2C Port: PORTB
; 0000 0186 // I2C SDA bit: 1
; 0000 0187 // I2C SCL bit: 0
; 0000 0188 // Bit Rate: 100 kHz
; 0000 0189 // Note: I2C settings are specified in the
; 0000 018A // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 018B i2c_init();
	CALL _i2c_init
; 0000 018C 
; 0000 018D // Alphanumeric LCD initialization
; 0000 018E // Connections are specified in the
; 0000 018F // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0190 // RS - PORTC Bit 0
; 0000 0191 // RD - PORTC Bit 1
; 0000 0192 // EN - PORTC Bit 2
; 0000 0193 // D4 - PORTC Bit 4
; 0000 0194 // D5 - PORTC Bit 5
; 0000 0195 // D6 - PORTC Bit 6
; 0000 0196 // D7 - PORTC Bit 7
; 0000 0197 // Characters/line: 16
; 0000 0198 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0199 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 019A c=compass_read(1);
	LDI  R26,LOW(1)
	RCALL _compass_read
	MOV  R6,R30
	CLR  R7
; 0000 019B 
; 0000 019C while (1)
_0x59:
; 0000 019D     {
; 0000 019E     sensor();    //khandan tamam sensorha
	RCALL SUBOPT_0x14
; 0000 019F     readcmp();   //khandan ghotbnama
; 0000 01A0     if(tsop<500)
	RCALL SUBOPT_0x9
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLT PC+2
	RJMP _0x5C
; 0000 01A1         {
; 0000 01A2         if(shr>300)
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRLT _0x5D
; 0000 01A3         {
; 0000 01A4         while(num<8)
_0x5E:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R12,R30
	CPC  R13,R31
	BRGE _0x60
; 0000 01A5             {
; 0000 01A6             sensor();
	RCALL SUBOPT_0x14
; 0000 01A7             readcmp();
; 0000 01A8             if(shr>400) move(12);
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	BRLT _0x61
	LDI  R26,LOW(12)
	LDI  R27,0
	RCALL _move
; 0000 01A9             else if(shr<250) break;
	RJMP _0x62
_0x61:
	RCALL SUBOPT_0xB
	CPI  R26,LOW(0xFA)
	LDI  R30,HIGH(0xFA)
	CPC  R27,R30
	BRLT _0x60
; 0000 01AA             else motor(cmp,cmp,cmp,cmp);
	RCALL SUBOPT_0x15
; 0000 01AB             }
_0x62:
	RJMP _0x5E
_0x60:
; 0000 01AC         }
; 0000 01AD         if(shl>300)
_0x5D:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRLT _0x65
; 0000 01AE         {
; 0000 01AF         while(num>8)
_0x66:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0x68
; 0000 01B0             {
; 0000 01B1             sensor();
	RCALL SUBOPT_0x14
; 0000 01B2             readcmp();
; 0000 01B3             if(shl>400) move(4);
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x191)
	LDI  R30,HIGH(0x191)
	CPC  R27,R30
	BRLT _0x69
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _move
; 0000 01B4             else if(shl<250) break;
	RJMP _0x6A
_0x69:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0xFA)
	LDI  R30,HIGH(0xFA)
	CPC  R27,R30
	BRLT _0x68
; 0000 01B5             else motor(cmp,cmp,cmp,cmp);
	RCALL SUBOPT_0x15
; 0000 01B6             }
_0x6A:
	RJMP _0x66
_0x68:
; 0000 01B7         }
; 0000 01B8 
; 0000 01B9         if(num==0)      move(0);
_0x65:
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x6D
	LDI  R26,LOW(0)
	RJMP _0x97
; 0000 01BA 
; 0000 01BB         else if(num==1) move(1);
_0x6D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x6F
	LDI  R26,LOW(1)
	RJMP _0x97
; 0000 01BC         else if(num==2) move(3);
_0x6F:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x71
	LDI  R26,LOW(3)
	RJMP _0x97
; 0000 01BD         else if(num==3) move(5);
_0x71:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x73
	LDI  R26,LOW(5)
	RJMP _0x97
; 0000 01BE         else if(num==4) move(6);
_0x73:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x75
	LDI  R26,LOW(6)
	RJMP _0x97
; 0000 01BF         else if(num==5) move(7);
_0x75:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x77
	LDI  R26,LOW(7)
	RJMP _0x97
; 0000 01C0         else if(num==6) move(8);
_0x77:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x79
	LDI  R26,LOW(8)
	RJMP _0x97
; 0000 01C1         else if(num==7) move(9);
_0x79:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x7B
	LDI  R26,LOW(9)
	RJMP _0x97
; 0000 01C2         else if(num==8) move(10);
_0x7B:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x7D
	LDI  R26,LOW(10)
	RJMP _0x97
; 0000 01C3         else if(num==9) move(7);
_0x7D:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x7F
	LDI  R26,LOW(7)
	RJMP _0x97
; 0000 01C4         else if(num==10) move(8);
_0x7F:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x81
	LDI  R26,LOW(8)
	RJMP _0x97
; 0000 01C5         else if(num==11) move(9);
_0x81:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x83
	LDI  R26,LOW(9)
	RJMP _0x97
; 0000 01C6         else if(num==12) move(10);
_0x83:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x85
	LDI  R26,LOW(10)
	RJMP _0x97
; 0000 01C7         else if(num==13) move(11);
_0x85:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x87
	LDI  R26,LOW(11)
	RJMP _0x97
; 0000 01C8         else if(num==14) move(13);
_0x87:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x89
	LDI  R26,LOW(13)
	RJMP _0x97
; 0000 01C9         else if(num==15) move(15);
_0x89:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x8B
	LDI  R26,LOW(15)
_0x97:
	LDI  R27,0
	RCALL _move
; 0000 01CA 
; 0000 01CB 
; 0000 01CC         }
_0x8B:
; 0000 01CD     else
	RJMP _0x8C
_0x5C:
; 0000 01CE         {
; 0000 01CF         if(shb<250)
	RCALL SUBOPT_0xD
	CPI  R26,LOW(0xFA)
	LDI  R30,HIGH(0xFA)
	CPC  R27,R30
	BRGE _0x8D
; 0000 01D0         motor(-150+cmp+k,-150+cmp-k,150+cmp-k,150+cmp+k);
	MOVW R30,R4
	SUBI R30,LOW(-65386)
	SBCI R31,HIGH(-65386)
	MOVW R26,R30
	ADD  R30,R8
	ADC  R31,R9
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R26
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x16
	ADD  R30,R8
	ADC  R31,R9
	MOVW R26,R30
	RJMP _0x98
; 0000 01D1         else motor(cmp,cmp,cmp,cmp);
_0x8D:
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R5
	ST   -Y,R4
	MOVW R26,R4
_0x98:
	RCALL _motor
; 0000 01D2         }
_0x8C:
; 0000 01D3 
; 0000 01D4 
; 0000 01D5     }
	RJMP _0x59
; 0000 01D6 }
_0x8F:
	RJMP _0x8F
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 13
	SBI  0x15,2
	__DELAY_USB 13
	CBI  0x15,2
	__DELAY_USB 13
	RJMP _0x2020001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2020001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2020002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x17
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x17
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020001
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2020001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x18
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	RCALL SUBOPT_0x0
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_tsop:
	.BYTE 0x2
_shb:
	.BYTE 0x2
_shr:
	.BYTE 0x2
_shl:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x0:
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL _i2c_write
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	MOVW R30,R4
	CALL __ANEGW1
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6:
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RJMP _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	CALL __DIVW21
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __MANDW12
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDS  R26,_tsop
	LDS  R27,_tsop+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDS  R26,_shr
	LDS  R27,_shr+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDS  R26,_shl
	LDS  R27,_shl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDS  R26,_shb
	LDS  R27,_shb+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xE:
	MOVW R30,R4
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0xF:
	MOVW R30,R4
	SUBI R30,LOW(-65281)
	SBCI R31,HIGH(-65281)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	MOVW R30,R4
	ADIW R30,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	MOVW R30,R4
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	MOVW R30,R4
	SUBI R30,LOW(-65408)
	SBCI R31,HIGH(-65408)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CALL _sensor
	JMP  _readcmp

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R5
	ST   -Y,R4
	MOVW R26,R4
	JMP  _motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	SUB  R30,R8
	SBC  R31,R9
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	SUBI R30,LOW(-150)
	SBCI R31,HIGH(-150)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	RJMP SUBOPT_0x0


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
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
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
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
	__DELAY_USW 0x7D0
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

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
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

;END OF CODE MARKER
__END_OF_CODE:
