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
		lw $a1 M			#M
        lw $a2 N			#N
        la $a2 vectorV		#V[]

        jal extractValues
        sucededEnd:
    		li $v0 10
            syscall

#------EXTRACT VALUES FUNCTION---------------------------------------------------------------------
    	extractValues:
        	move $t0 $a0		#A[]
            move $t1 $a3		#V[]
            move $t2 $a1		#M
            move $t3 $a2		#N
            
            ble $t2 $zero errorExtractValues
            ble $t3 $zero errorExtractValues	#If(M||N==0)
            
            mul $t2 $t2 $t3		#M*N
            move $t3 $zero		#i=0
            
            do:
            	#Code form XEMA-------------------------------
                #$f1 = A[i]
                #$t0 = A[]
                
                			lwc1 $f1 ($t0)			#load word coprocessor 1
							mfc1 $t1 $f1			#move from coprocessor 1
							li $t2 0x7F800000		#infinite
							and $t1 $t1 $t2			#logical and
							srl $t1 $t1 23			#shift right logical
							sub $t1 $t1 127					#exponent of the float number is in t1
                #---------------------------------------------
            	addu $t3 $t3 1	#i++
                addu $t0 $t0 4	#A[]++
                addu $t1 $t1 4	#V[]++
            while:
            	bge $t3 $t2 endExtractValues
            	b do
            endExtractValues:
            	li $v0 0
                jr $ra
  			errorExtractValues:
            	li $v0 -1
                jr $ra