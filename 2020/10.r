REBOL [
  Title: {AoC 2020 - Day 10}
  Date: 10-12-2020
]

data: load %data/10.txt

count: func [
  series [series! string!] 
  value 
  /local cnt entry
][
  cnt: 0 foreach entry series [all [value = entry ++ cnt]] cnt
]

; --- Part 1 ---
r1: 0
diff: copy []
use [s] [
  s: sort append data 0
  s: next append s (last s) + 3
  diff: copy []
  forall s [append diff (first s) - (first back s)]
  print s print diff
  r1: (count diff 3) * (count diff 1)
]
print [{Part 1:} r1]

; --- Part 2 ---

list-permutations: func [
  data [series! block!]
  /local res acc p
][
  res: copy []
  if tail? data [return reduce [res]]
  acc: 0
  until [
    not all [
      lesser-or-equal? acc: (acc + data/1) 3
      ; print reduce [acc {[} next data {]}]
      foreach p list-permutations (data: next data) [
        ; print reduce [{* [} p {]}]
        append/only res (join reduce [acc] p)
      ]
      not tail? data
    ]
  ]
  res
]

r2: 0
use [arr] [
  r2: [1] arr: copy []
  foreach e diff [
    switch e [
      1 [append arr e]
      2 [append arr 2]
      3 [append r2 length? list-permutations arr arr: copy []]
    ]
  ]
  append r2 length? list-permutations arr
]
print reduce [{Part 2: 2 exp} count r2 2 {* 4 exp} count r2 4 {* 7 exp} count r2 7]
