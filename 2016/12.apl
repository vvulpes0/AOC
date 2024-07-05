X ← ⊃⎕NGET '12.txt' 1
Reg ← ⍸⍷∘' abcd '
Read ← ⍎∘⍕∘⊃(((⊂∘Reg⊣)(∊⌷)⊢),(⊂⊣))
Advance ← (+∘1)@(5+⎕IO)
Copy ← { _ src dst ← ⍺ ⋄ ((src Read ⍵)@(Reg dst)Advance) ⍵ }
Dec ← { _ dst ← ⍺ ⋄ ((-∘1)@(Reg dst)Advance) ⍵ }
Inc ← { _ dst ← ⍺ ⋄ ((+∘1)@(Reg dst)Advance) ⍵ }
Jnz ← {
	_ cond dsp ← ⍺
	0≡cond Read⍵: Advance ⍵
	(Read dsp)(+@(5+⎕IO)) ⍵
}
Execute ← {
	instrs a b c d pc ← ⍵
	(pc-⎕IO)≥≢instrs: ⍵
	instr ← ' '(≠⊆⊢)pc⊃instrs
	'cpy'≡⊃instr: ∇instr Copy ⍵
	'dec'≡⊃instr: ∇instr Dec ⍵
	'inc'≡⊃instr: ∇instr Inc ⍵
	'jnz'≡⊃instr: ∇instr Jnz ⍵
	⍵
}
PartA ← 'a' Read Execute (X 0 0 0 0 ⎕IO)
PartB ← 'a' Read Execute (X 0 0 1 0 ⎕IO)
⎕ ← PartA PartB
)OFF
