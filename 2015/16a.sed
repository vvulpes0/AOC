#!/usr/bin/env sed -f
/children:/!bchildrenOK
/children: [^3]/d
/children: 3[0-9]/d
:childrenOK
/cats:/!bcatsOK
/cats: [^7]/d
/cats: 7[0-9]/d
:catsOK
/samoyeds:/!bsamoyedsOK
/samoyeds: [^2]/d
/samoyeds: 2[0-9]/d
:samoyedsOK
/pomeranians:/!bpomeraniansOK
/pomeranians: [^3]/d
/pomeranians: 3[0-9]/d
:pomeraniansOK
/akitas:/!bakitasOK
/akitas: [^0]/d
/akitas: 0[0-9]/d
:akitasOK
/vizslas:/!bvizslasOK
/vizslas: [^0]/d
/vizslas: 0[0-9]/d
:vizslasOK
/goldfish:/!bgoldfishOK
/goldfish: [^5]/d
/goldfish: 5[0-9]/d
:goldfishOK
/trees:/!btreesOK
/trees: [^3]/d
/trees: 3[0-9]/d
:treesOK
/cars:/!bcarsOK
/cars: [^2]/d
/cars: 2[0-9]/d
:carsOK
/perfumes:/!bperfumesOK
/perfumes: [^1]/d
/perfumes: 1[0-9]/d
:perfumesOK
s/^Sue \([0-9]*\)[^0-9].*/\1/
