REBOL [
    Title: "Advent of Code 2019 - Day 04"
    Author: "Gaetan Barel"
    Version: 1.0.0
    Date: 04-December-2019
]

comment {    
    to launch the script, use
    > change-dir %/path_to_script
    > do %script.r
}

comment {
    --- Day 4: Secure Container ---

    You arrive at the Venus fuel depot only to discover it's protected by a 
    password. The Elves had written the password on a sticky note, but someone 
    threw it out.

    However, they do remember a few key facts about the password:

        It is a six-digit number.
        The value is within the range given in your puzzle input.
        Two adjacent digits are the same (like 22 in 122345).
        Going from left to right, the digits never decrease; they only ever 
        increase or stay the same (like 111123 or 135679).

    Other than the range rule, the following are true:

        111111 meets these criteria (double 11, never decreases).
        223450 does not meet these criteria (decreasing pair of digits 50).
        123789 does not meet these criteria (no double).

    How many different passwords within the range given in your puzzle input 
    meet these criteria?

    Your puzzle input is 156218-652527.
}


test: func [
    {Compares a function output to the expected output}
    'fn [word!] "Function to test"
    data [block!] "the function input"
    expected [any-type!] "the expected output"
    /local 
    output [any-type!] "the actual function output"
][
    output: do (head insert data fn)
    if not (output = expected) [
        print rejoin [
            "Error: " :fn " " mold :data newline
            " - expected: " mold expected newline
            " - output: " mold output
        ]
    ]
]

++: func ['val [word!]] [set val 1 + get val]
--: func ['val [word!]] [set val -1 + get val]

is-valid-password: func [
    pw [string! number!] "the password"
    /exact
    size [integer!] "the maximum amount of matching adjacent digits"
    /local digit counts index
][
    if (not string? pw) [pw: to-string pw]
    ; passwords must be increasing in digits
    repeat index ((length? pw) - 1) [
        if pw/(index) > pw/(index + 1) [
            return false
        ]
    ]
    ; passwords must have matching adjacent digits
    digit: charset "0123456789"
    counts: copy array/initial 9 0
    parse pw [some [copy d digit (
        index: to-integer d
        change (at counts index) ((pick counts index) + 1))]]
    ; check matching adjacent digits
    case [
        exact [ forall counts [if ((first counts) = size) [return true]] ]
        true  [ forall counts [if ((first counts) > 1)    [return true]] ]
    ]
    return false
]

test is-valid-password [111111] true
test is-valid-password [223450] false
test is-valid-password [123789] false
test is-valid-password [122345] true
test is-valid-password [111123] true
test is-valid-password [135679] false

prin "Answer part 1: "
print length? collect [
    for pw 156218 652527 1 [
        if (is-valid-password pw) [keep pw]
    ]
]

comment {
    --- Part Two ---

    An Elf just remembered one more important detail: the two adjacent matching 
    digits are not part of a larger group of matching digits.

    Given this additional criterion, but still ignoring the range rule, the 
    following are now true:

        112233 meets these criteria because the digits never decrease and all 
        repeated digits are exactly two digits long.
        123444 no longer meets the criteria (the repeated 44 is part of a larger
        group of 444).
        111122 meets the criteria (even though 1 is repeated more than twice, it
        still contains a double 22).

    How many different passwords within the range given in your puzzle input 
    meet all of the criteria?
}

; question: how do we test functions with a refinement?
; test is-valid-password/exact [112233 2] true
; test is-valid-password/exact [123444 2] false
; test is-valid-password/exact [111122 2] true

prin "Answer part 2: "
print length? collect [
    for pw 156218 652527 1 [
        if (is-valid-password/exact pw 2) [keep pw]
    ]
]
