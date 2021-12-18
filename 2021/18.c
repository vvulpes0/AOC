#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#define SIZE 100

struct Fn {
	struct Fn * parent;
	struct Fn * left;
	struct Fn * right;
	int value;
};

static struct Fn * readFn(void);
static struct Fn * copy(struct Fn const * const);
static struct Fn * add(struct Fn *, struct Fn *);
static _Bool explode(struct Fn *, int);
static _Bool split(struct Fn *);
static void reduce(struct Fn *);
static void freeFn(struct Fn *);
static void printfn(struct Fn const);
static long magnitude(struct Fn const * const);

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
			x = copy(a[i]);
			y = copy(a[j]);
			t = add(x,y);
			n = magnitude(t);
			freeFn(t);
			t = x = y = NULL;
			m = (m > n) ? m : n;
		}
	}
	for (i = 0; i < SIZE; ++i)
	{
		b = add(b,a[i]);
	}
	printf("%ld\t%ld\n",magnitude(b),m);
	return 0;
}

long
magnitude(struct Fn const * const n)
{
	if (!n) { return 0; }
	return 3*magnitude(n->left) + 2*magnitude(n->right) + n->value;
}

void
reduce(struct Fn * n)
{
	_Bool b = 1;
	while (b)
	{
		if (explode(n, 0)) { continue; }
		b = split(n);
	}
}

struct Fn *
add(struct Fn * a, struct Fn * b)
{
	struct Fn * n;
	if (!b) {return a;}
	if (!a) {return b;}
	n = malloc(sizeof(*n));
	n->parent = NULL;
	n->value = 0;
	n->left = a;
	a->parent = n;
	n->right = b;
	b->parent = n;
	reduce(n);
	return n;
}

_Bool
explode(struct Fn * n, int d)
{
	struct Fn * p;
	if (!n) { return 0; }
	if (!n->left || !n->right) { return 0; }
	if (d < 4)
	{
		if (explode(n->left, d+1)) {return 1;}
		return explode(n->right, d+1);
	}
	/* exploding */
	/* add leftmost of pair to its nearest left neighbour */
	p = n;
	while (p->parent && p == p->parent->left)
	{
		p = p->parent;
	}
	p = p->parent;
	if (p) { p = p->left; }
	while (p && p->right)
	{
		p = p->right;
	}
	if (p) { p->value += n->left->value; }

	/* add rightmost of pair to its nearest right neighbour */
	p = n;
	while (p->parent && p == p->parent->right)
	{
		p = p->parent;
	}
	p = p->parent;
	if (p) { p = p->right; }
	while (p && p->left)
	{
		p = p->left;
	}
	if (p) { p->value += n->right->value; }

	/* cleanup */
	freeFn(n->left);
	n->left = NULL;
	freeFn(n->right);
	n->right = NULL;
	n->value = 0;
	return 1;
}

_Bool
split(struct Fn * n)
{
	if (!n) { return 0; }
	if (n->left && n->right)
	{
		if (split(n->left)) { return 1; }
		return split(n->right);
	}
	if (n->value < 10) { return 0; }
	n->left = malloc(sizeof(*n));
	n->left->parent = n;
	n->left->left = n->left->right = NULL;
	n->left->value = (n->value) >> 1;
	n->right = malloc(sizeof(*n));
	n->right->parent = n;
	n->right->left = n->right->right = NULL;
	n->right->value = n->value - n->left->value;
	n->value = 0;
	return 1;
}

struct Fn *
readFn(void)
{
	struct Fn *n = malloc(sizeof(*n));
	struct Fn *p = n;
	int c;
	n->parent = n->left = n->right = NULL;
	n->value = 0;
	while (EOF != (c = getchar()))
	{
		if (']' == c) {
			assert(n->parent);
			n = n->parent;
			assert(n->left && n->right);
			if (n == p) {break;}
		}
		if ('[' == c)
		{
			assert(n && n->left == NULL);
			n->left = malloc(sizeof(*n));
			n->left->parent = n;
			n = n->left;
			n->left = n->right = NULL;
			n->value = 0;
		}
		if (',' == c)
		{
			n = n->parent;
			assert(n && n->right == NULL);
			n->right = malloc(sizeof(*n));
			n->right->parent = n;
			n = n->right;
			n->left = n->right = NULL;
			n->value = 0;
		}
		if ('0' <= c && c <= '9')
		{
			n->value *= 10;
			n->value += c - '0';
		}
	}
	if (c == EOF) {free(n); return NULL;}
	return p;
}

void
freeFn(struct Fn * n)
{
	if (!n) { return; }
	freeFn(n->left);
	n->left = NULL;
	freeFn(n->right);
	n->right = NULL;
	free(n);
}

void
printfn(struct Fn const n)
{
	if (!n.left || !n.right) {
		printf("%d",n.value);
		return;
	}
	printf("[");
	printfn(*(n.left));
	printf(",");
	printfn(*(n.right));
	printf("]");
}

struct Fn *
copy(struct Fn const * const n)
{
	struct Fn *a = NULL;
	if (!n) { return NULL; }
	a = malloc(sizeof(*a));
	a->parent = a->left = a->right = NULL;
	a->value = n->value;
	if (n->left)
	{
		a->left = copy(n->left);
		a->left->parent = a;
	}
	if (n->right)
	{
		a->right = copy(n->right);
		a->right->parent = a;
	}
	return a;
}
