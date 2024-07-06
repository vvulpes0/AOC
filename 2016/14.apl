X ← ⊃⊃⎕NGET '14.txt' 1
'md5' ⎕NA './md5.dylib|md5 <0C1[] >C1[32]'
MD5 ← md5(32,⍨⊂)
EqualTriples ← ⊃¨∘((/⍨∘((1≡(≢∪))¨))⍨)3∘(,/)
EqualQuints ← ⊃¨∘((/⍨∘((1≡(≢∪))¨))⍨)5∘(,/)
Cache ← ⍬
Indices ← ⍬
∇R ← salt_n Go index;salt;n
[1]	salt n ← salt_n
[2]	→(index≥≢Cache)/5
[3]	R ← ⊃Cache[index+⎕IO]
[4]	→¯1
[5]	R ← (MD5⍣n)(salt,⍕≢Cache)
[6]	Cache ← Cache,(⊂R)
[7]	→(index≢(≢Cache)-1)/5
∇
∇R ← req GenerateKeys salt_n;i;j;x;ts;qs
[ 1]	Cache ← Indices ← ⍬
[ 2]	i ← 0
[ 3]	x ← salt_n Go i ⍝ finding a triple
[ 4]	ts ← EqualTriples x
[ 5]	i +← 1
[ 6]	→(0≡≢ts)/3 ⍝ loop until a triple is found
[ 7]	j ← 0 ⍝ finding quintuples, in the next up-to-1000 entries
[ 8]	x ← salt_n Go (i+j)
[ 9]	qs ← EqualQuints x
[10]	→((⊃ts)∊qs)/14 ⍝ key found, log it
[11]	j +← 1
[12]	→(j≡1000)/3 ⍝ not a key
[13]	→8 ⍝ not a key YET but could be
[14]	Indices ← Indices,(i-1)
[15]	→((≢Indices)<req)/3 ⍝ find next until requested number found
[16]	R ← Indices
∇
PartA ← ⊃⌽64 GenerateKeys (X 1)
PartB ← ⊃⌽64 GenerateKeys (X 2017)
⎕ ← PartA PartB
