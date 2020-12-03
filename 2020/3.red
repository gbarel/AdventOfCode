Red [
  Title: {AoC 2020 - Day 3}
  Date: 03-12-2020
]

data: copy []
foreach entry read/lines %data/3.txt [
    append/only data collect [
        parse entry [
            some [{.} (keep false) | {#} (keep true)]
        ]
    ]
]

++: func ['val [word!]] [set val 1 + get val]
+=: func ['val [word!] inc] [set val inc + get val]
*=: func ['val [word!] inc] [set val inc * get val]

count-trees: func [slope [pair!]] [
    count: 0
    pos: 1x1
    width: length? data/1
    height: length? data
    while [pos/2 <= height] [
        if data/(pos/2)/(pos/1) [++ count]
        += pos slope
        if pos/1 > width [+= pos as-pair negate width 0]
    ]
    count
]

; --- Part 1 ---
r1: count-trees 3x1
print [{Part 1:} r1]

; --- Part 2 ---
r2: copy []
slopes: [1x1 3x1 5x1 7x1 1x2]
foreach slope slopes [
    append trees count-trees slope
]
print [{Part 2:} r2] ; overflow. result is 3154761400