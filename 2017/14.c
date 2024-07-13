#include <stdio.h>
#include <stdint.h>
void hash(char const *, char *);

static int
popc(uint32_t n)
{
	int i = 0;
	while (n) { n &= n-1; ++i; }
	return i;
}

static char grid[128][128];

static void
clear_dfs(int i)
{
	int r = i/128;
	int c = i%128;
	grid[r][c] = 0;
	if (r-1 >=   0 && grid[r-1][c  ]) clear_dfs(128*(r-1)+c  );
	if (c-1 >=   0 && grid[r  ][c-1]) clear_dfs(128* r   +c-1);
	if (r+1 <  128 && grid[r+1][c  ]) clear_dfs(128*(r+1)+c  );
	if (c+1 <  128 && grid[r  ][c+1]) clear_dfs(128* r   +c+1);
}

static int
peel_scc(void)
{
	int i = 0;
	int n = 0;
	for (i = 0; i < 128*128; ++i) if (grid[i/128][i%128]) break;
	while (i != 128*128) {
		++n;
		clear_dfs(i);
		for (i = 0; i < 128*128; ++i)
			if (grid[i/128][i%128]) break;
	}
	return n;
}

#include <string.h>
int
main(void)
{
	unsigned char out[16];
	char buf[32];
	int n = 0;
	for (int i = 0; i < 128; ++i) {
		sprintf(buf,"hwlqcszp-%d",i);
		hash(buf,(char *)out);
		for (int j = 0; j < sizeof(out)/sizeof(*out); ++j) {
			n += popc(out[j]);
			for (int k = 7; k >= 0; --k) {
				grid[i][8*j + k] = out[j]%2;
				out[j] /= 2;
			}
		}
	}
	printf("%d\t%d\n",n,peel_scc()); // not 30 nor 23
	return 0;
}
