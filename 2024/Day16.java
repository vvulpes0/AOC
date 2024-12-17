import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Scanner;
class Day16 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		ArrayList<String> map = new ArrayList<String>();
		while (in.hasNextLine()) map.add(in.nextLine());
		ArrayList<Vec2> corners = new ArrayList<Vec2>();
		ArrayList<Pair<Vec2,Direction>> nodes
			= new ArrayList<Pair<Vec2,Direction>>();
		Graph g = new Graph();
		int starti = 0;
		int endi = 0;
		for (int r = 0; r < map.size(); r++) {
			for (int c = 0; c < map.get(r).length(); c++) {
				Vec2 p = new Vec2(c, r);
				boolean go = false;
				if (map.get(r).charAt(c) == 'S') {
					starti = nodes.size();
					go = true;
				}
				if (map.get(r).charAt(c) == 'E') {
					endi = nodes.size();
					go = true;
				}
				if (go || isCorner(map, r, c)) {
					corners.add(p);
					nodes.add(new Pair<Vec2,Direction>(p,Direction.RIGHT));
					nodes.add(new Pair<Vec2,Direction>(p,Direction.UP));
					nodes.add(new Pair<Vec2,Direction>(p,Direction.LEFT));
					nodes.add(new Pair<Vec2,Direction>(p,Direction.DOWN));
					g.addVertex();
					g.addVertex();
					g.addVertex();
					g.addVertex();
				}
			}
		}
		for (int i = 0; i < nodes.size(); i++) {
			Pair<Vec2,Direction> q1 = nodes.get(i);
			for (int j = 0; j < nodes.size(); j++) {
				Pair<Vec2,Direction> q2 = nodes.get(j);
				if (!hasDirectPath(map,q1.fst,q2.fst)) {
					continue;
				}
				Direction d = direction(q1.fst,q2.fst);
				if (q1.fst.equals(q2.fst)) {
					g.addEdge(i, j, 1000*q1.snd.nTurns(q2.snd));
				} else {
					int x = Math.abs(q1.fst.x - q2.fst.x) + Math.abs(q1.fst.y - q2.fst.y);
					g.addEdge(i, j, 1000*(d.nTurns(q1.snd) + d.nTurns(q2.snd)) + x);
				}
			}
		}
		int minDist = Collections.min(g.distances(starti).subList(endi, endi+3));
		System.out.println(minDist + "\t"
		                   + g.onPath(corners, starti, endi).size());
	}
	static void addPath(ArrayList<Vec2> corners,
	                    int i, int j,
	                    HashSet<Vec2> out) {
		Vec2 p = corners.get(i/4);
		Vec2 q = corners.get(j/4);
		int dx = q.x>p.x ? 1 : q.x<p.x ? -1 : 0;
		int dy = q.y>p.y ? 1 : q.y<p.y ? -1 : 0;
		out.add(p);
		out.add(q);
		for (int x = p.x, y = p.y;
		     x != q.x || y != q.y;
		     x += dx, y += dy) {
			out.add(new Vec2(x, y));
		}
	}
	static boolean inBounds(List<String> map, Vec2 p) {
		if (p.y < 0 || p.y >= map.size()) return false;
		if (p.x < 0 || p.x >= map.get(p.y).length()) return false;
		return true;
	}
	static Direction direction(Vec2 p, Vec2 q) {
		if ((p.x != q.x) && (p.y != q.y)) return Direction.NONE;
		if (p.x < q.x) return Direction.RIGHT;
		if (p.x > q.x) return Direction.LEFT;
		if (p.y < q.y) return Direction.DOWN;
		if (p.y > q.y) return Direction.UP;
		return Direction.NONE;
	}
	static boolean hasDirectPath(List<String> map, Vec2 p, Vec2 q) {
		if ((p.x != q.x) && (p.y != q.y)) return false;
		if (!inBounds(map,p)) return false;
		if (!inBounds(map,q)) return false;
		int dx = q.x>p.x ? 1 : q.x < p.x ? -1 : 0;
		int dy = q.y>p.y ? 1 : q.y < p.y ? -1 : 0;
		for (int i = p.y, j = p.x;
		     (i != q.y) || (j != q.x);
		     i += dy, j += dx) {
			if (map.get(i).charAt(j) == '#') return false;
		}
		return true;
	}
	static boolean isCorner(List<String> map, int r, int c) {
		if (map.get(r).charAt(c) == '#') return false;
		int vert = 0;
		int horz = 0;
		vert += map.get(r-1).charAt(c) == '#' ? 0 : 1;
		vert += map.get(r+1).charAt(c) == '#' ? 0 : 1;
		horz += map.get(r).charAt(c-1) == '#' ? 0 : 1;
		horz += map.get(r).charAt(c+1) == '#' ? 0 : 1;
		return (vert != 0) && (horz != 0);
	}
	private enum Direction {
		RIGHT, UP, LEFT, DOWN, NONE;
		public int nTurns(Direction b) {
			int x = ((this.ordinal() - b.ordinal())%4 + 4)%4;
			if (x == 3) x = 1;
			return x;
		}
		public static int nTurns(Direction a, Direction b) {
			int x = ((a.ordinal() - b.ordinal())%4 + 4)%4;
			if (x == 3) x = 1;
			return x;
		}
	}
	private static class Graph {
		private ArrayList<HashMap<Integer,Integer>> edges;
		Graph() { edges = new ArrayList<HashMap<Integer,Integer>>(); }
		public int addVertex() {
			edges.add(new HashMap<Integer,Integer>());
			return edges.size() - 1;
		}
		public void addEdge(int p, int q, int v) {
			edges.get(p).put(q, v);
		}
		public final HashMap<Integer,Integer> get(int x) {
			return edges.get(x);
		}
		public List<Integer> distances(int source) {
			ArrayList<Integer> out = new ArrayList<Integer>();
			PriorityQueue<Integer> Q = new PriorityQueue<Integer>((a,b) -> out.get(a).compareTo(out.get(b)));
			for (int i = 0; i < edges.size(); i++) {
				out.add(i == source ? 0 : null);
			}
			Q.add(source);
			while (Q.size() != 0) {
				int u = Q.poll();
				Iterator<Integer> vs = edges.get(u).keySet().iterator();
				while (vs.hasNext()) {
					int v = vs.next();
					int alt = out.get(u) + edges.get(u).get(v);
					if (out.get(v) == null || alt < out.get(v)) {
						out.set(v, alt);
						Q.add(v);
					}
				}
			}
			return out;
		}
		public HashSet<Vec2> onPath(ArrayList<Vec2> corners,
		                            int source, int end) {
			ArrayList<ArrayList<Integer>> paths = new ArrayList<ArrayList<Integer>>();
			ArrayList<Integer> out = new ArrayList<Integer>();
			PriorityQueue<Integer> Q = new PriorityQueue<Integer>((a,b) -> out.get(a).compareTo(out.get(b)));
			for (int i = 0; i < edges.size(); i++) {
				out.add(i == source ? 0 : null);
				paths.add(new ArrayList<Integer>());
			}
			Q.add(source);
			while (Q.size() != 0) {
				int u = Q.poll();
				Iterator<Integer> vs = edges.get(u).keySet().iterator();
				while (vs.hasNext()) {
					int v = vs.next();
					if (u == v) continue;
					int alt = out.get(u) + edges.get(u).get(v);
					if (out.get(v) != null && alt == out.get(v)) {
						paths.get(v).add(u);
					}
					if (out.get(v) == null || alt < out.get(v)) {
						paths.get(v).clear();
						paths.get(v).add(u);
						out.set(v, alt);
						Q.add(v);
					}
				}
			}
			HashSet<Vec2> points = new HashSet<Vec2>();
			ArrayDeque<Integer> bfs = new ArrayDeque<Integer>();
			int e = end;
			if (out.get(end+1) < out.get(e)) e = end+1;
			if (out.get(end+2) < out.get(e)) e = end+2;
			if (out.get(end+3) < out.get(e)) e = end+3;
			bfs.add(e);
			while (!bfs.isEmpty()) {
				Integer p = bfs.poll();
				if (p.equals(source)) continue;
				Iterator<Integer> ii = paths.get(p).iterator();
				while (ii.hasNext()) {
					int i = ii.next();
					addPath(corners, p, i, points);
					if (bfs.contains(i)) continue;
					bfs.add(i);
				}
			}
			return points;
		}
	}
	private static class Pair<A,B> {
		public A fst;
		public B snd;
		Pair(A a, B b) { fst = a; snd = b; }
		@Override
		public boolean equals(Object b) {
			if (getClass() != b.getClass()) return false;
			Pair c = (Pair)b;
			return fst.equals(c.fst) && snd.equals(c.snd);
		}
		@Override
		public int hashCode() {
			return (fst.hashCode()&0xdeadbeef)*snd.hashCode();
		}
		@Override
		public String toString() {
			return "<" + fst + "," + snd + ">";
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
