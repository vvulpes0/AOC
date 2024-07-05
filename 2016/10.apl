X ← ⊃⎕NGET '10.txt' 1
⎕IO ← 0 ⍝ Bots and Outputs are 0-indexed, so make the system match
Words ← ' '∘(≠⊆⊢)
NBots ← 1+⌈/⍎¨(/⍨∘(¯1⌽(('bot'∘≡)¨)))⍨ (⊃(,/(Words¨))) X
Select ← {⍺←⍵⋄(⍺⍺ ⍵)/⍺}

Repl ← ('1'@(('output'∘≡)¨))('0'@(('bot'∘≡)¨))
MkBot ← (((⊂0 1)∘⊃),(1∘(⊂↓)))∘(3 2∘⍴)∘(⍎¨)∘(((∧/(∊∘⎕D))¨)Select)∘Repl∘Words

Sort ← ⍋⊃¨⊂
Nums ← ((×∘(+\~))⍨(∊∘⎕D))(⍎¨⊆)⊢
ValueInstrs ← (/⍨∘(('v'=⊃)¨))⍨
Bots ← ↓¨ 1⊃¨ Sort MkBot¨ (/⍨∘(('b'=⊃)¨))⍨ X
Insert ← {(((⊃⍺)((⊂Sort),)∊)@(1⌷⍺))⍵}
⍝ Used like (5 2 Insert ⊂⍬) to insert 5 at position 2
Initials ← ⊃(Insert/((,∘(⊂NBots⍴⊂⍬))(Nums¨ValueInstrs)))

⍝ state will be a matrix with held items on top and outputs on bottom
InitialState ← (,[⎕IO-0.5]∘(⍬⍨¨⊢))⍨Initials X
Update ← { ⍝ State as ⍵
	ladenBots ← ⊃,/⊃¨↓¨Bots((2≡≢)¨(⎕IO⊃↓))Select ⍵
	heldItems ← ∊↓(2≡≢)¨Select⊃↓⍵
	insertions ← ↓⍉heldItems,[⎕IO-0.5]ladenBots
	base ← (((⊂⍬)@((2≡≢)¨)⊃↓⍵)@⎕IO)⍵
	⊃Insert/insertions,⊂base
}
Filled ← ∧/⍤((0≢≢)¨(3↑((⎕IO+1)⌷⊣)))
PartA ← ⊃⌽∊⍸(⊂(17 61))⍷(Update⍣((⊂17 61)∊(⎕IO⌷⊣))) InitialState
PartB ← ⊃×/3↑(⎕IO+1)⌷(Update⍣Filled)InitialState
⎕ ← PartA PartB
)OFF
