#!/usr/bin/env awk -f
BEGIN {
	x = 1
	split("20 60 100 140 180 220",imp)
	for (i in imp) { important[imp[i]] = 1 }
}
/noop/ { c++ }
/addx/ { c += 2; x += $2; changes[c] = x }
END {
	x = 1
	for (i = 1; i <= c; i++) {
		y = (i - 1) % 40
		printf ((x - y < 0 ? y - x : x - y) <= 1) ? "█" : " "
		if (i in important) a += x * i
		if (i in changes) x = changes[i]
		if (i % 40 == 0) printf "\n"
	}
	printf "A: %s\nB: %s\n", a, b
}
