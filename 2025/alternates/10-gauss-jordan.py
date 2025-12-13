from fractions import Fraction
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

def reacha(target, buttons):
    presses = 0
    closed = set()
    opens = {0}
    while target not in opens:
        new = set()
        for n in opens:
            for b in buttons:
                new.add(n^b)
        closed.update(opens)
        opens = new
        opens.difference_update(closed)
        presses += 1
    return presses

def rref(m, dest=0, c=0):
    if c >= len(m[0]) - 1:
        for row in m:
            for i,v in enumerate(row):
                if v.is_integer():
                    row[i] = int(v)
        return
    target = None
    for i in range(dest, len(m)):
        if m[i][c] != 0:
            target = i
            break
    if target is None:
        rref(m, dest, c + 1)
        return
    grabbed = m.pop(target)
    m.insert(dest,grabbed)
    pivot = m[dest][c]
    for i in range(len(m[dest])):
        m[dest][i] /= pivot
    for i in range(len(m)):
        if i == dest or m[i][c] == 0:
            continue
        scale = m[i][c]
        for j in range(len(m[i])):
            m[i][j] -= scale*m[dest][j]
    rref(m, dest + 1, c + 1)

def argmin(xs, r, m, free):
    if None not in xs:
        for row in m:
            if sum(map(lambda x,y: x*y, xs, row[:-1])) != row[-1]:
                return None # invalid
        return sum(xs) # valid
    lo = None
    free = [i for i in free if xs[i] is None]
    if len(free) == 0:
        return None
    j = min(free)
    for i in range(r[j]+1):
        ys = xs[:]
        ys[j] = i
        possible = True
        changed = True
        while changed and possible:
            changed = False
            for row in m:
                vs = row[:-1]
                ix = [i for i,v in enumerate(vs) if v != 0]
                nones = [i for i in ix if ys[i] is None]
                if len(nones) == 1:
                    changed = True
                    v = row[-1]
                    for k in ix:
                        if ys[k] is not None:
                            v -= row[k]*ys[k]
                    v = Fraction(v) / row[nones[0]]
                    if v < 0 or v > r[nones[0]] or not v.is_integer():
                        possible = False
                        break
                    ys[nones[0]] = int(v)
        if possible:
            out = argmin(ys, r, m, free)
            if lo is None or (out is not None and out < lo):
                lo = out
    return lo

def reachb(joltage, buttons):
    cols = len(buttons)
    m = []
    f0,f1 = Fraction(0), Fraction(1)
    ub = [max(joltage)]*len(buttons)
    for i,target in enumerate(joltage):
        for j,b in enumerate(buttons):
            if 2**i & b != 0:
                ub[j] = min(ub[j],target)
        m.append([f1 if 2**i & b != 0 else f0 for b in buttons]+[target])
    rref(m)
    free = []
    i = 0
    for row in m:
        while i < len(row) - 1 and row[i] == 0:
            free.append(i)
            i += 1
        i += 1
    free.extend(range(i,len(m[0]) - 1))

    presses = [None]*(len(m[0]) - 1)
    for row in m:
        vv = row[:-1]
        if all(x == 0 for x in vv):
            continue
        i = vv.index(1)
        vv.pop(i)
        if any(x != 0 for x in vv):
            continue
        presses[i] = row[-1]
    v = argmin(presses, ub, m, free)
    return v

def main():
    a = b = 0
    for i,line in enumerate(sys.stdin):
        target,buttons,joltage = parseline(line)
        a += reacha(target, buttons)
        b += reachb(joltage, buttons)
    print(a, b, sep='\t')
if __name__ == '__main__':
    main()
