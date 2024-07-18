#!/usr/bin/env awk -f
{
	for (i = NR - 1; i > 0; i--) {
		if (T[i] < $0) break;
		T[i+1] = T[i]
	}
	T[i+1] = $0
}
function isLeap(y) { return y%4 == 0 && (y%100 != 0 || y%400 == 0) }
function shouldInc(y,m,d) {
	if (m == 2 && d == 29+isLeap(y)) return 1
	if (d == 31 && m%2 == (m>7)) return 1
	if (d == 32 && m%2 == (m<8)) return 1
	return 0
}
function DBD(x,y,X,Y,d) {
	d = 0
	sub(" .*$","",x)
	sub(" .*$","",y)
	split(x,X,"-")
	split(y,Y,"-")
	while (X[1] != Y[1] || X[2] != Y[2] || X[3] != Y[3]) {
		d++; X[3]++
		if (shouldInc(X[1],X[2],X[3])) { X[2]++; X[3] = 1 }
		if (X[2] == 13) { X[1]++; X[2] = 0 }
	}
	return d;
}
function diff(x,y,X,Y,a) {
	split(x,X,"[- :]*")
	split(y,Y,"[- :]*")
	a  = DBD(x,y)*24*60
	a += (Y[4]-X[4])*60
	a +=  Y[5]-X[5]
	return a
}
function PartA(i,j,g,G,maxg,maxv,last,X,Y,M) {
	for (i = 1; i <= NR; i++) {
		$0 = T[i]
		gsub("[]#[]","",$0)
		if (/Guard/) g = $4
		if (/wakes/) G[g] += diff(T[i-1],T[i])
	}
	maxg = -1
	maxv = -1
	for (i in G) {
		if (maxv < 0 || G[i] > maxv) {
			maxg = i
			maxv = G[i]
		}
	}
	for (i = 1; i <= NR; i++) {
		$0 = T[i]
		gsub("[]#[]","",$0)
		if (/Guard/) g = $4
		if (/wakes/ && g == maxg) {
			split(last,X,"[- :]*")
			split($0,Y,"[- :]*")
			go = 0
			for (j = 1; j <= 5; j++) go = go || (X[j]!=Y[j])
			while (go) {
				M[X[5]]++
				X[5]++
				if (X[5]==60) { X[4]++; X[5]=0 }
				if (X[4]==24) { X[3]++; X[4]=0 }
				if (shouldInc(X[1],X[2],X[3])) {
					X[2]++; X[3]=1
				}
				if (X[2]==13) { X[1]++; X[2]=1 }
				go = 0
				for (j = 1; j <= 5; j++) {
					go = go || (X[j]!=Y[j])
				}
			}
		}
		last = $0
	}
	maxm = -1
	maxv = -1
	for (i in M) {
		if (maxv < 0 || M[i] > maxv) {
			maxm = i
			maxv = M[i]
		}
	}
	return maxg*maxm
}
function PartB(g,i,j,M,X,Y,last,maxm,maxv) {
	for (i = 1; i <= NR; i++) {
		$0 = T[i]
		gsub("[]#[]","",$0)
		if (/Guard/) g = $4
		if (/wakes/) {
			split(last,X,"[- :]*")
			split($0,Y,"[- :]*")
			go = 0
			for (j = 1; j <= 5; j++) go = go || (X[j]!=Y[j])
			while (go) {
				M[g","X[5]]++
				X[5]++
				if (X[5]==60) { X[4]++; X[5]=0 }
				if (X[4]==24) { X[3]++; X[4]=0 }
				if (shouldInc(X[1],X[2],X[3])) {
					X[2]++; X[3]=1
				}
				if (X[2]==13) { X[1]++; X[2]=1 }
				go = 0
				for (j = 1; j <= 5; j++) {
					go = go || (X[j]!=Y[j])
				}
			}
		}
		last = $0
	}
	maxv = -1
	for (i in M) {
		if (maxv < 0 || M[i]>maxv) {
			maxm = i
			maxv = M[i]
		}
	}
	split(maxm,X,",")
	return X[1]*X[2]
}
END { print PartA(),PartB() }
