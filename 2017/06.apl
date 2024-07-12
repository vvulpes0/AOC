X ← ∊⍎¨' '(≠⊆⊢)⊃⊃⎕NGET '06.txt' 1
distribute ← +⌿((1∘+⌈⍤÷),⊣)(⊣⍴((×/⍤⊣)↑⊢))(⍴∘1⊢)
FindCyc ← {
	d state seen ← ⍵
	(⊂state)∊(⊃¨seen) : d (d-2⌷⊃((⊂state)(⍸⍷)(⊃¨seen))⌷seen)
	m ← ⌈/state
	loc ← ⊃m(⍸⍷)state
	next ← ((-loc)⌽(≢state)distribute m) + ((0@loc)state)
	∇(d+1) next (seen,⊂state d)
}
⎕ ← FindCyc 0 X ⍬
)OFF
