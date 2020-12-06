REBOL [
  Title: {AoC 2020 - Day 6}
  Date: 06-12-2020
]

++: func ['val [word!]] [set val 1 + get val]
+=: func ['val [word!] inc] [set val inc + get val]

alpha: charset [#"A" - #"Z" #"a" - #"z"]

; --- Part 1 ---
r1: 0
data: copy [[]]
foreach entry read/lines %data/6.txt [
  either equal? length? entry 0 [
    append/only data copy []
  ][
    parse entry [some [copy letter alpha (append last data letter)]]
  ]
]
foreach entry data [+= r1 length? unique entry]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
data: copy [[]]
answer-count: 0
foreach entry read/lines %data/6.txt [
  either equal? length? entry 0 [
    append/only data copy []
    answer-count: 0
  ][
    answers: copy []
    parse entry [some [copy letter alpha (append answers letter)]]
    either equal? answer-count 0 [
      append last data answers
    ][
      answers: intersect last data answers
      clear last data
      append last data answers
    ]
    ++ answer-count
  ]
]
foreach entry data [+= r2 length? unique entry]
print [{Part 2:} r2]
