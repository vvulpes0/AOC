import sys
def f(s,n):
    if len(s) < n:
        raise ValueError()
    if n == 0:
        return ''
    if n == 1:
        return max(s)
    top = max(s[:-(n-1)])
    return top + f(s[s.index(top) + 1:], n - 1)
def main():
    a = 0
    b = 0
    for line in sys.stdin:
        line=line.strip()
        tens=max(line[:-1])
        ones=max(line[line.index(tens) + 1:])
        value = int(tens + ones)
        a = a + value
        b = b + int(f(line, 12))
    print(a, b, sep='\t')
if __name__ == '__main__':
    main()
