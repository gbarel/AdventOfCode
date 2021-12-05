REBOL [
  Title: {AoC 2021 - Day 4}
  Date: 04-12-2021
]

; load won't work. first line "82,86,73,..." seen as invalid decimal
data: read/lines %data/4.txt

++: func ['val [word!]] [set val 1 + get val]
+=: func ['val [word!] inc] [set val add get val inc]
-=: func ['val [word!] inc] [set val subtract get val inc]

; first line is integer separated by ","
draws: parse data/1 ","

; rest of data is series of 5x5 grids of numbers
; (start at 3 to skip drawn numbers)
grids: copy [] grid: copy []
for num 3 length? data 1 [
  line: data/:num either empty? line [
    append/only grids grid  grid: copy []
  ][
    append grid parse line none
  ]
]
if not empty? grid [append/only grids grid]


; --- Part 1 ---
check-bingo: funct [
  state [series!] "a grid of 5x5 booleans, true = marked numbers"
  ; output true if there exist a row or column of marked number
][
  repeat i 5 [
    row: (i - 1) * 5  col: i
    if any [
      all[state/(row + 1) state/(row + 2) state/(row + 3) state/(row + 4) state/(row + 5)]
      all[state/(col) state/(col + 5) state/(col + 10) state/(col + 15) state/(col + 20)]
    ] [return true]
  ]
  false
]

compute-bingo: funct [
  draws [series!] "the list of drawn numbers"
  grid [series!] "a series of numbers (currently encoded as strings!)"
  ; outputs [block!] "first element is integer! (number of draws before bingo) ; second element is list of unmarked numbers"
][
  if 25 <> length? grid [throw "incorrect grid!"]
  state: array/initial 25 false
  forall draws [
    repeat i 25 [
      if grid/:i = draws/1 [change at state i true  break]
    ]
    ; tmp: copy [] repeat i 25 [if state/:i [append tmp reduce [grid/:i]]]
    ; print reduce [{draw: } index? draws { marked: } tmp]
    if check-bingo head state [
      sum-unmarked: 0
      repeat i 25 [if not state/:i [+= sum-unmarked to-integer grid/:i]]
      return reduce [index? draws sum-unmarked]
    ]
  ]
]

first-win: none  last-win: none
forall grids [
  res: compute-bingo draws grids/1
  if any [not first-win  lesser? res/1 first-win/1] [first-win: res]
  if any [not last-win  greater? res/1 last-win/1] [last-win: res]
]
r1: first-win/2 * to-integer draws/(first-win/1)
print [{Part 1:} r1]

; --- Part 2 ---
r2: last-win/2 * to-integer draws/(last-win/1) 
print [{Part 2:} r2]
