REBOL [
  Title: {AoC 2021 - Day 3}
  Date: 03-12-2021
]

data: read/lines %data/3.txt

++: func ['val [word!]] [set val 1 + get val]
+=: func ['val [word!] inc] [set val add get val inc]
-=: func ['val [word!] inc] [set val subtract get val inc]

; not sure how to handle binaries in REBOL
; so instead each binary is manipulated as string (from data)
; counts are manipulated as a block of numbers

count-bits: funct [
  data [series!] "a series of string!"
  ; output [series!] "a series of integer!"
] [
  res: array/initial length? data/1 0
  foreach bits data [
    forall bits [
      if bits/1 = #"1" [i: index? bits change at res i add pick res i 1]
    ]
  ] res
]

most-common-bit: funct [
  data [series!] "a series of string!"
  ; output [string!]
][
  res: "" avg: divide length? data 2
  foreach cnt count-bits data [append res either cnt < avg ["0"]["1"]]
  res
]

bits-to-integer: funct [
  bits [string!]
  ; output [integer!]
][
  res: 0 len: length? bits
  forall bits [if bits/1 = #"1" [res: add res power 2 (len - index? bits)]]
  to-integer res
]

bits-complement: funct [
  bits [string!]
  ; output [string!]
][
  res: copy bits
  forall res [change at res 1 either res/1 = #"0" [#"1"][#"0"]]
  res
]

; --- Part 1 ---
gamma: most-common-bit data epsilon: bits-complement gamma
r1: multiply bits-to-integer gamma bits-to-integer epsilon
print [{Part 1:} r1]

; --- Part 2 ---

count-bit: func [
  data [series!] "a series of string binaries"
  bitpos [integer!] "position to count"
  ; output [integer!]
][
  res: 0 foreach bits data [
    if bits/(bitpos) = #"1" [++ res]
  ] res
]

find-bit-criteria: funct [
  data [series!] "a series of string binaries"
  /least "select bits with least common bit instead"
  ; output [string!]
][
  ; iterate through bit positions, find most common bit (mcb) and remove binaries based on critera
  values: copy data  bitpos: 0  bitlen: length? values/1
  while [all [1 < length? values  bitpos < bitlen  ++ bitpos]] [
    avg: divide length? values 2 
    mcb: either (count-bit values bitpos) < avg [#"0"][#"1"]
    remove-each bits values [either least [bits/(bitpos) = mcb] [bits/(bitpos) <> mcb]]
  ]
  values/1
]

oxygen: bits-to-integer find-bit-criteria data
co2: bits-to-integer find-bit-criteria/least data

r2: oxygen * co2
print [{Part 2:} r2]
