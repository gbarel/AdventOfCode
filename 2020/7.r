REBOL [
  Title: {AoC 2020 - Day 7}
  Date: 07-12-2020
]

digit: charset {0123456789}
data: collect [
  foreach entry read/lines %data/7.txt [
    children: copy []
    parse entry [
        copy parent to {bag} thru {contain}
        some [
          copy count some digit 
          copy child to {bag}
          (append children reduce [load count trim child]) 
          opt thru {,} ; opt = 0 or 1
          ; load = parse string and deduce type
        ]
    ]
    keep reduce [trim parent children]
  ]
]

; --- Part 1 ---
r1: 0
colors: copy [{shiny gold}]
while [not tail? colors] [
  foreach [parent children] data [
    all [
      find children colors/1
      not find head colors parent
      append colors parent
    ]
  ]
  colors: next colors
]
r1: (length? head colors) - 1
print [{Part 1:} r1]

; --- Part 2 ---
r2: do count-bags: func [name][
  res: 0
  foreach [count child] data/:name [
    res: res + count + (count * count-bags child)
  ]
  res
] "shiny gold"
print [{Part 2:} r2]