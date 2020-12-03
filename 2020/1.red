Red [
  Title: {AoC 2020 - Day 1}
  Date: 01-12-2020
]

data: load %data/1.txt

lower_bound: [data val] [
  count: length data
  step: 0
  until [
    probe count2: round/floor (count / 2)
    mid: at data count
    count: either mid < val [
      data: next mid
      add count2 1
    ] [
      count 2
    ]
    count <= 0
  ]
  data
]

; --- Part 1 ---
r1: 0
foreach value data [
  foreach value2 data [
    if 2020 = (value + value2) [
      r1: value * value2
      break
    ]
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach value data [
  foreach value2 data [
    value3: 2020 - (value2 + value)
    if find data value3 [ r2: value * value2 * value3 break ]
  ]
]
print [{Part 2:} r2]
