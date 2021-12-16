#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

struct Packet
{
	struct PacketList * packets;
	long value;
	char version;
	char type;
};
struct PacketList
{
	struct PacketList * tail;
	struct Packet head;
};

long sum(struct PacketList const *);
long product(struct PacketList const *);
long minimum(struct PacketList const *);
long maximum(struct PacketList const *);
long greater(struct PacketList const *);
long lesser(struct PacketList const *);
long equal(struct PacketList const *);
struct Packet parse_packet(int *, int *, int *);
int getbit(int *, int *, int *);
long read_literal(int *, int *, int *);
long read_operator(int *, int *, int *, char, struct PacketList **);
void free_packets(struct PacketList *);
int sum_versions(struct Packet const);

int
main(void)
{
	struct Packet p;
	int u = 0;
	int c = 0;
	int i;
	p = parse_packet(&u, &c, NULL);
	printf("%d\t%ld\n", sum_versions(p), p.value);
	free_packets(p.packets);
	return 0;
}

int
sum_versions(struct Packet const p)
{
	int a = p.version;
	struct PacketList * x = p.packets;
	while (x)
	{
		a += sum_versions(x->head);
		x = x->tail;
	}
	return a;
}

struct Packet
parse_packet(int *u, int *c, int *d)
{
	struct Packet p;
	int a = 0;
	int i;
	_Bool b;
	p.packets = NULL;
	p.value = 0;
	p.version = 0;
	p.type = 0;
	if (!u || !c) { return p; }
	for (i = 0; i < 3; ++i)
	{
		a <<= 1;
		a |= getbit(u, c, d);
	}
	p.version = a;
	a = 0;
	for (i = 0; i < 3; ++i)
	{
		a <<= 1;
		a |= getbit(u, c, d);
	}
	p.type = a;
	switch (p.type)
	{
	case 4:
		p.value = read_literal(u, c, d);
		break;
	default:
		p.value = read_operator(u, c, d, p.type, &(p.packets));
	}
	return p;
}

long
read_literal(int *u, int *c, int *d)
{
	long a = 0;
	int i;
	_Bool b;
	b = getbit(u, c, d);
	while (b)
	{
		for (i = 0; i < 4; ++i)
		{
			a <<= 1;
			a |= getbit(u, c, d);
		}
		b = getbit(u, c, d);
	}
	for (i = 0; i < 4; ++i)
	{
		a <<= 1;
		a |= getbit(u, c, d);
	}
	return a;
}

long
read_operator(int *u, int *c, int *d, char t, struct PacketList **p)
{
	struct PacketList **q;
	long a = 0;
	int n = 0;
	int i;
	int e = 0;
	_Bool b = getbit(u, c, d);
	if (!p) { return -1; }
	q = p;
	while (*p)
	{
		p = &((*p)->tail);
	}
	if (b)
	{
		for (i = 0; i < 11; ++i)
		{
			n <<= 1;
			n |= getbit(u, c, d);
		}
		for (i = 0; i < n; ++i)
		{
			*p = malloc(sizeof(**p));
			(*p)->tail = NULL;
			(*p)->head = parse_packet(u, c, d);
			p = &((*p)->tail);
		}
	}
	else
	{
		for (i = 0; i < 15; ++i)
		{
			n <<= 1;
			n |= getbit(u, c, d);
		}
		while (e < n)
		{
			*p = malloc(sizeof(**p));
			(*p)->tail = NULL;
			(*p)->head = parse_packet(u, c, &e);
			p = &((*p)->tail);
		}
		if (d) { *d += e; }
	}
	switch (t)
	{
	case 0:
		return sum(*q);
	case 1:
		return product(*q);
	case 2:
		return minimum(*q);
	case 3:
		return maximum(*q);
	case 5:
		return greater(*q);
	case 6:
		return lesser(*q);
	case 7:
		return equal(*q);
	}
	return a;
}

int
getbit(int *u, int *c, int *d)
{
	if (!u || !c) { return -1; }
	if (d) { ++(*d); }
	if (*u == 0)
	{
		*c = getchar();
		if ('0' <= *c && *c <= '9')
		{
			*c -= '0';
		}
		else if ('A' <= *c && *c <= 'F')
		{
			*c -= 'A';
			*c += 10;
		}
		*u = 4;
	}
	if (EOF == *c) { return -1; }
	--(*u);
	return ((*c) >> (*u)) & 1;
}

long
sum(struct PacketList const * p)
{
	long a = 0;
	while (p)
	{
		a += (p->head).value;
		p = p->tail;
	}
	return a;
}

long
product(struct PacketList const * p)
{
	long a = 1;
	while (p)
	{
		a *= (p->head).value;
		p = p->tail;
	}
	return a;
}

long
minimum(struct PacketList const * p)
{
	long a = LONG_MAX;
	long b;
	while (p)
	{
		b = (p->head).value;
		a = (a < b) ? a : b;
		p = p->tail;
	}
	return a;
}

long
maximum(struct PacketList const * p)
{
	long a = LONG_MIN;
	long b;
	while (p)
	{
		b = (p->head).value;
		a = (a > b) ? a : b;
		p = p->tail;
	}
	return a;
}

long
greater(struct PacketList const * p)
{
	long a = 0;
	long b = 0;
	while (p)
	{
		a = b;
		b = (p->head).value;
		p = p->tail;
	}
	return a > b;
}

long
lesser(struct PacketList const * p)
{
	long a = 0;
	long b = 0;
	while (p)
	{
		a = b;
		b = (p->head).value;
		p = p->tail;
	}
	return a < b;
}

long
equal(struct PacketList const * p)
{
	long a = 0;
	long b = 0;
	while (p)
	{
		a = b;
		b = (p->head).value;
		p = p->tail;
	}
	return a == b;
}

void
free_packets(struct PacketList * p)
{
	struct PacketList * q;
	while (p)
	{
		q = p->tail;
		free_packets((p->head).packets);
		(p->head).packets = NULL;
		free(p);
		p = q;
	}
}
