REBOL [
  Title: {Day 15}
  Date: 15-12-2021
]

; import utility functions
do %util.r

; cavern: context [
;   map: none
;   use [] [
    map: collect [foreach l read/lines %data/test.txt [
      keep/only collect [foreach c l [keep c - #"0"]]
    ]]
    dims: as-pair length? map/1 length? map

    reconstruct-path: funct [backlinks current][
      total-path: reduce [current]
      while [all [
        idx: 1 + index? find extract backlinks 2 current
        backlinks/:idx
      ]][
        current: backlinks/:idx
        insert head total-path current
      ]
      total-path
    ]

    get-neighbours: funct [pos [pair!]][
      res: copy []
      if pos/x > 1 [append res pos - 1x0]
      if pos/y > 1 [append res pos - 0x1]
      if pos/x < dims/y [append res pos + 1x0]
      if pos/y < dims/y [append res pos + 0x1]
      res
    ]

    evaluate: funct [path [block!]][
      r: 0 foreach p next path [+= r map/(p/y)/(p/x)] r
    ]

    manhattan-dist: funct [a [pair!] b [pair!]][
      c: abs a - b  c/x + c/y
    ]

    a-star: func [start [pair!] dest [pair!]][
      ; gscore = cost of cheapest path known from start to pos
      ; fscore = best guess at shortest path from start to finish
      ; backlinks = list of dest-node from-node
      openlist: reduce [start]
      tmp: copy [] repeat x dims/x [repeat y dims/y[append tmp reduce[as-pair x y none]]]
      infinity: to-integer (power 2 31) - 1
      gscores: copy tmp  forskip gscores 2 [gscores/2: infinity]  gscores/:start: 0
      fscores: copy tmp  fscores/:start: manhattan-dist start dest
      backlinks: copy tmp

      while [not empty? openlist] [
        ; find node in open list with lowest fscore
        curr: openlist/1 foreach node openlist [
          if gscores/:node < gscores/:curr [curr: node]
        ]
        take find openlist curr
        ; print [{pick} curr {from [} openlist {] /} fscores]
        
        ; termination
        if curr = dest [
          return reconstruct-path backlinks curr
        ]

        foreach node get-neighbours curr [
          gscore: gscores/:curr + map/(node/y)/(node/x)
          idx: 1 + index? find gscores node
          print [curr {=>} node {costs} gscore]
          if gscore < gscores/:idx [
            ; update scores
            gscores/:idx: gscore
            fscores/:idx: gscore + manhattan-dist node dest
            ; update backlinks
            backlinks/:idx: curr
            ; add node to openlist if it wasn't there
            unless find openlist node [append openlist node]
          ]

          ; fscore: gscore + manhattan-dist node dest
          ; either find extract gscores 2 node [
          ;   ; print [
          ;   ;   {compare} reduce [node gscore fscore] 
          ;   ;   {<?} reduce [node gscores/:node fscores/:node]
          ;   ; ]
          ;   if gscore < gscores/:node [
          ;     ; print [{ => update} reduce [node gscore fscore]]
          ;     unless find openlist node [append openlist node]
          ;     gscores/:node: gscore
          ;     fscores/:node: fscore
          ;     links/:node: curr
          ;   ]
          ; ][
          ;   ; print [{ => add} reduce [node gscore fscore]]
          ;   append openlist node
          ;   append gscores reduce [node gscore]
          ;   append fscores reduce [node fscore]
          ;   append links reduce [node curr]
          ; ]
        ]
        ; probe closedlist
      ]
    ]
;   ]
; ]

; --- Part 1 ---
r1: 0
print [{Part 1:} r1]

; --- Part 2 ---
r2: 0
print [{Part 2:} r2]
