( num key -- num' )
: add '0' - swap 10 * + ;
( -- """infinity""" )
: inf 9999999999999999 ;
( -- cksum )
: go 0 inf 0 0 begin
  key dup 4 - while
  dup  9 = if drop rot over min rot rot max 0                else
  dup 10 = if drop rot over min rot rot max swap - + inf 0 0 else
           add
  then then
  repeat drop drop drop drop ;
go . CR
bye
