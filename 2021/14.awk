#!/usr/bin/env awk -f
BEGIN {
	FS=" -> "
	OFS="\t"
}

(NR == 1) {
	split("#" $0 "#",a,"")
	y[a[1]] = 1
	for (i = 2; i <= length(a); ++i) {
		s[a[i-1] a[i]] += 1
	}
}
(NF == 2) {
	x[$1] = $2
}

END {
	for (j = 0; j < 40; ++j) {
		delete t
		for (i in s) {
			if (!(i in x)) { t[i] = s[i]; continue; }
			t[substr(i,1,1) x[i]] += s[i]
			t[x[i] substr(i,2,1)] += s[i]
		}
		delete s
		for (i in t) {
			s[i] = t[i]
		}
		if (j == 9) {
			for (k in s) {
				b[substr(k,1,1)] += s[k] / 2
				b[substr(k,2,1)] += s[k] / 2
				mx = s[k] > mx ? s[k] : mx
			}
			mn = mx
			for (k in b) {
				if (k == "#") {continue;}
				mx = b[k] > mx ? b[k] : mx
				mn = b[k] < mn ? b[k] : mn
			}
			printf "%d\t", mx - mn
		}
	}
	for (i in s) {
		b[substr(i,1,1)] += s[i] / 2
		b[substr(i,2,1)] += s[i] / 2
		mx = s[i] > mx ? s[i] : mx
	}
	mn = mx
	for (i in b) {
		if (i == "#") {continue;}
		mx = b[i] > mx ? b[i] : mx
		mn = b[i] < mn ? b[i] : mn
	}
	print mx - mn
}
