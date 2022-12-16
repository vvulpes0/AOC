#!/usr/bin/env awk -f
BEGIN { x = 1 }
/noop/ { c++ }
/addx/ { c += 2; x += $2; changes[c] = x }
END {
	x = 1
	for (i = 1; i <= c; i++) {
		y = (i - 1) % 40
		printf ((x - y < 0 ? y - x : x - y) <= 1) ? "█" : " "
		if (i % 40 == 0) printf "\n"
		else if (i % 40 == 20) a += x * i
		if (i in changes) x = changes[i]
	}
	printf "A: %s\nB: displayed\n", a
}
