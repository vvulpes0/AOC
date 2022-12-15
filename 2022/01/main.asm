.include "constants.inc"
.include "header.inc"

.segment "CODE"
.proc irq_handler
	RTI
.endproc

.proc reset_handler
	SEI
	CLD
	LDX #$00
	STX PPUCTRL
	STX PPUMASK
vblankwait:
	BIT PPUSTATUS
	BPL vblankwait

	LDX #$00
	LDA #$ff
clear_oam:
	STA $0200,X ; set sprite y-positions off-screen
	INX
	INX
	INX
	INX
	BNE clear_oam
	DEX

	LDX #$00
	TXA
clear_zp:
	STA $00,X
	INX
	BNE clear_zp
	TXS

	JMP main
.endproc

.proc nmi_handler
	;; need push/pull?
	PHA
	;; pushed
	LDA #$00
	STA OAMADDR
	LDA #$02
	STA OAMDMA
	INC ready
	;; start pulling
	PLA
	RTI
.endproc

.export main
.proc main
	LDA #<input_data
	STA data
	LDA #>input_data
	STA data + 1

loop:
	JSR atoi
	;; add a2ibuf to cur
	LDA #<a2ibuf
	STA add32s
	LDA #>a2ibuf
	STA add32s + 1
	LDA #<cur
	STA add32d
	LDA #>cur
	STA add32d + 1
	JSR add32

	LDY #$00
	LDA (data),Y
	CMP #$0a
	BNE check_end
	INC data
	BNE noinc
	INC data + 1
noinc:
	JSR insert
	LDA #$00
	STA cur
	STA cur + 1
	STA cur + 2
	STA cur + 3
	JMP loop
check_end:
	CMP #$ff
	BEQ calcdone
	JMP loop
calcdone:

	LDA #<max1
	STA add32s
	LDA #>max1
	STA add32s + 1
	LDA #<max3
	STA add32d
	LDA #>max3
	STA add32d + 1
	JSR add32
	LDA #<max2
	STA add32s
	LDA #>max2
	STA add32s + 1
	JSR add32

	;; itoa max1 as ascii into part1
	LDA max1
	STA dividend
	LDA max1 + 1
	STA dividend + 1
	LDA max1 + 2
	STA dividend + 2
	LDA max1 + 3
	STA dividend + 3
	LDA #$0A
	STA divisor
	LDX #$0F
itoa1:	JSR udiv32o8
	LDA remainder
	CLC
	ADC #48
	STA part1,X
	DEX
	BPL itoa1

	;; itoa max3 as ascii into part2
	LDA max3
	STA dividend
	LDA max3 + 1
	STA dividend + 1
	LDA max3 + 2
	STA dividend + 2
	LDA max3 + 3
	STA dividend + 3
	LDA #$0A
	STA divisor
	LDX #$0F
itoa2:	JSR udiv32o8
	LDA remainder
	CLC
	ADC #48
	STA part2,X
	DEX
	BPL itoa2

	;; disable display
	LDA #$00
	STA PPUCTRL
	NOP
	STA PPUMASK

	LDA PPUSTATUS
	LDA #$3F
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	LDX #$03
pallp:
	LDA #$1D
	STA PPUDATA
	LDA #$00
	STA PPUDATA
	LDA #$10
	STA PPUDATA
	LDA #$20
	STA PPUDATA
	DEX
	BPL pallp

	;; now let's actually write these to the screen!
	LDA PPUSTATUS
	LDA #$20
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	LDA #$41 ; 'A'
	STA PPUDATA
	LDA #$3A ; ':'
	STA PPUDATA
	LDA #$20 ; ' '
	STA PPUDATA
	LDA #$00
	STA temp
	LDX #$05
	LDY #$0A
p1:	LDA part1,Y
	BIT temp
	BMI w1
	CMP #$30
	BNE nt1
	LDA #$20
	JMP w1
nt1:	DEC temp
w1:	STA PPUDATA
	INY
	DEX
	BPL p1

	LDA PPUSTATUS
	LDA #$20
	STA PPUADDR
	LDA #$20
	STA PPUADDR
	LDA #$42 ; 'B'
	STA PPUDATA
	LDA #$3A ; ':'
	STA PPUDATA
	LDA #$20 ; ' '
	STA PPUDATA
	LDA #$00
	STA temp
	LDX #$05
	LDY #$0A
p2:	LDA part2,Y
	BIT temp
	BMI w2
	CMP #$30
	BNE nt2
	LDA #$20
	JMP w2
nt2:	DEC temp
w2:	STA PPUDATA
	INY
	DEX
	BPL p2

	LDA PPUSTATUS
	LDA #$E0
	STA PPUSCROLL
	LDA #$D0
	STA PPUSCROLL
	LDA #$83
	STA PPUCTRL
	LDA #$0E
	STA PPUMASK

