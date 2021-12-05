REBOL [
  Title: {AoC 2021 - Utility}
  Date: 05-12-2021
]

++: func ['val [word!]] [set val 1 + get val]
+=: func ['val [word!] inc] [set val add get val inc]
-=: func ['val [word!] inc] [set val subtract get val inc]