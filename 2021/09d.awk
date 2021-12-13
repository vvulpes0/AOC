#!/usr/bin/env awk -f
BEGIN {
	FS = ""
}

{
	a[NR] = $0
	f = (NF > f) ? NF : f
}

END {
	print "P3"
	print f,NR

	# Initialize colours to 0 (unknown)
	for (i = 1; i <= NR; ++i) {
		for (j = 1; j <= f; ++j) {
			x[i "," j] = 0
		}
	}

	# Find low points (y) and boundaries (-1)
	for (i = 1; i <= NR; ++i) {
		split(a[i-1],p)
		split(a[i],c)
		split(a[i+1],s)
		for (j = 1; j <= f; ++j) {
			if (c[j] == 9) {
				x[i "," j] = -1
				continue
			}
			b = 1
			if ((i > 1 && c[j] >= p[j]) \
			    || (i < NR && c[j] >= s[j]) \
			    || (j > 1 && c[j] >= c[j-1]) \
			    || (j < length(c) && c[j] >= c[j+1])) {
				b = 0
			}
			if (b) {
				++y
				x[i "," j] = y
			}
		}
	}

	print y

	# Floodfill
	do {
		for (i = 1; i <= NR; ++i) {
			split(a[i-1],p)
			split(a[i],c)
			split(a[i+1],s)
			for (j = 1; j <= f; ++j) {
				if (x[i "," j]) { continue }
				m = 0
				if (i > 1) {
					z = x[(i - 1) "," j]
					m = (z > m) ? z : m
				}
				if (i < NR) {
					z = x[(i + 1) "," j]
					m = (z > m) ? z : m
				}
				if (j > 1) {
					z = x[i "," (j - 1)]
					m = (z > m) ? z : m
				}
				if (j < f) {
					z = x[i "," (j + 1)]
					m = (z > m) ? z : m
				}
				x[i "," j] = m
			}
		}

		# Detect emptiness
		seenEmpty = 0
		for (i in x) {
			if (!x[i]) {
				seenEmpty = 1
				break
			}
		}
	} while (seenEmpty)

	# Compute sizes
	for (i in x) {
		if (x[i] < 0) {continue}
		++g[x[i]]
	}
	# Sort them
	for (i in g) {
		for (j=length(h); j > 0; --j) {
			if (g[h[j]] <= g[i]) { break }
			h[j+1] = h[j]
		}
		h[j+1] = i
	}
	for (i in h) {
		q[h[i]] = i
	}

	for (i=1; i<=NR;++i) {
		for (j=1; j<=f; ++j) {
			z = x[i "," j]
			printf "%d ",(z < 1) ? int(0) : q[z]
			printf "%d ",(z < 1) ? int(0) : q[z]
			printf "%d\n",(z < 1) ? int(0) : q[z]
		}
		printf "\n"
	}
}
