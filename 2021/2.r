REBOL [
  Title: {AoC 2021 - Day 2}
  Date: 02-12-2021
]

data: load %data/2.txt

+=: func ['val [word!] inc] [set val add get val inc]
-=: func ['val [word!] inc] [set val subtract get val inc]

; --- Part 1 ---
x: 0 y: 0
forskip data 2 [
  dir: data/1 val: data/2
  switch dir [
    forward [+= x val]
    up      [-= y val]
    down    [+= y val]
  ]
]
r1: multiply x y
print [{Part 1:} r1]

; --- Part 2 ---
x: 0 y: 0 aim: 0
forskip data 2 [
  dir: data/1 val: data/2
  switch dir [
    forward [+= x val += y multiply val aim]
    up      [-= aim val]
    down    [+= aim val]
  ]
]
r2: multiply x y
print [{Part 2:} r2]
