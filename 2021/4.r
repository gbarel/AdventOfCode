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
drawn-numbers: parse data/1 "," 

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

; --- Part 1 ---
r1: 0
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
print [{Part 2:} r2]
