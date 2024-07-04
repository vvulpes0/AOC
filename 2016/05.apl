X ← ⊃⊃⎕NGET '05.txt' 1
'md5' ⎕NA './md5.dylib|md5 <0C1[] >C1[32]'
MD5 ← md5(32,⍨⊂)
IDSum ← MD5((2∘⌷)(,⍥∊)(⍕1∘⌷))
HoldsChar ← ∧/('0'=(5↑IDSum))
FindChar ← (1∘+@1)⍣(HoldsChar⊣)
FillA ← ((,⍨¨@3)⍨∘(6⌷IDSum))⍨
Location ← (/⍨∘(<∘9))⍨((⎕D,⎕C⎕A)⍳(6⌷IDSum))
Unfilled ← (⍳8)/⍨⍥∊('?'∘=4∘⌷)
MarkLocs ← ((∊⍨∘(⍳8))(Location∩Unfilled))(,¨⍥∊)(4∘⌷)
BChar ← 7⌷IDSum
ReplacedB ← (2⌷(⍉↑))(BChar((⊂(0,⊣))@(1=⊃¨))MarkLocs)
FillB ← (((⊂⊣)@4)⍨∘ReplacedB)⍨

R ← ((FillB∘FillA∘FindChar)⍣((⍬≡Unfilled)⊣)) 0 X '' '????????'
⎕ ← 8↑¨2↓R
)OFF
