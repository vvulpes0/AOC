#!/usr/bin/env awk -f
BEGIN { bigq = 1 }
/^Monkey/ { monkey = int($2) }
/Starting/ {
	items[monkey] = substr($0,index($0,":") + 2)
	gsub(",","",items[monkey])
	itemsb[monkey] = items[monkey]
}
/Oper/  { o1[monkey] = $4; oper[monkey] = $5; o2[monkey] = $6 }
/Test/  { divisor[monkey] = $4; bigq *= $4 / gcd(bigq, $4) }
/true/  { ttarget[monkey] = $6 }
/false/ { ftarget[monkey] = $6 }
function gcd(a,b) { return (b ? gcd(b, a % b) : a) }
function op(x,o,n) { return o[n] == "old" ? x : o[n] }
function domonkey(n,it,ins,d,x,t) {
	split(it[n],temp)
	ins[n] += length(temp)
	while (it[n] != "") {
		x = int(it[n])
		sub("[^ ]* *", "", it[n])
		if (oper[n] == "*") x = op(x,o1,n) * op(x,o2,n)
		else                x = op(x,o1,n) + op(x,o2,n)
		x = int(x / d) % bigq;
		t = x % divisor[n] ? ftarget[n] : ttarget[n]
		it[t] = it[t] (it[t] ? " " : "") x
	}
}
function insert(x,m) {
	if (x >= m[2]) { m[2] = x }
	if (x >= m[1]) { m[2] = m[1]; m[1] = x }
}
END {
	for (i = 1; i <= 10000; i++) {
		for (n = 0; n <= length(divisor); n++) {
			domonkey(n,itemsb,inspectionsb,1)
			if (i <= 20) domonkey(n,items,inspections,3)
		}
	}
	for (i = 0; i <= length(divisor); i++) {
		insert(inspections[i], a)
		insert(inspectionsb[i], b)
	}
	printf "A: %s\nB: %s\n", a[1] * a[2], b[1] * b[2]
}
