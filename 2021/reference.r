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

