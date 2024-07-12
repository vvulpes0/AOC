X ← ⊃⎕NGET '04.txt' 1
PartA ← +/((≢≡(≢∪))(' '∘(≠⊆⊢)))¨X
PartB ← +/((≢≡(≢∪))(⍋⊃¨⊂)¨∘(' '∘(≠⊆⊢)))¨X
⎕ ← PartA PartB
)OFF
