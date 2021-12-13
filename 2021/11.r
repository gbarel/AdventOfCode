REBOL [
  Title: {AoC 2021 - Day 11}
  Date: 11-12-2021
]

; import utility functions
do %util.r

; read heightmap as a series of strings
data: copy []
foreach line read/lines %data/11.txt [
  append/only data collect [
    foreach c line [keep c - #"0"]
  ]
]

; --- Part 1 ---
step-octopus: func [
  data [block!]
][
  flashes: copy [] ; series of positions as pairs
  dims: as-pair length? data/1 length? data
  repeat x dims/x [repeat y dims/y[
    data/:y/:x: data/:y/:x + 1
    if data/:y/:x = 10 [
      append flashes as-pair x y
    ]
  ]]

  it: flashes
  while [not tail? it] [
    foreach delta [-1x-1 -1x0 -1x1 0x-1 0x1 1x-1 1x0 1x1] [
      p: delta + first it  x: p/x  y: p/y
      if all [
        x > 0  x <= dims/x 
        y > 0  y <= dims/y
        data/:y/:x < 10
      ][
        data/:y/:x: data/:y/:x + 1
        if data/:y/:x = 10 [append flashes p]
      ]
    ] it: next it
  ]

  flash-count: length? flashes
  foreach pos flashes [data/(pos/y)/(pos/x): 0]
  flash-count
]

config: copy/deep data
r1: 0  loop 100 [+= r1 step-octopus config]
print [{Part 1:} r1]

; --- Part 2 ---
len: (length? data) * (length? data/1)  config: copy/deep data
r2: 0  until [++ r2  equal? step-octopus config len]
print [{Part 2:} r2]
