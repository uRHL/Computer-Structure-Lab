.model flat, stdcall


.data
	matrix_A: .word 1, 1, 1
    		.word 1, 1, 0
            .word 0, 1, 1
	matrix_B: .word 1, 0, 0
    		.word 0, 1, 0
            .word 0, 0, 1
	M: .word 3
    N: .word 3
.text
.globl main
main:
la $a0 matrix_A
la $a1 matrix_B
la $t0 M
lw $a2 ($t0)
la $t0 N
lw $a3 ($t0)

jal moreZeros

#printing the value returned
move $a0 $v0
li $v0 1
syscall

#ending execution
li $v0 10
syscall


moreZeros:
#Checking M and N bigger than 0
blez $a2 error
blez $a3 error

#saving the parameters
move $s0 $a0
move $s1 $a1
move $s2 $a2
move $s3 $a3

#push $ra before calling the function
subu $sp $sp 4
sw $ra ($sp)

#checking the number of zeros of matrix A
move $a1 $a2
move $a2 $a3
li $a3 0

jal calcular

#if calcular returns -1 an error ocurred
bltz $v0 error
#If not store the result in S4
move $s4 $v0

#checking the number of zeros of matrix B
move $a0 $s1
#move $a2 $a3
#li $a3 0

jal calcular

#If calcular returns -1 an error ocurred
bltz $v0 error
#If not store the result in S5
move $s5 $v0

#pop $ra to restore it
lw $ra ($sp)
addu $sp $sp 4


#A > B --> 0
bgt $s4 $s5 moreA
#A < B --> 1
blt $s4 $s5	moreB
#If A not bigger neither lesser than B then they are equal
#A = B --> 2
li $v0 2
b return

moreA:
li $v0 0
b return

moreB:
li $v0 1
b return

error:
li $v0 -1

return:
jr $ra