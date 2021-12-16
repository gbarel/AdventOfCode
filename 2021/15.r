REBOL [
  Title: {Day 15}
  Date: 15-12-2021
]

; import utility functions
do %util.r

astar: context [
  openlist: state: data: dims: none

  init: func [/test /large][
    lines: read/lines either test [%data/test.txt][%data/15.txt]
    dims: as-pair length? lines/1 length? lines
    data: collect [foreach l lines [
      keep/only collect [foreach c l [keep c - #"0"]]
    ]]

    if large [
      ; duplicate data 5 times along the x axis (adding num each time)
      repeat y dims/y [
        row: copy data/:y
        loop 4 [
          append data/:y row: map-each i row [either i = 9 [1][i + 1]]
        ]
      ]
      ; duplicate new data 5 times along the y axis (adding num each time)
      repeat y (4 * dims/y) [
        append/only data map-each i data/:y [either i = 9 [1][i + 1]]
      ]
      ; update dims
      dims: dims * 5
    ]
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
    while [all [statecurr: get-state current  statecurr/3]][
      current: statecurr/3  append total-path current
    ]
    reverse total-path
  ]

  evaluate: funct [path [block!]][
    r: 0 foreach p next path [+= r data/(p/y)/(p/x)] r
  ]

  manhattan-dist: funct [a [pair!] b [pair!]][
    c: abs a - b  c/x + c/y
  ]

  get-state: funct [p [pair!]][
    i: p/x + ((p/y - 1) * dims/x)
    state/:i
  ]

  compute: func [
    /with
    start [pair!] 
    dest [pair!]
  ][
    unless with [start: 1x1  dest: dims]
    ; state/openlist = list of pos to consider
    ; state = map of pos -> [gscore fscore backlink]
    openlist: reduce [start]
    state: array/initial (dims/x * dims/y) reduce [(to-integer (power 2 31) - 1) 0 none]
    statestart: get-state start  statestart/1: 0  statestart/2: manhattan-dist start dest

    step-cnt: 0
    while [not empty? openlist] [
      ; find node in open list with lowest fscore
      curr: openlist/1  statecurr: get-state curr
      foreach pos openlist [
        statepos: get-state pos
        if (statepos/1 < statecurr/1) [curr: pos  statecurr: statepos]
      ]
      ; print [{pick} curr statecurr {from [} openlist {] /}]
      take find openlist curr
      
      ; termination
      if curr = dest [
        path: reconstruct curr
        return reduce [evaluate path  path]
      ]

      ++ step-cnt
      foreach pos get-neighbours curr [
        gscore: statecurr/1 + data/(pos/y)/(pos/x)
        statepos: get-state pos
        ; print [{ compare} curr {->} pos {costs} gscore { // current state:} statepos]
        if gscore < statepos/1 [
          ; update state (gscore fscore backlink)
          statepos/1: gscore
          statepos/2: gscore + manhattan-dist pos dest
          statepos/3: curr
          ; print [{  update} pos statepos]
          ; add pos to openlist if it wasn't there
          unless find openlist pos [
            append openlist pos
            ; print [{  addlist} pos]
          ]
        ]
      ]
    ]
  ]
]

; --- Part 1 ---
astar/init
path1: astar/compute
r1: path1/1
print [{Part 1:} r1]

; --- Part 2 ---
astar/init/large
path2: astar/compute
r2: path2/1
print [{Part 2:} r2]
