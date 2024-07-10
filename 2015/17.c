#include <limits.h>
#include <stdio.h>
int main(void) {
	int buf[sizeof(int)*CHAR_BIT-1];
	int size = 0;
	int i;
	int j;
	int s;
	int x = 0;
	int popc;
	int minpopc = INT_MAX;
	int partA = 0;
	int partB = 0;
	char c;
	while ((c = fgetc(stdin)) != EOF) {
		if (c == '\n') {
			buf[size++] = x;
			x = 0;
			if (size == sizeof(buf)/sizeof(*buf)) {
				fprintf(stderr,"too big\n");
				return 1;
			}
			continue;
		}
		x *= 10;
		x += c - '0';
	}
	for (i = 0; i < (1<<size); ++i) {
		x = i;
		popc = 0;
		while (x) { x &= x-1; ++popc; }
		x = i;
		j = s = 0;
		while (x) {
			if (x%2) s += buf[j];
			++j;
			x /= 2;
		}
		if (s == 150) {
			++partA;
			if (popc < minpopc) {
				minpopc = popc;
				partB = 0;
			}
			partB += popc <= minpopc;
		}
	}
	printf("%d %d\n", partA, partB);
}
