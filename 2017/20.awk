#!/usr/bin/env awk -f
function abs(x) { return x<0?-x:x }
BEGIN { FS = "[^0-9-][^0-9-]*" }
{
	px[NR]=$2; py[NR]=$3; pz[NR]=$4
	vx[NR]=$5; vy[NR]=$6; vz[NR]=$7
	ax[NR]=$8; ay[NR]=$9; az[NR]=$10
	a = abs(ax[NR])+abs(ay[NR])+abs(az[NR])
	min_a = (NR==1||a<min_a)?a:min_a
}
function times(s,i,j,A,V,P,T,a,b,c,v,r,x) {
	a = A[i]-A[j]; v = V[i]-V[j]; c = P[i]-P[j]
	# a should be halved everywhere but easier to keep whole
	b = v + a/2
	delete T
	if (a == 0 && b != 0 && -c/b==int(-c/b)) {
		if (-c/b < 0) { return -1 }
		T[1] = -c/b
		return 0
	} else if (a != 0 ) {
		r = b*b - 2*a*c
		if (r < 0) { return -1 }
		T[1] = (-b - sqrt(r))/a
		T[2] = (-b + sqrt(r))/a
		if (T[1]<0 && T[2]<0) { return -1 }
		if (T[1]<0 || T[1]!=int(T[1])) {
			T[1] = T[2]; delete T[2]
		}
		x = length(T)
		if (T[x]<0 || T[x]!=int(T[x])) {
			delete T[x]
		}
		if (length(T) == 0) { return -1 }
		return 0
	} else if (a==0 && b==0 && p==0) {
		return 1
	}
	return -1
}
function elem(x,T,i) {
	for (i in T) { if (T[i] == x) return 1 }
	return 0
}
function ckcoll(i,j,tx,ty,tz,x,y,z,t) {
	x=times("X",i,j,ax,vx,px,tx);
	y=times("Y",i,j,ay,vy,py,ty);
	z=times("Z",i,j,az,vz,pz,tz);
	t = -1
	if (x ==  1 && y ==  1 && z ==  1) { return  0 }
	if (x == -1 || y == -1 || z == -1) { return -1 }
	if (x != 1) {
		for (i in tx) {
			if ((y==1||elem(tx[i],ty)) && (z==1||elem(tx[i],tz))) {
				t = (tx[i]<t||t<0)?tx[i]:t
			}
		}
	} else if (y != 1) {
		for (i in ty) {
			if ((x==1||elem(ty[i],tx)) && (z==1||elem(ty[i],tz))) {
				t = (ty[i]<t||t<0)?ty[i]:t
			}
		}
	} else {
		for (i in tz) {
			if ((x==1||elem(tz[i],tx)) && (y==1||elem(tz[i],ty))) {
				t = (tz[i]<t||t<0)?tz[i]:t
			}
		}
	}
	return t
}
END {
	vset = 0
	for (i = 1; i <= NR; i++) {
		a = abs(ax[i])+abs(ay[i])+abs(az[i])
		if (a==min_a) {
			v = abs(vx[i])+abs(vy[i])+abs(vz[i])
			min_v = (v<min_v||!vset)?v:min_v
			vset = 1
		}
	}
	for (i = 1; i <= NR; i++) {
		a = abs(ax[i])+abs(ay[i])+abs(az[i])
		v = abs(vx[i])+abs(vy[i])+abs(vz[i])
		if (a==min_a && v==min_v) { A = i-1 }
	}
	do {
		rem = ""
		min_t = -1
		for (i in ax) {
			for (j in ax) {
				if (j <= i) continue
				t = ckcoll(i,j)
				if (t < 0) continue
				if (t == min_t && min_t >= 0) {
					rem = rem ":" i ":" j
				} else if (t<min_t || min_t<0) {
					min_t = t;
					rem = i ":" j
				}
			}
		}
		split(rem,Q,":")
		for (i in Q) K[Q[i]]=Q[i]
		for (i in K) delete ax[i]
	} while (rem != "")
	B = length(ax)
	print A,B
}
