#!/usr/bin/env awk -f
BEGIN { FS=", "; min_x = min_y = 99999999; max_x = max_y = -1 }
{
	X[NR]=$1
	Y[NR]=$2
	min_x = $1 < min_x ? $1 : min_x
	max_x = $1 > max_x ? $1 : max_x
	min_y = $2 < min_y ? $2 : min_y
	max_y = $2 > max_y ? $2 : max_y
}
function abs(x) { return x<0 ? -x : x }
END {
	if (DO_DISPLAY) {
		print "P3"
		print max_x - min_x + 3, max_y - min_y + 3
		print NR
	}
	b = 0
	for (j = min_y - 1; j <= max_y + 1; j++) {
		for (i = min_x - 1; i <= max_x + 1; i++) {
			md = -1
			m = 0
			t = 0
			for (p = 1; p <= NR; p++) {
				d = abs(i - X[p]) + abs(j - Y[p])
				t += d
				if (md < 0 || d < md) {
					md = d
					m = p
				}
			}
			if (t < 10000) b++
			c = 0
			for (p = 1; p <= NR; p++) {
				d = abs(i - X[p]) + abs(j - Y[p])
				c += d == md
			}
			if (c > 1) m = -1
			if (i<min_x||i>max_x||j<min_y||j>max_y) NO[m]
			C[m]++
			if (DO_DISPLAY) {
				if (md == 0) {
					printf "%4d %4d %4d\n",NR,NR,NR
				} else if (m < 0) {
					printf "%4d %4d %4d\n",0,0,0
				} else {
					g  = m * 1461932367
					g += m*m * 2817264
					r = int(3*(NR+1)/4)
					o = (NR+1)-r
					printf "%4d",(g%r)+o
					g = int(g/r)
					printf "%4d",(g%r)+o
					g = int(g/r)
					printf "%4d\n",(g%r)+o
				}
			}
		}
	}
	NO[-1]
	a = 0
	for (i = 1; i <= NR; i++) {
		if (i in NO) continue
		a = C[i]>a ? C[i] : a
	}
	if (!DO_DISPLAY) {
		print a,b
	}
}
