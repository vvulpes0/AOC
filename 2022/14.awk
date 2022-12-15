#!/usr/bin/env awk -f
function min(a,b) { return a < b ? a : b }
function max(a,b) { return a < b ? b : a }
function dosand(f,sx,sy,i,x) {
	sx = 500
	sy = 0
	if (sx "," sy in cave) return 0
	updated = 1
	while (updated && sy <= maxy) {
		for (i = updated = 0; i <= 2 && !updated; i++) {
			x = sx + (1 - 2*(i%2))*int((i+1)/2)
			if (x "," (sy + 1) in cave) continue
			updated = 1
			sx = x
			sy++
		}
	}
	cave[sx "," sy]
	return (f || !updated)
}
function vert(x,a,b,i) { for (i = a; i <= b; i++) cave[x "," i] }
function horz(y,a,b,i) { for (i = a; i <= b; i++) cave[i "," y] }
BEGIN { FS=",| -> "; maxy = -1 }
{
	ox = $1
	oy = $2
	for (i = 3; i <= NF; i += 2) {
		nx = $i
		ny = $(i+1)
		maxy = max(oy, max(ny, maxy))
		if (nx == ox) vert(ox, min(ny,oy), max(ny,oy))
		else          horz(oy, min(nx,ox), max(nx,ox))
		ox = nx
		oy = ny
	}
}
END {
	while (dosand(0)) x++
	print "A:",x
	do { x++ } while (dosand(1))
	print "B:",x
}
