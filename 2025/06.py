import math
import sys

def add_digit(n,d):
    return 10*(0 if n is None else n) + int(d) if d in '0123456789' else n
def split(xs,sep=None):
    i = 0
    out = []
    while sep in xs[i:]:
        j = xs.index(sep,i)
        out.append(xs[i:j])
        i = j + 1
    if i < len(xs):
        out.append(xs[i:])
    return out

def main(iterable):
    a = b = 0
    line = next(iterable).strip('\r\n')
    horz = [(int(x), int(x)) for x in line.split()]
    nums = [add_digit(None,c) for c in line]
    for line in iterable:
        if '+' in line or '*' in line:
            break
        line = line.strip('\r\n')
        xs = [int(x) for x in line.split()]
        horz = map(lambda p,x: (p[0]+x,p[1]*x), horz, xs)
        nums[:] = map(add_digit, nums, line)
    horz = iter(horz)
    vert = ((sum(vs), math.prod(vs)) for vs in split(nums))
    for i,op in enumerate(0 if c == '+' else 1 for c in line.split()):
        a += next(horz)[op]
        b += next(vert)[op]
    print(a,b,sep='\t')

if __name__ == '__main__':
    main(sys.stdin)
