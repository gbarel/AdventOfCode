REBOL [
  Title: {Day 13}
  Date: 13-12-2021
]

; import utility functions
do %util.r

data: split read/lines %data/13.txt ""
points: []  foreach point data/1 [
  parse point [
    copy x to "," skip copy y to end
    (append points as-pair to-integer x to-integer y)
  ]
]

fold: funct [
  points [block!]
  line [pair!]
][
  either line/1 <> 0 [
    ; fold horizontally
    forall points [all [
        points/1/x > line/1
        points/1: as-pair (2 * line/1 - points/1/x) points/1/y
    ]]
  ][
    ; fold vertically
    forall points [all [
      points/1/y > line/y
      points/1: as-pair points/1/x  (2 * line/2 - points/1/y)
    ]]
  ]
  points: unique points
]

draw-points: funct [
  points [block!]
][
  dims: 0x0  foreach p points [dims: max dims p]
  dots: array/initial reduce [dims/y + 1 dims/x + 1] "."
  foreach p points [dots/(p/y + 1)/(p/x + 1): "#"]
  foreach line dots [
    print reform line
  ]
]

; --- Part 1 ---
x: y: 0 parse data/2/1 ["fold along " 
  ["x=" copy x to end | "y=" copy y to end] 
]
fold points as-pair to-integer x to-integer y

r1: length? unique points
print [{Part 1:} r1]

; --- Part 2 ---
for i 2 length? data/2 1 [
  x: y: 0 parse data/2/:i ["fold along " 
    ["x=" copy x to end | "y=" copy y to end] 
  ]
  fold points as-pair to-integer x to-integer y
]
draw-points points
r2: 0
print [{Part 2:} r2]
