REBOL [
Title: {AoC 2020 - Day 9}
Date: 09-12-2020
]

data: load %data/9.txt

is-valid-xmas-number: func [
  data [series! block!]
  length [integer!]
  /local nums
][
  nums: copy/part skip data negate length length
  forall nums [all [find next nums (data/1 - nums/1) return true]]
  false
]
is-valid-xmas-code: func [
  data [series! block!]
  length [integer!]
][
  data: skip data length
  while [is-valid-xmas-number data length] [data: next data]
  either tail? data [compose [true none]][compose [false (data/1)]]
]
; --- Part 1 ---
r1: pick is-valid-xmas-code data 25 2
print [{Part 1:} r1]

find-range-sum: func [
  p [series! block!]
  value [integer!]
  /local acc range
][
  acc: 0 range: copy []
  until [acc: acc + p/1 append range p/1 p: next p greater-or-equal? acc value]
  either equal? acc value [range][none]
]
; --- Part 2 ---
r2: 0
forall data [
  range: find-range-sum data r1
  if range [r2: (first maximum-of range) + (first minimum-of range) break]
]
print [{Part 2:} r2]