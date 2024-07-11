target := 36000000;;
a := 0;; repeat a := a + 1; until 10*Sigma(a)>=target;
b := 0;;
repeat
        b := b + 1;
        s := 0;
        for d in DivisorsInt(b) do
                if Int(b/d) <= 50 then
                        s := s + 11*d;
                fi; 
        od;
until s >= target;
Print(a," ",b,"\n");
