#include <stdio.h>
#include <stdlib.h>
#define NUMP 465
#define LAST 71498
static unsigned long long score[NUMP];
struct IDLL {
	struct IDLL *cw;
	struct IDLL *ccw;
	int value;
};
static struct IDLL *
step (struct IDLL *current, int i, int *rem)
{
	struct IDLL *t;
	int j;
	if (!current) {
		current = malloc(sizeof(*current));
		current->cw = current->ccw = current;
		current->value = i;
		return current;
	}
	if (i % 23) {
		current = current->cw;
		t = malloc(sizeof(*t));
		t->cw = current->cw;
		t->ccw = current;
		t->value = i;
		current->cw = t;
		t->cw->ccw = t;
		return t;
	}
	score[i%NUMP] += i;
	for (j = 0; j < 7; j++) current = current->ccw;
	score[i%NUMP] += current->value;
	if (rem) *rem = current->value;
	t = current->cw;
	t->ccw = current->ccw;
	current->ccw->cw = t;
	free(current);
	return t;
}
int
main(void)
{
	struct IDLL *current = NULL;
	struct IDLL *t = NULL;
	int last_rem = 0;
	int i = 0;
	int j = 0;
	unsigned long a = 0;
	unsigned long b = 0;
	while (i <= LAST) current = step(current,i++,&last_rem);
	for (j = 0; j < NUMP; j++) {
		a = score[j]>a ? score[j] : a;
	}
	while (i <= 100*LAST) current = step(current,i++,&last_rem);
	for (j = 0; j < NUMP; j++) {
		b = score[j]>b ? score[j] : b;
	}
	printf("%lu\t%lu\n",a,b);
	current->ccw->cw = NULL;
	while (current) {
		t = current->cw;
		free(current);
		current = t;
	}
	return 0;
}
