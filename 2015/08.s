_main:	call parse
	mult r0, r4, -1
	add  r0, r0, r3
	call _pnum
	out  9
	mult r0, r3, -1
	add  r0, r0, r5
	call _pnum
	out  10
	halt

parse:	in   r0
	eq   r1, r0, $7FFF # is EOF?
	jt   r1, endparse
	eq   r1, r0, 10 # is a newline?
	jt   r1, parse
	eq   r1, r0, $22 # is a double-quote?
	jf   r1, error
	add  r3, r3, 1
	add  r5, r5, 3
pquot:	in   r0
	eq   r1, r0, $7FFF # is EOF?
	jt   r1, endparse
	add  r3, r3, 1
	add  r5, r5, 1
	eq   r1, r0, $22 # is a double-quote?
	add  r1, r1, r1
	add  r5, r5, r1
	jt   r1, parse
	add  r4, r4, 1
	eq   r1, r0, $5C # is a backslash?
	add  r5, r5, r1
	jf   r1, pquot
	in   r0
	add  r3, r3, 1
	add  r5, r5, 1
	eq   r1, r0, $5C # is a backslash?
	eq   r2, r0, $22 # or is a double-quote?
	or   r1, r1, r2
	add  r5, r5, r1
	jt   r1, pquot
	in   r0
	in   r0
	add  r3, r3, 2
	add  r5, r5, 2
	jmp  pquot
endparse:
	ret

error:	out  $45
	out  $52
	out  $52
	out  $4F
	out  $52
	out  $0A
	halt

# _divmod(dividend, divisor) -> (quotient, remainder)
_divmod:
	push r3
	push r4
	push r5
	jf   r0 end
	set  r2, 0
	set  r3, 15
	set  r5, 0
loop:	jf   r3, end
	gt   r4, r0, $3FFF
	add  r2, r2, r2
	add  r2, r2, r4
	add  r0, r0, r0
	add  r0, r0, r5
	not  r4, r1
	add  r4, r4, 1
	add  r4, r2, r4
	gt   r5, $4000, r4
	jf   r5, endl
	set  r2, r4
endl:	add  r3, r3, -1
	jmp  loop
end:	gt   r4, r0, $3FFF
	add  r1, r2, r4
	add  r0, r0, r0
	add  r0, r0, r5
	pop  r5
	pop  r4
	pop  r3
	ret

# _pnum(n) -> print n as a decimal value
_pnum:	jt   r0, pnumx
	out  $30
	ret
pnumx:	jf   r0, endp
	set  r1, 10
	call _divmod
	push r1
	call pnumx
	pop  r1
	add  r1, r1, $30
	out  r1
endp:	ret
