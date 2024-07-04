X ← ⊃⎕NGET '07.txt' 1
PalindromicQuads ← (≡∘⌽)⍨¨4∘(,/)
DistinctQuads ← (1≠(≢∪))¨4∘(,/)
ABBAQuads ← PalindromicQuads∧DistinctQuads
EnclosedQuads ← (3↓¯3∘⌽)('['=(((⊃⌽)(/⍨∘(∊∘'[]'))⍨)¨(,\)))
PartA ← +/(ABBAQuads((∨/⍤∧∘~)(∧∘~)(∨/⍤∧))EnclosedQuads)¨X

PalindromicTris ← (≡∘⌽)⍨¨3∘(,/)
DistinctTris ← (1≠(≢∪))¨3∘(,/)
ABATris ← PalindromicTris∧DistinctTris
EnclosedTris ← (2↓¯2∘⌽)('['=(((⊃⌽)(/⍨∘(∊∘'[]'))⍨)¨(,\)))
ABAs ← (3∘(,/))(/⍨)(ABATris(∧∘~)EnclosedTris)
PartB ← +/(∨/((3∘(,/)(/⍨)EnclosedTris)∊((2 1 2 ⊃¨⊂)¨ABAs)))¨X
⎕ ← PartA PartB
)OFF
