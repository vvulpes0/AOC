import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Scanner;
class Day12 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		ArrayList<String> map = new ArrayList<String>();
		while (in.hasNextLine()) map.add(in.nextLine());
		in.close();
		Partition<Vec2> regions = new Partition<Vec2>();
		int rows = map.size();
		int cols = map.get(0).length();
		for (int i = 0; i < rows; i++) {
			for (int j = 0; j < cols; j++) {
				Vec2 p = new Vec2(j,i);
				regions.add(p);
				if (i > 0 && map.get(i).charAt(j) == map.get(i-1).charAt(j)) {
					regions.union(new Vec2(j, i-1), p);
				}
				if (j > 0 && map.get(i).charAt(j) == map.get(i).charAt(j-1)) {
					regions.union(new Vec2(j-1, i), p);
				}
			}
		}
		HashMap<Vec2,Integer> areas = new HashMap<Vec2,Integer>();
		HashMap<Vec2,Integer> peris = new HashMap<Vec2,Integer>();
		HashMap<Vec2,Integer> sides = new HashMap<Vec2,Integer>();
		for (int i = 0; i < rows; i++) {
			for (int j = 0; j < cols; j++) {
				Vec2 p = new Vec2(j,i);
				Vec2 parent = regions.get(p);
				augment(areas, parent, 1);
				augment(peris, parent, peri(regions, p, rows, cols));
				augment(sides, parent, side(regions, p, rows, cols));
			}
		}
		int partA = 0;
		int partB = 0;
		Iterator<Vec2> ps = areas.keySet().iterator();
		while (ps.hasNext()) {
			Vec2 p = ps.next();
			partA += areas.get(p) * peris.get(p);
			partB += areas.get(p) * sides.get(p);
		}
		System.out.println(partA + "\t" + partB);
	}
	static int peri(Partition<Vec2> regions, Vec2 p, int rows, int cols) {
		Vec2 parent = regions.get(p);
		Vec2 up    = new Vec2( 0,-1);
		Vec2 down  = new Vec2( 0, 1);
		Vec2 left  = new Vec2(-1, 0);
		Vec2 right = new Vec2( 1, 0);
		int out = 4;
		if (p.y > 0 && regions.get(p.add(up)).equals(parent)) out--;
		if (p.y < rows - 1 && regions.get(p.add(down)).equals(parent)) out--;
		if (p.x > 0 && regions.get(p.add(left)).equals(parent)) out--;
		if (p.x < cols - 1 && regions.get(p.add(right)).equals(parent)) out--;
		return out;
	}
	static int side(Partition<Vec2> regions, Vec2 p, int rows, int cols) {
		Vec2 up    = new Vec2( 0,-1);
		Vec2 down  = new Vec2( 0, 1);
		Vec2 left  = new Vec2(-1, 0);
		Vec2 right = new Vec2( 1, 0);
		int out = 0;
		if (contributesSide(regions, p, up, rows, cols)) out++;
		if (contributesSide(regions, p, down, rows, cols)) out++;
		if (contributesSide(regions, p, left, rows, cols)) out++;
		if (contributesSide(regions, p, right, rows, cols)) out++;
		return out;
	}
	static boolean inRange(Vec2 p, int rows, int cols) {
		return p.x >= 0 && p.x < cols && p.y >= 0 && p.y < rows;
	}
	static boolean hasSide(Partition<Vec2> regions, Vec2 p, Vec2 d, int rows, int cols) {
		if (!inRange(p, rows, cols)) return false;
		Vec2 x = regions.get(p);
		if (inRange(p.add(d), rows, cols)
		    && regions.get(p.add(d)).equals(x))
			return false;
		return true;
	}
	static boolean contributesSide(Partition<Vec2> regions, Vec2 p, Vec2 d, int rows, int cols) {
		if (!hasSide(regions, p, d, rows, cols)) return false;
		Vec2 x = regions.get(p);
		Vec2 dd = new Vec2(d.x == 0 ? -1 : 0, d.y == 0 ? -1 : 0);
		if (inRange(p.add(dd), rows, cols)
		    && !regions.get(p.add(dd)).equals(x))
			return true;
		return !hasSide(regions, p.add(dd), d, rows, cols);
	}
	static void augment(HashMap<Vec2,Integer> m, Vec2 k, Integer a) {
		m.compute(k, (_k,v) -> v == null ? a : v + a);
	}
	static class Partition<E> {
		private HashMap<E,E> parents;
		Partition() { this.parents = new HashMap<E,E>(); }
		boolean add(E e) {
			if (parents.containsKey(e)) return false;
			parents.put(e,e);
			return true;
		}
		void clear() { parents.clear(); }
		boolean isEmpty() { return parents.isEmpty(); }
		E get(E e) {
			E p = parents.get(e);
			if (p == null || p == e) return p;
			parents.put(e,get(p));
			return parents.get(e);
		}
		boolean union(E x, E y) {
			add(x);
			add(y);
			if (get(x) == get(y)) return false;
			parents.put(get(y),get(x));
			return true;
		}
	}
	private static class Vec2
		implements Comparable<Vec2> {
		public final int x;
		public final int y;
		Vec2() { this.x = 0; this.y = 0; }
		Vec2(int x, int y) { this.x = x; this.y = y; }
		public Vec2 add(Vec2 d) {
			return new Vec2(this.x+d.x,this.y+d.y);
		}
		public Vec2 rotate() {
			return new Vec2(-this.y, this.x);
		}
		@Override
		public int compareTo(Vec2 b) {
			if (this.x != b.x) { return this.x - b.x; }
			return this.y - b.y;
		}
		@Override
		public boolean equals(Object b) {
			if (getClass() != b.getClass()) return false;
			Vec2 bv2 = (Vec2)b;
			return this.compareTo(bv2) == 0;
		}
		@Override
		public int hashCode() {
			return this.x ^ (this.y * 0xdeadbeef);
		}
		@Override
		public String toString() {
			return "<" + this.x + "," + this.y + ">";
		}
	}
}
