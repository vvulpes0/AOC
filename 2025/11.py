import sys

def paths(to,waypoints,conn):
    counts = dict()
    counts[frozenset()] = {to: 1}
    changed = True
    while changed:
        changed = False
        for source,dests in conn.items():
            if source in waypoints:
                ks = [k for k in counts if source not in k]
                for s in ks:
                    s2 = s | {source}
                    if s2 not in counts:
                        counts[s2] = dict()
                    was = counts[s2].get(source, 0)
                    counts[s2][source] = 0
                    for dest in dests:
                        counts[s2][source] += counts[s].get(dest, 0)
                        counts[s2][source] += counts[s2].get(dest,0)
                    if was != counts[s2][source]:
                        changed = True
            else:
                for s in counts:
                    was = counts[s].get(source, 0)
                    counts[s][source] = 0
                    for dest in dests:
                        counts[s][source] += counts[s].get(dest, 0)
                    if was != counts[s][source]:
                        changed = True
    return counts

def main():
    conn = dict()
    for line in sys.stdin:
        line = line.strip().replace(':','').split()
        conn[line[0]] = line[1:]
    counts = paths('out',frozenset(['dac','fft']),conn)
    a = sum(d.get('you',0) for d in counts.values())
    b = counts[frozenset(['dac','fft'])].get('svr',0)
    print(a,b,sep='\t')

if __name__ == '__main__':
    main()
