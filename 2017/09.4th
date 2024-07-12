: main 0 >r 0 0 begin
  key dup 4 - while
  dup '{' = if drop r> 1+ dup >r +                      else
  dup '}' = if drop r> 1- >r                            else
  dup '!' = if drop key drop                            else
  dup '<' = if drop begin key dup '>' - while
    dup '!' = if drop key drop else
                 drop swap 1+ swap then repeat drop     else
            drop
  then then then then
  repeat drop r> drop ;
main . . CR
bye
