#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#define SIZE 100

struct Fn {
	struct Fn * tail;
	int depth;
	int value;
};

static struct Fn * readFn(void);
static struct Fn * add(struct Fn *, struct Fn *);
static _Bool explode(struct Fn *);
static _Bool split(struct Fn *);
static void freeFn(struct Fn *);
static void printfn(struct Fn const);
static long magnitude(struct Fn const *);

int
main(void)
{
	struct Fn * a[SIZE];
	struct Fn * b = NULL;
	struct Fn * t;
	struct Fn * x;
	struct Fn * y;
	long m = 0;
	long n = 0;
	int i;
	int j;

	for (i = 0; i < SIZE; ++i)
	{
		a[i] = readFn();
	}
	for (i = 0; i < SIZE; ++i)
	{
		for (j = 0; j < SIZE; ++j)
		{
			if (i == j) { continue; }
			t = add(a[i],a[j]);
			n = magnitude(t);
			freeFn(t);
			t = x = y = NULL;
			m = (m > n) ? m : n;
		}
	}
	b = a[0];
	for (i = 1; i < SIZE; ++i)
	{
		b = add(b,a[i]);
		freeFn(a[i]);
	}
	printf("%ld\t%ld\n",magnitude(b),m);
	return 0;
}

long
magnitude(struct Fn const * n)
{
	long s[16];
	long d[16];
	int i;
	int j = 0;
	int k;
	int m = 0;
	if (!n) { return 0; }
	while (n)
	{
		assert(j<16);
		d[j] = n->depth;
		m = (d[j] > m) ? d[j] : m;
		s[j++] = n->value;
		n = n->tail;
	}
	i = 0;
	while (j - 1)
	{
		for (; i < j && d[i] != m; ++i) {;}
		if (i == j) { --m; i = 0; continue; }
		s[i] = 3 * s[i] + 2 * s[i + 1];
		--(d[i]);
		--j;
		for (k = i + 1; k < j; ++k)
		{
			s[k] = s[k + 1];
			d[k] = d[k + 1];
		}
	}
	return s[0];
}

struct Fn *
add(struct Fn * a, struct Fn * b)
{
	struct Fn *t = NULL;
	struct Fn *q = NULL;
	struct Fn **p = &t;
	int x = !!(a && b);
	while (a)
	{
		(*p) = malloc(sizeof(**p));
		(*p)->depth = a->depth + x;
		(*p)->value = a->value;
		(*p)->tail = NULL;
		q = (*p);
		p = &(q->tail);
		a = a->tail;
	}
	while (b)
	{
		(*p) = malloc(sizeof(**p));
		(*p)->depth = b->depth + x;
		(*p)->value = b->value;
		(*p)->tail = NULL;
		q = (*p);
		p = &(q->tail);
		b = b->tail;
	}
	while (explode(t));
	return t;
}

_Bool
explode(struct Fn * n)
{
	struct Fn * o = n;
	struct Fn * t;
	struct Fn * p = NULL;
	while (n)
	{
		while (n && n->depth < 4) { p = n; n = n->tail; }
		if (!n) { break; }
		/* we're at the left element of a pair to explode */
		assert(n->tail);
		if (p) { p->value += n->value; }
		t = n->tail;
		if (t->tail) { t->tail->value += n->tail->value; }
		n->tail = t->tail;
		--(n->depth);
		n->value = 0;
		free(t);
		p = n;
		n = n->tail;
	}
	return split(o);
}

_Bool
split(struct Fn * n)
{
	struct Fn * t;
	while (n && n->value < 10) { n = n->tail; }
	if (!n) { return 0; }
	/* we're at a regular number and need to split it */
	++(n->depth);
	t = malloc(sizeof(*t));
	t->tail = n->tail;
	t->depth = n->depth;
	t->value = n->value;
	n->value >>= 1;
	t->value -= n->value;
	n->tail = t;
	return 1;
}

struct Fn *
readFn(void)
{
	struct Fn *n = malloc(sizeof(*n));
	struct Fn *t;
	struct Fn **p = &n;
	n->tail = 0;
	n->depth = n->value = 0;
	int c;
	int d = -1;
	while (EOF != (c = getchar()))
	{
		if (']' == c) {
			assert(d>=0);
			if (!d) { break; }
			--d;
		}
		if ('[' == c) { ++d; continue; }
		if (',' == c)
		{
			(*p)->tail = malloc(sizeof(**p));
			p = &((*p)->tail);
			(*p)->tail = NULL;
			(*p)->value = 0;
			(*p)->depth = d;
		}
		if ('0' <= c && c <= '9')
		{
			assert(*p);
			(*p)->value *= 10;
			(*p)->value += c - '0';
			(*p)->depth = d;
		}
	}
	if (c == EOF) {
		while (n)
		{
			t = n->tail;
			free(n);
			n = t;
		}
		return NULL;
	}
	return n;
}

void
freeFn(struct Fn * n)
{
	struct Fn * t = NULL;
	while (n)
	{
		t = n->tail;
		free(n);
		n = t;
	}
}

void
printfn(struct Fn const n)
{
	struct Fn const * x = &n;
	while (x) { printf("%3d",x->value); x = x->tail; }
	printf("\n");
	x = &n;
	while (x) { printf("%3d",x->depth); x = x->tail; }
	printf("\n\n");
}
