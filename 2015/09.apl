X ← ⊃⎕NGET '09.txt' 1
Nums ← ((×∘(+\~))⍨(∊∘⎕D))(⍎¨⊆)⊢
Size ← (2÷⍨×∘(1∘+))⍨⍣¯1
UnTop ← { 0≡≢⍵:⍬ ⋄ x r ← (⊃⍵) (1↓⍵) ⋄ (,[⎕IO-0.5]x)⍪((1↓x),∇r) }
NextPerm ← {
	k ← (1∘↑∘⌽∘⍸∘(1∘↓)∘(¯1∘⌽)(<∘(1∘⌽))⍨)⍵
	~k∊(⍳≢⍵): ⍬
	l ← ⊃⌽⍸⍵[k]<⍵
	p ← ((⍵[l],⍵[k])@(k l))⍵
	(⌽@{k<⍳≢p})p
}
DistMap ← UnTop (,∘0)0,¨(((\∘⌽)⍨⌽∘⍳∘Size∘≢)⊆⊢)(∊Nums¨X)
Total ← +/(⊃∘DistMap(⊂,))¨∘(2∘(,/))
MinMaxDist ← {
	⍺ ← (⌊/⍬) (⌈/⍬)
	0≡≢⍵: ⍺
	min max ← ⍺
	T ← Total ⍵
	((min⌊T)(max⌈T))∇(NextPerm⍵)
}
⎕ ← MinMaxDist⍳1+Size≢X
)OFF
