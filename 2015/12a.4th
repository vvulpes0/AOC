: add ( sign sum num key -- sign sum num )
  '0' -
  dup 0< invert over 10 < and
  if swap 10 * + else drop rot * + 1 swap 0 then
;
: maybe-neg ( sign sum num key -- sign sum num next/key )
  dup '-' = if drop rot negate rot rot key then
;

: sum-nums ( sign sum num  -- sign sum num )
  key begin maybe-neg add key dup 4 = until add
;

1 0 0 sum-nums rot drop drop . cr
bye
