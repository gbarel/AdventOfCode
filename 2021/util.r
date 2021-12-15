REBOL [
  Title: {AoC 2021 - Utility}
  Date: 05-12-2021
]

;++: func ['val [word!]] [set val 1 + get val]
+=: func ['val [word!] inc] [set val add get val inc]
-=: func ['val [word!] inc] [set val subtract get val inc]

; split a series ONCE when you find a specific delimiter
; todo: improve to make it recursive
split: funct [
  data [series!]
  delimiter [block! integer! char! bitset! any-string!]
][
  it: find data delimiter
  reduce [(copy/part data it) (next it)]
]

; modified version of map-each
find-if: func [
  [throw catch]
  'word [word! block!] {Word or block of words to set each time (local)}
  data [block!] {The series to traverse}
  pred [block!] {Block to evaluate each time}
  /local init len x
][
  if empty? data [return data]
  word: either block? word [
      if empty? word [throw make error! [script invalid-arg []]]
      copy/deep word
  ] [reduce [word]]
  word: use word reduce [word]
  pred: bind/copy pred first word
  init: none 
  parse word [any [word! | x: set-word! (
      unless init [init: make block! 4]
      insert insert insert tail init first x [at data] index? x
      remove x
  ) :x | x: skip (
      throw make error! reduce ['script 'expect-set [word! set-word!] type? first x]
  )]]
  len: length? word
  until [
      set word data do init
      unless unset? set/any 'x do pred [if :x [break]]
      tail? data: skip data len
  ]
  data
]