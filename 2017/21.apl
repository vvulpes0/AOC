X ← ⊃⎕NGET '21.txt' 1
∇ R ← Parse22 s
[1] b ← 2 2⍴1 2 4 5⊃¨⊂s ⋄ i ← 0 ⋄ blocks ← ⍬
[2] blocks ← blocks,⊂b ⋄ b ← ⍉b ⋄ blocks ← blocks,⊂b ⋄ b ← ⌽b
[3] i +← 1
[4] →(i<4)/2
[5] t0 ← 3 3⍴10 11 12 14 15 16 18 19 20⊃¨⊂s
[6] R ← ∪((,⍥⊂)∘t0)¨blocks
∇
∇ R ← Parse33 s
[1] b ← 3 3⍴1 2 3 5 6 7 9 10 11⊃¨⊂s ⋄ i ← 0 ⋄ blocks ← ⍬
[2] blocks ← blocks,⊂b ⋄ b ← ⍉b ⋄ blocks ← blocks,⊂b ⋄ b ← ⌽b
[3] i +← 1
[4] →(i<4)/2
[5] t0 ← 4 4⍴16 17 18 19 21 22 23 24 26 27 28 29 31 32 33 34⊃¨⊂s
[6] R ← ∪((,⍥⊂)∘t0)¨blocks
∇
Parse ← {
	⍺ ← ⍬
	0≡≢⍵: ⍺
	s rest ← (⊃⍵) (1↓⍵)
	25>≢s: (⍺,Parse22 s)∇rest
	(⍺,Parse33 s)∇rest
}
Rules ← Parse X
Contract ← ⊃(⍪⌿)∘(,/)
Lookup ← ⊃∘⌽∘⊃∘(⊃¨∘(⊂Rules))∘((⍸⍷)∘(⊃¨Rules))∘⊂
ExpandE ← {
	m ← ¯1+⊃⍴⍵
	e ← (m⍴1 0)/(m⍴1 0)⌿({⊂Lookup ⍵}⌺2 2)⍵
	Contract e
}
ExpandO ← {
	m ← ⊃⍴⍵
	e ← (m⍴0 1 0)/(m⍴0 1 0)⌿({⊂Lookup ⍵}⌺3 3)⍵
	Contract e
}
Expand ← {
	0=2|⊃⍴⍵: ExpandE ⍵
	ExpandO ⍵
}
PartA ← +/∊'#'=(Expand⍣5) 3 3⍴'.#...####'
PartB ← +/∊'#'=(Expand⍣18) 3 3⍴'.#...####'
⎕ ← PartA PartB
)OFF
