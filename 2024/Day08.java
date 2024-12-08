import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Scanner;
class Day08 {
	public static void main(String[] args) {
		Roof r = Roof.read(System.in);
		int partA = r.countAntinodes();
		int partB = r.countBntinodes();
		System.out.println(partA + "\t" + partB);
	}
	static class Vec2
		implements Comparable<Vec2> {
		public final int x;
		public final int y;
		Vec2() { x = 0; y = 0; }
		Vec2(int x, int y) { this.x = x; this.y = y; }
		public Vec2 add(Vec2 b) {
			return new Vec2(x + b.x, y + b.y);
		}
		public Vec2 subtract(Vec2 b) {
			return new Vec2(x - b.x, y - b.y);
		}
		public Vec2 scale(int k) {
			return new Vec2(k*x, k*y);
		}
		public Vec2 negate() { return scale(-1); }
		@Override public int compareTo(Vec2 v) {
			if (x != v.x) return x - v.x;
			return y - v.y;
		}
		@Override public boolean equals(Object o) {
			if (getClass() != o.getClass()) return false;
			return compareTo((Vec2)o) == 0;
		}
		@Override public int hashCode() {
			return x ^ y ^ 0xdeadbeef;
		}
	}
	private static class Roof {
		private HashMap<Character,ArrayList<Vec2>> map;
		private int xsize;
		private int ysize;
		Roof() {
			map = new HashMap<Character,ArrayList<Vec2>>();
			xsize = 0;
			ysize = 0;
		}
		public static Roof read(InputStream instream) {
			Scanner in = new Scanner(instream);
			Roof out = new Roof();
			ArrayList<Vec2> a;
			while (in.hasNextLine()) {
				String s = in.nextLine();
				out.xsize = Math.max(out.xsize,s.length());
				for (int i = 0; i < s.length(); i++) {
					char c = s.charAt(i);
					if (c == '.') continue;
					a = out.map.get(c);
					if (a == null) {
						a = new ArrayList<Vec2>();
					}
					a.add(new Vec2(i,out.ysize));
					out.map.put(c,a);
				}
				out.ysize++;
			}
			in.close();
			return out;
		}
		private boolean good(Vec2 p) {
			return p.x >= 0 && p.x < xsize
				&& p.y >= 0 && p.y < ysize;
		}
		public int countAntinodes() {
			Iterator<Character> types = map.keySet().iterator();
			HashSet<Vec2> out = new HashSet<Vec2>();
			while (types.hasNext()) {
				ArrayList<Vec2> antennae = map.get(types.next());
				for (int i = 0; i < antennae.size(); i++) {
					Vec2 a = antennae.get(i);
					for (int j = i + 1; j < antennae.size(); j++) {
						Vec2 b = antennae.get(j);
						Vec2 d = b.subtract(a);
						Vec2 p = a.subtract(d);
						if (good(p)) {
							out.add(p);
						}
						p = b.add(d);
						if (good(p)) {
							out.add(p);
						}
					}
				}
			}
			return out.size();
		}
		public int countBntinodes() {
			Iterator<Character> types = map.keySet().iterator();
			HashSet<Vec2> out = new HashSet<Vec2>();
			int m = Math.max(xsize, ysize);
			while (types.hasNext()) {
				ArrayList<Vec2> antennae = map.get(types.next());
				for (int i = 0; i < antennae.size(); i++) {
					Vec2 a = antennae.get(i);
					for (int j = i + 1; j < antennae.size(); j++) {
						Vec2 b = antennae.get(j);
						Vec2 d = b.subtract(a);
						for (int k = -m; k <= m; k++) {
							Vec2 p = a.add(d.scale(k));
							if (good(p)) {
								out.add(p);
							}
						}
					}
				}
			}
			return out.size();
		}
	}
}
