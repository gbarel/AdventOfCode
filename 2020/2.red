Red [
  Title: {AoC 2020 - Day 2}
  Date: 02-12-2020
]

data: read/lines %data/2.txt

; --- Part 1 ---

++: func ['val [word!]] [set val 1 + get val]

count: func [series [series! string!] value /local cnt] [
  cnt: 0
  foreach entry series [all [value = entry ++ cnt]]
  cnt
]

digit: charset "0123456789"
letter: charset [#"A" - #"Z" #"a" - #"z"]
password-rule: [
  copy lo some digit "-" (lo: to-integer lo) 
  copy hi some digit space (hi: to-integer hi)
  copy char 1 letter ":" space (char: to-char char)
  copy password some letter
]

r1: 0
foreach line data [
  parse line [ 
    password-rule 
    (
      occurrence: count password char
      all [occurrence >= lo occurrence <= hi ++ r1]
    )
  ]
]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
foreach line data [
  parse line [
    password-rule
    (if (password/:lo = char) xor (password/:hi = char) [++ r2] )
  ]
]
print [{Part 2:} r2]
