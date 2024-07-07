X ← ⊃⎕NGET '23.txt' 1
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
Execute ← {
	instrs a b c d pc ← ⍵
	(pc-⎕IO)≥≢instrs: ⍵
	instr ← ' '(≠⊆⊢)pc⊃instrs
	'cpy'≡⊃instr: ∇instr Copy ⍵
	'dec'≡⊃instr: ∇instr Dec ⍵
	'inc'≡⊃instr: ∇instr Inc ⍵
	'jnz'≡⊃instr: ∇instr Jnz ⍵
	'tgl'≡⊃instr: ∇instr Tgl ⍵
}
⍝PartA ← 'a' Read Execute (X  7 0 0 0 ⎕IO)
⍝PartB ← 'a' Read Execute (X 12 0 0 0 ⎕IO)
PartA ← (! 7) + ×/⍎¨(⎕IO+1 4)⊃¨⊂' '(≠⊆⊢)⊃Flatten 20 21 ⊃¨⊂ X
PartB ← (!12) + ×/⍎¨(⎕IO+1 4)⊃¨⊂' '(≠⊆⊢)⊃Flatten 20 21 ⊃¨⊂ X
⎕ ← PartA PartB
)OFF
