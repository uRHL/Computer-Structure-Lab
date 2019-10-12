.data
	vector_A: .space 12 .align 2
	matrix_B: .word 1, 2, 3,
    			.word 4, 5, 6
                .word, 7, 8, 9
    
    M: .word 3
    N: .word 3
    j_row: .word 1
.text
.globl main
main:
  la $a0 vector_A
  la $a1 matrix_B
  la $t0 M
  lw $a2 ($t0)
  la $t1 N
  lw $a3 ($t1)
  la $t0 j_row
  lw $t1 ($t0)
  #sub unsigned since memory positions are always positive
  subu $sp $sp 4
  sw $t1 ($sp)

  jal extractRow
  #priting the returned value
  move $a0 $v0
  li $v0 1
  syscall
  #ending execution
  li $v0 10
  syscall
  
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
	#funtion ended due to parameter errors
	li $v0 1

return:
	jr $ra