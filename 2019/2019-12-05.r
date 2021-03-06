REBOL [
  Title: "Advent of Code 2019 - Day 05"
  Author: "Gaetan Barel"
  Version: 1.0.1
  Date: 05-December-2019
]

comment {    
  to launch the script, use
  > in-dir %/path_to_script [do %script.r]
}

comment {
  --- Day 5: Sunny with a Chance of Asteroids ---

  You're starting to sweat as the ship makes its way toward Mercury. The Elves 
  suggest that you get the air conditioner working by upgrading your ship 
  computer to support the Thermal Environment Supervision Terminal.

  The Thermal Environment Supervision Terminal (TEST) starts by running a 
  diagnostic program (your puzzle input). The TEST diagnostic program will run 
  on your existing Intcode computer after a few modifications:

  First, you'll need to add two new instructions:

    Opcode 3 takes a single integer as input and saves it to the position given 
    by its only parameter. For example, the instruction 3,50 would take an input
    value and store it at address 50.
    Opcode 4 outputs the value of its only parameter. For example, the 
    instruction 4,50 would output the value at address 50.

  Programs that use these instructions will come with documentation that 
  explains what should be connected to the input and output. The program 
  3,0,4,0,99 outputs whatever it gets as input, then halts.

  Second, you'll need to add support for parameter modes:

  Each parameter of an instruction is handled based on its parameter mode. Right
  now, your ship computer already understands parameter mode 0, position mode, 
  which causes the parameter to be interpreted as a position - if the parameter
  is 50, its value is the value stored at address 50 in memory. Until now, all 
  parameters have been in position mode.

  Now, your ship computer will also need to handle parameters in mode 1, 
  immediate mode. In immediate mode, a parameter is interpreted as a value - if 
  the parameter is 50, its value is simply 50.

  Parameter modes are stored in the same value as the instruction's opcode. The 
  opcode is a two-digit number based only on the ones and tens digit of the 
  value, that is, the opcode is the rightmost two digits of the first value in 
  an instruction. Parameter modes are single digits, one per parameter, read 
  right-to-left from the opcode: the first parameter's mode is in the hundreds 
  digit, the second parameter's mode is in the thousands digit, the third 
  parameter's mode is in the ten-thousands digit, and so on. Any missing modes 
  are 0.

  For example, consider the program 1002,4,3,4,33.

  The first instruction, 1002,4,3,4, is a multiply instruction - the rightmost 
  two digits of the first value, 02, indicate opcode 2, multiplication. Then, 
  going right to left, the parameter modes are 0 (hundreds digit), 1 (thousands 
  digit), and 0 (ten-thousands digit, not present and therefore zero):

  ABCDE
  1002

  DE - two-digit opcode,      02 == opcode 2
  C - mode of 1st parameter,  0 == position mode
  B - mode of 2nd parameter,  1 == immediate mode
  A - mode of 3rd parameter,  0 == position mode,
                                    omitted due to being a leading zero

  This instruction multiplies its first two parameters. The first parameter, 4 
  in position mode, works like it did before - its value is the value stored at 
  address 4 (33). The second parameter, 3 in immediate mode, simply has value 3.
  The result of this operation, 33 * 3 = 99, is written according to the third 
  parameter, 4 in position mode, which also works like it did before - 99 is 
  written to address 4.

  Parameters that an instruction writes to will never be in immediate mode.

  Finally, some notes:

    It is important to remember that the instruction pointer should increase by 
    the number of values in the instruction after the instruction finishes. 
    Because of the new instructions, this amount is no longer always 4.
    Integers can be negative: 1101,100,-1,4,0 is a valid program (find 100 + -1,
    store the result in position 4).

  The TEST diagnostic program will start by requesting from the user the ID of 
  the system to test by running an input instruction - provide it 1, the ID for 
  the ship's air conditioner unit.

  It will then perform a series of diagnostic tests confirming that various 
  parts of the Intcode computer, like parameter modes, function correctly. For 
  each test, it will run an output instruction indicating how far the result of 
  the test was from the expected value, where 0 means the test was successful. 
  Non-zero outputs mean that a function is not working correctly; check the 
  instructions that were run before the output instruction to see which one 
  failed.

  Finally, the program will output a diagnostic code and immediately halt. This 
  final output isn't an error; an output followed immediately by a halt means 
  the program finished. If all outputs were zero except the diagnostic code, the
  diagnostic program ran successfully.

  After providing 1 to the only input instruction and passing all the tests, 
  what diagnostic code does the program produce?
}

