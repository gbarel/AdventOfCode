REBOL [
    Title: {AoC 2020 - Day 4}
  Date: 04-12-2020
]

++: func ['val [word!]] [set val 1 + get val]
between?: func [
  n [integer!]
  mini [integer!]
  maxi [integer!]
][
  all[(mini <= n) (n <= maxi)]
]

passports: copy []
append/only passports copy []
use [entry key value] [
  foreach entry read/lines %data/4.txt [
    either greater? length? entry 0 [
      parse entry [
        some [
          copy key to {:} skip copy value [to { } | to end]
          (append last passports reduce [key value])
        ]
      ]
    ][
      all [
        greater? length? last passports 0 
        append/only passports copy []
      ]
    ]
  ]
]

; --- Part 1 ---
r1: 0
check-passport: func [passport [series!]] [
  fields: extract passport 2
  required-fields: ["byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid"]
  equal? length? intersect fields required-fields length? required-fields
]
foreach p passports [check-passport p [++ r1]]
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
hexadecimal: charset [#"0" - #"9" #"a" - #"f"]
check-passport-strict: func [passport [series!]] [
  all [
    between? to-integer select passport "byr" 1920 2002
    between? to-integer select passport "iyr" 2010 2020
    between? to-integer select passport "eyr" 2020 2030
    hgt: select passport "hgt"
    hcl: select passport "hcl"
    pid: select passport "pid"
    parse hgt [
      copy height integer! copy unit to end 
      (height: to-integer height)
    ]
    any [
      all [unit = "cm" between? height 150 193]
      all [unit = "in" between? height 59 76]
    ]
    parse hcl ["#" 6 hexadecimal]
    find ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"] select passport "ecl"
    parse pid [9 integer]
  ]
]
foreach p passports [
  if check-passport-strict p [++ r2]
]
print [{Part 2:} r2]