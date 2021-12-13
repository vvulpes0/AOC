#!/usr/bin/env awk -f
BEGIN {
	FS=""
	OFS="\t"
	o[")"] = "("; p[")"] =     3
	o["]"] = "["; p["]"] =    57
	o["}"] = "{"; p["}"] =  1197
	o[">"] = "<"; p[">"] = 25137
}

{
	good = 1
	delete s
	for (i = 1; i <= NF; ++i) {
		# Opener
		if (index("(<{[",$i)) {
			s[length(s)] = $i
			continue
		}
		# Attempt to pop emptiness
		if (length(s) == 0) {
			good = 0
			break
		}
		# Attempt to pop wrong character
		if (s[length(s) - 1] != o[$i]) {
			good = 0
			break;
		}
		delete s[length(s) - 1]
	}
	if (!good) {
		r += p[$i]
		next
	}

	y = 0
	for (i = length(s) - 1; i >= 0; --i) {
		y *= 5
		y += index("([{<", s[i])
	}
	for (i = length(z); i > 0; --i) {
		if (z[i] < y) { break }
		z[i + 1] = z[i]
	}
	z[i + 1] = y
}

END {
	print r,z[int(length(z)/2)+1]
}
