#!/usr/bin/env awk -f
BEGIN { FS = "[: ][: ]*" }
(NF == 4) { left[$1] = $2; op[$1] = $3; right[$1] = $4 }
(NF == 2) { val[$1] = $2 }
($1 == "humn") { hum[$1] }
function calc(n, temp) {
	if (n in val) return val[n]
	if (op[n] == "+") val[n] = calc(left[n]) + calc(right[n])
	else if (op[n] == "-") val[n] = calc(left[n]) - calc(right[n])
	else if (op[n] == "*") val[n] = calc(left[n]) * calc(right[n])
	else if (op[n] == "/") val[n] = calc(left[n]) / calc(right[n])
	if (left[n] in hum || right[n] in hum) { hum[n] }
	return val[n]
}
function solve(h,x) {
	if (h == "humn") return x
	if (op[h] == "+") {
		if (left[h] in hum) return solve(left[h],x-val[right[h]])
		else return solve(right[h],x-val[left[h]])
	} else if (op[h] == "*") {
		if (left[h] in hum) return solve(left[h],x/val[right[h]])
		else return solve(right[h],x/val[left[h]])
	} else if (op[h] == "-") {
		if (left[h] in hum) return solve(left[h],x+val[right[h]])
		else return solve(right[h],val[left[h]]-x)
	} else if (op[h] == "/") {
		if (left[h] in hum) return solve(left[h],x*val[right[h]])
		else return solve(right[h],val[left[h]]/x)
	}
}
END {
	print "A:",calc("root")
	h = left["root"]
	x = val[right["root"]]
	if (right["root"] in hum) {
		h = right["root"]
		x = val[left["root"]]
	}
	print "B:",solve(h,x)
}
