REBOL [
  Title: {Day 13}
  Date: 13-12-2021
]

; import utility functions
do %util.r


points: context [
  process: draw: dots: inst: none 
  use [data fold data] [
    data: split read/lines %data/13.txt ""
    ; parse data into dots and inst
    dots: map-each line data/1 [load replace line {,} {x}]
    inst: data/2

    draw: funct [][
      m: 0x0  foreach p dots [m: max m p]
      res: array/initial reduce [m/y + 1 m/x + 1] "."
      foreach p dots [res/(p/y + 1)/(p/x + 1): "#"]
      foreach line res [print rejoin line]
    ]

    fold: funct [
      line [pair!]
    ][
      either line/1 <> 0 [
        ; fold horizontally
        forall dots [all [
          dots/1/x > line/1
          dots/1: as-pair (2 * line/1 - dots/1/x) dots/1/y
        ]]
      ][
        ; fold vertically
        forall dots [all [
          dots/1/y > line/y
          dots/1: as-pair dots/1/x  (2 * line/2 - dots/1/y)
        ]]
      ]
      set 'dots unique dots
    ]

    process: func [
      /all
    ][
      loop either all [length? inst][1][
        x: y: 0 parse inst/1 ["fold along " 
          ["x=" copy x to end | "y=" copy y to end] 
        ]
        fold as-pair to-integer x to-integer y
        inst: next inst
      ]
    ]
  ]
]

; --- Part 1 ---
points/process
r1: length? points/dots
print [{Part 1:} r1]

; --- Part 2 ---
points/process/all
points/draw
r2: 0
print [{Part 2:} r2]
