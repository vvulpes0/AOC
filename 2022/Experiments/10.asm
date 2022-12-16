##################################################################
## CHIP-8 ASSEMBLY SOURCE                                       ##
##################################################################
# V0 : temp
# V1 : col
# V2 : row
# V3 : X-register
# V4 : atoibuf
# V5 : neg?
# V6 : othertemp
# VA : I >> 2
# VB : I  & 3
@BASECOL 12
@BASEROW 13
CLEAR
SETM 1 0
SETM 2 @BASEROW
SETM 3 1
SETM 0xA 0
SETM 0xB 0

$READINSN
CALL $LOAD
JNEM 0 0x61
JUMP $HANDLEADDR
JNEM 0 0x6e
JUMP $HANDLENOOP
$HALT
JUMP $HALT
$HANDLENOOP
CALL $SHOW
SETM 0 5
CALL $ADDI
JUMP $READINSN
$HANDLEADDR
CALL $SHOW
CALL $SHOW
SETM 0 5
CALL $ADDI
SETM 4 0
SETM 5 0
$A2I
CALL $LOAD
JNEM 0 0x0A
JUMP $A2IDONE
JEQM 0 0x2D
JUMP $NONNEG
SETM 5 1
SETM 0 1
CALL $ADDI
CALL $LOAD
$NONNEG
RGOP 6 4 ASSIGN
RGOP 4 4 ADD
RGOP 4 4 ADD
RGOP 4 4 ADD
RGOP 4 6 ADD
RGOP 4 6 ADD
RGOP 6 0 ASSIGN
SETM 0 48
RGOP 6 0 SUB
RGOP 4 6 ADD
SETM 0 1
CALL $ADDI
JUMP $A2I
$A2IDONE
JEQM 5 1
RGOP 3 4 ADD
JNEM 5 1
RGOP 3 4 SUB
SETM 0 1
CALL $ADDI
JUMP $READINSN


$SHOW
JNEQ 1 3
JUMP $DRAWPX
RGOP 0 1 ASSIGN
RGOP 0 3 SUB
JNEM 0 1
JUMP $DRAWPX
ADDM 0 2
JEQM 0 1
JUMP $PXDONE
$DRAWPX
SETM 0 0x80
SETI $TEMPSLOT
DUMP 0
SETI $TEMPSLOT
SETM 0 @BASECOL
RGOP 0 1 ADD
DRAW 0 2 1
$PXDONE
SETM 0 1
RGOP 1 0 ADD
JEQM 1 40
JUMP $ROWOKAY
RGOP 2 0 ADD
SETM 1 0
$ROWOKAY
RETN


# Some implementations have a LOAD that increments I,
# while others leave I untouched.
# Using A:B as a register (here 10 bits rather than 12 for speed),
# we can just simply not care
$LOAD
SETI $ENDOFCODE
ADDI 0xA
ADDI 0xA
ADDI 0xA
ADDI 0xA
ADDI 0xB
LOAD 0
RETN


# Using A:B as our I register means that we need to implement our own
# variant of the ADDI instruction.
# Is this efficient?  No.  But it avoids using the shift instructions,
# which were originally undocumented and thus could be unavailable.
$ADDI
ADDM 0xB 1
JEQM 0xB 4
JUMP $ADDINOINC
ADDM 0xA 1
SETM 0xB 0
$ADDINOINC
ADDM 0 0xFF
JEQM 0 0
JUMP $ADDI
RETN

$TEMPSLOT
# This is really just a way to have a blank space
RETN
$ENDOFCODE
