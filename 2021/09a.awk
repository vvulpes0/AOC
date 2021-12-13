#!/usr/bin/env awk -f
BEGIN {
	FS = ""
}

{a[NR] = $0}

END {
	for (i = 1; i <= NR; ++i) {
		split(a[i-1],p)
		split(a[i],c)
		split(a[i+1],s)
		for (j = 1; j <= length(c); ++j) {
			b = 1
			if ((i > 1 && c[j] >= p[j]) \
			    || (i < NR && c[j] >= s[j]) \
			    || (j > 1 && c[j] >= c[j-1]) \
			    || (j < length(c) && c[j] >= c[j+1])) {
				b = 0
			}
			if (b) {
				r += c[j] + 1
			}
		}
	}
	print r
}
