X ← ↑⊃⎕NGET '24.txt' 1
POI ← (⍋⊃¨⊂)(/⍨∘(∊∘⎕D))⍨∘,
∇ dists ← poi Distances loc;d;q;rows;cols;seen
[1]	rows cols ← ⍴X ⋄ dists ← (⌊/⍬)⍨¨poi ⋄ Q ← ⊂0,loc ⋄ seen ← loc
[2]	d loc ← ⊃Q
[3]	dists ← d(⌊@(((⊂loc)⊃X)(⍸⍷)poi))dists
[4]	nexts ← ((0 1) (0 ¯1) (1 0) (¯1 0))+⊂loc
[5]	nexts ← (/⍨∘((⎕IO∘≤)(∧/¨∧)(<∘(⊂⎕IO+rows cols))))⍨ nexts
[6]	nexts ← ('#'≠(⊂¨nexts)⊃¨⊂X)/nexts
[7]	Q ← (1↓Q),(d+1)(,∘⊂)¨(nexts~seen)
[8]	seen ← ∪seen,nexts
[9]	→(0≢≢Q)/2
∇
NextPerm ← {
	k ← (1∘↑∘⌽∘⍸∘(1∘↓)∘(¯1∘⌽)(<∘(1∘⌽))⍨)⍵
	~k∊(⍳≢⍵): ⍬
	l ← ⊃⌽⍸⍵[k]<⍵
	p ← ((⍵[l],⍵[k])@(k l))⍵
	(⌽@{k<⍳≢p})p
}
DistMap ← ↑(⊂(Distances∘((⍸⍷)∘X))¨⊢) POI X
Total ← +/(⊃∘DistMap(⊂,))¨∘(2∘(,/))
MinDist ← {⍺ ← ⌊/⍬ ⋄ ⎕IO≢⊃⍵: ⍺ ⋄ (⍺⌊Total⍵)∇(NextPerm⍵)}
TotalB ← Total∘(,∘⎕IO)
MinDistB ← {⍺ ← ⌊/⍬ ⋄ ⎕IO≢⊃⍵: ⍺ ⋄ (⍺⌊TotalB⍵)∇(NextPerm⍵)}
PartA ← MinDist ⍳≢POI X
PartB ← MinDistB ⍳≢POI X
⎕ ← PartA PartB
)OFF
