#include <stdio.h>

static int update(signed char * const);
static int update_cell(signed char * const, int const, int const);

int
main(void)
{
	int c;
	int i = 0;
	int t;
	int r = 0;
	signed char o[100];
	while ((c = getchar()) != EOF && i < 100)
	{
		if ('0' >= c || c >= '9') { continue; }
		o[i++] = c - '0';
	}
	c = 0;
	for (i = 1; (i <= 100) || (!r); ++i)
	{
		t = update(o);
		if (i <= 100) { c += t; }
		if (t == 100 && !r) { r = i; }
	}
	printf("%d\t%d\n",c,r);
	return 0;
}

int
update(signed char * const o)
{
	int a = 0;
	int i;
	for (i = 0; i < 100; ++i)
	{
		a += update_cell(o, i % 10, i / 10);
	}
	for (i = 0; i < 100; ++i)
	{
		if (o[i] < 0) { o[i] = 0; }
	}
	return a;
}

int
update_cell(signed char * const o, int const x, int const y)
{
	int a = 1;
	int p = 10 * y + x;
	/* Out of Bounds */
	if (x < 0 || x > 9 || y < 0 || y > 9) { return 0; }
	/* Already flashed */
	if (o[p] < 0) { return 0; }
	++(o[p]);
	/* Didn't flash */
	if (o[p] < 10) { return 0; }
	o[p] = -1;
	a += update_cell(o, x-1, y-1);
	a += update_cell(o, x  , y-1);
	a += update_cell(o, x+1, y-1);
	a += update_cell(o, x-1, y  );
	a += update_cell(o, x+1, y  );
	a += update_cell(o, x-1, y+1);
	a += update_cell(o, x  , y+1);
	a += update_cell(o, x+1, y+1);
	return a;
}
