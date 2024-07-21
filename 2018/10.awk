#!/usr/bin/env awk -f
BEGIN { FS="[< ,>][< ,>]*" }
{
	 X[NR] = $2+0
	 Y[NR] = $3+0
	VX[NR] = $5+0
	VY[NR] = $6+0
}
function step(i) {
	maxy = -99999999
	miny =  99999999
	for (i = 1; i <= NR; i++) {
		X[i] += VX[i]
		Y[i] += VY[i]
		maxy = Y[i]>maxy ? Y[i] : maxy
		miny = Y[i]<miny ? Y[i] : miny
	}
}
function unstep(i) {
	maxy = maxx = -99999999
	miny = minx =  99999999
	for (i = 1; i <= NR; i++) {
		X[i] -= VX[i]
		Y[i] -= VY[i]
		maxx = X[i]>maxx ? X[i] : maxx
		minx = X[i]<minx ? X[i] : minx
		maxy = Y[i]>maxy ? Y[i] : maxy
		miny = Y[i]<miny ? Y[i] : miny
		P[X[i]","Y[i]]
	}
}
END {
	b = -1
	while (height <= last_height || last_height == 0) {
		b++
		step()
		last_height = height
		height = maxy - miny + 1
	}
	unstep()
	for (i = miny; i <= maxy; i++) {
		for (j = minx; j <= maxx; j++) {
			printf "%c",((j","i) in P ? "#" : " ")
		}
		printf "\n"
	}
	print b
}
