REBOL [
    Title: {AoC 2020 - Day 4}
  Date: 04-12-2020
]

++: func ['val [word!]] [set val 1 + get val]

passports: copy []
append/only passports copy []
use [entry key value] [
    foreach entry read/lines %data/4test.txt [
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
check-passport-strict: func [passport [series!]] [
    all [
        all [ 
            byr: to-integer select passport "byr"
            (byr >= 1920) 
            (byr <= 2020)
        ]
        all [
            iyr: to-integer select passport "iyr"
            (iyr >= 2010) (byr <= 2020)
        ]
        all [
            eyr: to-integer select passport "eyr"
            (eyr >= 2020) (eyr <= 2030)
        ]
        all [
            parse select passport "hgt" [ 
                copy height integer! to "cm" to end (all [(height >= 150) (height <= 193)]) |
                copy height integer! to "in" to end (all [(height >= 59) (height <= 76)])                 
            ]
        ]
    ]
]
foreach p passports [
    if check-passport-strict p [++ r2]
]
print [{Part 2:} r2]