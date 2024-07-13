#!/usr/bin/env awk -f
function read (x)   { return match(x,"[0-9]") ? x+0 : 0+regs[x]       }
function readB(n,x) { return match(x,"[0-9]") ? x+0 : 0+regs[n "," x] }
{ prog[NR] = $0 }
function PartA(pc,A) {
	delete regs
	for (pc = 1; 0 < pc && pc <= NR; pc++) {
		$0 = prog[pc]
		if (/snd/)               {     last  = read($2)     }
		if (/set/)               { regs[$2]  = read($3)     }
		if (/add/)               { regs[$2] += read($3)     }
		if (/mul/)               { regs[$2] *= read($3)     }
		if (/mod/)               { regs[$2] %= read($3)     }
		if (/rcv/ && read($2))   {        A  = last; break  }
		if (/jgz/ && read($2)>0) {       pc += read($3) - 1 }
	}
	return A
}
function empty(n) { sub("^:*","",Q[n]); return Q[n] == "" }
function deQ(n,X) {
	split(Q[n],X,":");
	sub("^[^:]*:*","",Q[n]);
	return X[1]
}
function GoB(n) {
	if (0 >= pcs[n] || pcs[n] > NR) return 0
	$0 = prog[pcs[n]]
	if (/snd/)                  { Q[1-n] = Q[1-n] ":" readB(n,$2)  }
	if (/snd/)                  {              B += n              }
	if (/set/)                  { regs[n "," $2]  = readB(n,$3)    }
	if (/add/)                  { regs[n "," $2] += readB(n,$3)    }
	if (/mul/)                  { regs[n "," $2] *= readB(n,$3)    }
	if (/mod/)                  { regs[n "," $2] %= readB(n,$3)    }
	if (/rcv/ &&  empty(n))     { return 0                         }
	if (/rcv/ && !empty(n))     { regs[n "," $2] = deQ(n)          }
	if (/jgz/ && readB(n,$2)>0) { pcs[n] += readB(n,$3) - 1        }
	return 1
}
function PartB() {
	delete regs
	did_0 = did_1 = pcs[0] = pcs[1] = 1
	regs[0 ",p"] = 0; regs[1 ",p"] = 1
	while (did_0 || did_1) {
		pcs[0] += did_0 = GoB(0)
		pcs[1] += did_1 = GoB(1)
	}
	return B
}
END { print PartA(),PartB() }
