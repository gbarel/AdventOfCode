REBOL [
  Title: {Day 15}
  Date: 15-12-2021
]

; import utility functions
do %util.r

astar: context [
  openlist: state: data: dims: none

  init: func [/test][
    lines: read/lines either test [%data/test.txt][%data/15.txt]
    data: collect [foreach l lines [
      keep/only collect [foreach c l [keep c - #"0"]]
    ]]
    dims: as-pair length? data/1 length? data
    return
  ]

  get-neighbours: funct [pos [pair!]][
    res: copy []
    if pos/x > 1 [append res pos - 1x0]
    if pos/y > 1 [append res pos - 0x1]
    if pos/x < dims/y [append res pos + 1x0]
    if pos/y < dims/y [append res pos + 0x1]
    res
  ]

  reconstruct: funct [current][
    total-path: reduce [current]
    while [all [backlink: state/(current)/3]][
      current: backlink  append total-path current
    ]
    reverse total-path
  ]

  evaluate: funct [path [block!]][
    r: 0 foreach p next path [+= r data/(p/y)/(p/x)] r
  ]

  manhattan-dist: funct [a [pair!] b [pair!]][
    c: abs a - b  c/x + c/y
  ]

  pos-to-index: funct [p [pair!]][
    print [{pos-to-index:} p]
    p/x + (p/y * dims/x)
  ]

  index-to-pos: funct [i [integer!]][
    y: i / (dims/x)  x: i - (i * dims/x)
    as-pair x y
  ]

  compute: func [
    /with
    start [pair!] 
    dest [pair!]
  ][
    ; state/openlist = list of pos to consider
    ; state = map of pos -> [gscore fscore backlink]
    openlist: reduce [start]
    state: array/initial (dims/x * dims/y) reduce [(to-integer (power 2 31) - 1) 0 none]
    state/(pos-to-index start)/1: 0

    step-cnt: 0
    while [not empty? openlist] [
      ; find node in open list with lowest fscore
      curr: openlist/1  foreach pos openlist [
        if (state/(pos-to-index pos)/1 < state/(pos-to-index curr)/1) [curr: pos]
      ]
      ; print [{pick} curr {from [} openlist {] /}]
      take find openlist curr
      
      ; termination
      if curr = dest [
        path: reconstruct curr
        return reduce [evaluate path  path]
      ]

      ++ step-cnt
      statecurr: state/(pos-to-index curr)
      foreach pos get-neighbours curr [
        gscore: statecurr/1 + data/(pos/y)/(pos/x)
        statepos: state/(pos-to-index pos)
        ; print [curr {=>} pos {costs} gscore]
        if gscore < statepos/1 [
          ; update state (gscore fscore backlink)
          statepos/1: gscore
          statepos/2: gscore + manhattan-dist pos dest
          statepos/3: curr
          ; add pos to openlist if it wasn't there
          unless find openlist pos [append openlist pos]
        ]
      ]
    ]
  ]
]



;     reconstruct: funct [backlinks current][
;       total-path: reduce [current]
;       while [all [
;         idx: 1 + index? find extract backlinks 2 current
;         backlinks/:idx
;       ]][
;         current: backlinks/:idx
;         insert head total-path current
;       ]
;       total-path
;     ]


;     evaluate: funct [path [block!]][
;       r: 0 foreach p next path [+= r map/(p/y)/(p/x)] r
;     ]

;     manhattan-dist: funct [a [pair!] b [pair!]][
;       c: abs a - b  c/x + c/y
;     ]

;     compute: func [start [pair!] dest [pair!]][
;       ; gscore = cost of cheapest path known from start to pos
;       ; fscore = best guess at shortest path from start to finish
;       ; backlinks = list of dest-node from-node
;       openlist: reduce [start]
;       tmp: copy [] repeat x dims/x [repeat y dims/y[append tmp reduce[as-pair x y none]]]
;       infinity: to-integer (power 2 31) - 1
;       gscores: copy tmp  forskip gscores 2 [gscores/2: infinity]  gscores/:start: 0
;       fscores: copy tmp  fscores/:start: manhattan-dist start dest
;       backlinks: copy tmp

;       while [not empty? openlist] [
;         ; find node in open list with lowest fscore
;         curr: openlist/1 foreach node openlist [
;           if gscores/:node < gscores/:curr [curr: node]
;         ]
;         take find openlist curr
;         ; print [{pick} curr {from [} openlist {] /} fscores]
        
;         ; termination
;         if curr = dest [
;           return reconstruct-path backlinks curr
;         ]

;         foreach node get-neighbours curr [
;           gscore: gscores/:curr + map/(node/y)/(node/x)
;           idx: 1 + index? find gscores node
;           print [curr {=>} node {costs} gscore]
;           if gscore < gscores/:idx [
;             ; update scores
;             gscores/:idx: gscore
;             fscores/:idx: gscore + manhattan-dist node dest
;             ; update backlinks
;             backlinks/:idx: curr
;             ; add node to openlist if it wasn't there
;             unless find openlist node [append openlist node]
;           ]
;         ]
;       ]
;     ]
; ;   ]
; ]

; --- Part 1 ---
r1: 0
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
print [{Part 2:} r2]
