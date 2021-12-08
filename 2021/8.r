REBOL [
  Title: {AoC 2021 - Day 8}
  Date: 08-12-2021
]

; import utility functions
do %util.r

; split-once utility function
split: funct [
  data [series!]
  delimiter [block! integer! char! bitset! any-string!]
][
  it: find data delimiter
  reduce [(copy/part data it) (next it)]
]

; parse data into displays as a list of [digits [block!] output [block!]]
data: read/lines %data/8.txt
displays: collect [forall data [keep split parse data/1 none "|"]]

; --- Part 1 ---
r1: 0
foreach [signals output] displays [
  foreach digits output [
    if find [2 3 4 7] length? digits [++ r1]
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
decode: func [
  signals [series!]
  output [series!]
][
  segments: array/initial 7 [] ; signals ordered by segment count
  perm: copy []                ; list of permutations
  forall signals [
    append segments/(length? signals/1) sort signals/1
  ]
  
  ; find unique signals
  one: segments/2/1
  four: segments/4/1
  seven: segments/3/1
  eight: segments/7/1
  ; six is the only 6-segment-digit to share only one segment with one
  foreach sig segments/6 [all [equal? 1 length? intersect sig one  six: sig  break]]
  append perm reduce [(difference six eight) "c"]
  ; nine is the only 6-segment-digit to share all segments with four
  foreach sig segments/6 [all [equal? 4 length? intersect sig four  nine: sig  break]]
  append perm reduce [(difference nine eight) "e"]
  ; zero is the remaining 6-segment digit
  foreach sig segments/6 [if not any [sig = six  sig = nine][zero: sig  break]]
  append perm reduce [(difference zero eight) "d"]
  ; three is the only 5-segment-digit to share two segments with one
  foreach sig segments/5 [all [equal? 2 length? intersect sig one  three: sig  break]]
  append perm reduce [(difference three nine) "b"]
  ; five is contained in nine
  foreach sig segments/5 [
    all [
      sig <> three  
      either (equal? 5 length? intersect sig nine) [five: sig][two: sig]
    ]
  ]

  mapping: reduce[zero one two three four five six seven eight nine]
  to-integer rejoin map-each digit output [(index? find mapping (sort digit)) - 1]
]
r2: 0
foreach [signals output] displays [+= r2 decode signals output]
print [{Part 2:} r2]
