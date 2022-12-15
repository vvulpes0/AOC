#!/usr/bin/env awk -f
BEGIN { for (i = 1; i <= 6; i++) map[substr("ABCXYZ",i,1)] = 1 + (i-1)%3 }
function win(x)  { return 1 + (x+1)%3 }
function lose(x) { return 1 + x%3 }
(map[$1] == win(map[$2])) { a += 6 }
(map[$1] ==     map[$2] ) { a += 3 }
{ a += map[$2] }
($2 == "X") { b += win(map[$1]) }
($2 == "Y") { b += 3 + map[$1] }
($2 == "Z") { b += 6 + lose(map[$1]) }
END { printf "A: %s\nB: %s\n", a, b }
