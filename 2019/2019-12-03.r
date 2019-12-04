REBOL [
    Title: "Advent of Code 2019 - Day 03"
    Author: "Gaetan Barel"
    Version: 1.0.0
    Date: 03-December-2019
]

comment {    
    to launch the script, use
    > change-dir %/path_to_script
    > do %script.r
}

comment {
    --- Day 3: Crossed Wires ---

    The gravity assist was successful, and you're well on your way to the Venus 
    refuelling station. During the rush back on Earth, the fuel management 
    system wasn't completely installed, so that's next on the priority list.

    Opening the front panel reveals a jumble of wires. Specifically, two wires 
    are connected to a central port and extend outward on a grid. You trace the 
    path each wire takes as it leaves the central port, one wire per line of 
    text (your puzzle input).

    The wires twist and turn, but the two wires occasionally cross paths. To fix
    the circuit, you need to find the intersection point closest to the central
    port. Because the wires are on a grid, use the Manhattan distance for this
    measurement. While the wires do technically cross right at the central port 
    where they both start, this point does not count, nor does a wire count as 
    crossing with itself.

    For example, if the first wire's path is R8,U5,L5,D3, then starting from the
    central port (o), it goes right 8, up 5, left 5, and finally down 3:

    ...........
    ...........
    ...........
    ....+----+.
    ....|....|.
    ....|....|.
    ....|....|.
    .........|.
    .o-------+.
    ...........

    Then, if the second wire's path is U7,R6,D4,L4, it goes up 7, right 6, 
    down 4, and left 4:

    ...........
    .+-----+...
    .|.....|...
    .|..+--X-+.
    .|..|..|.|.
    .|.-X--+.|.
    .|..|....|.
    .|.......|.
    .o-------+.
    ...........

    These wires cross at two locations (marked X), but the lower-left one is 
    closer to the central port: its distance is 3 + 3 = 6.

    Here are a few more examples:

        R75,D30,R83,U83,L12,D49,R71,U7,L72
        U62,R66,U55,R34,D71,R55,D58,R83 = distance 159
        R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
        U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = distance 135

    What is the Manhattan distance from the central port to the closest 
    intersection?
}

; representation [[X1,Y1], [X2,Y2], ...]


parse-wire-path: func [
    "Return a list of all turning points of a wire (starting point = [0,0])"
    path [series!] "the list of wire locations"
    /local locations
] [
    locations: copy [[0 0]]
    foreach movement path [
        use [dx dy] [
            dx: dy: "0"
            parse movement [
                "R" copy dx to end |
                "L" copy dx to end (insert head dx "-") |
                "U" copy dy to end |
                "D" copy dy to end (insert head dy "-") |
            ]
            prev: last locations
            curr: probe compose [
                ((pick prev 1) + (to-integer dx)) 
                ((pick prev 2) + (to-integer dy))
            ]
            append/only locations curr
        ]
    ]
    locations
]

get-intersection: func [
    "Find where two lines cross"
    point1 [series!] "first point of first line"
    point2 [series!] "second point of first line"
    point3 [series!] "first point of second line"
    point4 [series!] "second point of second line"
] [
    ; line 1 and line 2 must be orthogonal
    if all [
        (point1/1 = point2/1) 
        (point3/2 = point4/2) 
        (point1/1 < max point3/1 point4/1) 
        (point1/1 > min point3/1 point4/1)
        (point3/2 < max point1/2 point2/2)
        (point3/2 > min point1/2 point2/2)
    ] [
        compose [(pick point1 1) (pick point3 2)]
    ]
    if all [
        (point1/2 = point2/2) 
        (point3/1 = point4/1)
        (point1/2 < max point3/2 point4/2) 
        (point1/2 > min point3/2 point4/2)
        (point3/1 < max point1/1 point2/1)
        (point3/1 > min point1/1 point2/1)
    ] [
        compose [(pick point3 1) (pick point1 2)]
    ]
]



; -------------------------

; test: funct ['fn input expected /local output] [
;     output: (do reduce insert input fn)
;     if not (output = expected) [
;         print rejoin [
;             "Error: " :fn " " :input newline
;             " - expected: " expected newline
;             " - output: " output
;         ]
;     ]
; ]

; test parse-wire-path [] [[0 0]]
; test parse-wire-path ["U1"] [[0 0] [0 1]]
; test parse-wire-path ["D1"] [[0 0] [0 -1]]
; test parse-wire-path ["R1"] [[0 0] [1 0]]
; test parse-wire-path ["L1"] [[0 0] [-1 0]]
; test parse-wire-path ["L1" "R2" "U3" "D4"] [[0 0] [-1 0] [1 0] [1 3] [1 -1]]

; test get-intersection [[-1 0] [1 0] [0 -1] [0 1]] [[0 0]]
; test get-intersectino [[-1 0] [5 0] [2 -1] [2 5]] [[2 0]]
