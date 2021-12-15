#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

#define MIN(a,b) (((a) < (b)) ? (a) : (b))
#define EXPANSION 5
#define SIZE 100

static unsigned short p[EXPANSION * SIZE][EXPANSION * SIZE];

static _Bool update_risks(unsigned short * const * const,
                          int const, int const);

int
main(void)
{
	div_t m;
	div_t n;
	unsigned short **risk = NULL;
	int c;
	int i = 0;
	int j = 0;
	int w = 0;
	int h = 0;
	h = 0;
	while ((c = getchar()) != EOF)
	{
		if ('0' <= c && c <= '9') {
			p[i][j] = c - '0';
			++j;
			h = 1;
			continue;
		}
		/* account for \r\n line endings */
		if (!h) { continue; }
		w = j;
		++i;
		j = h = 0;
	}
	/* account for files that don't end in newline */
	h += i;
	risk = malloc(EXPANSION * h * sizeof(*risk));

	/* Part 1 */
	for (i=0; i < EXPANSION * h; ++i)
	{
		risk[i] = malloc(EXPANSION * w * sizeof(**risk));
		for (j=0; j < EXPANSION * w; ++j)
		{
			risk[i][j] = SHRT_MAX;
		}
	}
	risk[h-1][w-1] = p[h-1][w-1];
	while (update_risks(risk, w, h)) {;}
	printf("%d\t",risk[0][0] - p[0][0]);

	/* Expand map */
	for (i = 0; i < EXPANSION * h; ++i)
	{
		m = div(i,h);
		for (j = 0; j < EXPANSION * w; ++j)
		{
			n = div(j,w);
			p[i][j] = p[m.rem][n.rem] + m.quot + n.quot - 1;
			p[i][j] %= 9;
			p[i][j] += 1;
		}
	}

	/* Part 2 */
	for (i = 0; i < h; ++i)
	{
		for (j = 0; j < w; ++j)
		{
			risk[i][j] = SHRT_MAX;
		}
	}
	h *= EXPANSION;
	w *= EXPANSION;
	risk[h-1][w-1] = p[h-1][w-1];
	while (update_risks(risk, w, h)) {;}
	printf("%d\n",risk[0][0] - p[0][0]);

	/* cleanup */
	for (i = 0; i < h; ++i)
	{
		free(risk[i]);
		risk[i] = NULL;
	}
	free(risk);
	return 0;
}

_Bool
update_risks(unsigned short * const * const r, int const w, int const h)
{
	int i;
	int j;
	int n;
	_Bool c = 0;
	for (i = h - 1; i >= 0; --i)
	{
		for (j = w - 1 - (i == h - 1); j >= 0; --j)
		{
			n = (j > 0) ? r[i][j-1] : SHRT_MAX;
			if (i > 0) { n = MIN(n,r[i-1][j]); }
			if (j < w - 1) { n = MIN(n,r[i][j+1]); }
			if (i < h - 1) { n = MIN(n,r[i+1][j]); }
			n += p[i][j];
			c |= (r[i][j] != n);
			r[i][j] = n;
		}
	}
	return c;
}
