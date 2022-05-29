# 
# CSC258 Fall 2021 Assembly Project
# University of Toronto, ST.GEORGE
#
# Student: Jiwoo Jung, 1006868613
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Reached Milestones 1, 2, 3, 4, 5
#
# Features
# 1. Display the number of lives remaining.
# 2. After final player death, display game over/retry screen. Restart the game if the "retry" option is chosen.
# 3. Dynamic increase in difficulty (speed, obstacles, etc.) as game progresses
# 4. Have objects in different rows move at different speeds.
# 5. Add a third row in each of the water and road sections.
# 6. Make a second level that starts after the player completes the first level.

.data
displayAddress: .word 0x10008000
x_value: .word 60
y_value: .word 3712
carspace1: .word 2564
carspace2: .word 2636
carspace3: .word 2944
carspace4: .word 3012
carspace5: .word 3328
carspace6: .word 3392
logspace1: .word 1056
logspace2: .word 1112
logspace3: .word 1452
logspace4: .word 1492
logspace5: .word 1800
logspace6: .word 1840

.text
lw $a1, displayAddress
lw $a2, displayAddress
lw $a3, displayAddress
li $s0, 0x00ff00 # $s0 stores the green colour code
addi $a1, $a1, 384
jal ROW # draws safe zone (green)
addi $a1, $a1, 128 # moves down to next row
jal ROW # draws safe zone
addi $a2, $a2, 656
addi $a3, $a3, 1024
li $s0, 0xffffff # white
jal RECTANGLE
addi $a2, $a2, 32
jal RECTANGLE
addi $a2, $zero, 3
jal LIFE
jal DRAW_MAP
jal UPDATE # updates the map
jal RETRY
addi $a2, $zero, 2
jal LIFE
jal RETRY
jal UPDATE
addi $a2, $zero, 1
jal LIFE
jal RETRY
jal UPDATE1
addi $a2, $zero, 0
jal LIFE
jal BLUESCREEN
jal GAME
Exit:
li $v0, 10 # terminate the program gracefully
syscall

GAME:
addi $t0, $zero, 0
addi $t1, $zero, 1
addi $sp, $sp, -4
sw $ra, 0($sp)
beq $t0, $t1, GAME_END
jal MOVE
j GAME
GAME_END:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

# Main
MAIN:
lw $a1, displayAddress
lw $a2, displayAddress
lw $a3, displayAddress
li $s0, 0x00ff00 # $s0 stores the green colour code
addi $a1, $a1, 384
jal ROW # draws safe zone (green)
addi $a1, $a1, 128 # moves down to next row
jal ROW # draws safe zone
addi $a2, $a2, 656
addi $a3, $a3, 1024
li $s0, 0xffffff # white
jal RECTANGLE
addi $a2, $a2, 32
jal RECTANGLE
addi $a2, $zero, 3
jal LIFE
jal DRAW_MAP
jal UPDATE # updates the map
jal RETRY
addi $a2, $zero, 2
jal LIFE
jal RETRY
jal UPDATE
addi $a2, $zero, 1
jal LIFE
jal RETRY
jal UPDATE1
addi $a2, $zero, 0
jal LIFE
jal BLUESCREEN
addi $t0, $zero, 0
addi $t1, $zero, 1
jal GAME

# Main
MAIN1:
lw $a1, displayAddress
lw $a2, displayAddress
lw $a3, displayAddress
li $s0, 0x00ff00 # $s0 stores the green colour code
addi $a1, $a1, 384
jal ROW # draws safe zone (green)
addi $a1, $a1, 128 # moves down to next row
jal ROW # draws safe zone
addi $a2, $a2, 656
addi $a3, $a3, 1024
li $s0, 0xffffff # white
jal RECTANGLE
addi $a2, $a2, 32
jal RECTANGLE
addi $a2, $zero, 3
jal LIFE
jal DRAW_MAP
jal UPDATE1 # updates the map
jal RETRY
addi $a2, $zero, 2
jal LIFE
jal RETRY
jal UPDATE1
addi $a2, $zero, 1
jal LIFE
jal RETRY
jal UPDATE1
addi $a2, $zero, 0
jal LIFE
jal BLUESCREEN
addi $t0, $zero, 0
addi $t1, $zero, 1
jal GAME

