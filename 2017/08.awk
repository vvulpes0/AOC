#!/usr/bin/env awk -f
function read(x) { return match(x,"[0-9]") ? x+0 : 0+regs[x] }
function cond(l,m,r) {
	if (m == ">" ) { return l > r }
	if (m == ">=") { return l >= r }
	if (m == "<" ) { return l < r }
	if (m == "<=") { return l <= r }
	if (m == "==") { return l == r }
	if (m == "!=") { return l != r }
}
(cond(read($5),$6,read($7))) {
	s = /inc/; s = 2*s - 1
	regs[$1] += s*read($3)
	if (regs[$1] > biggest) biggest = regs[$1]
}
END {
	m = 0
	g = 0
	for (r in regs) { if (regs[r] > m || !g) { m = regs[r]; g = 1 } }
	print m,biggest
}
