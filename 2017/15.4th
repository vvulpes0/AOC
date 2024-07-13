     16807 constant amul      277 constant astart
     48271 constant bmul      349 constant bstart
2147483647 constant modulus
: gen_a ( count a b -- count' a' b' )
  bmul modulus */mod drop swap
  amul modulus */mod drop swap
  over 0xFFFF and over 0xFFFF and = if rot 1+ rot rot then ;
: gen_b ( count a b -- count' a' b' )
  begin bmul modulus */mod drop dup 7 and 0= until swap
  begin amul modulus */mod drop dup 3 and 0= until swap
  over 0xFFFF and over 0xFFFF and = if rot 1+ rot rot then ;
: main ( -- )
  0 astart bstart 40000000 0 do gen_a loop drop drop .
  0 astart bstart  5000000 0 do gen_b loop drop drop .
  CR ;
main bye