BLUESCREEN:
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $t0, $zero, 0
addi $t1, $zero, 10
li $s0, 0x0000ff
lw $a1, displayAddress
jal ROW
addi $a1, $a1, 256
BLUESCREEN_START:
beq $t0, $t1, BLUESCREEN_END
jal ROW
addi $a1, $a1, 256
addi $t0, $t0, 1
j BLUESCREEN_START
BLUESCREEN_END:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

# Life Function
LIFE:
addi $sp, $sp, -4
sw $ra, 0($sp)
li $s0, 0x000000
lw $a1, displayAddress
jal ROW
li $s0, 0xE650E6 # purple
lw $a0, displayAddress
addi $a0, $a0, 128
addi $t4, $zero, 0 # loop counter
LIFE_LOOP:
beq $t4, $a2, LIFE_END
sw $s0, 0($a0)
addi $a0, $a0, 8
addi $t4, $t4, 1
j LIFE_LOOP
LIFE_END:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

RETRY:
addi $sp, $sp, -4
sw $ra, 0($sp)
la $t1, x_value 
la $t2, y_value
addi $t3, $zero, 60
addi $t4, $zero, 3712
sw $t3, 0($t1)
sw $t4, 0($t2)
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

# Square Function
SQUARE:
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $t4, $zero, 0 # $t4 stores the value 0
addi $t5, $zero, 4 # $t5 stores the value 4
SQUARE_START:
beq $t4, $t5, SQUARE_END # check condition satisfied
sw $s0, 0($a0) # paint the given unit
addi $a0, $a0, 128 # increment $a0 to move displayAddress
#ble $a0, $a3, UPDATE_LINE
sw $s0, 0($a0) # paint the given unit
addi $a0, $a0, 128 # increment $a0 to move displayAddress
#ble $a0, $a3, UPDATE_LINE
sw $s0, 0($a0) # paint the given unit
addi $a0, $a0, -252 # increment $a0 to move to next line
#ble $a0, $a3, UPDATE_LINE
addi $t4, $t4, 1 # incremement counter
j SQUARE_START # jump to start
j SAME_LINE
SQUARE_END:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

# LINE Function
LINE:
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $t4, $zero, 0 # $t4 stores the value 0
addi $t5, $zero, 1 # $t5 stores the value 4
SAME_LINE:
ble $a0, $a3, UPDATE_LINE
LINE_START:
beq $t4, $t5, LINE_END # check condition satisfied
sw $s0, 0($a0) # paint the given unit
addi $a0, $a0, 128 # increment $a0 to move displayAddress
sw $s0, 0($a0) # paint the given unit
addi $a0, $a0, 128 # increment $a0 to move displayAddress
sw $s0, 0($a0) # paint the given unit
addi $a0, $a0, -252 # increment $a0 to move to next line
addi $t4, $t4, 1 # incremement counter
j LINE_START # jump to start
UPDATE_LINE:
addi $a0, $a0, 128
j SAME_LINE
LINE_END:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

# LINE1 Function
LINE1:
addi $sp, $sp, -4
sw $ra, 0($sp)
addi $t4, $zero, 0 # $t4 stores the value 0
addi $t5, $zero, 1 # $t5 stores the value 4
SAME_LINE1:
bge $a0, $a3, UPDATE_LINE1
LINE_START1:
beq $t4, $t5, LINE_END1 # check condition satisfied
sw $s0, 0($a0) # paint the given unit
addi $a0, $a0, 128 # increment $a0 to move displayAddress
sw $s0, 0($a0) # paint the given unit
addi $a0, $a0, 128 # increment $a0 to move displayAddress
sw $s0, 0($a0) # paint the given unit
addi $a0, $a0, -252 # increment $a0 to move to next line
addi $t4, $t4, 1 # incremement counter
j LINE_START1 # jump to start
UPDATE_LINE1:
addi $a0, $a0, -128
j SAME_LINE1
LINE_END1:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

