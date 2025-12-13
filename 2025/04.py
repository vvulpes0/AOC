import sys

def graph(iterable):
    idx = dict()
    rolls = dict()
    for i,line in enumerate(iterable):
        line = line.strip()
        for j,c in enumerate(line):
            if c == '@':
                roll = len(rolls)
                idx[i,j] = roll
                rolls[roll] = []
                for key in [(i-1,j-1),(i-1,j),(i-1,j+1),(i,j-1)]:
                    if key in idx:
                        other = idx[key]
                        rolls[other].append(roll)
                        rolls[roll].append(other)
    return rolls

def extract(rolls):
    dead = []
    for roll,neighs in rolls.items():
        if len(neighs) < 4:
            dead.append(roll)
    for roll in dead:
        for neigh in rolls[roll]:
            rolls[neigh].remove(roll)
        del rolls[roll]
    return len(dead)

def main():
    rolls = graph(sys.stdin)
    a = b = t = extract(rolls)
    while t != 0:
        t = extract(rolls)
        b += t
    print(a, b, sep='\t')

if __name__ == '__main__':
    main()
