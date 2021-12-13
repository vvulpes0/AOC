#!/usr/bin/env awk -f
BEGIN {x=0;d=0}
($1 == "forward") {x += $2}
($1 == "down") {d += $2}
($1 == "up") {d -= $2}
END {print d*x}