# Rectangle Function
RECTANGLE:
addi $sp, $sp, -4 # stack pointer goes down the stack
sw $ra, 0($sp) # $sp gets the value of $ra
add $t2, $zero, $zero
addi $t3, $zero, 8
RECTANGLE_START:
lw $a0, displayAddress
beq $t2, $t3, RECTANGLE_END # check condition satisfied
addi $a0, $a2, 0
jal LINE # call LINE function
addi $a2, $a2, 4 # change location of next square to complete row
addi $t2, $t2, 1 # increment counter
j RECTANGLE_START # jump to start
RECTANGLE_END:
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra

# Rectangle Function
RECTANGLE1:
addi $sp, $sp, -4 # stack pointer goes down the stack
sw $ra, 0($sp) # $sp gets the value of $ra
add $t2, $zero, $zero
addi $t3, $zero, 8
RECTANGLE_START1:
lw $a0, displayAddress
beq $t2, $t3, RECTANGLE_END1 # check condition satisfied
addi $a0, $a2, 0
jal LINE1 # call LINE function
addi $a2, $a2, 4 # change location of next square to complete row
addi $t2, $t2, 1 # increment counter
j RECTANGLE_START1 # jump to start
RECTANGLE_END1:
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra

# Row Function
ROW:
addi $sp, $sp, -4 # stack pointer goes down the stack
sw $ra, 0($sp) # $sp gets the value of $ra
addi $t6, $zero, 0 # $t6 stores the value 0
addi $t7, $zero, 8 # $t7 stores the value 8
ROW_START:
beq $t6, $t7, ROW_END # check condition satisfied
addi $a0, $a1, 0
jal SQUARE # call SQUARE function to make row
addi $a1, $a1, 16 # change location of next square to complete row
addi $t6, $t6, 1 # increment counter
j ROW_START # jump to start
ROW_END:
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra

# Draw Map
DRAW_MAP:
addi $sp, $sp, -4
sw $ra, 0($sp)
lw $a1, displayAddress
li $s0, 0x0000ff
addi $a1, $a1, 1024
jal ROW # draws river (blue)
addi $a1, $a1, 256
jal ROW # draws river (blue)
addi $a1, $a1, 256
jal ROW # draws river (blue)
li $s0, 0xF5F5DC # $t3 stores the beige colour code
addi $a1, $a1, 256
jal ROW # draws middle zone
li $s0, 0x000000 # $t3 stores the black colour code
addi $a1, $a1, 256
jal ROW # draws road
addi $a1, $a1, 256
jal ROW # draws road
addi $a1, $a1, 256
jal ROW # draws road
li $s0, 0x00ff00 # $t3 stores the green colour code
addi $a1, $a1, 256
jal ROW # draws start zone
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

# Frog Function
FROG:
addi $sp, $sp, -4 # stack pointer goes down the stack
sw $ra, 0($sp) # $sp gets the value of $ra
lw $a2, displayAddress
li $s0, 0xE650E6 # purple
lw $t0, x_value
lw $t1, y_value
add $t2, $t1, $t0
add $a2, $a2, $t2
sw $s0, 0($a2)
addi $a2, $a2, 12
sw $s0, 0($a2)
addi $a2, $a2, 116
sw $s0, 0($a2)
addi $a2, $a2, 4
sw $s0, 0($a2)
addi $a2, $a2, 4
sw $s0, 0($a2)
addi $a2, $a2, 4
sw $s0, 0($a2)
addi $a2, $a2, 116
sw $s0, 0($a2)
addi $a2, $a2, 12
sw $s0, 0($a2)
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra

# Move logs and cars
MOVE_OBSTACLES:
addi $sp, $sp, -4 # stack pointer goes down the stack
sw $ra, 0($sp) # $sp gets the value of $ra
add $t0, $zero, $zero # counter
addi $t1, $zero, 1
MOVE_OBSTACLES_START:
beq $t0, $t1, MOVE_OBSTACLES_END
lw $a2, displayAddress
add $a2, $a2, $t8
jal RECTANGLE
add $t8, $t8, -4
sw $t8, 0($t9)
addi $t0, $t0, 1
MOVE_OBSTACLES_END:
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra

