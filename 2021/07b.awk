#!/usr/bin/env awk -f
BEGIN {
	RS=",|\n"
	OFS="\t"
}

{
	a += $1
	r[NR] = $1
}

END {
	# mean is between two values; whichever one is best wins
	x = int(a/NR)
	f1 = 0
	for (i in r) {
		i = r[i]
		d = (i < x) ? x - i : i - x
		f1 += (d * (d + 1)) / 2
	}

	x = int(a/NR)+1
	f2 = 0
	for (i in r) {
		i = r[i]
		d = (i < x) ? x - i : i - x
		f2 += (d * (d + 1)) / 2
	}

	print (f1 < f2) ? f1 : f2
}
