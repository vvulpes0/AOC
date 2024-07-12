#!/usr/bin/env awk -f
function abs(x) { return x < 0 ? -x : x }
BEGIN { FS="," }
{
	q = r = 0
	for (i=1; i<=NF; i++) {
		if ($i == "n" )   q += 1
		if ($i == "s" )   q -= 1
		if ($i == "ne")           r += 1
		if ($i == "sw")           r -= 1
		if ($i == "nw") { q += 1; r -= 1 }
		if ($i == "se") { q -= 1; r += 1 }
		s = -q - r
		m = abs(q) > abs(r) ? abs(q) : abs(r)
		m = abs(s) > m ? abs(s) : m
		bigm = m > bigm ? m : bigm
	}
}
END { print m, bigm }
