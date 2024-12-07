import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Scanner;
import java.util.Set;
class Day06 {
	public static void main(String[] args) {
		HashSet<Vec2> map = new HashSet<Vec2>();
		Scanner in = new Scanner(System.in);
		Vec2 start = new Vec2();
		int r = 0;
		int xsize = 0;
		while (in.hasNextLine()) {
			String s = in.nextLine();
			xsize = s.length();
			for (int i = 0; i < s.length(); i++) {
				if (s.charAt(i) == '#') {
					map.add(new Vec2(i,r));
				} else if (s.charAt(i) == '^') {
					start = new Vec2(i,r);
				}
			}
			r++;
		}
		in.close();
		HashSet<Vec2> touched = new HashSet<Vec2>();
		ArrayList<State> path = new ArrayList<State>();
		State now = new State(start, new Vec2(0,-1));
		while (now.good(xsize, r)) {
			touched.add(now.getPos());
			path.add(now);
			now = now.advance(map);
		}
		System.out.print(touched.size());
		HashSet<Vec2> b = new HashSet<Vec2>();
		HashSet<State> path2 = new HashSet<State>();
		for (int i = 0; i < path.size(); i++) {
			State s = path.get(i);
			Vec2 v = s.getPos().add(s.dir);
			if (!(new State(v,new Vec2())).good(xsize, r)) {
				continue;
			}
			if (map.contains(v)) continue;
			path2.clear();
			now = new State(start, new Vec2(0,-1));
			while (now.good(xsize, r, path2)) {
				path2.add(now);
				now = now.advance(map, v);
			}
			if (path2.contains(now)) b.add(v);
		}
		System.out.print("\t");
		System.out.println(b.size());
	}
	static class Vec2
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
			return this.x ^ this.y ^ 0xdeadbeef;
		}
		@Override
		public String toString() {
			return "<" + this.x + "," + this.y + ">";
		}
	}
	static class State
		implements Comparable<State> {
		private final Vec2 pos;
		private final Vec2 dir;
		State(Vec2 pos, Vec2 dir) {
			this.pos = pos;
			this.dir = dir;
		}
		public State advance(Set<Vec2> map) {
			Vec2 pos = this.pos.add(this.dir);
			if (!map.contains(pos)) {
				return new State(pos, this.dir);
			}
			return new State(this.pos, this.dir.rotate());
		}
		public State advance(Set<Vec2> map, Vec2 obs) {
			Vec2 pos = this.pos.add(this.dir);
			if (!map.contains(pos) && !pos.equals(obs)) {
				return new State(pos, this.dir);
			}
			return new State(this.pos, this.dir.rotate());
		}
		public Vec2 getPos() { return this.pos; }
		public Vec2 getDir() { return this.dir; }
		public boolean good(int xsize, int ysize) {
			return this.pos.x >= 0 && this.pos.x < xsize &&
				this.pos.y >= 0 && this.pos.y < ysize;
		}
		public boolean good(int xsize, int ysize, Collection<State> xs) {
			return this.good(xsize, ysize)
				&& !xs.contains(this);
		}
		@Override
		public int compareTo(State b) {
			if (!this.pos.equals(b.pos)) {
				return this.pos.compareTo(b.pos);
			}
			return this.dir.compareTo(b.dir);
		}
		@Override
		public boolean equals(Object b) {
			if (getClass() != b.getClass()) return false;
			State bs = (State) b;
			return this.compareTo(bs) == 0;
		}
		@Override
		public int hashCode() {
			return this.pos.hashCode() * this.dir.hashCode()
				^ 0x900fba11;
		}
	}
}
