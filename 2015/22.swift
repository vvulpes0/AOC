let boss=(51,9)
func minn(_ a: Int,_ b: Int) -> Int {
	if (a < 0) { return b }
	if (b < 0) { return a }
	return min(a,b)
}
var cap = -1
func go(_      iboss: (Int,Int),
        _    iplayer: (Int,Int),
        _   shield_t: Int,
        _   poison_t: Int,
        _ recharge_t: Int,
        _        who: Int,
        _       loss: Bool,
        _      spent: Int) -> Int {
	// boss: (hp, damage); player: (hp, mana)
	var boss = iboss
	var player = iplayer
	let      armor = shield_t > 0 ? 7 : 0
	var        val = -1
	if loss && who == 0 {
		player.0 = player.0 - 1
	}
	if poison_t > 0 {
		boss.0 = boss.0 - 3
	}
	if recharge_t > 0 {
		player.1 = player.1 + 101
	}
	if spent >= cap && cap >= 0 {
		return -1
	}
	if boss.0 <= 0 {
		cap = minn(cap,spent)
		return spent
	}
	if player.0 <= 0 {
		return -1
	}
	if who == 0 {
		var potential = 0
		var m = 53
		if player.1 < m { return -1 }
		// magic missile
		if player.1 >= m {
			potential = go((boss.0-4,boss.1),
			               (player.0,player.1-53),
			               max(shield_t-1,0),
			               max(poison_t-1,0),
			               max(recharge_t-1,0),
			               1-who,loss,spent+m)
			if potential >= 0 {val = minn(val,potential)}
		}
		// drain
		m = 73
		if player.1 >= m {
			potential = go((boss.0-2,boss.1),
			               (player.0+2,player.1-m),
			               max(shield_t-1,0),
			               max(poison_t-1,0),
			               max(recharge_t-1,0),
			               1-who,loss,spent+m)
			if potential >= 0 {val = minn(val,potential)}
		}
		// shield
		m = 113
		if shield_t <= 1 && player.1 >= m {
			potential = go(boss,
			               (player.0,player.1-m),
			               6,
			               max(poison_t-1,0),
			               max(recharge_t-1,0),
			               1-who,loss,spent+m)
			if potential >= 0 {val = minn(val,potential)}
		}
		// poison
		m = 173
		if poison_t <= 1 && player.1 >= m {
			potential = go(boss,
			               (player.0,player.1-m),
			               max(shield_t-1,0),
			               6,
			               max(recharge_t-1,0),
			               1-who,loss,spent+m)
			if potential >= 0 {val = minn(val,potential)}
		}
		// recharge
		m = 229
		if recharge_t <= 1 && player.1 >= m {
			potential = go(boss,
			               (player.0,player.1-m),
			               max(shield_t-1,0),
			               max(poison_t-1,0),
			               5,
			               1-who,loss,spent+m)
			if potential >= 0 {val = minn(val,potential)}
		}
		return val
	}
	return go(boss,
	          (player.0-max(1,boss.1-armor),player.1),
	          max(shield_t-1,0),
	          max(poison_t-1,0),
	          max(recharge_t-1,0),
	          1-who,loss,spent)
}
cap = -1
let part_a = go(boss,(50,500),0,0,0,0,false,0)
cap = -1
let part_b = go(boss,(50,500),0,0,0,0,true,0)
print(part_a,part_b)
