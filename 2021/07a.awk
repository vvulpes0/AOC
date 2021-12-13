#!/usr/bin/env awk -f
BEGIN {
	RS=",|\n"
	OFS="\t"
}
{
	for (i = NR - 1; (i > 0) && (a[i] > $1); --i) {
		a[i+1] = a[i]
	}
	a[i+1] = $1
}

END {
	median = a[int(NR/2)]
	x = 0
	for (i in a) {
		i = a[i]
		x += (i < median) ? median - i : i - median
	}
	print x
}