halt:	JMP halt
.endproc

.proc insert
	LDX #$03
lp3:	LDA cur,X
	CMP max3,X
	BMI end
	BNE insert3
	DEX
	BPL lp3
insert3:
	LDX #$03
insert3l:
	LDA cur,X
	STA max3,X
	DEX
	BPL insert3l

	LDX #$03
lp2:	LDA cur,X
	CMP max2,X
	BMI end
	BNE insert2
	DEX
	BPL lp2
insert2:
	LDX #$03
insert2l:
	LDA max2,X
	STA max3,X
	LDA cur,X
	STA max2,X
	DEX
	BPL insert2l

	LDX #$03
lp1:	LDA cur,X
	CMP max1,X
	BMI end
	BNE insert1
	DEX
	BPL lp1
insert1:
	LDX #$03
insert1l:
	LDA max1,X
	STA max2,X
	LDA cur,X
	STA max1,X
	DEX
	BPL insert1l

end:	RTS
.endproc

.proc add32
	PHA
	TYA
	PHA
	TXA
	PHA

	LDX #$03
	LDY #$00
	CLC
lp:	LDA (add32s),Y
	ADC (add32d),Y
	STA (add32d),Y
	INY
	DEX
	BPL lp

	PLA
	TAX
	PLA
	TAY
	PLA
	RTS
.endproc

.proc atoi
	LDY #$00
	STY a2ibuf
	STY a2ibuf + 1
	STY a2ibuf + 2
	STY a2ibuf + 3
loop:
	LDA (data),Y
	STA temp + 4
	INY
	CMP #48
	BPL digit
	JMP end
digit:
	LDX a2ibuf
	STX temp
	LDX a2ibuf + 1
	STX temp + 1
	LDX a2ibuf + 2
	STX temp + 2
	LDX a2ibuf + 3
	STX temp + 3

	;; multiply a2ibuf by 8
	ASL a2ibuf
	ROL a2ibuf + 1
	ROL a2ibuf + 2
	ROL a2ibuf + 3
	ASL a2ibuf
	ROL a2ibuf + 1
	ROL a2ibuf + 2
	ROL a2ibuf + 3
	ASL a2ibuf
	ROL a2ibuf + 1
	ROL a2ibuf + 2
	ROL a2ibuf + 3

	;; multiply temp by 2
	ASL temp
	ROL temp + 1
	ROL temp + 2
	ROL temp + 3

	;; add temp into a2ibuf
	LDA #<temp
	STA add32s
	LDA #>temp
	STA add32s + 1
	LDA #<a2ibuf
	STA add32d
	LDA #>a2ibuf
	STA add32d + 1
	JSR add32

	;; add new value
	LDA temp + 4
	SEC
	SBC #48
	CLC
	ADC a2ibuf
	STA a2ibuf
	LDA #$00
	ADC a2ibuf + 1
	STA a2ibuf + 1
	LDA #$00
	ADC a2ibuf + 2
	STA a2ibuf + 2
	LDA #$00
	ADC a2ibuf + 3
	STA a2ibuf + 3
	JMP loop

end:	TYA
	CLC
	ADC data
	STA data
	BCC ret
	INC data + 1
ret:	RTS
.endproc

	;; inputs
	;; * 32-bit little-endian value in dividend
	;; * 8-bit divisor
	;; outputs:
	;; * 32-bit dividend/divisor in dividend
	;; * 8-bit remainder in remainder
	;; divisor remains unchanged
.proc udiv32o8
	PHA
	TXA
	PHA
	TYA
	PHA
	LDA #$00
	STA remainder
	STA remainder + 1
	LDX #$20
lp:	ASL dividend
	ROL dividend + 1
	ROL dividend + 2
	ROL dividend + 3
	ROL remainder
	ROL remainder + 1
	LDA remainder
	SEC
	SBC divisor
	TAY
	LDA remainder + 1
	SBC #$00
	BCC cont
	STA remainder + 1
	STY remainder
	INC dividend
cont:	DEX
	BNE lp
	PLA
	TAY
	PLA
	TAX
	PLA
	RTS
.endproc

.segment "RODATA"
input_data:
.incbin "01.txt"
.byte $0A,$FF

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "font.chr"

.segment "ZEROPAGE"
temp: .res 16
a2ibuf: .res 4
cur: .res 4
max1: .res 4
max2: .res 4
max3: .res 4
data: .res 2
add32s: .res 2
add32d: .res 2
dividend: .res 4
remainder: .res 2
divisor: .res 1
ready: .res 1

.segment "BSS"
part1:	.res 16
part2:	.res 16
