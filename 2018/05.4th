50000 constant sz   variable szA   variable minSZ
create in sz allot    create inB sz allot
: read sz 0 do key dup in i + c! inB i + c! loop sz szA ! ;
: condense 0 1 begin
  dup 1- in + c@ over in + c@ xor 32 <>
  if over in + over in + 1- c@ swap c! swap 1+ swap else
     1+
  then 1+
  dup szA @ < invert until 1-
  dup 1- in + c@ over in + c@ xor 32 <>
  if over in + over in + 1- c@ swap c! swap 1+ swap then
  drop szA ! ;
: part-a begin szA @ condense szA @ = until ;
: remove ( c -- count ) 0 sz 0
  do over in i + c@ xor 32 invert
  and if in i + c@ over in + c! 1+ then loop nip ;
: part-b 999999 minSZ !
  26 0 do
    sz 0 do inB i + c@ in i + c! loop
    i 'A' + remove szA ! part-a
    szA @ minSZ @ < if szA @ minSZ ! then
  loop ;
read part-a szA @ . part-b minSZ @ . cr bye
