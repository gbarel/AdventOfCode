REBOL [
  Title: {AoC 2021 - Day 1}
  Date: 01-12-2021
]

data: load %data/1.txt

++: func ['val [word!]] [set val 1 + get val]

count-inc: func [data [series!]] [
  count: 0 it: data
  until [
    all [lesser? it/1 it/2 ++ count]
    it: next it tail? next it
  ]
  count
]

; --- Part 1 ---
r1: count-inc data
print [{Part 1:} r1]

; --- Part 2 ---
; copy data ; for each element, add next two elements ; remove last two elements
it: data2: copy data
until [it/1: do [it/1 + it/2 + it/3] it: next it tail? at it 3] remove it remove it

r2: count-inc data2
print [{Part 2:} r2]
