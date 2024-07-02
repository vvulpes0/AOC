Parse ← ((⊃,(1(⍎↓)⊢))¨(⊆⍨∘(', '(~∊)⍨⊢))⍨)
Expand ← ↑(,/(((⊂1@2),((⊂('F' 1))⍴⍨(¯1+2⌷⊢)))¨))
Turn ← 'RLF'(+/0J¯1 0J1 1×=)⊢
ActA ← ((((Turn⊣)×⊢)⍥(1⌷⊢)) (⊣,((1,⍨⊣)(+/×)⊢)) (,⍥(2⌷⊢)))
ActB ← (((1 1 0 0 1 0/⊢),((4⌷⊢)⊂⍤∊⍤,(6⌷⊢)))(((⊃(↑3⌷⊢))ActA(2↑⊢)),(1↓¨⊢)@3))
Destination ← ((2⌷↑)ActA/)(⊂0J1 0),⍨(⌽⊢)
L1Length ← +/(|9 11○⊢)

X ← Parse∊⊃⎕NGET '01.txt' 1
PartA ← L1Length Destination X
PartB ← L1Length 2⌷ (ActB⍣((2⌷⊣)∊¨(4⌷⊣))) 0J1 0 (Expand X) ⍬
⎕ ← PartA PartB
)OFF
