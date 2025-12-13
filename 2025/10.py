import sys
def parseline(line):
    parts = line.strip().split()
    buttons = []
    joltage = []
    for p in parts:
        if p[0] == '[':
            target = 0
            for i,x in enumerate(p[1:-1]):
                if x == '#':
                    target += 2**i
        if p[0] == '(':
            b = 0
            for x in p[1:-1].split(','):
                b += 2**int(x)
            buttons.append(b)
        if p[0] == '{':
            for x in p[1:-1].split(','):
                joltage.append(int(x))
    return target,buttons,tuple(joltage)

def sets(buttons,n):
    xs = {0: [0]}
    vs = {0: [(0,)*n]}
    for b in buttons:
        butt = [0 if 2**i & b == 0 else 1 for i in range(n)]
        ks = list(xs)[:]
        for k in ks:
            if k^b not in xs:
                xs[k^b] = []
                vs[k^b] = []
            xs[k^b].extend(x + 1 for x in xs[k])
            vs[k^b].extend(tuple(map(lambda x,y: x+y, v, butt)) for v in vs[k])
    return xs,vs

def reach(bsets, adders, joltage, cache):
    if joltage in cache:
        return cache[joltage]
    if all(x == 0 for x in joltage):
        cache[joltage] = 0
        return 0
    if any(x < 0 for x in joltage):
        return None
    need = sum(2**i for i,x in enumerate(joltage) if x%2 != 0)
    if need not in bsets:
        return None
    presses = bsets[need]
    contributions = adders[need]
    low = None
    for i in range(len(presses)):
        targets = map(lambda x,y: x - y, joltage, contributions[i])
        targets = tuple(map(lambda x: x//2, targets))
        value = reach(bsets, adders, targets, cache)
        if value is not None:
            value = 2*value + presses[i]
            if low is None:
                low = value
            else:
                low = min(low, value)
    cache[joltage] = low
    return low

def main():
    a = b = 0
    for line in sys.stdin:
        target, buttons, joltage = parseline(line)
        bsets,adders = sets(buttons, len(joltage))
        a += min(bsets[target])
        b += reach(bsets, adders, joltage, dict())
    print(a, b, sep='\t')

if __name__ == '__main__':
    main()
