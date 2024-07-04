X ← ⊃⎕NGET '08.txt' 1
⍝ w Rect h makes a w-wide, h-tall rectangle in the upper left.
⍝     combine it with a screen via ∨
Rect ← 6 50⍴((((50∘|,¨⌊⍤(÷∘50))(-∘⎕IO))⍳300)(∧/¨(<∘⊂)),)
⍝ x CRot n rotates column-x (0-indexed) n pixels downward
⍝     returns a sequence of rotations to apply via ⊖
CRot ← ((×∘-)⍨∘(((-∘⎕IO)⍳50)∘=))⍨
⍝ y RRot n rotates row-y (0-indexed) n pixels rightward
⍝     returns a sequence of rotations to apply via ⌽
RRot ← ((×∘-)⍨∘(((-∘⎕IO)⍳6)∘=))⍨

⍝ Mask indicates which adjustment is made. For example,
⍝ (Mask 'rect 10x3') is (1 0 0) indicating that the Rect should be used
Mask ← 'rect' 'row' 'column'∊(' '∘(≠⊆⊢))
⍝ Args extracts the numeric constants. For example,
⍝ (Args 'rect 10x3') is (10 3)
Args ← ((×∘(+\~))⍨(∊∘⎕D))(⍎¨⊆)⊢

⍝ state is (index[0-based] into instrs, instrs, screen)
Instr ← ((⎕IO+1),(⎕IO∘+⎕IO∘⌷))⊃⊢
Screen ← (⎕IO+2)∘⊃
Rected ← (⊃(Rect/Args∘Instr))∨Screen
RRolled ← (⊃(RRot/Args∘Instr))⌽Screen
CRolled ← (⊃(CRot/Args∘Instr))⊖Screen
NewScr ← ((Mask∘Instr)(∨/×)((Rected(,⍥⊂)RRolled),(⊂CRolled)))
Go ← (1∘+@⎕IO)((⊣@(2+⎕IO))⍨∘NewScr)⍨
PartB ← Screen (Go⍣(((⎕IO∘⊃)=(≢(⎕IO+1)∘⊃))⊣)) 0 X (6 50⍴0)
PartA ← +/∊PartB
⎕ ← PartA
⎕ ← ('#'@('1'∘=))(' '@('0'∘=))↑(∊⍕¨)¨↓PartB
)OFF
