#!/usr/bin/env awk -f
function check(x) {
	if (s1 ~ "^[0-9]" && s2 ~ "^[0-9]") {
		if (int(s1) < int(s2)) { return 1 }
		if (int(s1) > int(s2)) { return -1 }
		sub("^[0-9]*,*","",s1)
		sub("^[0-9]*,*","",s2)
		return 0
	} else if (s1 ~ "^[[]" && s2 ~ "^[[]") {
		s1 = substr(s1,2)
		s2 = substr(s2,2)
		while (!(s1 ~ "^]" || s2 ~ "^]")) {
			if (x = check()) return x
		}
		x  = sub("^],*","",s1)
		x -= sub("^],*","",s2)
		return x
	}
	if (match(s1,"^[0-9][0-9]*")) {
		s1 = "[" substr(s1,1,RLENGTH) "]" substr(s1,1+RLENGTH)
	}
	if (match(s2,"^[0-9][0-9]*")) {
		s2 = "[" substr(s2,1,RLENGTH) "]" substr(s2,1+RLENGTH)
	}
	return check()
}
/^$/ { ind++; if (check() > 0) a += ind; next }
{ s1 = s2; packets[length(packets)] = s2 = $0 }
END {
	ind++
	if (check() == 1) a += ind
	print "A:",a
	packets[length(packets)] = "[[2]]"
	packets[length(packets)] = "[[6]]"
	b = 1
	for (i = 0; i < length(packets); i++) {
		for (j = i + 1; j < length(packets); j++) {
			s1 = x = packets[i]
			s2 = packets[j]
			if (check() >= 0) continue
			packets[i] = packets[j]
			packets[j] = x
		}
		if (packets[i] ~ "^[[][[][26][]][]]$") b *= i + 1
	}
	print "B:",b
}
