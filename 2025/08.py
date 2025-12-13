import math
import sys
def sqdist(p,q):
    return sum(map(lambda x,y: (x - y)**2, p, q))
def parent(x, homes):
    p = x
    while homes[p] != p:
        p = homes[p]
    while x != p:
        x, homes[x] = homes[x], p
    return x
def main():
    junctions = [tuple([int(x) for x in p.split(',')]) for p in sys.stdin]
    n = len(junctions)
    pairs = sorted(
        [(i,j) for i in range(n) for j in range(i + 1, n)],
        key=(lambda p: sqdist(junctions[p[0]], junctions[p[1]]))
    )
    homes = [i for i in range(n)]
    sizes = [1]*n
    a = b = 0
    todo = 1000
    for connected,ij in enumerate(pairs):
        i,j = ij
        pi = parent(i, homes)
        pj = parent(j, homes)
        if pi != pj:
            sizes[pi] = sizes[pj] = sizes[pi] + sizes[pj]
            homes[pi] = homes[pj] = pj if sizes[pi] < sizes[pj] else pi
            if sizes[pi] == n:
                b = junctions[i][0] * junctions[j][0]
        circuits = [i for i in range(n) if homes[i] == i]
        if connected == todo - 1:
            vs = [sizes[i] for i in range(n) if homes[i] == i]
            vs.sort(reverse=True)
            a = math.prod(vs[:3])
        if a != 0 and b != 0:
            break
    print(a, b, sep='\t')
if __name__ == '__main__':
    main()
