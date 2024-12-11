import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Scanner;
class Day11 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		HashMap<Long,Long> stones = new HashMap<Long,Long>();
		while (in.hasNextLong()) {
			augment(stones, in.nextLong(), 1L);
		}
		in.close();
		long partA = 0L;
		long partB = 0L;
		for (int i = 0; i < 75; i++) {
			HashMap<Long,Long> stonesB = new HashMap<Long,Long>();
			Iterator<Long> vs = stones.values().iterator();
			if (i == 25) {
				while (vs.hasNext()) partA += vs.next();
			}
			Iterator<Map.Entry<Long,Long>> kvs = stones.entrySet().iterator();
			while (kvs.hasNext()) {
				Map.Entry<Long,Long> kv = kvs.next();
				Long k = kv.getKey();
				Long v = kv.getValue();
				String s = Long.toString(kv.getKey());
				if (k == 0) {
					augment(stonesB, 1L, v);
				} else if (s.length() % 2 == 0) {
					int len = s.length() / 2;
					Long x = Long.parseLong(s.substring(0,len));
					Long y = Long.parseLong(s.substring(len));
					augment(stonesB, x, v);
					augment(stonesB, y, v);
				} else {
					augment(stonesB, 2024*k, v);
				}
			}
			stones = stonesB;
		}
		Iterator<Long> vs = stones.values().iterator();
		while (vs.hasNext()) partB += vs.next();
		System.out.println(partA + "\t" + partB);
	}
	static void augment(HashMap<Long,Long> m, Long k, Long a) {
		m.compute(k, (_k,v) -> v == null ? a : v + a);
	}
}
