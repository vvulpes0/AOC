X ← ⊃⎕NGET '04.txt' 1
Sort ← ⍋⌷¨⊂
Name ← 1∘↓¯1⌽(/⍨∘(~(∨\∊∘⎕D))⍨)
SectorID ← ⍎(/⍨∘(∊∘⎕D)⍨)
StoredCheck ← 2∘↓¯1⌽(/⍨∘(∨\=∘'[')⍨)
TopFiveLetters ← 5∘↑2⌷¨∘↑∘Sort((∪(+/∘-⍷)¨⊂),¨∪)
IsRealRoom ← TopFiveLetters∘(~∘'-')∘Name≡StoredCheck

PartA ← +/ (SectorID¨(/⍨)IsRealRoom¨) X
⍝ /⍨∘(IsRealRoom¨)⍨ X ⍝ the list of all and only the valid rooms
⍝ (⍷∘(⎕C⎕A,'-')¨Name) ⍝ per-letter locations in alphabet
⍝ (⊂⍤,∘' '(⎕C⎕A⌽⍨SectorID)) ⍝ alphabet swizzled
Decrypt ← ∊((⊂⍤,∘' '(⎕C⎕A⌽⍨SectorID)) (/¨⍨) (⍷∘(⎕C⎕A,'-')¨Name))
RealRooms ← /⍨∘(IsRealRoom¨)⍨X
PartB ← SectorID⊃(/⍨∘(('northpole object storage'∘≡Decrypt)¨))⍨RealRooms
⎕ ← PartA PartB
)OFF
