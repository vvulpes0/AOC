.text
.balign 4
.global _main
_main:
	sub sp, sp, 48
	stp x29, x30, [sp, 16]
	stp x27, x28, [sp, 32]
	mov x27, #0
	mov x28, #0
	mov x29, #1
1:	bl _getchar
	tbnz w0, 31, 2f
	add w28, w28, w29
	cmp w0, '('
	cinc w27, w27, eq
	beq 1b
	subs w27, w27, #1
	bge 1b
	mov w29, #0
	b 1b
2:	adr x0, 3f
	stp x27, x28, [sp]
	bl _printf
	mov x0, #0
	ldp x27, x28, [sp, 32]
	ldp x29, x30, [sp, 16]
	add sp, sp, 48
	ret

.global _getchar
.global _printf
.balign 4
3:	.asciz "%d\t%d\n"
