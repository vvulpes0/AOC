import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Scanner;
class Day15 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		String s = "";
		int row = 0;
		Sokoban board = new Sokoban();
		Sokoban wboard = new Sokoban();
		Vec2 rsize = new Vec2(1,1);
		Vec2 bsize = new Vec2(2,1);
		while (in.hasNextLine()) {
			s = in.nextLine();
			if (s.length() == 0) break;
			for (int col = 0; col < s.length(); col++) {
				char c = s.charAt(col);
				Vec2 v = new Vec2(col, row);
				Box b = new Box(v, rsize);
				Vec2 wv = new Vec2(2*col, row);
				Box wb = new Box(wv, bsize);
				if (c == '#') {
					board.addWall(b);
					wboard.addWall(wb);
				} else if (c == 'O') {
					board.addBox(b);
					wboard.addBox(wb);
				} else if (c == '@') {
					board.start(v);
					wboard.start(wv);
				}
			}
			row++;
		}
		//System.out.print(wboard);
		while (in.hasNextLine()) {
			s = in.nextLine();
			board.move(s);
			wboard.move(s);
		}
		System.out.println(board.gps() + "\t" + wboard.gps());
		//System.out.print(wboard);
	}
	private static class Sokoban {
		private HashSet<Box> boxes;
		private HashMap<Vec2,Box> subboxes;
		private HashSet<Vec2> walls;
		private Vec2 pos;
		private int rows;
		private int cols;
		Sokoban() {
			boxes = new HashSet<Box>();
			subboxes = new HashMap<Vec2,Box>();
			walls = new HashSet<Vec2>();
			rows = 0;
			cols = 0;
		}
		private void bound(Vec2 p) {
			if (p.y >= rows) rows = p.y + 1;
			if (p.x >= cols) cols = p.x + 1;
		}
		public int gps() {
			Iterator<Box> vs = boxes.iterator();
			int out = 0;
			while (vs.hasNext()) {
				Vec2 v = vs.next().pos;
				out += 100*v.y + v.x;
			}
			return out;
		}
		public void addBox(Box b) {
			bound(b.pos.add(b.size.add(new Vec2(-1,-1))));
			Iterator<Vec2> sb = b.positions();
			while (sb.hasNext()) {
				if (subboxes.containsKey(sb.next())) {
					return;
				}
			}
			sb = b.positions();
			while (sb.hasNext()) {
				subboxes.put(sb.next(), b);
			}
			boxes.add(b);
		}
		public void removeBox(Box b) {
			if (!boxes.contains(b)) return;
			Iterator<Vec2> sb = b.positions();
			while (sb.hasNext()) subboxes.remove(sb.next());
			boxes.remove(b);
		}
		public void addWall(Box b) {
			Iterator<Vec2> ps = b.positions();
			while (ps.hasNext()) {
				Vec2 p = ps.next();
				bound(p);
				walls.add(p);
			}
		}
		public void start(Vec2 p) {
			bound(p);
			pos = p;
		}
		public boolean canMove(char c) {
			if (walls.contains(pos.add(c))) return false;
			if (!subboxes.containsKey(pos.add(c))) return true;
			return canMove(subboxes.get(pos.add(c)), c);
		}
		private boolean canMove(Box b, char c) {
			Iterator<Vec2> ps = b.positions(c);
			HashSet<Box> bs = new HashSet<Box>();
			while (ps.hasNext()) {
				Vec2 p = ps.next();
				if (walls.contains(p)) return false;
				if (!subboxes.containsKey(p)) continue;
				bs.add(subboxes.get(p));
			}
			Iterator<Box> bsi = bs.iterator();
			while (bsi.hasNext()) {
				if (!canMove(bsi.next(),c)) return false;
			}
			return true;
		}
		public void move(String s) {
			for (int i = 0; i < s.length(); i++) {
				move(s.charAt(i));
			}
		}
		public void move(char c) {
			if (!canMove(c)) return;
			Vec2 q = pos.add(c);
			if (subboxes.containsKey(q)) {
				move(subboxes.get(q), c);
			}
			pos = q;
		}
		private void move(Box b, char c) {
			Iterator<Vec2> ps = b.positions(c);
			HashSet<Box> bs = new HashSet<Box>();
			while (ps.hasNext()) {
				Vec2 p = ps.next();
				if (!subboxes.containsKey(p)) continue;
				bs.add(subboxes.get(p));
			}
			Iterator<Box> bsi = bs.iterator();
			while (bsi.hasNext()) move(bsi.next(),c);
			removeBox(b);
			addBox(new Box(b.pos.add(c), b.size));
		}
		@Override
		public String toString() {
			StringBuilder s = new StringBuilder("");
			for (int i = 0; i < rows; i++) {
				for (int j = 0; j < cols; j++) {
					Vec2 v = new Vec2(j,i);
					if (walls.contains(v)) {
						s.append('#');
					} else if (subboxes.containsKey(v)) {
						Box b = subboxes.get(v);
						if (b.size.x == 1) {
							s.append('O');
						} else if (b.pos.equals(v)) {
							s.append('[');
						} else {
							s.append(']');
						}
					} else if (pos.equals(v)) {
						s.append('@');
					} else {
						s.append('.');
					}
				}
				s.append('\n');
			}
			return s.toString();
		}
	}
	private static class Box {
		public final Vec2 pos;
		public final Vec2 size;
		Box(Vec2 p, Vec2 s) { pos = p; size = s; }
		@Override
		public boolean equals(Object b) {
			if (getClass() != b.getClass()) return false;
			Box x = (Box)b;
			return pos.equals(x.pos) && size.equals(x.size);
		}
		@Override
		public int hashCode() {
			return pos.hashCode() * size.hashCode();
		}
		boolean contains(Vec2 p) {
			return p.x >= pos.x
				&& p.x < pos.x + size.x
				&& p.y >= pos.y
				&& p.y < pos.y + size.y;
		}
		boolean intersects(Box b) {
			Iterator<Vec2> ps = b.positions();
			while (ps.hasNext()) {
				if (contains(ps.next())) return true;
			}
			return false;
		}
		Iterator<Vec2> positions() {
			// all contained
			HashSet<Vec2> ps = new HashSet<Vec2>();
			for (int i = 0; i < size.y; i++) {
				for (int j = 0; j < size.x; j++) {
					ps.add(pos.add(new Vec2(j,i)));
				}
			}
			return ps.iterator();
		}
		Iterator<Vec2> positions(char c) {
			// next outside the border in direction
			HashSet<Vec2> ps = new HashSet<Vec2>();
			int m;
			if (c == '^') {
				m = -1;
				for (int i = 0; i < size.x; i++) {
					ps.add(pos.add(new Vec2(i,m)));
				}
			} else if (c == 'v') {
				m = size.y;
				for (int i = 0; i < size.x; i++) {
					ps.add(pos.add(new Vec2(i,m)));
				}
			} else if (c == '<') {
				m = -1;
				for (int i = 0; i < size.y; i++) {
					ps.add(pos.add(new Vec2(m,i)));
				}
			} else if (c == '>') {
				m = size.x;
				for (int i = 0; i < size.y; i++) {
					ps.add(pos.add(new Vec2(m,i)));
				}
			}
			return ps.iterator();
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
			return "<" + this.x + "," + this.y + ">";
		}
	}
}
