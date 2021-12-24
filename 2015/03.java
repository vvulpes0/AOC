import java.util.Scanner;
import java.util.TreeSet;

class AoC03 {
	public static void main(String args[]) {
		Scanner scanner = new Scanner(System.in);
		char s[] = scanner.nextLine().toCharArray();
		TreeSet<Pair> m = new TreeSet<Pair>();
		TreeSet<Pair> n = new TreeSet<Pair>();
		Pair p = new Pair(0,0);
		Pair q = new Pair(0,0);
		Pair r = new Pair(0,0);
		boolean a = true;
		m.add(p);
		n.add(p);
		for (char x : s) {
			p = update(p,x);
			m.add(p);
			if (a) { q = update(q,x); n.add(q); }
			else   { r = update(r,x); n.add(r); }
			a = !a;
		}
		System.out.printf("%d\t%d\n",m.size(),n.size());
	}

	static Pair update (Pair p, char x) {
		Pair t = new Pair(p.a, p.b);
		switch (x) {
		case '<': t.a -= 1; break;
		case '>': t.a += 1; break;
		case '^': t.b += 1; break;
		case 'v': t.b -= 1; break;
		default:  break;
		}
		return t;
	}
}

class Pair implements Comparable<Pair> {
	public int a;
	public int b;
	public Pair(int x, int y) {
		a = x;
		b = y;
	}
	public int compareTo(Pair x) {
		if (a < x.a) {return -1;}
		if (a > x.a) {return  1;}
		if (b < x.b) {return -1;}
		if (b > x.b) {return  1;}
		return 0;
	}
}
