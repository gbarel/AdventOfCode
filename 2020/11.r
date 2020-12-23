REBOL [
  Title: {AoC 2020 - Day 11}
  Date: 11-12-2020
]

algo: context [
  count: funct [series value] [
    cnt: 0 forall series [all [series/1 = value ++ cnt]] cnt
  ]
]

d11: context [
  ; colors
  empty: 0.255.0.0 occupied: 255.0.0.0 floor: 0.0.0.0 
  ; dirs  
  dirs: [-1x-1 -1x0 -1x1 0x-1 0x1 1x-1 1x0 1x1]
  ; data
  data: none bitmap: none threshold: none count-adj: none 

  xy?: func [image [image!]] [
    as-pair 
        (index? image) - 1 // image/size/x
        (index? image) - 1 / image/size/x
  ]

  update-seats: funct [img [image!]] [
    make image! append/only reduce [img/size] collect [
      it: img until [
        count: count-adj head it xy? it
        keep switch first it compose [
          (floor) [floor]
          (empty) [either equal? count 0 [occupied][empty]]
          (occupied) [either greater-or-equal? count threshold [empty][occupied]]
        ]
        tail? it: next it
      ]
    ]
  ]

  process: funct [/test /visible /debug] [
    set 'data read/lines either test [%data/11test.txt] [%data/11.txt]
    ; make image! [pair [data]]
    ; make image! append/only reduce [pair] data
    width: length? data/1 height: length? data
    set 'bitmap make image! append/only reduce [as-pair width height] collect [
      foreach line data [foreach seat line [keep switch seat [#"L" [empty] #"#" [occupied] #"." [floor]]]]
    ]
    set 'threshold either visible [5][4]
    set 'count-adj either visible [
      funct [img coord /visible] [
        count: 0 
        foreach dir dirs [
          p: coord forever [
            p: p + dir
            either all [p/x >= 0 p/y >= 0 p/x < img/size/x p/y < img/size/y] [
              switch img/:p compose [(occupied) [++ count break] (empty) [break]] 
            ] [
              break
            ]
          ]
        ]
        count
      ]
    ] [
      funct [img coord /visible] [
        count: 0
        foreach dir dirs [
          p: coord + dir
          all [p/x >= 0 p/y >= 0 p/x < img/size/x p/y < img/size/y img/:p = occupied ++ count]
        ]
        count
      ]
    ]
    img: bitmap
    either debug [
      view layout compose [
        ; img-face: image img (img/size * 10) rate 1 feel [
        ;   redraw: func [face act pos] [switch act [draw [face/image: img img: update-seats img]]]
        ; ]
        ; button {Draw} [show img-face]
        image img (img/size * 10) rate 5 feel [
          engage: func [face act evt] [
            if act = 'time [
              face/image: img: update-seats img
              show face
            ]
          ]
        ]
      ]
    ][
      until [
        img: update-seats bkp: img
        equal? bkp img
      ]
      algo/count img occupied
    ]
  ]
]

; --- Part 1 ---
r1: d11/compute
print [{Part 1:} r1]

; --- Part 2 ---
r2: d11/compute/visible
print [{Part 2:} r2]
