#include <stdlib.h>
static int buf[256];
#define NELEMS (sizeof(buf)/sizeof(*buf))
static void rev(int a, int b) {
	if (b < a) { b += NELEMS; }
	while (a < b) {
		buf[a  %NELEMS] ^= buf[b  %NELEMS];
		buf[b  %NELEMS] ^= buf[a  %NELEMS];
		buf[a++%NELEMS] ^= buf[b--%NELEMS];
	}
}
static char const extra[] = {17, 31, 73, 47, 23};
/* hash: base: null-terminated string input;
          out: caller-owned 16-byte unterminated string output */
void
hash(char const *in, char *out)
{
	int p=0, s=0, n=0;
	for (int i=0; i < sizeof(buf)/sizeof(*buf); ++i) {
		buf[i] = i;
	}
	for (int i=0; in && *in && i < 64; ++i) {
		char const *pos = in;
		do {
			n = *pos;
			if (n) rev(p, (p+n-1)%NELEMS);
			p += n + (s++);
			p %= NELEMS;
		} while (*(++pos));
		for (int j = 0; j < sizeof(extra)/sizeof(*extra); ++j) {
			n = extra[j];
			if (n) rev(p, (p+n-1)%NELEMS);
			p += n + (s++);
			p %= NELEMS;
		}
	}
	for (int i=0; i < 16; ++i) {
		for (int j=1; j < 16; ++j) {
			buf[16*i] ^= buf[16*i + j];
		}
		out[i] = buf[16*i];
	}
}
