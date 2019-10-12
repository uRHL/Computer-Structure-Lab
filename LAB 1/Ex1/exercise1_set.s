
.data
	M: .word 3
	N: .word 3
	matrix_A: 
		.space 36
		.align 2
.text
.globl main

main:
#loading the arguments
la $a0 matrix_A
la $t1 M
lw $a1 ($t1)
la $t2 N
lw $a2 ($t2)

jal set

#syscall to print an int
move $a0 $v0
li $v0 1
syscall
#syscall to end the test
li $v0 10
syscall

set:
	#the arguments of the function will be passed in a0, a1, a2
	#check if arguments are in the accepted range
	blez $a1 error
	blez $a2 error
	
	#Calculating Total number of elements in the matrix = M x N
	#t0 (# elements not set) will be the counter of the loop 
	mul $t0, $a1, $a2
	
	move $s0 $a0
	
	loop:	
	sw $zero ($s0) # matrix item = 0
	add $s0 $s0 4 #next element of the array (int is 4byte long)
	sub $t0 $t0 1 # counter -1 
	bnez $t0 loop
	li $v0 0 #function end successfully
	b return
	
	error:
	li $v0 1
	
	return:
	jr $ra