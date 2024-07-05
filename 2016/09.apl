X ← ∊⊃⎕NGET '09.txt' 1
⎕PP ← 20
Nums ← (((×∘(+\~))⍨(∊∘⎕D))(⍎¨⊆)⊢)(,∘' 0')
SkipClose ← 1↓(/⍨∘(∨\(')'∘=)))⍨
PostRep ← (⊃Nums)↓SkipClose
DoRep ← (⊂(PostRep⊃)),(((×/2↑Nums)⊃)+(2∘⌷))
DoPlain ← (⊂(1↓⊃)),(1+(2∘⌷))
GoA ← (⎕IO+(('('∘=)(⊃⊃)))⊃(DoPlain(,⍥⊂)DoRep)
PartA ← (1+⎕IO)⊃GoA⍣((''≡⊃)⊣) X 0

Length ← {
	''≡⍵: 0
	'('≢⊃⍵: 1+∇(1↓⍵)
	(((1(⊃↓)Nums)(×∘∇)((⊃Nums)↑SkipClose))⍵)+∇((⊃Nums)↓SkipClose)⍵
}
PartB ← Length X

⎕ ← PartA PartB
)OFF
