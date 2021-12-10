REBOL [
  Title: {Rebol Reference}
  Date: 01-12-2021
]


; do [block!]
; * evaluates the block
; * return the result of the last expression
; ! used to evaluate scripts
print do [1 + 2  3 + 4] ; == 7

; reduce [block!]
; * evaluates all expressions within a block
; * returns result of all expressions in a new block
print reduce [1 + 2  3 + 4] ; == 3 7

; either expr! [block!] [block!]
; * do first block! if expr! is true 
either now/time < 12:00 [print "morning!"] [print "evening!"]

; any [block!] / all [block!]
; * evaluates expression one at a time
; * any function returns on the first true expression / all on the first false epxression
;   * a true expression is any value other than false or none
number: none
print number: any [number 100] ; 100

; until [block!] / while [block!]
; * `until` evaluates block _until_ last expression is true 
; * `while` evaluates block _while_ last expression is true
; * `break` can be used to escape the loop
color: [red green blue]
while [not tail? color] [print first color color: next color] ; red green blue

; select [any! [block!]]expr!
; * finds expr within the words, and return the block
cases: [
  center [print "center"]
  right  [print "right"]
  left   [print "left"]
]
action: select cases 'right
if action [do action]

; switch/default [any! [block!]] [default-block!] expr!
; * same as select, but returns evaluated block


; ========================
; PARSE

; parse series rules
; * args: series [string! block!], rules [block!]
; * /all parse all characters within a string
; * /case treat lower case and upper case as different characters

; parse splits the input argument into a block of multiple strings

probe parse "here there,everywhere; ok" none
; ["here" "there" "everywhere" "ok"]

probe parse "707-467-8000" "-"
; ["707" "467" "8000"]


rules: [some "a" "b"] ; accepts ab aab aaab aaaab
rules: [any "a" "b"] ; accepts b ab aab aaab aaaab
rules: ["a" 10 skip "b"] ; accepts a0123456789b
rules: ["a" to "b"] ; starts at `a` and ends at `b`, does not include `b`
rules: ["a" thru "b"] ; same as `to`, but includes `b`

digit: charset "0123456789" ; equivalent to charset [#"0" - #"9"]
rules: [3 digit "-" 3 digit "-" 4 digit] ; accepts 707-467-8000

alphanum: charset [#"0" - #"9" #"A" - #"Z" #"a" - #"z"]

rules: [to "phone" (print "found phone") to end] ; prints "found phone" if phone is in the input series
rules: [thru <title> copy text to </title>] ; copies title in text variable
rules: [thru <title> begin: to </title> ending: (change/part begin "New Title" ending)]

; =======================
; CONTEXT

; `context` is the equivalent of an object
box: context [
  inc: func [n [number!]][n + 1]
  str: "value"
]
box/inc 2 ; == 3
box/str ; == "value"

; `use` is an unnamed context to define local variables (unset outside the scope)
box2: context [
  speak: none
  use [words] [
    words: "blablabla"
    speak: func [][words]
  ]
]
box2/speak ; == "blablabla
"