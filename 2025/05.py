import sys
def insert(new, ranges):
    i = 0
    while i < len(ranges):
        r = ranges[i]
        if r.stop <= new.start or r.start >= new.stop:
            i += 1
        elif r.start >= new.start:
            if new.stop < r.stop:
                ranges[i] = range(new.stop, r.stop)
                i += 1
            else:
                ranges[i] = ranges.pop()
        elif r.stop <= new.stop:
            if r.start <= new.start:
                ranges[i] = range(r.start, new.start)
                i += 1
            else:
                ranges[i] = ranges.pop()
        else:
            return
    ranges.append(new)

if __name__ == '__main__':
    a = b = 0
    ranges = []
    for line in sys.stdin:
        line = line.strip()
        if not line: break
        lo, hi = [int(x) for x in line.split('-')]
        insert(range(lo, hi + 1), ranges)
    for line in sys.stdin:
        x = int(line)
        a += 1 if any(x in r for r in ranges) else 0
    b += sum(len(r) for r in ranges)
    print(a, b, sep='\t')
