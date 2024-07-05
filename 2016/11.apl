X ← ⊃⎕NGET '11.txt' 1
Words ← ((' '∘≠⊆⊢)∘(~∘',.')∘(' '@(=∘'-')))¨X
Generators ← (⍋⊃¨⊂)∘⊃,/∘(((/⍨∘(1⌽'generator'∘≡¨))⍨¨),¨¨((1-⎕IO)∘+∘⍳≢))
Microchips ← (⍋⊃¨⊂)∘⊃,/∘(((/⍨∘(2⌽'microchip'∘≡¨))⍨¨),¨¨((1-⎕IO)∘+∘⍳≢))
State ← (0 1,⊂)∊∘(⍋⊃¨⊂)∘(Generators,¨⍥((⊃⌽)¨)Microchips) Words
Pairs ← ((∪¨⊃),/)(,⍨¨¨∘(,\))⍨
Occupants ← ⍳∘≢∘((2+⎕IO)∘⊃)(/⍨)((1+⎕IO)∘⊃=(2+⎕IO)∘⊃)
Down ← {(1+⊃⍵) (((⎕IO+1)⊃⍵)-1) (((-∘1)@⍺)(⎕IO+2)⊃⍵)}
Up ← {(1+⊃⍵) (((⎕IO+1)⊃⍵)+1) (((+∘1)@⍺)(⎕IO+2)⊃⍵)}
Valid ← {
	i floor locs ← ⍵
	(<∘1∨4∘<)floor: 0
	mg ← ((⍴∘1 0≢)⊂⊢) locs
	∧/=/¨mg: 1
	bareChip ← (⊃⌽)¨(/⍨∘(≠/¨)⍨)mg
	~∨/bareChip∊⊃¨mg
}
Sort ← (,/∘(⍋⊃¨⊂)(((⍴∘1 0≢)⊂⊢)(⊃⌽)))@(2+⎕IO)
Solve ← {
	s ← ⊃⊃⍵
	rest ← 1↓⊃⍵
	i floor locs ← s
	∧/4=locs: i
	nexts ← (/⍨∘(Valid¨))⍨,↑(Down(,⍥⊂)Up)∘s¨Pairs Occupants s
	seen ← ⊃⌽⍵
	unseen ← (/⍨∘(((~∊)∘seen)(((⊂∊),)1∘↓)¨))⍨Sort¨nexts
	∇(∪(rest,unseen)) ((⊂(floor,locs)),seen)
}
PartA ← Solve (⊂State) ⍬
PartB ← Solve (⊂(((⊂∊)1 1 1 1∘,)@(2+⎕IO)) State) ⍬
⎕ ← PartA PartB
)OFF
