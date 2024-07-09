( sign sum num key -- sign sum num )
: add '0' - dup 0< invert over 10 < and
  if swap 10 * + else drop rot * + 1 swap 0 then ;
( sign sum num key -- sign sum num next/key )
: maybe-neg dup '-' = if drop rot negate rot rot key then ;

( states: 0=free, 1='{', 2='{:', 3='{:"', 4='{:"r', 5='{:"re',
          6='{:"red', 7='{:"red"' )
: close rot * + >r rot * + r> + 1 swap 0 ;
: clear-obj begin key dup '{' = if drop recurse key then '}' = until ;
: process 1 0 0 0 >r
  begin
  i   0= if
    key dup '{' =
    if r> 1 + >r drop 1 >r 1 0 0 '{'
    else maybe-neg dup >r add r> then
  else i 1  = if
    key dup ':' = if r> 1 + >r else
        dup '{' = if drop 1 >r 1 0 0 '{' else
        dup '}' = if drop r> drop close '}' else
          maybe-neg dup >r add r>
        then then then
  else i 2  = if
    key dup '"' = if r> 1 + >r else
        dup ',' = if r> drop 1 >r else
        dup '}' = if drop r> drop close '}' else
        dup '{' = if drop 1 >r 1 0 0 '{' else
          r> drop 1 >r
          maybe-neg dup >r add r>
        then then then then
  else i 3  = if
    key dup 'r' = if r> 1 + >r
    else maybe-neg dup >r add r> r> drop 1 >r then
  else i 4  = if
    key dup 'e' = if r> 1 + >r
    else maybe-neg dup >r add r> r> drop 1 >r then
  else i 5  = if
    key dup 'd' = if r> 1 + >r
    else maybe-neg dup >r add r> r> drop 1 >r then
  else i 6  = if
    key dup '"' = if r> 1 + >r
    else maybe-neg dup >r add r> r> drop 1 >r then
  else i 7  = if drop drop drop r> drop clear-obj '}'
  then then then then then then then then
  4 = until r> drop
;

process rot * + . CR
bye