# Move logs and cars
MOVE_OBSTACLES1:
addi $sp, $sp, -4 # stack pointer goes down the stack
sw $ra, 0($sp) # $sp gets the value of $ra
add $t0, $zero, $zero # counter
addi $t1, $zero, 1
MOVE_OBSTACLES_START1:
beq $t0, $t1, MOVE_OBSTACLES_END1
lw $a2, displayAddress
add $a2, $a2, $t8
jal RECTANGLE1
add $t8, $t8, 8
sw $t8, 0($t9)
addi $t0, $t0, 1
j MOVE_OBSTACLES_START1
MOVE_OBSTACLES_END1:
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra

# Move logs and cars
MOVE_OBSTACLES2:
addi $sp, $sp, -4 # stack pointer goes down the stack
sw $ra, 0($sp) # $sp gets the value of $ra
add $t0, $zero, $zero # counter
addi $t1, $zero, 1
MOVE_OBSTACLES_START2:
beq $t0, $t1, MOVE_OBSTACLES_END2
lw $a2, displayAddress
add $a2, $a2, $t8
jal RECTANGLE1
add $t8, $t8, 12
sw $t8, 0($t9)
addi $t0, $t0, 1
j MOVE_OBSTACLES_START1
MOVE_OBSTACLES_END2:
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra

# Move Frog
MOVE:
addi $sp, $sp, -4 # stack pointer goes down the stack
sw $ra, 0($sp) # $sp gets the value of $ra
INPUT:
lw $t0, 0xffff0004
beq $t0, 0x77, UP
beq $t0, 0x64, RIGHT
beq $t0, 0x61, LEFT
beq $t0, 0x73, DOWN
beq $t0, 0x72, RESTART
beq $t0, 0x6E, NEXT
UP:
la $t1, y_value 
lw $t2, y_value
addi $t2, $t2, -384
sw $t2, 0($t1)
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra
RIGHT:
la $t1, x_value 
lw $t2, x_value
addi $t2, $t2, 16
sw $t2, 0($t1)
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra
LEFT:
la $t1, x_value 
lw $t2, x_value
addi $t2, $t2, -16
sw $t2, 0($t1)
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra
DOWN:
la $t1, y_value 
lw $t2, y_value
addi $t2, $t2, 384
sw $t2, 0($t1)
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra
RESTART:
la $t1, x_value 
la $t2, y_value
addi $t3, $zero, 60
addi $t4, $zero, 3712
sw $t3, 0($t1)
sw $t4, 0($t2)
jal MAIN
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra
NEXT:
la $t1, x_value 
la $t2, y_value
addi $t3, $zero, 60
addi $t4, $zero, 3712
sw $t3, 0($t1)
sw $t4, 0($t2)
jal MAIN1
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra

# Collision for rivers

# Update Function
UPDATE:
addi $sp, $sp, -4 # stack pointer goes down the stack
sw $ra, 0($sp) # $sp gets the value of $ra

lw $a0, displayAddress # a0 stores the base address for display
lw $a1, displayAddress # a1 stores the base address for display
lw $a2, displayAddress # a2 stores the base address for display
li $s0, 0x00ff00 # $s0 stores the green colour code

addi $s4, $zero, 0
addi $s5, $zero, 10000
UPDATE_START:
beq $s4, $s5, OBSTACLES
lw $t0, 0xffff0000
beq $t0, 1, MOVE
jal FROG # draw frog
lw $s6, x_value
lw $s7, y_value
add $s7, $s7, $s6
lw $s6, carspace6
addi $s4, $s4, 1
j UPDATE_START
OBSTACLES:
jal DRAW_MAP
jal FROG
bge $s6, $s7, UPDATE_END
# Cars
li $s0, 0xff0000 # $s0 stores the red colour code
lw $a3, displayAddress
addi $a3, $a3, 2556
lw $t8, carspace1
la $t9, carspace1
jal MOVE_OBSTACLES
lw $t8, carspace2
la $t9, carspace2
jal MOVE_OBSTACLES

