create input 25000 chars allot
variable lines   variable size   variable s1   variable s2
: part-a ( -- n ) 0 lines !
  0 0 begin pad 80 stdin read-line drop while
  dup size !  pad over input lines @ 100 * + swap cmove
  0 swap 0 swap 0 do
  0 i' 0 do pad i + c@ pad j + c@ = - loop
  dup 3 = swap 2 = >r or swap r> or swap
  loop swap >r - swap r> - swap
  1 lines +! repeat drop * ;
: part-b ( -- ) 0 s1 !
  lines @ 1 do
  i 0 do
  0 input 100 j * + input 100 i * +
  size @ 0 do
  over i + c@ over i + c@ <> negate >r rot r> + rot rot
  loop 2drop 1 = if input i 100 * + s1 ! input j 100 * + s2 ! then
  s1 @ 0<> if leave then loop
  s1 @ 0<> if leave then loop
  size @ 0 do s1 @ i + c@ s2 @ i + c@ = if s1 @ i + @ emit then
  loop cr ;
part-a . part-b
bye
