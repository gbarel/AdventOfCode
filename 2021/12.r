REBOL [
  Title: {AoC 2021 - Day 12}
  Date: 12-12-2021
]

; import utility functions
do %util.r

data: map-each line read/lines %data/12.txt [split line {-}]


; --- Part 1 ---
add-connection: func [
  connections [block!]
  subpath [block!]
][
  if all [subpath/2 <> "start"  subpath/1 <> "end"][
    if not it: find connections subpath/1 [
      append connections reduce [subpath/1 []]
      it: find connections subpath/1
    ]
    it/2: union it/2 reduce [subpath/2]
  ]
]

connections: copy []
foreach subpath data [
  add-connection connections subpath
  add-connection connections reverse subpath
]

small-cave?: funct [node [string!]][
  node == lowercase copy node
  ; lowerchar: charset [#"a" - #"z"]
  ; parse node [some lowerchar]
]

count-cave: funct [path [block!] cave [string!]][
  res: 0  forall path [all [path/1 = cave  ++ res]]  res
]

cnt: 0
list-paths: funct [
  path [block!]
  connections [block!]
  twice [logic!]
][
  cave: last path
  all [cave = "end"  ++ cnt  return];return reduce [path]]
  all [
    small-cave? cave
    (count-cave path cave) > either twice [2][1]
    return
    ; return []
  ]
  if all [small-cave? cave  2 = count-cave path cave][twice: false]
  paths: copy []
  foreach next-cave connections/:cave [
    next-path: append copy path next-cave
    list-paths next-path connections twice
    ;res: list-paths next-path connections twice
    ; foreach p res [append/only paths p]
  ]
  paths
]

;paths1: list-paths ["start"] connections false
list-paths ["start"] connections false  r1: cnt
; r1: length? paths1
print [{Part 1:} r1]

; --- Part 2 ---
r2: cnt: 0 list-paths ["start"] connections true r2: cnt
print [{Part 2:} r2]
; paths2: list-paths ["start"] connections true
; r2: length? paths2
; print [{Part 2:} r2]
