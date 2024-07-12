variable size variable quot create row 64 cells allot
( num key -- num' )
: add '0' - swap 10 * + ;
( x1 ... xn n -- quot)
: analyze
  dup size ! 0 do row i cells + ! loop
  size @ 0 do size @ 0 do
    i j = if else
      row i cells + @ row j cells + @ over over
      mod 0= if / quot ! else drop drop then then
  loop loop quot @ ;
( -- cksum )
: go 0 0 0 begin
  key dup 4 - while
  dup  9 = if drop swap 1+ 0             else
  dup 10 = if drop swap 1+ analyze + 0 0 else
           add
  then then
  repeat drop drop drop ;
go . CR
bye
