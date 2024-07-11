numeric digits 20
main_routine:
  filein = "24.txt"
  i = 1
  data.0 = 0
  do while lines(filein)>0
    data.i = linein(filein)
    data.0 = data.0 + 1
    i = i + 1
  end

  target = 0
  i = 0
  do while i < data.0
    i = i + 1
    target = target + data.i
  end

  i = 0
  do until result>0
    i = i + 1
    call combinations i
    call min_prod (target/3)
  end
  part_a = result

  i = 0
  do until result>0
    i = i + 1
    call combinations i
    call min_prod (target/4)
  end
  part_b = result
  say part_a part_b
  exit 0

min_prod: procedure expose combos.
  parse arg reach
  i = 0
  min = -1
  p = i
  do while i < combos.0
    i = i + 1
    prod = 1
    sum = 0
    j = 0
    do while j < combos.i.0
      j = j + 1
      prod = prod * combos.i.j
      sum = sum + combos.i.j
    end
    if sum == reach & (min < 0 | prod < min) then
    do
      min = prod
      p = i
    end
  end
  return min

combinations: procedure expose combos. data.
  parse arg num
  pos.0 = num
  i = 0
  do num
    i = i + 1
    pos.i = i
  end
  drop combos.
  combos.0 = 0
  do while pos.1 <= data.0 - num + 1
    combos.0 = combos.0 + 1
    t = combos.0
    i = 0
    do while i < pos.0
      i = i + 1
      p = pos.i
      combos.t.i = data.p
    end
    combos.t.0 = pos.0

    t = pos.0
    do while t>0
      pos.t = pos.t + 1
      u = t - 1
      if t > 1 & pos.t > data.0 - num + t then
      do
        pos.t = pos.u + 2
        t = t + 1
        do while t <= pos.0
          v = t - 1
          pos.t = pos.v + 1
          t = t + 1
        end
        t = u
      end
      else
        t = 0
    end
  end
