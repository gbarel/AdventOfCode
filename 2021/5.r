REBOL [
  Title: {AoC 2021 - Day 5}
  Date: 05-12-2021
]

; import utility functions
do %util.r

data: read/lines %data/5.txt

vents: copy []
foreach line data [
  parse line [
    copy x1 to "," skip copy y1 to " " skip thru " " copy x2 to "," skip copy y2 to end
    (p1: to-pair reduce [1 + to-integer x1 1 + to-integer y1]
     p2: to-pair reduce [1 + to-integer x2 1 + to-integer y2]
     append/only vents reduce [p1 p2])
  ]
]

; find maximum size for grid
max: 0x0
foreach vent vents [foreach pos vent [
  if pos/1 > max/1 [max: to-pair reduce [pos/1 max/2]]
  if pos/2 > max/2 [max: to-pair reduce [max/1 pos/2]]
]]

; --- Part 1 ---
grid: array/initial max/1 array/initial max/2 0
foreach vent vents [foreach [p1 p2] vent [
  if any [p1/1 = p2/1  p1/2 = p2/2] [
    min-pos: to-pair reduce [minimum p1/1 p2/1  minimum p1/2 p2/2]
    max-pos: to-pair reduce [maximum p1/1 p2/1  maximum p1/2 p2/2]
    for x min-pos/1 max-pos/1 1 [for y min-pos/2 max-pos/2 1 [
      grid/:y/:x: 1 + grid/:y/:x
    ]]
    ; print [{vent } vent]
    ; forall grid [probe grid/1]
  ]
]]

r1: 0
repeat x max/1 [repeat y max/2 [all [2 <= grid/:x/:y  ++ r1]]]
print [{Part 1:} r1]

; --- Part 2 ---
foreach vent vents [foreach [p1 p2] vent [
  delta: to-pair reduce [p1/1 - p2/1  p1/2 - p2/2]
  if equal? abs delta/1 abs delta/2 [
    pos: p2  offset: to-pair reduce [sign? delta/1 sign? delta/2]
    ; print [{vent } vent]
    ; print [{offset delta} offset delta]
    for i 0 abs delta/1 1 [
      x: pos/1  y: pos/2  pos: pos + offset
      ; print [{xy} x y]
      grid/:y/:x: 1 + grid/:y/:x
    ]
    ; forall grid [probe grid/1]
  ]
]]

r2: 0
repeat x max/1 [repeat y max/2 [all [2 <= grid/:x/:y  ++ r2]]]
print [{Part 2:} r2]
