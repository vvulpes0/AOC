create buf   82 chars allot   variable  mink 999999 mink  !
create  fs 1000 cells allot   variable   nfs      0 nfs   !
                              variable  repi
: num ( addr u -- n ) swap
  dup c@ '-' = if 1+ swap 1- -1 else
  dup c@ '+' = if 1+ swap 1-  1 else
                  swap 1
  then then rot rot 0. 2swap >number 2drop drop * ;
: part-a ( -- ) 0 begin buf 80 stdin read-line drop while
  buf swap num + dup fs nfs @ cells + ! 1 nfs +! repeat drop ;
: part-b ( n -- n' ) nfs @ 1 do i 0 do
  fs i cells + @ fs j cells + @ - over /mod swap
  0= if abs dup mink @ < if mink ! i repi ! else drop then
   else drop then
  loop loop fs repi @ cells + @ ;
part-a dup . part-b . CR bye
