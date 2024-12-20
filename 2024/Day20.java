import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;
class Day20 {
	static int h = 0;
	static int w = 0;
	static final int save = 100;
	public static void main(String[] args) {
		ArrayList<Boolean> map = new ArrayList<Boolean>();
		Scanner in = new Scanner(System.in);
		int start = 0;
		int end = 0;
		int row = 0;
		while (in.hasNextLine()) {
			String s = in.nextLine();
			w = s.length();
			for (int i = 0; i < w; i++) {
				char c = s.charAt(i);
				map.add(c == '#');
				if (c == 'S') start = v(i,row);
				if (c == 'E') end = v(i,row);
			}
			row++;
		}
		Graph g = new Graph();
		h = row;
		/* one pass to make the vertices */
		for (int i = 0; i < h; i++) {
			for (int j = 0; j < w; j++) {
				g.addVertex();
			}
		}
		/* another to make connections */
		for (int i = 0; i < h; i++) {
			for (int j = 0; j < w; j++) {
				if (map.get(v(j,i))) continue;
				int v1 = v(j,i);
				if (i > 0 && !map.get(v(j, i - 1))) {
					g.addEdge(v1, v(j, i - 1));
				}
				if (i + 1 < h && !map.get(v(j, i + 1))) {
					g.addEdge(v1, v(j, i + 1));
				}
				if (j > 0 && !map.get(v(j - 1, i))) {
					g.addEdge(v1, v(j - 1, i));
				}
				if (j + 1 < w && !map.get(v(j + 1, i))) {
					g.addEdge(v1, v(j + 1, i));
				}
			}
		}
		List<Integer> ds = g.distances(start);
		System.out.println(go(map,ds,2) + "\t" + go(map,ds,20));
	}
	private static int go(List<Boolean> map, List<Integer> ds, int radius) {
		HashSet<Vec2> out = new HashSet<Vec2>();
		for (int i = 0; i < h; i++) {
			for (int j = 0; j < w; j++) {
				int v1 = v(j,i);
				if (map.get(v1)) continue;
				if (ds.get(v1) == null) continue;
				for (int y = -radius; y <= radius; y++) {
					for (int x = -radius; x <= radius; x++) {
						if (Math.abs(x) + Math.abs(y) > radius) continue;
						if (mget(map,j+x,i+y)) continue;
						int v2 = v(j+x,i+y);
						if (ds.get(v2) == null) continue;
						if (ds.get(v1) - ds.get(v2) < save + Math.abs(x) + Math.abs(y)) continue;
						out.add(new Vec2(v1,v2));
					}
				}
			}
		}
		return out.size();
	}
	private static boolean mget(List<Boolean> map, int x, int y) {
		if (x < 0 || x >= w || y < 0 || y >= h) return true;
		return map.get(v(x,y));
	}
	private static int v(int x, int y) { return y*w + x; }
	private static class Graph {
		ArrayList<HashSet<Integer>> edges;
		Graph() {
			edges = new ArrayList<HashSet<Integer>>();
		}
		int addVertex() {
			edges.add(new HashSet<Integer>());
			return edges.size() - 1;
		}
		boolean addEdge(int x, int y) {
			boolean b = edges.get(x).contains(y);
			edges.get(x).add(y);
			return !b;
		}
		List<Integer> distances(int source) {
			ArrayList<Integer> ds = new ArrayList<Integer>();
			ArrayDeque<Integer> q = new ArrayDeque<Integer>();
			for (int i = 0; i < edges.size(); i++) {
				ds.add(null);
			}
			ds.set(source,0);
			q.add(source);
			while (!q.isEmpty()) {
				int p = q.poll();
				Iterator<Integer> is = edges.get(p).iterator();
				while (is.hasNext()) {
					int r = is.next();
					if (ds.get(r) == null) {
						ds.set(r,ds.get(p) + 1);
						q.add(r);
					}
				}
			}
			return ds;
		}
	}
	private static class Vec2
		implements Comparable<Vec2> {
		public final int x;
		public final int y;
		Vec2() { x = 0; y = 0; }
		Vec2(int x, int y) { this.x = x; this.y = y; }
		public Vec2 add(Vec2 d) {
			return new Vec2(this.x+d.x,this.y+d.y);
		}
		public Vec2 add(char c) {
			int dx = (c=='>'?1:0) - (c=='<'?1:0);
			int dy = (c=='v'?1:0) - (c=='^'?1:0);
			return add(new Vec2(dx,dy));
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
			return "<" + x + "," + y + ">";
		}
	}
}
