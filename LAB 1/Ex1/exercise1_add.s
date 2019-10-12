.data
	matrix_A: .space 36 .align 2
	matrix_B: .word 1, 1, 1,
    			.word 1, 1, 1
                .word, 1, 1, 1
    matrix_C: .word 2, 2, 2,
    			.word 2, 2, 2
                .word, 2, 2, 2
    M: .word 3
    N: .word 3
.text
.globl main
main:
  la $a0 matrix_B
  la $a1 matrix_C
  la $t0 M
  lw $a2 ($t0)
  la $t2 N
  lw $a3 ($t2)
  la $t0 matrix_A
  #sub unsigned since memory positions are always positive
  subu $sp $sp 4
  sw $t0 ($sp)

  jal add
  #priting the returned value
  move $a0 $v0
  li $v0 1
  syscall
  #ending execution
  li $v0 10
  syscall
  
add:
#move $t0 $a2
#move $t1 $a3
#checking positive values for M and N
blez $a2 error
blez $a3 error

mul $s0 $a2 $a3
#poping the 5th parameter
lw $s1 ($sp)
addu $sp $sp 4

loop:
#loop's body
lw $t0 ($a0)
lw $t1 ($a1)
add $t2 $t0 $t1
sw $t2 ($s1)

#loop's control
addu $a0 $a0 4
addu $a1 $a1 4
addu $s1 $s1 4
subu $s0 $s0 1
bgez $s0 loop

#function executed successfully
li $v0 0
b return

error:
	#funtion ended due to parameter errors
	li $v0 1

return:
	jr $ra