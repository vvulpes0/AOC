#include <stdio.h>
#include <stdlib.h>
static int buf[256];
#define NELEMS (sizeof(buf)/sizeof(*buf))
void rev(int a, int b) {
	if (b < a) { b += NELEMS; }
	while (a < b) {
		buf[a  %NELEMS] ^= buf[b  %NELEMS];
		buf[b  %NELEMS] ^= buf[a  %NELEMS];
		buf[a++%NELEMS] ^= buf[b--%NELEMS];
	}
}
static int
partA(char *in)
{
	int p=0, s=0, n=0;
	char *pos = in;
	if (!pos || !*pos) { return 0; }
	do {
		if ('0' <= *pos && *pos <= '9') {
			n = 10*n + (*pos)-'0';
		} else {
			if (n) rev(p, (p+n-1)%NELEMS);
			p += n + (s++);
			p %= NELEMS;
			n = 0;
		}
	} while (*(pos++));
	return buf[0]*buf[1];
}

static void
partB(char *in)
{
	int p=0, s=0, n=0;
	for (int i=0; in && *in && i < 64; ++i) {
		char *pos = in;
		do {
			n = *pos;
			if (n) rev(p, (p+n-1)%NELEMS);
			p += n + (s++);
			p %= NELEMS;
			n = 0;
		} while (*(++pos));
	}
	for (int i=0; i < 16; ++i) {
		for (int j=1; j < 16; ++j) {
			buf[16*i] ^= buf[16*i + j];
		}
		printf("%02x",buf[16*i]);
	}
	printf("\n");
}

int
main(void)
{
	char *in = malloc(256);
	int capacity=256, size=0;
	char c = 0;
	for (int i = 0; i < sizeof(buf)/sizeof(*buf); ++i) {
		buf[i] = i;
	}
	while ((c = fgetc(stdin)) != EOF) {
		if (c == '\n') continue;
		if (size+10 >= capacity) {
			in = realloc(in, 2*capacity);
			capacity *= 2;
		}
		in[size++] = c;
	};
	in[size]   = 0;
	in[size+1] = 31;
	in[size+2] = 73;
	in[size+3] = 47;
	in[size+4] = 23;
	in[size+5] =  0;
	printf("%d\t",partA(in));
	in[size] = 17;
	for (int i = 0; i < sizeof(buf)/sizeof(*buf); ++i) {
		buf[i] = i;
	}
	partB(in);
	return 0;
}
