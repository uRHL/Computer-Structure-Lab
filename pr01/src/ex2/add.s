.data
	M: .word 3  
    N: .word 4
    matrixA: .float 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.1, 2.2, 2.3
    matrixB: .float 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0
    matrixC: .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
    vectorV: .word 1, 1, 1, 1, 1, 1
    
.text
	.globl main
    main:
    	#We load the input values for function Extract Values, no stack needed
    	la $a0 matrixA		#A[][]
        la $a1 matrixB		#B[][]
        la $a2 matrixC		#C[][]
        la $t0 M
        lw $t0 ($t0)
        move $a3 $t0		#M
        subu $sp $sp 20
        la $t0 N
        lw $t0 ($t0)
        sw $t0 ($sp)		#N (to stack)
        jal add
        sucededEnd:
    		li $v0 10
            syscall

#------ADD FUNCTION---------------------------------------------------------------------
    	add:
        	move $t0 $a0	#A[][]
            move $t1 $a1	#B[][]
            move $t2 $a2	#C[][]
            move $t3 $a3	#M
            lw $t4 ($sp)	
            addu $sp $sp 20	#N (from stack)
            
            ble $t3 $zero errorAdd
            ble $t4 $zero errorAdd
            mul $t3 $t3 $t4	#M*N
            move $t4 $zero	#i=0
            
            do:
            	lwc1 $f0 0($t0)	#$f0=A[i]
                lwc1 $f2 0($t1)	#$f1=B[i]
                add.s $f0 $f0 $f2
                swc1 $f0 0($t2)	#C=A[i]+B[i]
            	addu $t4 $t4 1	#i++
                addu $t0 $t0 4 	#A[][]++
                addu $t1 $t1 4	#B[][]++
                addu $t2 $t2 4 	#C[][]++
            while:
            	bge $t4 $t3 endWhile
                b do
            
        endWhile:
        	li $v0 0
            jr $ra            
        errorAdd:
        	li $v0 -1
            jr $ra       	