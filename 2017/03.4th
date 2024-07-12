: sqrt -1 swap over do 2 + dup +loop 2/ ;
368078 constant input
input
dup sqrt dup 1+ 2 mod - 2 +
over over dup * swap -
over 1- mod
over 2/ - abs
swap 2/ +
swap drop
.

create spiral 256 cells allot
create xc 256 cells allot
create yc 256 cells allot
variable x
variable y
variable ind
variable times
: init
  0 dup xc ! yc ! 0 dup x ! y ! 1 ind ! 1 times !
  begin
    times @ 0 do
      xc ind @ 1- cells + @ 1+ xc ind @ cells + !
      yc ind @ 1- cells + @    yc ind @ cells + !
      ind @ 1+ ind !
    loop
    times @ 0 do
      xc ind @ 1- cells + @    xc ind @ cells + !
      yc ind @ 1- cells + @ 1+ yc ind @ cells + !
      ind @ 1+ ind !
    loop
    times @ 1+ times !
    times @ 0 do
      xc ind @ 1- cells + @ 1- xc ind @ cells + !
      yc ind @ 1- cells + @    yc ind @ cells + !
      ind @ 1+ ind !
    loop
    times @ 0 do
      xc ind @ 1- cells + @    xc ind @ cells + !
      yc ind @ 1- cells + @ 1- yc ind @ cells + !
      ind @ 1+ ind !
    loop
    times @ 1+ times !
  ind @ 200 >= until ;
: part-b init
  1 spiral ! 0
  200 1 do
    drop 0
    i 0 do
      xc i cells + @ xc j cells + @ - abs 2 <
      yc i cells + @ yc j cells + @ - abs 2 < and
      if spiral i cells + @ + then
    loop
    dup spiral i cells + !
    dup input > if leave then
  loop
;
part-b . CR
bye
