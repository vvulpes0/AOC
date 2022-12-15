#!/usr/bin/env awk -f
{ for (i = 1; i <= length; i++) { trees[NR "," i] = substr($0,i,1) } }
END {
	h = NR
	w = length
	for (t in trees) {
		x = trees[t]
		split(t,pos,",")
		l = 0
		for (i = pos[2] - 1; i >= 1; i--) {
			l++
			if (trees[pos[1] "," i] >= x) break
		}
		if (i == 0) visible[t] = 1
		r = 0
		for (i = pos[2] + 1; i <= w; i++) {
			r++
			if (trees[pos[1] "," i] >= x) break
		}
		if (i == w + 1) visible[t] = 1
		u = 0
		for (i = pos[1] - 1; i >= 1; i--) {
			u++
			if (trees[i "," pos[2]] >= x) break
		}
		if (i == 0) visible[t] = 1
		d = 0
		for (i = pos[1] + 1; i <= h; i++) {
			d++
			if (trees[i "," pos[2]] >= x) break
		}
		if (i == h + 1) visible[t] = 1
		x = l * r * u * d
		b = x > b ? x : b
	}
	printf "A: %s\nB: %s\n", length(visible), b
}
