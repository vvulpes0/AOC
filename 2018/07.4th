26 constant sz   5 constant workers
create in-a sz cells allot
create in-b sz cells allot
create tasks workers allot
create time  workers allot
variable mini    variable mint    variable total
: read ( -- ) sz 0 do 0 in-a i cells + ! loop
  begin pad 80 stdin read-line drop while
  drop 1 pad 5 + c@ 'A' - lshift
  pad 36 + c@ 'A' - cells in-a + @ or
  pad 36 + c@ 'A' - cells in-a + !
  repeat drop
  sz 0 do in-a i cells + @ in-b i cells + ! loop ;
: pop-step ( -- )
  sz 0 do in-a i cells + @ 0= if i leave then loop
  1 over lshift invert
  sz 0 do in-a i cells + @ over and in-a i cells + ! loop drop
  dup 'A' + emit
  cells in-a + -1 swap ! ;
: part-a ( -- "part a" ) sz 0 do pop-step loop bl emit ;
: clear-free ( -- ) workers 0 do
    time i + c@ 0= if
    1 tasks i + c@ lshift invert
    sz 0 do dup in-b i cells + @ and in-b i cells + ! loop drop
    -1 in-b tasks i + c@ cells + ! -1 tasks i + c!
  then loop ;
: pop-b ( -- ) 99999999 mint !
  workers dup 0 do tasks i + c@ 128 and if drop i then loop
  workers = if \ nobody free
    workers 0 do
      time i + c@ mint @ < if time i + c@ mint ! then loop
    workers 0 do time i + c@ mint @ - time i + c! loop
    clear-free
    mint @ total +!
  else \ at least one worker
    sz dup 0 do in-b i cells + @ 0=
      if 0 workers 0 do tasks i + c@ j = or loop invert
      if drop i leave then then loop
    dup sz = if drop \ nothing ready
      workers 0 do tasks i + c@ 128 and 0=
        if time i + c@ mint @ <
        if time i + c@ mint !
        then then loop
      workers 0 do time i + c@ mint @ - time i + c! loop
      clear-free
      mint @ total +!
    else
      workers 0 do tasks i + c@ 128 and
        if dup tasks i + c!
           \ dup 'A' + emit
           61 + time i + c! leave then loop
    then
  then ;
: part-b ( -- n ) workers 0 do -1 tasks i + c! loop
  begin pop-b -1 sz 0 do in-b i cells + @ 0< and loop until
  total @ ;
read part-a part-b . cr
bye
