import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;
import java.util.StringJoiner;
class Day17 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		long a = Long.parseLong(in.findInLine("[0-9]+"));
		in.nextLine();
		long b = Long.parseLong(in.findInLine("[0-9]+"));
		in.nextLine();
		long c = Long.parseLong(in.findInLine("[0-9]+"));
		in.nextLine();
		in.nextLine();
		List<Integer> prog = new ArrayList<Integer>();
		in.useDelimiter("[^0-9]+");
		while (in.hasNextInt()) {
			prog.add(in.nextInt());
		}
		Mach m = new Mach(prog, a, b, c);
		System.out.println(m + "\t" + m.makeQuine());
	}
	static class Mach {
		private final long oa;
		private final long ob;
		private final long oc;
		private final List<Integer> prog;
		private long a;
		private long b;
		private long c;
		private int pc;
		private ArrayList<Integer> out;
		Mach(List<Integer> prog, long a, long b, long c) {
			this.a = a;
			oa = a;
			this.b = b;
			ob = b;
			this.c = c;
			oc = c;
			pc = 0;
			out = null;
			this.prog = prog;
		}
		public long makeQuine() {
			for (int i = 0; i < 8; i++) {
				long x = qdfs(i, prog.size() - 1);
				if (x >= 0) return x;
			}
			return -1;
		}
		private long qdfs(long aIn, int p) {
			if (p < 0) return -1;
			if (!run(aIn).get(0).equals(prog.get(p))) return -1;
			if (p == 0) return aIn;
			for (int i = 0; i < 8; i++) {
				long x = qdfs(8*aIn + i, p - 1);
				if (x >= 0) return x;
			}
			return -1;
		}
		public List<Integer> run() { return run(oa); }
		public List<Integer> run(long aIn) {
			a = aIn;
			b = ob;
			c = oc;
			pc = 0;
			out = new ArrayList<Integer>();
			while (pc < prog.size()) {
				++pc;
				switch (prog.get(pc - 1)) {
				case 0:
					a /= ipow(combo());
					break;
				case 1:
					b ^= literal();
					break;
				case 2:
					b = combo()%8;
					break;
				case 3:
					if (a != 0) pc = (int)(literal()) - 1;
					break;
				case 4:
					b = b ^ c;
					break;
				case 5:
					out.add((int)(combo()%8));
					break;
				case 6:
					b = a/ipow(combo());
					break;
				case 7:
					c = a/ipow(combo());
					break;
				}
				++pc;
			}
			return out;
		}
		private long literal() {
			return prog.get(pc);
		}
		private long combo() {
			int x = prog.get(pc);
			if (x == 4) return a;
			if (x == 5) return b;
			if (x == 6) return c;
			return x;
		}
		private static long ipow(long y) {
			long x = 2;
			long t = 1;
			while (y != 0) {
				if (y%2 != 0) t *= x;
				x *= x;
				y /= 2;
			}
			return t;
		}
		@Override
		public String toString() {
			Iterator<Integer> i = run().iterator();
			StringJoiner s = new StringJoiner(",");
			while (i.hasNext()) s.add(i.next().toString());
			return s.toString();
		}
	}
}
