REBOL [
  Title: {AoC 2021 - Day 10}
  Date: 10-12-2021
]

; import utility functions
do %util.r

; read heightmap as a series of strings
data: read/lines %data/test.txt

; --- Part 1 ---
rules: [any [
  ["{" rules it: (i: max i index? it) "}"] | 
  ["[" rules it: (i: max i index? it) "]"] | 
  ["(" rules it: (i: max i index? it) ")"] |
  ["<" rules it: (i: max i index? it) ">"]
]]
rules-init: [(i: 0) rules]
points: [#")" 3 #"]" 57 #"}" 1197 #">" 25137]

; turns out rebol starts going backwards in the syntax if an error is found
; so the first error encountered will always be the last marker
r1: 0  foreach line data [
  parse line rules-init
  if all [i >= 1  i <= length? line][
    += r1 select points line/:i
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
; let's try something new! push and pop expected closure characters on a block
check-line: funct [
  line [series!]
][
  stack: copy []  it: line
  until [
    c: it/1
    switch/default c [
      #"(" [insert stack #")"]
      #"{" [insert stack #"}"]
      #"[" [insert stack #"]"]
      #"<" [insert stack #">"]
    ][if c <> take stack [break]]
    tail? it: next it
  ]
  completion-points: [#")" 1 #"]" 2 #"}" 3 #">" 4]
  points: 0.0  forall stack [points: (points * 5) + select completion-points stack/1]
  reduce [tail? it c points]
]

; we can also solve part 1 again!
r1: 0  scores: copy []  
foreach line data [
  either pick res: check-line line 1
    [append scores res/3]
    [+= r1 select points res/2]
]
print [{Part 1 (again!): } r1]

scores: sort scores
r2: scores/((length? scores) / 2 + 1)
print [{Part 2:} r2]
