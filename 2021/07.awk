#!/usr/bin/env awk -f
BEGIN {
	RS=",|\n"
	OFS="\t"
}
{
	m1 += $1
	for (i = NR - 1; (i > 0) && (a[i] > $1); --i) {
		a[i+1] = a[i]
	}
	a[i+1] = $1
}

END {
	median = a[int(NR/2)]
	m1 = int(m1/NR)
	m2 = m1+1
	for (i in a) {
		i = a[i]
		x += (i < median) ? median - i : i - median
		d1 = (i < m1) ? m1 - i : i - m1
		d2 = (i < m2) ? m2 - i : i - m2
		f1 += (d1 * (d1 + 1)) / 2
		f2 += (d2 * (d2 + 1)) / 2
	}
	print x, (f1 < f2) ? f1 : f2
}
