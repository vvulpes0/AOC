create buf    80 chars allot         variable b
create primes 200000 cells allot     variable nprimes
: mknum 0. 2swap >number 2drop drop ;
: drop-line buf 80 stdin read-line 2drop drop ;
: ?prime ( n -- flag ) 1 swap nprimes @ 0 do
  dup primes i cells + @ mod 0= if nip 0 swap leave then
  loop drop ;
: read-num buf 80 stdin read-line 2drop 6 - buf 6 +
  dup c@ '-' = if 1+ swap 1- mknum negate else swap mknum then ;
: part-a ( -- "part A" b ) read-num dup 2 - dup * . ;
: part-b ( b -- "part B" ) 0 swap drop-line drop-line drop-line
  read-num * read-num - dup b ! drop-line read-num - 1+ 3 do
  i ?prime if i primes nprimes @ cells + ! 1 nprimes +! else
  i b @ < invert i b @ - 17 mod 0= and if 1+ else
  then then loop . ;
2 primes ! 1 nprimes ! part-a part-b CR bye
