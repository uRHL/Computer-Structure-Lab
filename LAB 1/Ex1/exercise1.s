.data
.text
.globl main

#-----Begining of function SET---------------------------------
set:
	#the arguments of the function will be passed in a0, a1, a2
	#check if arguments are in the accepted range
	blez $a1 error
	blez $a2 error
	
	#Calculating Total number of elements in the matrix = M x N
	#t0 (# elements not set) will be the counter of the loop 
	mul $t0, $a1, $a2
	
	move $t1 $a0
	
	loop:	
	sw $zero ($t1) # matrix item = 0
	add $t1 $t1 4 #next element of the array (int is 4byte long)
	sub $t0 $t0 1 # counter -1 
	bnez $t0 loop
	li $v0 0 #function end successfully
	b return
	
	error:
	li $v0 1
	
	return:
	jr $ra
#-----end of function SET---------------------------------	

#-----beginning function ADD------------------------------
add:
#checking positive values for M and N
blez $a2 error
blez $a3 error

mul $t3 $a2 $a3
#poping the 5th parameter
lw $t4 ($sp)
addu $sp $sp 4

loop:
#loop body
lw $t0 ($a0)
lw $t1 ($a1)
add $t2 $t0 $t1
sw $t2 ($t4)

#loop control
addu $a0 $a0 4
addu $a1 $a1 4
addu $t4 $t4 4
subu $t3 $t3 1
bgez $t3 loop

#function executed successfully
li $v0 0
b return

error:
	#function ended due to parameter errors
	li $v0 1

return:
	jr $ra
#-----end function ADD------------------------------

#-----beginning function EXTRACT_ROWS---------------
extractRow:
#checking positive values for M and N
blez $a2 error
blez $a3 error


#poping the 5th parameter
lw $s0 ($sp)
addu $sp $sp 4
#It must holds that j<N
bge $s0 $a3 error

#mul j*N = number of elements to skip
mul $t0 $s0 $a3 
#numer of bytes to skip
mul $t0 $t0 4
#N>0, j>=0
addu $s1 $t0 $a1

loop:
#loop's body
#load from B
lw $t0 ($s1)
sw $t0 ($a0)

#loop's control
addu $s1 $s1 4
addu $a0 $a0 4
#Number of elements not copied
subu $a3 $a3 1

bgtz $a3 loop

#function executed successfully
li $v0 0
b return

error:
	#function ended due to parameter errors
	li $v0 1

return:
	jr $ra
#------end function EXTRACT_ROWS---------------

#------beginning function MORE_ZEROS-----------
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
#If A #zeros not bigger neither lesser than #zeros B then they are equal
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

#------end function MORE_ZEROS-----------
