$boss = []
IO.foreach("21.txt") { |x| $boss << x.scan(/\d/).join('').to_i }
wpn = [[ 8,4,0],[10,5,0],[ 25,6,0],[40,7,0],[ 74,8,0]]
arm = [[13,0,1],[31,0,2],[ 53,0,3],[75,0,4],[102,0,5]]
rng = [[25,1,0],[50,2,0],[100,3,0],[20,0,1],[ 40,0,2],[80,0,3]]

wpnc = wpn.combination(1).to_a
armc = arm.combination(1).to_a + [[]]
rngc = rng.combination(2).to_a + rng.combination(1).to_a + [[]]
builds = wpnc.product(armc,rngc)
             .map{|x| x.flatten(1).transpose.map{|y| y.sum}}

def is_winner(build)
  player_turn = $boss[0].fdiv((build[1]-$boss[2]).clamp(1,9999)).ceil()
  boss_turn   =      100.fdiv(($boss[1]-build[2]).clamp(1,9999)).ceil()
  return player_turn <= boss_turn
end
part_a = builds.select{|x|  is_winner(x)}.map{|x| x[0]}.min
part_b = builds.select{|x| !is_winner(x)}.map{|x| x[0]}.max
print part_a, " ", part_b, "\n"
