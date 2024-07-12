#!/usr/bin/env awk -f
{ jump[NR] = 0+$0 }
END {
	for (i = 1; i <= NR; i++) { jcopy[i] = jump[i] }
	i = 1
	steps = 0
	while (i > 0 && i <= NR) {
		t = jump[i]
		jump[i]++
		i = i + t
		steps++
	}
	stepsB = 0
	i = 1
	while (i > 0 && i <= NR) {
		t = jcopy[i]
		if (t < 3) { jcopy[i]++ } else { jcopy[i]-- }
		i = i + t
		stepsB++
	}
	print steps, stepsB
}
