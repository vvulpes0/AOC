#!/usr/bin/env awk -f
BEGIN {OFS="\t"}
(NR > 1 && $1 > x) {a+=1}
(NR > 3 && $1 > z) {b+=1}
{z = y; y = x; x = $1}
END {print a,b}
