X ← ⊃⎕NGET '02.txt' 1
Clamp ← 1 0J1(+/×)((1⌊¯1∘⌈)9 11∘○)
Direction ← (/∘0J¯1 0J1 ¯1 1)'UDLR'∘=
MoveA ← (Clamp+)∘Direction⍨ ⍝ letter MoveA position
StreamA ← MoveA/(,⍨⍥⌽) ⍝ position StreamA string
DecodeA ← 1∘+(1 3∘(+/×)(1∘+9 11∘○))
PartA ← ∊⍕¨DecodeA¨0∘StreamA¨,\X

L1Length ← 9 11∘(+⍥|/○)
MoveB ← (⊢((⊃⌽)⍤/⍨)<∘3⍥L1Length¨)(⊢,(+∘Direction⍨))
StreamB ← MoveB/(,⍨⍥⌽)
KeysB ← 5 5⍴'  1   234 56789 ABC   D  '
DecodeB ← ⌷∘KeysB⍤⌽(3∘+9 11∘○)
PartB ← DecodeB¨¯2∘StreamB¨,\X

⎕ ← PartA PartB
)OFF
