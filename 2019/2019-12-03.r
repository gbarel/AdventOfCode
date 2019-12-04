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

test: func [
    {Compares a function output to the expected output}
    'fn [word!] "Function to test"
    data [any-type!] "the function input"
    expected [any-type!] "the expected output"
    /local 
    output [any-type!] "the actual function output"
][
    output: pick reduce join (reduce [fn]) data 1
    if not (output = expected) [
        print rejoin [
            "Error: " :fn " " mold :data newline
            " - expected: " mold expected newline
            " - output: " mold output
        ]
    ]
]

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
            curr: compose [
                ((pick prev 1) + (to-integer dx)) 
                ((pick prev 2) + (to-integer dy))
            ]
            append/only locations curr
        ]
    ]
    locations
]

test parse-wire-path [[]] [[0 0]]
test parse-wire-path [["U1"]] [[0 0] [0 1]]
test parse-wire-path [["D1"]] [[0 0] [0 -1]]
test parse-wire-path [["R1"]] [[0 0] [1 0]]
test parse-wire-path [["L1"]] [[0 0] [-1 0]]
test parse-wire-path [["L1" "R2" "U3" "D4"]] [[0 0] [-1 0] [1 0] [1 3] [1 -1]]

get-intersection: func [
    "Find where two lines cross"
    p1 [series!] "first point of first line"
    p2 [series!] "second point of first line"
    p3 [series!] "first point of second line"
    p4 [series!] "second point of second line"
] [
    ; line 1 and line 2 must be orthogonal
    if all [
        (p1/1 = p2/1) 
        (p3/2 = p4/2)
        (p1/1 <= max p3/1 p4/1) 
        (p1/1 >= min p3/1 p4/1)
        (p3/2 <= max p1/2 p2/2)
        (p3/2 >= min p1/2 p2/2)
    ] [
        return compose [(p1/1) (p3/2)]
    ]
    if all [
        (p1/2 = p2/2) 
        (p3/1 = p4/1)
        (p1/2 <= max p3/2 p4/2) 
        (p1/2 >= min p3/2 p4/2)
        (p3/1 <= max p1/1 p2/1)
        (p3/1 >= min p1/1 p2/1)
    ] [
        return compose [(p3/1) (p1/2)]
    ]
]

test get-intersection [[-1 0] [1 0] [0 -1] [0 1]]  [0 0]
test get-intersection [[-1 0] [5 0] [2 -1] [2 5]]  [2 0]
test get-intersection [[-1 -1] [-1 -6] [2 -3] [-2 -3]] [-1 -3]

dist?: func [p1 p2] [
    absolute (p2/1 - p1/1) + absolute (p2/2 - p1/2)
]

get-intersection-list: func [
    "Find the list of intersections for two wire paths"
    path1 [series!] "the points made up by the first line"
    path2 [series!] "the points made up by the second line"
    /length
    /local output p length1 length2 p1 p2 p3 p4
] [
    output: copy []
    length1: 0
    length2: 0
    repeat i ((length? path1) - 1) [
        p1: path1/(i)
        p2: path1/(i + 1)
        repeat j ((length? path2) - 1) [
            p3: path2/(j)
            p4: path2/(j + 1)
            p: get-intersection p1 p2 p3 p4
            if any [p] [
                if any [length] [
                    val: length1 + length2 + (dist? p1 p) + (dist? p3 p)
                    append p val
                ]
                append/only output p
            ]
            length2: length2 + dist? p3 p4
        ]
        length1: length1 + dist? p1 p2
        length2: 0
    ]
    output
]

get-shortest-distance: func [
    "Finds closest intersection"
    points [series!] "a list of points"
    /length
    /local min-dist 
] [
    min-dist: none
    foreach p points [
        dist: either length [p/3] [(absolute p/1) + (absolute p/2)]
        if all [
            dist > 0
            any [none? min-dist  dist < min-dist]
        ] [
            min-dist: dist
        ]
    ]
    min-dist
]

get-manhattan-distance: func [
    {Return the closest intersection of two paths}
    path1 [series!] "the path1 string input"
    path2 [series!] "the path2 string input"
    /length
][
    points1: parse-wire-path parse path1 ","
    points2: parse-wire-path parse path2 ","
    intersections: get-intersection-list/length points1 points2 1
    get-shortest-distance intersections
]

test get-manhattan-distance [
    "R75,D30,R83,U83,L12,D49,R71,U7,L72" 
    "U62,R66,U55,R34,D71,R55,D58,R83"
] 159
test get-manhattan-distance [
    "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
    "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
] 135

; 1. parse input
input-file: %2019-12-03-input.txt
; data: load replace/all read filepath "," " "
data: read/lines input-file
prin "Answer part 1: " print get-manhattan-distance data/1 data/2
prin "Answer part 2: " print get-manhattan-distance/length data/1 data/2

; -------------------------

comment {
    It turns out that this circuit is very timing-sensitive; you actually need 
    to minimize the signal delay.

    To do this, calculate the number of steps each wire takes to reach each 
    intersection; choose the intersection where the sum of both wires' steps is 
    lowest. If a wire visits a position on the grid multiple times, use the 
    steps value from the first time it visits that position when calculating the
    total value of a specific intersection.

    The number of steps a wire takes is the total number of grid squares the
    wire has entered to get to that location, including the intersection being 
    considered. Again consider the example from above:

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

    In the above example, the intersection closest to the central port is 
    reached after 8+5+5+2 = 20 steps by the first wire and 7+6+4+3 = 20 steps by
    the second wire for a total of 20+20 = 40 steps.

    However, the top-right intersection is better: the first wire takes only 
    8+5+2 = 15 and the second wire takes only 7+6+2 = 15, a total of 15+15 = 30 
    steps.

    Here are the best steps for the extra examples from above:

        R75,D30,R83,U83,L12,D49,R71,U7,L72
        U62,R66,U55,R34,D71,R55,D58,R83 = 610 steps
        R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
        U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = 410 steps

    What is the fewest combined steps the wires must take to reach an 
    intersection?
}

