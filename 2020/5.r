REBOL [
  Title: {AoC 2020 - Day 5}
  Date: 05-12-2020
]

++: func ['val [word!]] [set val 1 + get val]
+=: func ['val [word!] inc] [set val inc + get val]

seats: collect [
  foreach entry read/lines %data/5.txt [
    col: 0 row: 0
    parse entry [
      (inc: 64) 7 [["F" | ["B" (+= col inc)]] (inc: inc / 2)]
      (inc: 4)  3 [["L" | ["R" (+= row inc)]] (inc: inc / 2)]
    ]
    keep/only reduce [col row (col * 8 + row)]
  ]
]

; --- Part 1 ---
r1: 0
foreach seat seats [r1: max r1 seat/3]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
seat-ids: sort map-each seat seats [seat/3]
forall seat-ids [
  all [
    (length? seat-ids) > 1
    (seat-ids/2 - seat-ids/1) > 1
    r2: (seat-ids/1 + 1)
  ]
]
print [{Part 2:} r2]
