#!/usr/bin/env sed -f
/children:/!bchildrenOK
/children: [^3]/d
/children: 3[0-9]/d
:childrenOK
/cats:/!bcatsOK
/cats: [1-9][0-9][0-9]*/bcatsOK
/cats: [8-9]/bcatsOK
d
:catsOK
/samoyeds:/!bsamoyedsOK
/samoyeds: [^2]/d
/samoyeds: 2[0-9]/d
:samoyedsOK
/pomeranians:/!bpomeraniansOK
/pomeranians: [1-9][0-9][0-9]*/bpomeraniansBAD
/pomeranians: [0-2]/bpomeraniansOK
:pomeraniansBAD
d
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
/goldfish: [1-9][0-9][0-9]*/bgoldfishBAD
/goldfish: [0-4]/bgoldfishOK
:goldfishBAD
d
:goldfishOK
/trees:/!btreesOK
/trees: [1-9][0-9][0-9]*/btreesOK
/trees: [4-9]/btreesOK
d
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
