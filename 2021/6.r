REBOL [
  Title: {AoC 2021 - Day 6}
  Date: 06-12-2021
]

; import utility functions
do %util.r

data: map-each int parse read %data/6.txt "," [to-integer int]

; encode fishes as key-value pairs of day / fishes
; ! day = 0 is encoded with index 1 (because rebol)
fishes: array/initial 9 0.0
map-each i data [fishes/(i + 1): 1 + fishes/(i + 1)]

step-fish: funct [
  fishes [series!] {the number of fish at each day}
][
  spawn-count: fishes/1
  remove at fishes 1
  append fishes spawn-count
  fishes/(6 + 1): add fishes/(6 + 1) spawn-count
  fishes 
]

; --- Part 1 ---
fishes1: copy fishes  repeat _ 80 [step-fish fishes1]
r1: 0.0  forall fishes1 [+= r1 fishes1/1]
print [{Part 1:} r1]

; --- Part 2 ---
fishes2: copy fishes  repeat _ 256 [step-fish fishes2]
r2: 0.0  forall fishes2 [+= r2 fishes2/1]
print [{Part 2:} r2]
