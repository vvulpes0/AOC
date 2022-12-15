#!/usr/bin/env awk -f
function distinct(s,i) {
	for (i = 1; i <= length(s); i++)
	{
		if (index(substr(s,i+1),substr(s,i,1))) return 0
	}
	return 1
}
{
	for (i = 4; i <= length; i++) {
		if (distinct(substr($0,i - 3,4))) a = a ? a : i
		if (i < 14) continue
		if (distinct(substr($0,i - 13,14))) b = b ? b : i
	}
}
END { printf "A: %s\nB: %s\n", a, b }