lw $a3, displayAddress
addi $a3, $a3, 3068
lw $t8, carspace3
la $t9, carspace3
jal MOVE_OBSTACLES1
lw $t8, carspace4
la $t9, carspace4
jal MOVE_OBSTACLES1

lw $a3, displayAddress
addi $a3, $a3, 3324
lw $t8, carspace5
la $t9, carspace5
jal MOVE_OBSTACLES
lw $t8, carspace6
la $t9, carspace6
jal MOVE_OBSTACLES

# Logs
li $s0, 0x964B00 # brown
lw $a3, displayAddress
addi $a3, $a3, 1152
lw $t8, logspace1
la $t9, logspace1
jal MOVE_OBSTACLES1
lw $t8, logspace2
la $t9, logspace2
jal MOVE_OBSTACLES1

lw $a3, displayAddress
addi $a3, $a3, 1404
lw $t8, logspace3
la $t9, logspace3
jal MOVE_OBSTACLES
lw $t8, logspace4
la $t9, logspace4
jal MOVE_OBSTACLES

lw $a3, displayAddress
addi $a3, $a3, 1920
lw $t8, logspace5
la $t9, logspace5
jal MOVE_OBSTACLES1
lw $t8, logspace6
la $t9, logspace6
jal MOVE_OBSTACLES1
add $s4, $zero, $zero
j UPDATE_START

UPDATE_END:
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra

# Update Function
UPDATE1:
addi $sp, $sp, -4 # stack pointer goes down the stack
sw $ra, 0($sp) # $sp gets the value of $ra

lw $a0, displayAddress # a0 stores the base address for display
lw $a1, displayAddress # a1 stores the base address for display
lw $a2, displayAddress # a2 stores the base address for display
li $s0, 0x00ff00 # $s0 stores the green colour code

addi $s4, $zero, 0
addi $s5, $zero, 10000
UPDATE_START1:
beq $s4, $s5, OBSTACLES1
lw $t0, 0xffff0000
beq $t0, 1, MOVE
jal FROG # draw frog
lw $s6, x_value
lw $s7, y_value
add $s7, $s7, $s6
lw $s6, carspace6
addi $s4, $s4, 1
j UPDATE_START1
OBSTACLES1:
jal DRAW_MAP
jal FROG
bge $s6, $s7, UPDATE_END1
# Cars
li $s0, 0xff0000 # $s0 stores the red colour code
lw $a3, displayAddress
addi $a3, $a3, 2556
lw $t8, carspace1
la $t9, carspace1
jal MOVE_OBSTACLES
lw $t8, carspace2
la $t9, carspace2
jal MOVE_OBSTACLES

lw $a3, displayAddress
addi $a3, $a3, 3068
lw $t8, carspace3
la $t9, carspace3
jal MOVE_OBSTACLES2
lw $t8, carspace4
la $t9, carspace4
jal MOVE_OBSTACLES2

lw $a3, displayAddress
addi $a3, $a3, 3324
lw $t8, carspace5
la $t9, carspace5
jal MOVE_OBSTACLES
lw $t8, carspace6
la $t9, carspace6
jal MOVE_OBSTACLES

# Logs
li $s0, 0x964B00 # brown
lw $a3, displayAddress
addi $a3, $a3, 1152
lw $t8, logspace1
la $t9, logspace1
jal MOVE_OBSTACLES2
lw $t8, logspace2
la $t9, logspace2
jal MOVE_OBSTACLES2

lw $a3, displayAddress
addi $a3, $a3, 1404
lw $t8, logspace3
la $t9, logspace3
jal MOVE_OBSTACLES
lw $t8, logspace4
la $t9, logspace4
jal MOVE_OBSTACLES

lw $a3, displayAddress
addi $a3, $a3, 1920
lw $t8, logspace5
la $t9, logspace5
jal MOVE_OBSTACLES2
lw $t8, logspace6
la $t9, logspace6
jal MOVE_OBSTACLES2
add $s4, $zero, $zero
j UPDATE_START1

UPDATE_END1:
lw $ra, 0($sp) # $ra gets the value of $sp
addi $sp, $sp, 4 # stack pointer goes up the stack
jr $ra # jumps to $ra

