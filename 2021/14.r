REBOL [
  Title: {Day 14}
  Date: 14-12-2021
]

; import utility functions
do %util.r


polymer: context [
  template: rules: step: none
  use [] [
    data: split read/lines %data/14.txt {}
    template: data/1/1
    rules: collect [foreach line data/2 [
      c1: line/1 c2: line/2 c3: line/(length? line)
      keep rejoin [c1 c2]
      keep rejoin [c1 c3]
      keep rejoin [c3 c2]
    ]]

    count-letters: funct [
      init [series!]
      counts [block!]
    ][
      res: copy []
      foreach [p cnt] counts [
        either it: find res p/1 [
          it/2: it/2 + cnt
        ][
          append res reduce [p/1 cnt]
        ]
      ]
      last: init/(length? init)
      res/:last: res/:last + 1
      res
    ]

    step: func [
      data [series!] 
      num [integer!]
      rules [block!]
      ; output {the number of times each pair is present}
    ][
      ; create a map of [combination occurrences]
      data-pairs: collect [forall data [
        if tail? next data [break]
        keep rejoin [data/1 data/2]
      ]]
      all-pairs: join unique data-pairs unique rules
      counts: collect [foreach p all-pairs [keep reduce [p 0.0]]]

      ; count combinations for data
      foreach p data-pairs [
        counts/:p: counts/:p + 1
      ]

      ; grow the polymer with the following rules
      ; for each combination > 0 in the rules
      ; decrement combination and increment 2 new substitutions
      repeat i num [
        res: copy counts
        foreach [p cnt] counts [
          if all [cnt > 0  it: find extract rules 3 p] [
            it: at rules (3 * index? it) - 2
            res/:p: res/:p - cnt
            res/(it/2): res/(it/2) + cnt
            res/(it/3): res/(it/3) + cnt
          ]
        ]
        counts: res
      ]

      ; count the number of letters
      res: count-letters data counts

      ; keep only strictly positive counts
      minmax: reduce [res/2 res/2]
      foreach [p cnt] res [
        if cnt > 0 [
          minmax/1: min minmax/1 cnt
          minmax/2: max minmax/2 cnt
        ]
      ]
      minmax/2 - minmax/1
    ]
  ]
]

; --- Part 1 ---
r1: polymer/step polymer/template 10 polymer/rules
print [{Part 1:} r1]

; --- Part 2 ---
r2: polymer/step polymer/template 40 polymer/rules
print [{Part 2:} r2]
