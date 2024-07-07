⎕IO ← 0
Parse ← ⍎¨((∊∘⎕D)⊆⊢)
X ← Parse¨2↓⊃⎕NGET '22.txt' 1
Nodes ← (3 4⊃¨⊂)¨((1+2↑(⊃⌽))⍴⊢)X
∇ d ← FindHole;Q;MX;MY;x;y;Valid;Capacity;used;beside;seen
[ 1]	MX MY ← ⍴Nodes ⋄ Q ← ⊂(0 (MX-1) 0) ⋄ seen ← 1↓¨Q
[ 2]	Valid ← ∧/¨(0 0∘≤¨)∧(MX MY∘>¨)
[ 3]	Capacity ← +/∘(⊃∘Nodes)∘⊂
[ 4]	d x y ← ⊃Q
[ 5]	used ← ⊃(⊂x y)⊃Nodes
[ 6]	→((0=used)∨(0≡≢Q))/¯1
[ 7]	beside ← (/⍨∘Valid)⍨ ((1 0) (¯1 0) (0 1) (0 ¯1))+¨⊂(x y)
[ 8]	beside ← (/⍨∘(used≤Capacity¨))⍨beside
[ 9]	beside ← beside~seen
[10]	seen ← seen,beside
[11]	Q ← (1↓Q),((d+1),¨beside)
[12]	→4
∇
MLeq ← {((⊃⍺)≤(1⊃⍵)) ∧ (0≠⊃⍺)}
PartA ← +/∊((MLeq/¨∧(∘.≠)⍨∘(⍳≢))(∘.(,⍥⊂))⍨),Nodes
PartB ← FindHole+5×¯2+⊃⍴Nodes
⎕ ← PartA PartB
)OFF
