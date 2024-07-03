X ← ⍎¨⊃⎕NGET '03.txt' 1
Sort ← ⍋⌷¨⊂
Valid ← +\>⍥(2∘⌷)1∘⌽
Shuffle ← ⊂⍨∘(1 0 0⍴⍨⍴)⍨∊∘⍉∘↑
PartA ← +/(Valid∘Sort)¨X
PartB ← +/(Valid∘Sort)¨Shuffle X
⎕ ← PartA PartB
)OFF
