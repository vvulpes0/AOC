#!/usr/bin/env awk -f
BEGIN { FS="" }
{
	for (i = 1; i <= NF; ++i) {
		if ($i != "#") continue
		IA[NR "," i]
		IB[NR "," i]
	}
}
function PartA(n,a,x,y,dx,dy) {
	x = y = int((NR+1)/2)
	dx = 0; dy = -1
	a = 0
	for (i = 0; i < n; i++) {
		if ((y "," x) in IA) {
			t = dx; dx = -dy; dy = t
			delete IA[y "," x]
		} else {
			a++
			t = dx; dx = dy; dy = -t
			IA[y "," x]
		}
		x += dx; y += dy
	}
	return a
}
function PartB(n,a,x,y,dx,dy,W,F) {
	x = y = int((NR+1)/2)
	dx = 0; dy = -1
	a = 0
	for (i = 0; i < n; i++) {
		if ((y "," x) in IB) {
			t = dx; dx = -dy; dy = t
			delete IB[y "," x]
			F[y "," x]
		} else if ((y "," x) in W) {
			a++
			delete W[y "," x]
			IB[y "," x]
		} else if ((y "," x) in F) {
			dx = -dx; dy = -dy
			delete F[y "," x]
		} else {
			t = dx; dx = dy; dy = -t
			W[y "," x]
		}
		x += dx; y += dy
	}
	return a
}
END { print PartA(10000),PartB(10000000) }
