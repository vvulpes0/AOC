#!/usr/bin/env awk -f
BEGIN { FS = "," }
function empty(a,  i) { for (i in a) return 0; return 1}
{
	cubes[$0] = 0
	for (i = 1; i <= NF; i++) {
		min[i] = min[i] < $i ? min[i] : $i
		max[i] = max[i] > $i ? max[i] : $i
		x = ($1 + (i==1)) "," ($2 + (i==2)) "," ($3 + (i==3))
		if (x in cubes) { cubes[x] += 1; cubes[$0]++ }
		x = ($1 - (i==1)) "," ($2 - (i==2)) "," ($3 - (i==3))
		if (x in cubes) { cubes[x] += 1; cubes[$0]++ }
	}
}
END {
	for (i in cubes) { a += 6 - cubes[i] }
	open[(min[1] - 1) "," (min[2] - 1) "," (min[3] - 1)]
	b = 0
	do {
		delete tmp
		for (i in open) {
			if (i in outer) continue
			split(i, p, ",")
			x = p[1]; y = p[2]; z = p[3]
			if (x < min[1] - 1 || x > max[1] + 1) continue
			if (y < min[2] - 1 || y > max[2] + 1) continue
			if (z < min[3] - 1 || z > max[3] + 1) continue
			outer[i]
			for (j = 1; j <= 3; j++) {
				v=(x+(j==1))","(y+(j==2))","(z+(j==3))
				if (v in cubes) b++; else tmp[v]
				v=(x-(j==1))","(y-(j==2))","(z-(j==3))
				if (v in cubes) b++; else tmp[v]
			}
		}
		delete open
		for (i in tmp) open[i]
	} while (!empty(open))
	printf "A: %s\nB: %s\n",a,b
}
