X ← ⊃⊃⎕NGET '17.txt' 1
'md5' ⎕NA './md5.dylib|md5 <0C1[] >C1[32]'
MD5 ← md5(32,⍨⊂)
⍝ start: 0J0; target: 3J¯3
⍝ hash first four UDLR
IsValid ← (⊃(((0≤⌊)∧(3≥⌈))/9 11∘○))
Seek ← { ⍝ (base target) Seek (pos path) (pos path) ...
	base target ← ⍺
	0≡≢⍵: 'error: no path'
	pos path ← ⊃⍵
	pos≡target: path
	nexts ← 0J¯1 0J1 ¯1 1+pos
	valids ← (4↑MD5 (base,path))∊'bcdef'
	valids ← valids ∧ IsValid¨nexts
	nexts ← nexts(,∘⊂)¨('UDLR',⍨¨⊂path)
	⍺∇1↓⍵,valids/nexts
}
LSeek ← { ⍝ (base target d) LSeek (pos path) (pos path) ...
	base target d ← ⍺
	0≡≢⍵: d
	pos path ← ⊃⍵
	pos≡target: (base target (≢path))∇1↓⍵
	nexts ← 0J¯1 0J1 ¯1 1+pos
	valids ← (4↑MD5 (base,path))∊'bcdef'
	valids ← valids ∧ IsValid¨nexts
	nexts ← nexts(,∘⊂)¨('UDLR',⍨¨⊂path)
	⍺∇1↓⍵,valids/nexts
}
PartA ← (X 3J3) Seek ⊂(0 '')
PartB ← (X 3J3 ¯1) LSeek ⊂(0 '')
⎕ ← PartA PartB
)OFF
