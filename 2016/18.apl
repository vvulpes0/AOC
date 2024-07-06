X ← '^'=⊃⊃⎕NGET '18.txt' 1
Next ← (∨/(((1 1 0)(0 1 1)(1 0 0)(0 0 1))∘(≡¨))∘⊂)¨3,/0∘(⊣,,⍨)
∇R ← hold Solve row
[1]	R ← ⍬
[2]	count ← i ← 0
[3]	count +← +/~row
[4]	row ← Next row
[5]	i +← 1
[6]	→(∧/i>hold)/¯1
[7]	→(~i∊hold)/3
[8]	R ,← count
[9]	→3
∇
⎕ ← 40 400000 Solve X
)OFF
