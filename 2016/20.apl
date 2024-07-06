Nums ← '-'∘≠(∊⍎¨⍤⊆)⊢
Sort ← ⍋⊃¨⊂
X ← Sort Nums¨⊃⎕NGET '20.txt' 1
Top ← ¯1+2*32
Union ← {
	⍺ ← ⍬
	2>≢⍵: ⍺,⍵
	(a1 b1) (a2 b2) ← 2↑⍵
	a2≤b1+1: ⍺∇(⊂a1 (b1⌈b2)),2↓⍵
	(⍺,⊂(a1 b1))∇1↓⍵
}
Invert ← {
	0≡≢⍵: ⊂(0 Top)
	⍺ ← (0≢⊃⊃⍵)↑⊂0 (¯1+⊃⊃⍵)
	a1 b1 ← ⊃⍵
	1≡≢⍵: ⍺,(b1<Top)↑⊂(b1+1) Top
	a2 ← ⊃2⊃⍵
	(⍺,⊂(b1+1)(a2-1))∇(1↓⍵)
}
Size ← 1+(-⍨/)
FindOpen ← {
	lo hi ← ⊃⍵
	⍺<lo: ⍺
	(⍺⌈(hi+1))∇1↓⍵
}
Open ← Invert Union X
PartA ← ⊃⊃Open
PartB ← +/Size¨Open
⎕ ← PartA PartB
)OFF
