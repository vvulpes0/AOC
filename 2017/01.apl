X ← ⍎¨∊⊃⎕NGET '01.txt' 1
PartA ← +/(⊢(/⍨)(=∘(1∘⌽))⍨) X
PartB ← +/(⊢(/⍨)(=∘((÷∘2≢)⌽⊢))⍨) X
⎕ ← PartA PartB
)OFF
