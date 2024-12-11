import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;
class Day10 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		ArrayList<String> map = new ArrayList<String>();
		ArrayList<Vec2> heads = new ArrayList<Vec2>();
		while (in.hasNextLine()) {
			String s = in.nextLine();
			for (int i = 0; i < s.length(); i++) {
				if (s.charAt(i) == '0') {
					heads.add(new Vec2(i,map.size()));
				}
			}
			map.add(s);
		}
		Vec2 out = score(heads, map);
		System.out.println(out.x + "\t" + out.y);
	}
	public static boolean inBounds(List<String> map, Vec2 p) {
		if (map.size() == 0) return false;
		return p.y >= 0 && p.y < map.size()
			&& p.x >= 0 && p.x < map.get(0).length();
	}
	public static int height(List<String> map, Vec2 p) {
		return Character.getNumericValue(map.get(p.y).charAt(p.x));
	}
	public static Vec2 score(List<Vec2> headArr, List<String> map) {
		ArrayDeque<Vec2> bfs = new ArrayDeque<Vec2>();
		Iterator<Vec2> heads = headArr.iterator();
		HashSet<Vec2> seen = new HashSet<Vec2>();
		HashSet<Vec2> peaks = new HashSet<Vec2>();
		ArrayList<Vec2> dirsArr
			= new ArrayList<Vec2>
			(Arrays.asList
			 (new Vec2( 0, 1),
			  new Vec2( 1, 0),
			  new Vec2( 0,-1),
			  new Vec2(-1, 0)));
		int outA = 0;
		int outB = 0;
		while (heads.hasNext()) {
			bfs.clear();
			seen.clear();
			peaks.clear();
			bfs.add(heads.next());
			while (bfs.size() > 0) {
				Vec2 p = bfs.remove();
				seen.add(p);
				int h = height(map, p);
				if (h == 9) {
					peaks.add(p);
					outB++;
				}
				Iterator<Vec2> dirs = dirsArr.iterator();
				while (dirs.hasNext()) {
					Vec2 q = p.add(dirs.next());
					if (inBounds(map, q)
					    && height(map, q) == h+1
					    && !seen.contains(q)) {
						bfs.add(q);
					}
				}
			}
			outA += peaks.size();
		}
		return new Vec2(outA, outB);
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
			return this.x ^ this.y ^ 0xdeadbeef;
		}
		@Override
		public String toString() {
			return "<" + this.x + "," + this.y + ">";
		}
	}
}