test: func [
  {Compares a function output to the expected output}
  block [block!] "the block to be evaluated"
  expected [any-type!] "the expected output"
  /local output 
][
  output: either ((type? block/1) = word!) 
    [do block] 
    [compose block]
  if not (output = expected) [
    print rejoin [
      "Error: " mold block newline
      " - expected: " mold expected newline
      " - output: " mold output
    ]
  ]
]

;------------------------------

get-code: func [
    memory [series!] "program to be read from"
    pos [integer!] "index to access [0-N]"
    mode [char! string!] "0: position ; 1: immediate"
    /local index
][
  ; TODO access modee
  index: switch mode [
    "position"  [ (memory/(pos + 1)) + 1 ]
    #"0"           [ (memory/(pos + 1)) + 1 ]
    "immediate" [ pos + 1 ]
    #"1"           [ pos + 1 ]
  ] [ print rejoin ["undefined mode " mode] ]
  ; print rejoin compose [
  ;   "get-code " mold memory 
  ;   " " mold pos 
  ;   " " mold mode 
  ;   " -> idx=" index
  ;   " -> output=" (memory/(index))
  ; ]
  memory/(index)
]

; test [get-code [1 2 3 4 5] 0 #"1"] 1
; test [get-code [1 2 3 4 5] 0 "immediate"] 1
; test [get-code [1 2 3 4 5] 0 #"0"] 2
; test [get-code [1 2 3 4 5] 0 "position"] 2
; test [get-code [5 4 3 2 1] 1 #"1"] 4
; test [get-code [5 4 3 2 1] 1 #"0"] 1

set-code: func [
  program [series!] "program to be modified"
  pos [integer!] "index to modify [0-N]"
  val [any-type!] "the new value"
] [
  head change/part (at program (pos + 1)) val 1
]

; test [set-code [1 2 3] 0 3] [3 2 3]

step-code: func [
    {Process the intcode at the given position}
    memory [block!] "the list of opcodes"
    'pos_out [word!] "the position of the opcode"
    /local op inst w1 w2 w3 pos val
][
  pos: get pos_out
  op: to-string get-code memory pos "immediate"
  while [(length? op) < 5] [insert head op "0"]
  inst: to-integer (at op 4) 
  prin rejoin compose ["step %" pos " : " op " >> "]
  switch inst [
    1 [
      w1: get-code memory (pos + 1) op/3
      w2: get-code memory (pos + 2) op/2
      w3: get-code memory (pos + 3) "immediate"
      print rejoin compose ["ADD %" (w3) ": (" (w1) " + " (w2) ")"]
      set-code memory w3 (w1 + w2)
      set pos_out (pos + 4)
    ]
    2 [       
      w1: get-code memory (pos + 1) op/3
      w2: get-code memory (pos + 2) op/2
      w3: get-code memory (pos + 3) "immediate"
      print rejoin compose ["MUL %" (w3) ": (" (w1) " * " (w2) ")"]
      set-code memory w3 (w1 * w2) 
      set pos_out (pos + 4)
    ]
    3 [ 
      w1: get-code memory (pos + 1) "immediate"
      val: to-integer ask "input =? "
      print rejoin compose ["IN  %" (w1) ": " (val)]
      set-code memory w1 val
      set pos_out (pos + 2)
    ]
    4 [ 
      w1: get-code memory (pos + 1) op/3
      val: get-code memory (pos + 1) "position"
      print rejoin compose ["OUT " val] 
      set pos_out (pos + 2)
    ]
    5 [
      w1: get-code memory (pos + 1) op/3
      w2: get-code memory (pos + 2) op/2
      val: either (not (w1 = 0)) [w2] [pos + 3]
      print rejoin compose ["JNE " w1 " /= 0 ( " val " )"] 
      set pos_out val
    ]
    6 [
      w1: get-code memory (pos + 1) op/3
      w2: get-code memory (pos + 2) op/2
      val: either (w1 = 0) [w2] [pos + 3]
      print rejoin compose ["JE  " w1 " = 0 ( " val " )"]
      set pos_out val    
    ]
    7 [
      w1: get-code memory (pos + 1) op/3
      w2: get-code memory (pos + 2) op/2
      w3: get-code memory (pos + 3) "immediate"
      val: either (w1 < w2) [1] [0]
      print rejoin compose ["LT  " w1 " < " w2 " ( %" w3 ": " val " )"]
      set-code memory w3 val
      set pos_out (pos + 4)
    ]
    8 [
      w1: get-code memory (pos + 1) op/3
      w2: get-code memory (pos + 2) op/2
      w3: get-code memory (pos + 3) "immediate"
      val: either (w1 = w2) [1] [0]
      print rejoin compose ["EQ  " w1 " = " w2 " ( %" w3 ": " val " )"]
      set-code memory w3 val
      set pos_out (pos + 4)
    ]
    99 [ 
      set pos_out -1
      print "BRK"
    ] ; abort
  ]
  return
]

; memory: [1002 4 3 4 33]
; pos: 0
; step-code memory pos
; test [memory] [1002 4 3 4 99]
; test [pos] 4

; memory: [1101 100 -1 4 0]
; pos: 0
; step-code memory pos
; test [memory] [1101 100 -1 4 99]
; test [pos] 4

run-code: func [input] [
  memory: copy input ;map-each entry parse input "," [to-integer entry]
  pos: 0
  while [pos >= 0] [
    step-code memory pos
  ]
]

__is_debug: false
__debug: func [block [block!]] [
  if __is_debug [print rejoin compose/only block]
]
debug: func [b [logic!]] [__is_debug: b return]
run-code2: func [data [block!] /local memory ip opcode inst modes params p1 p2 p3] [
  memory: ip: copy data
  ; opcode=(modes*100+inst) params=[p1 p2 p3]
  while [not tail? ip] [
    opcode: first+ ip  params: copy/part set [p1 p2 p3] ip 3
    inst: opcode // 100  modes: round/floor opcode / 100 
    forall params [
      if 0 = (modes // 10) [ params/1: memory/((params/1) + 1)]
      modes: round/floor modes / 10
    ]
    __debug ["%" (subtract ((length? head ip) - (length? ip)) 1) " [" opcode " " p1 " " p2 " " p3 "]"]
    ip: switch/default inst [
      1 [ __debug ["ADD %" p3 ": " params/1 " + " params/2]
          memory/(p3 + 1): (params/1 + params/2)
          skip ip 3 ]
      2 [ __debug ["MUL %" p3 ": " params/1 " * " params/2]
          memory/(p3 + 1): (params/1 * params/2)
          skip ip 3 ]
      3 [ __debug ["IN  %" p3]
          memory/(p1 + 1): to-integer ask "input =? "
          skip ip 1 ]
      4 [ print rejoin compose ["OUT = " memory/(p1 + 1)]
          skip ip 1 ]
      5 [ __debug ["JNE " params/1 " /=? 0 -> " params/2 ]
          either not (0 = params/1) [skip head ip params/2] [skip ip 2] ]
      6 [ __debug ["JEQ " params/1 " =? 0 ->" params/2 ]
          either (0 = params/1) [skip head ip params/2] [skip ip 2] ]
      7 [ __debug ["LT  %" p3 ": " params/1 " = " params/2]
          memory/(p3 + 1): either ((params/1) < (params/2)) [1] [0]  
          skip ip 3 ]
      8 [ __debug ["EQ  %" p3 ": " params/1 " = " params/2]
          memory/(p3 + 1): either ((params/1) = (params/2)) [1] [0]
          skip ip 3 ]
      99 [ ip: tail ip ]
    ] [ __debug ["ERROR unknown instruction " inst]  ip: tail ip ]
  ]
]

data: map-each entry (parse read %2019-12-05-input.txt ",") [to-integer entry]

; run-code2 data

comment {
  --- Part Two ---

  The air conditioner comes online! Its cold air feels good for a while, but 
  then the TEST alarms start to go off. Since the air conditioner can't vent its
  heat anywhere but back into the spacecraft, it's actually making the air 
  inside the ship warmer.

  Instead, you'll need to use the TEST to extend the thermal radiators. 
  Fortunately, the diagnostic program (your puzzle input) is already equipped 
  for this. Unfortunately, your Intcode computer is not.

  Your computer is only missing a few opcodes:

  * Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets the 
    instruction pointer to the value from the second parameter. Otherwise, it 
    does nothing.
  * Opcode 6 is jump-if-false: if the first parameter is zero, it sets the 
    instruction pointer to the value from the second parameter. Otherwise, it 
    does nothing.
  * Opcode 7 is less than: if the first parameter is less than the second 
    parameter, it stores 1 in the position given by the third parameter. 
    Otherwise, it stores 0.
  * Opcode 8 is equals: if the first parameter is equal to the second 
    parameter, it stores 1 in the position given by the third parameter. 
    Otherwise, it stores 0.

  Like all instructions, these instructions need to support parameter modes as 
  described above.

  Normally, after an instruction is finished, the instruction pointer increases 
  by the number of values in that instruction. However, if the instruction 
  modifies the instruction pointer, that value is used and the instruction 
  pointer is not automatically increased.

  For example, here are several programs that take one input, compare it to the 
  value 8, and then produce one output:

  * 3,9,8,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input 
    is equal to 8; output 1 (if it is) or 0 (if it is not).
  * 3,9,7,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input 
    is less than 8; output 1 (if it is) or 0 (if it is not).
  * 3,3,1108,-1,8,3,4,3,99 - Using immediate mode, consider whether the input 
    is equal to 8; output 1 (if it is) or 0 (if it is not).
  * 3,3,1107,-1,8,3,4,3,99 - Using immediate mode, consider whether the input 
    is less than 8; output 1 (if it is) or 0 (if it is not).

  Here are some jump tests that take an input, then output 0 if the input was 
  zero or 1 if the input was non-zero:

  * 3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 (using position mode)
  * 3,3,1105,-1,9,1101,0,0,12,4,12,99,1 (using immediate mode)

  Here's a larger example:

  3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
  1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
  999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99

  The above example program uses an input instruction to ask for a single 
  number. The program will then output 999 if the input value is below 8, output
  1000 if the input value is equal to 8, or output 1001 if the input value is 
  greater than 8.

  This time, when the TEST diagnostic program runs its input instruction to get 
  the ID of the system to test, provide it 5, the ID for the ship's thermal 
  radiator controller. This diagnostic test suite only outputs one number, the 
  diagnostic code.

  What is the diagnostic code for system ID 5?
}

; print rejoin [ newline "Part 2: " ]
; run-code "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"

; TODO
; #1 retrieve all values using set
; #2 merge run-code & step-code
; #3 switch pos (index) for ip (array at a given position)
; opcode: first+ ip memops: copy/part ip 3 
; mode: round opcode / 100 opcode: opcode // 100
; forall memops [
;   if 0 == (mode // 10) [
;     memops/1: memory/(memops/1 + 1)
;   ] mode: round mode / 10
; ]
; switch opcode [ blablabla ]
