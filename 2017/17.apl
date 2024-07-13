X ← ⍎⊃⊃⎕NGET '17.txt' 1
⎕IO ← 0
Insert ← {
	p ns ← ⍵
	q ← (≢ns)|p+X
	ns ← ns,≢ns
	(q+1) ((¯1∘⌽@(,q+1+⍳(≢ns)-q+1))ns)
}
PartA ← (⌷⍨∘(1∘+))⍨/(Insert⍣2017) 0 0
∇ z ← PartB
[1]	i p z ← 1 0 0
[2]	p ← 1+i|p+X
[3]	z ← (p=1)⌷z i
[4]	i ← i + 1
[5]	→(i≤50000000)/2
∇
⎕ ← PartA PartB
)OFF
