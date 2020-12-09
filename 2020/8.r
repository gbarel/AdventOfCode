REBOL [
Title: {AoC 2020 - Day 8}
Date: 08-12-2020
]

data: parse read %data/8.txt none ; split elements using space/newlines
+=: func ['val [word!] inc] [set val inc + get val]

is-looping: func [ip /local buff acc inst arg jmp] [
  buff: copy []
  acc: 0
  while [not tail? ip] [
    append buff compose [(index? ip) acc]
    jmp: 1
    switch ip/1 [
      "nop" []
      "acc" [+= acc load ip/2]
      "jmp" [jmp: load ip/2]
    ]
    ip: skip ip (jmp * 2) ; skip a pair of [inst arg] exactly jmp times
    all [find extract buff 2 index? ip r1: acc break]
  ]
  compose [(not tail? ip) (acc)]
]

; --- Part 1 ---
r1: pick is-looping data 2
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
forskip data 2 [
  if not equal? first data "acc" [
    data2: copy head data
    switch first data [
      "nop" [poke data2 (index? data) "jmp" ]
      "jmp" [poke data2 (index? data) "nop"]
    ]
    all [res: is-looping data2 not res/1 r2: res/2 break]
  ]
]
print [{Part 2:} r2]