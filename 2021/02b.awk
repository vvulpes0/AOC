#!/usr/bin/env awk -f
BEGIN {x=0;d=0;a=0}
($1 == "forward") {x += $2; d += a * $2}
($1 == "down") {a += $2}
($1 == "up") {a -= $2}
END {print d*x}
