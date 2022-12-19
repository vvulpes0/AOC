#!/usr/bin/env awk -f
BEGIN { FS="[ :][ :]*"; b = 1 }
function max(a,b) { return a > b ? a : b }
function cdiv(a,b) { return int((a+b-1)/b) }
function dfs(d,rsrc,rbt,  i,j,sbrsrc,sbrbt,t,x) {
	t = rbt[4] * d + rsrc[4] # if we do nothing at all
	for (i in rbt) {
		if (i != 1 && !rbt[i-1]) continue # unbuildable
		if (i in mcost && rbt[i] >= mcost[i]) continue # no need
		x = max(0,cdiv(cost[i ":" 1] - rsrc[1], rbt[1]))
		if (i!=1) x=max(x,cdiv(cost[i":"(i-1)]-rsrc[i-1],rbt[i-1]))
		x++
		if (x >= d) continue # too long
		for (j in rsrc) {
			sbrbt[j] = rbt[j] + (j==i) # same indices
			sbrsrc[j] = rsrc[j] + x*rbt[j]
			if (!(i ":" j in cost)) continue
			sbrsrc[j] -= cost[i ":" j]
		}
		t = max(t, dfs(d - x, sbrsrc, sbrbt))
	}
	return t
}
{
	split("0 0 0 0", resource)
	split("1 0 0 0", robot)
	mcost[1] = max(max($7,$13),max($19,$28))
	mcost[2] = $22
	mcost[3] = $31
	cost["1:1"] = $7
	cost["2:1"] = $13
	cost["3:1"] = $19
	cost["3:2"] = $22
	cost["4:1"] = $28
	cost["4:3"] = $31
	z = dfs(24, resource, robot)
	a += $2 * z
	if ($2 <= 3) b *= dfs(32, resource, robot)
}
END { printf "A: %s\nB: %s\n",a,b }
