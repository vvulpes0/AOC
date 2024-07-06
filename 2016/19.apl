X ← ⍎⊃⊃⎕NGET '19.txt' 1
Round ← (-2|≢)⌽(∊1↑⍉∘((,∘2∘⌈2÷⍨≢)⍴⊢))
HighHalf ← 2∘×-(3×3*∘⌊3⍟2∘(÷⍨))
LowHalf ← ⊢-(3*∘⌈3⍟2∘(÷⍨))
PartA ← (Round⍣((1≡≢)⊣)) ⍳X
PartB ← (LowHalf((⎕IO+0≥⊣)⊃,)HighHalf) X
⎕ ← PartA PartB
)OFF
