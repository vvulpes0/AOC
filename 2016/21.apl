⎕IO ← 0
X ← ⊃⎕NGET '21.txt' 1
Words ← ' '∘(≠⊆⊢)
SwapP ← {(((⌽⍺)⊃¨⊂⍵)@⍺)⍵}
SwapL ← {((⊃¨∘(⊂⌽⍺))⍺∘⍳)@(∊∘⍺¨)⍵}
RotB ← (-(+∘(1+≥∘4))⍨⍤(⍸⍷))⌽⊢
UnRotB ← ((⍸⍷)(⊣-(⍸⍷))(≢|((+∘(+∘1))⍨+(≥∘4))¨)∘(⍳≢)⍤⊢)⌽⊢
RevR ← {(⌽@((0=(((+∘1)@1)⍺)⍸⍳≢⍵)⍨⊢))⍵}
MoveR ← {((1∘⌽)@((0=(((+∘1)@1)⍺)⍸⍳≢⍵)⍨⊢))⍵}
MoveL ← {((¯1∘⌽)@((0=(((+∘1)@1)(⌽⍺))⍸⍳≢⍵)⍨⊢))⍵}
Move ← { >/⍺: ⍺MoveL⍵ ⋄ ⍺MoveR⍵ }
Act ← {
	0∊'swap position'(⍸⍷)⍺: (⍎¨2 5⊃¨⊂(Words ⍺))SwapP⍵
	0∊'swap letter'(⍸⍷)⍺: (∊2 5⊃¨⊂(Words ⍺))SwapL⍵
	0∊'rotate left'(⍸⍷)⍺: (⍎2⊃Words ⍺)⌽⍵
	0∊'rotate right'(⍸⍷)⍺: (-⍎2⊃Words ⍺)⌽⍵
	0∊'rotate based'(⍸⍷)⍺: (6⊃Words ⍺)RotB⍵
	0∊'reverse positions'(⍸⍷)⍺: (⍎¨2 4⊃¨⊂(Words ⍺))RevR⍵
	0∊'move position'(⍸⍷)⍺: (⍎¨2 5⊃¨⊂(Words ⍺))Move⍵
}
UnAct ← {
	0∊'swap position'(⍸⍷)⍺: (⍎¨2 5⊃¨⊂(Words ⍺))SwapP⍵
	0∊'swap letter'(⍸⍷)⍺: (∊2 5⊃¨⊂(Words ⍺))SwapL⍵
	0∊'rotate left'(⍸⍷)⍺: (-⍎2⊃Words ⍺)⌽⍵
	0∊'rotate right'(⍸⍷)⍺: (⍎2⊃Words ⍺)⌽⍵
	0∊'rotate based'(⍸⍷)⍺: (6⊃Words ⍺)UnRotB⍵
	0∊'reverse positions'(⍸⍷)⍺: (⍎¨2 4⊃¨⊂(Words ⍺))RevR⍵
	0∊'move position'(⍸⍷)⍺: (⍎¨5 2⊃¨⊂(Words ⍺))Move⍵
}
PartA ← ⊃Act/(⌽X),⊂'abcdefgh'
PartB ← ⊃UnAct/X,⊂'fbgdceah'
⎕ ← PartA PartB
)OFF
