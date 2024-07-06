X ← ⊃⎕NGET '15.txt' 1
⎕IO ← 1
Nums ← ((×∘(+\~))⍨(∊∘⎕D))(⍎¨⊆)⊢
Parse ← ↓∘⍉∘↑(2 4⊃¨⊂∘Nums)¨
Delayed ← (1∘⊃(,⍨∘⊂)⍨|/)((0 1×(⍳≢)¨)+⊢)
∇ S0 ← X Inv Y;Q;R0;R1;S1
[1]	R0 R1 ← (Y|X) Y
[2]	S0 S1 ← 1 0
[3]	Q ← ⌊R0÷R1
[4]	S0 S1 ← S1 (S0 - Q×S1)
[5]	R0 R1 ← R1 (R0 - Q×R1)
[6]	→(R1≠0)/3
[7]	S0 +← (S0<0)×Y
∇
∇ I ← Go X
[1]	Divisors Locs ← Delayed X
[2]	LCMs ← (1@⎕IO)¯1⌽∧\Divisors
[3]	Invs ← LCMs Inv¨Divisors
[4]	I ← 0
[5]	Disc ← ⎕IO
[6]	Dists ← Divisors-(Divisors|(Locs+I))
[7]	I +← (Disc⊃LCMs)×(Disc⊃Divisors)|Invs×⍥(Disc∘⊃)Dists
[8]	Disc +← 1
[9]	→((Disc-⎕IO)<≢Locs)/6
∇

Parsed ← Parse X
PartA ← Go Parsed
PartB ← Go 11 0,⍨¨Parsed
⎕ ← PartA PartB
)OFF
