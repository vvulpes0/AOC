X ← ⍎¨⊃⊃⎕NGET '16.txt' 1
Dragon ← ⊢(,∘(0∘,))(~⌽)
Fill ← {⍺↑Dragon⍣((⍺≤≢)⊣)⍵}
Pass ← ∊1↑⍉∘(⍴⍨∘((,∘2)2÷⍨≢)⍨)∘((=∘(1∘⌽))⍨)
Checksum ← ∊⍕¨∘(Pass⍣((2|≢)⊣))
PartA ← Checksum 272 Fill X
PartB ← Checksum 35651584 Fill X
⎕ ← PartA PartB
)OFF
