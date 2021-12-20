#!/usr/bin/env awk -f
BEGIN {
	FS = OFS = ","
	print "Lang","Time","Parts","Avg"
}
(NR > 1) {
	a[$4] += $7
	b[$4] += 1
}
END {
	for (i in a) {
		print i, a[i], b[i], a[i]/b[i]
	}
}
