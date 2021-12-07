REBOL [
  Title: {AoC 2021 - Day 7}
  Date: 07-12-2021
]

; import utility functions
do %util.r

data: load replace/all read %data/7.txt {,} { }

; --- Part 1 ---
sum-diff: funct [
  data [series!]
  val [number!]
][
  res: 0  forall data [+= res abs subtract data/1 val]  res
]

minmax: reduce [pick minimum-of data 1 pick maximum-of data 1]

r1: none
for i minmax/1 minmax/2 1 [
  all [diff: sum-diff data i  any[not r1  lesser? diff r1]  r1: diff]
]
print [{Part 1:} r1]

; --- Part 2 ---
sum-diff-arithmetic: funct [
  data [series!]
  val [number!]
][
  res: 0
  forall data [
    n: abs subtract data/1 val  arithmetic-sum: (n * (n + 1)) / 2
    += res arithmetic-sum
  ]
  res
]

r2: none
for i minmax/1 minmax/2 1 [
  all [diff: sum-diff-arithmetic data i  any[not r2  lesser? diff r2]  r2: diff]
]
print [{Part 2:} r2]
