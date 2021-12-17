#!/usr/bin/env awk -f
function    ceiling(x) { return (x == int(x)) ? x : int(x) + 1 }
function    solve(m,p) { return m + sqrt(m^2 - p) }
function dragless(v,t) { return t*(2*v-t+1)/2 }
function  dragged(v,t) { return dragless(v,(v < t) ? v : t) }
BEGIN { FS="[=,]|\\.\\."; OFS="\t" }
{
	s = ceiling(solve(-1/2,-2*$2))
	for (y = $5; y < -$5; ++y) {
		i = ceiling(solve(y+1/2,2*$6))
		j = int(solve(y+1/2,2*$5))
		for (x = s; x <= $3; ++x) {
			for (t = i; t <= j; ++t) {
				p = dragged(x,t)
				if ($2 > p || p > $3) { continue }
				b += 1
				a = y
				break
			}
		}
	}
	print dragless(a,a),b
}
