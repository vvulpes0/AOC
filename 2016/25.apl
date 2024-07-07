X ← ⊃⎕NGET '25.txt' 1
Flatten ← ,∘(' '∘,)/
Reg ← ⍸⍷∘' abcd '
Read ← ⍎∘⍕∘⊃(((⊂∘Reg⊣)(∊⌷)⊢),(⊂⊣))
Advance ← (+∘1)@(5+⎕IO)
Copy ← { _ src dst ← ⍺ ⋄ ((src Read ⍵)@(Reg dst)Advance) ⍵ }
Dec ← { _ dst ← ⍺ ⋄ ((-∘1)@(Reg dst)Advance) ⍵ }
Inc ← { _ dst ← ⍺ ⋄ ((+∘1)@(Reg dst)Advance) ⍵ }
Jnz ← {
	_ cond dsp ← ⍺
	0≡cond Read⍵: Advance ⍵
	(dsp Read ⍵)(+@(5+⎕IO)) ⍵
}
Tgl ← {
	_ dsp ← ⍺
	dsp ← dsp Read ⍵
	instrs a b c d pc ← ⍵
	(dsp+pc-⎕IO)≥(≢instrs): Advance ⍵
	instr ← ' '(≠⊆⊢)(dsp+pc)⊃instrs
	rep ← {((Flatten((⊂⍵)@⎕IO)instr)@(dsp+pc))instrs}
	use ← {(rep ⍵) a b c d (pc+1)}
	'inc'≡⊃instr: use 'dec'
	2≡≢instr: use 'inc'
	'jnz'≡⊃instr: use 'cpy'
	use 'jnz'
}
Out ← {
	_ val ← ⍺
	⎕ ← ('a' Read ⍵) (val Read ⍵)
	Advance ⍵
}
Execute ← {
	instrs a b c d pc ← ⍵
	(pc-⎕IO)≥≢instrs: ⍵
	instr ← ' '(≠⊆⊢)pc⊃instrs
	'cpy'≡⊃instr: ∇instr Copy ⍵
	'dec'≡⊃instr: ∇instr Dec ⍵
	'inc'≡⊃instr: ∇instr Inc ⍵
	'jnz'≡⊃instr: ∇instr Jnz ⍵
	'tgl'≡⊃instr: ∇instr Tgl ⍵
	'out'≡⊃instr: ∇instr Out ⍵
}

⍝PartA ← 'a' Read Execute (X  182 0 0 0 ⎕IO)
Go ← (⊃(⊢(/⍨)<)∘((2⊥⍴∘1 0)¨⍤(0 1∘+)(⌈2∘⍟)))⍨-⊢
PartA ← Go ×/⍎¨(⎕IO+1 4)⊃¨⊂' '(≠⊆⊢)⊃Flatten 1↓3↑X
⎕ ← PartA
)OFF
