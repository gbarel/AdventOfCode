REBOL [
  Title: {AoC 2020 - Day 11}
  Date: 11-12-2020
]

data: read/lines %data/11.txt

adjacent-seats: func [
  seats [block! series!]
  pos [pair!]
  /local res
][
  res: copy []
  w: length? seats/1 h: length? seats
  foreach delta [-1x-1 -1x0 -1x1 0x-1 0x1 1x-1 1x0 1x1] [
    all [
      xy: pos + delta x: xy/1 y: xy/2
      (x > 0) (x <= w) (y > 0) (y <= h)
      append res seats/:x/:y
    ]
  ]
  res
]

count: func [
  series [series! string!] 
  value 
  /local cnt e
][
  cnt: 0 foreach e series [all [value = e ++ cnt]] cnt
]

apply-seat-rules: func [
  seats [block! series!]
  /local res x y cnt
][
  res: copy/deep seats
  w: length? seats/1 h: length? seats
  repeat x w [
    repeat y h [
      cnt: count adjacent-seats seats as-pair x y #"#"
      switch seats/:x/:y [
        #"." [none]
        #"L" [if equal? cnt 0 [res/:x/:y: #"#"]]
        #"#" [if greater? cnt 3 [res/:x/:y: #"L"]]
      ]
    ]
  ]
  res
]

; --- Part 1 ---
r1: 0
; use [seats] [
  prev-seats: next-seats: copy/deep data
  i: 0
  until [
    print reduce [{seatings #} ++ i]
    foreach e next-seats [print reduce [{[} e {]}]]

    prev-seats: next-seats
    next-seats: apply-seat-rules prev-seats
    equal? prev-seats next-seats
  ]
  foreach row prev-seats [
    r1: r1 + count row #"#"
  ]
; ]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0

print [{Part 2:} r2]
