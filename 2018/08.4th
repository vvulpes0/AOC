create in 20000 cells allot   variable sz    variable c
: num ( -- n key )
  0 begin key '0' - dup 0< invert over 9 > invert and while
  swap 10 * + repeat '0' + ;
: read ( -- ) 0 sz !
  begin num bl = while in sz @ cells + ! 1 sz +! repeat
  in sz @ cells + ! 1 sz +! ;
: add-metatree ( n c -- n' c' )
  dup cells in + @ over 1+ cells in + @ >r >r 2 +
  r> ?dup if 0 do recurse loop then
  r> ?dup if 0 do dup cells in + @ rot + swap 1+ loop then ;
: part-a ( -- n ) 0 0 add-metatree drop ;
: add-metabee ( c -- n c' )
  dup cells in + @ over 1 + cells in + @ >r >r 2 +
  r> ?dup if \ nonzero children
    200 cells allocate throw
    200 0 do dup i cells + 0 swap ! loop rot rot
    0 do over swap recurse swap rot i 1+ cells + ! loop
    0 swap r> ?dup if 0 do ( addr n c' )
      dup cells in + @
      ?dup if >r >r over r> swap r> cells + @ rot + swap then 1+
    loop then rot free drop
  else \ zero children
    0 swap r> ?dup if 0 do ( n c' )
      dup cells in + @ rot + swap 1+
    loop then then ;
: part-b ( -- n ) 0 0 add-metabee drop + ;
read part-a . part-b . cr
bye
