X ← ⍎⊃⊃⎕NGET '13.txt' 1
⍝ (x CoordBase y) ≡ (x×x) + (3×x) + (2×x×y) + y + (y×y)
CoordBase ← ((+⍨∘(3∘×))⍨+(+⍥(×⍨)))+2××
Bit ← ((⌊÷∘2)@⎕IO)(,∘(2∘|⊃))⍨
Popc ← +/(1↓Bit⍣((0≡⊃)⊣))
IsWall ← (2∘|)∘Popc∘(X∘+)∘(CoordBase/)9 11∘○
IsValid ← (⍱/(<∘0)∘(9 11∘○))(∧∘~)IsWall
Seek ← {
	states seen ← ⍵
	i loc ← ⊃states
	loc≡⍺: i
	nexts ← (/⍨∘(IsValid¨))⍨(/⍨∘((~∊)∘seen))⍨1 ¯1 0J1 0J¯1+loc
	⍺∊nexts: i+1
	⍺∇((1↓states),((i+1),¨nexts)) (seen,loc)
}
Expand ← {
	states seen ← ⍵
	0≡≢states: seen
	i loc ← ⊃states
	i>⍺: ⍺∇(1↓states) seen
	nexts ← (/⍨∘(IsValid¨))⍨(/⍨∘((~∊)∘seen))⍨1 ¯1 0J1 0J¯1+loc
	⍺∇((1↓states),((i+1),¨nexts)) (seen(∪,)loc)
}
PartA ← 31J39 Seek (⊂0 1J1) ⍬
PartB ← ≢50 Expand (⊂0 1J1) ⍬
⎕ ← PartA PartB
)OFF
