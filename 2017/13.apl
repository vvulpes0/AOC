Nums ← ⍎¨⎕D∘((∊⍨)⊆⊢)
X ← Nums¨⊃⎕NGET '13.txt' 1
CycP ← |⍨∘(+⍨-∘1)
PartA ← +/∘(×/¨)(/⍨∘((0∘=)(CycP/¨)))⍨X
∇ i ← GoB ns
[1]	moduli ← (+⍨-∘1)∘(⊃1∘↓)¨ns
[2]	base ← CycP/¨ns
[3]	i ← ¯1
[4]	i +← 1
[5]	→(0∊(moduli|i+base))/4
∇
PartB ← GoB X
⎕ ← PartA PartB
)OFF
