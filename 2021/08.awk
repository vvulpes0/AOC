#!/usr/bin/env awk -f
BEGIN {
	FS=" [|] "
	segments["abcefg"] = 0
	segments["cf"] = 1
	segments["acdeg"] = 2
	segments["acdfg"] = 3
	segments["bcdf"] = 4
	segments["abdfg"] = 5
	segments["abdefg"] = 6
	segments["acf"] = 7
	segments["abcdefg"] = 8
	segments["abcdfg"] = 9
	b[2] = b[3] = b[4] = b[7] = 0
}

{
	# Determine wiring
	#
	# At the start, anything can be anything
	s = "abcdefg"
	split(s,x,"")
	for (i in x) {
		m[x[i]] = s
	}

	# Use the patterns to deduce the mapping
	split($1,x," ")
	for (i in x) {
		i = x[i]
		c = s
		gsub("[" i "]","",c) # c is complement of i
		for (j in m) {
			t = " "
			if (length(i) == 2) {
				t = (index("cf",j) ? c : i)
			} else if (length(i) == 3) {
				t = (index("acf",j) ? c : i)
			} else if (length(i) == 4) {
				t = (index("bcdf",j) ? c : i)
			} else if (length(i) == 5) {
				t = (index("adg",j) ? c : t)
			} else if (length(i) == 6) {
				t = (index("abfg",j) ? c : t)
			}
			gsub("[" t "]", "", m[j])
			if (length(m[j]) == 1) {
				for (k in m) {
					if (k == j) {continue}
					gsub("[" m[j] "]", "", m[k])
				}
			}
		}
	}

	# Decode four-digit codes
	z = 0
	split($2,x," ")
	for (i = 1; i <= length(x); ++i) {
		split(x[i],y,"")
		a += (length(x[i]) in b)
		for (j = 1; j <= length(y); ++j) {
			t = y[j]
			for (k in m) {
				y[j] = (t == m[k]) ? k : y[j]
			}
		}
		# Sort the values
		for (j = 1; j < length(y); ++j) {
			for (k = j; k <= length(y); ++k) {
				if (y[k] < y[j]) {
					t = y[j]
					y[j] = y[k]
					y[k] = t
				}
			}
		}
		# And concatenate into a string for lookup
		t=""
		for (j = 1; j <= length(y); ++j) {
			t = t y[j]
		}
		z *= 10
		z += segments[t]
	}
	result += z
}

END {
	print a,result
}
