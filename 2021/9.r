REBOL [
  Title: {AoC 2021 - Day 9}
  Date: 09-12-2021
]

; import utility functions
do %util.r

; read heightmap as a series of strings
data: read/lines %data/9.txt


; --- Part 1 ---
find-lowpoints: func [
  data [series!] {the heightmap}
][
  dim: to-pair reduce [length? data/1 length? data]
  res: copy []
  repeat x dim/1 [repeat y dim/2 [
    height: data/:y/:x
    all [ 
      any [x = 1      data/:y/(x - 1) > height] ; left
      any [x = dim/x  data/:y/(x + 1) > height] ; right
      any [y = 1      data/(y - 1)/:x > height] ; top
      any [y = dim/y  data/(y + 1)/:x > height] ; bottom
      append res reduce [to-pair reduce [x y]]
    ]
  ]]
  res
]

r1: 0  lowpoints: find-lowpoints data
foreach pos lowpoints [r1: r1 + data/(pos/y)/(pos/x) + 1 - #"0"]
print [{Part 1:} r1]

; --- Part 2 ---
fill-basin: func [
  data [series!] {the heightmap}
  lowpoint [pair!] {the lowpoint from which to fill the basin}
][
  dim: to-pair reduce [length? data/1 length? data]
  basin: copy [] ; the points that have been added to the basin
  wave: reduce [lowpoint] ; the points that are considered for filling the basin
  until [
    pos: take wave
    height: data/(pos/y)/(pos/x) - #"0"
    if height < 9 [ ; points of height 9 are not included
      append basin pos
      any [pos/x = 1      append wave (pos - 1x0)]
      any [pos/x = dim/x  append wave (pos + 1x0)]
      any [pos/y = 1      append wave (pos - 0x1)]
      any [pos/y = dim/y  append wave (pos + 0x1)]
      wave: exclude unique wave basin ; only consider new unique points
    ]
    empty? wave
  ]
  basin
]

basinsizes: map-each lowpoint lowpoints [length? fill-basin data lowpoint]
r2: 1  loop 3 [r2: r2 * take maximum-of basinsizes]
print [{Part 2:} r2]
