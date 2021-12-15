REBOL [
  Title: {Day 15}
  Date: 15-12-2021
]

; import utility functions
do %util.r

cavern: context [
  map: none
  use [] [
    map: collect [foreach l read/lines %data/test.txt [
      keep/only collect [foreach c l [keep c - #"0"]]
    ]]
  ]
]

; --- Part 1 ---
r1: 0
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
print [{Part 2:} r2]
