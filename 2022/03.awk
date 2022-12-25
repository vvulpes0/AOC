#!/usr/bin/env awk -f
function value(x) {
	z = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	return index(z,x)
}
{
	h = 1/2 * length
	right=substr($0,h+1,h)
	for (i = 1; i <= h; i++) {
		x = substr($0,i,1)
		if (index(right,x)) {
			a += value(x)
			break
		}
	}
	elves[NR%3] = $0
}
(NR%3 == 0) {
	for (i = 1; i <= length(elves[0]); i++) {
		x = substr(elves[0],i,1)
		if (!index(elves[1],x) || !index(elves[2],x)) continue
		b += value(x)
		break
	}
}
END { printf "A: %s\nB: %s\n", a, b }
