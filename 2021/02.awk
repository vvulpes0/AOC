#!/usr/bin/env awk -f
BEGIN {OFS="\t"}
($1 == "forward") {x += $2; d += a * $2}
($1 == "down") {a += $2}
($1 == "up") {a -= $2}
END {print a*x, d*x}
