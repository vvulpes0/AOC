#!/usr/bin/awk -f
BEGIN { FS = "" }
function settle(rows,  i,t) {
	for (i = 0; i < heights[p]; i++) field[y+i+1] += rows[1+i]
	s++
	p = s % length(piece) + 1
	x = w - widths[p] - 2
	y = length(field) + 3
	t = hashstate()
	if (t in states) cycl = s - states[t]
	states[t] = s
	return 1
}
function move(m,  nx,i,temp) {
	nx = x + (m == "<") - (m == ">")
	nx = nx < 0 ? 0 : nx < w - widths[p] ? nx : w - widths[p]
	split(piece[p],temp," ")
	for (i = 0; i < heights[p] && nx != x; i++) {
		if (!(y + i in field)) break
		if (overlap(temp[i+1]*(2**nx),field[y+i])) nx = x
	}
	x = nx
	for (i in temp) { temp[i] *= 2**x }
	y--
	if (y<0) return settle(temp)
	for (i in temp) {
		if (!((y+i-1) in field) || !overlap(temp[i],field[y+i-1]))
			continue
		return settle(temp)
	}
	return 0
}
function overlap(a,b) {
	while (a && b) {
		if (a % 2 && b % 2) return 1
		a = int(a / 2)
		b = int(b / 2)
	}
	return 0
}
function nextspawn() { while (!move($(((mv++)%NF) + 1))); }
function hashstate(  i,q,t) {
	if (length(field) < 16) { return p " " mv }
	t = 0
	# 10 is arbitrary but sufficient, makes result fit in 64 bits
	for (i = length(field) - 1; i > length(field)-10; i--) {
		t *= 2**w
		t += field[i]
	}
	return p " " (mv%NF) " " t
}
END {
	split("1 3 3 4 2", heights, " ")
	split("4 3 3 1 2", widths, " ")
	split("15,2 7 2,7 1 1,1 1 1 1,3 3",piece,",")
	w = 7
	p = 1
	x = w - widths[p] - 2
	y = length(field) + 3
	while (s < 2022) { nextspawn() }
	print "A:", length(field)
	while (!cycl) nextspawn()
	t = s
	h = length(field)
	bign = 1000000000000 - t
	for (i = 0; i < cycl; i++) nextspawn()
	dh2 = length(field)
	dh = dh2 - h
	for (i = 0; i < bign%cycl; i++) nextspawn()
	dh2 = length(field) - dh2
	print "B:", h+dh2+dh*int(bign/cycl)
}
