382 constant S  50000000 constant N  create pos 2017 cells allot
: partB ( -- partB )
  0 0 N 0 do
    S + i 1+ mod 1+ dup 1 = if swap drop i swap then
    i 2017 < if dup pos i cells + ! then
    loop drop 1+ ;
: partA ( -- partA )
  pos 2016 cells + @ 0 2015 do
    dup pos i cells + @ = if i 1+ leave then
    dup pos i cells + @ > if 1- then
    -1 +loop swap drop ;
partB partA . . CR
bye
