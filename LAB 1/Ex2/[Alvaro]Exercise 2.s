.data
	M: .word 3  
    N: .word 4
    matrixA: .float 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.1, 2.2, 2.3
    matrixB: .float 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
    vectorV: .word 1, 1, 1, 1, 1, 1
    
.text
	.globl main
    main:
    	#We load the input values for function Extract Values, no stack needed
    	la $a0 M
        la $a1 N
        la $a2 matrixA
        la $a3 vectorV
        jal extractValues
        b sucededEnd

#------EXTRACT VALUES FUNCTION----------------------------------------------------------
    	extractValues:
        	#We load the values from input registers, and check the MN condition
        	lw $t0 ($a0)		#M
            lw $t1 ($a1)		#N
            move $t2 $a2		#A[][]
            move $t3 $a3		#V[]
            
            blez $t0 failEnd1
            blez $t1 failEnd1	#if(M||N<=0)
            
           	#We make some operations necesary for the loop
            mul $t0 $t0 $t1		#M*N
            subu $t0 $t0 1
            li $t1 0			#i=0
            
            doExtract:
            	move $t6 $t3	#V[] initial memory address
            	
                #We load the float values
                lwc1 $f0 0($t2)			#A[][] value
                li.s $f2 00000000000000000000000000000000
                c.eq.s $f0 $f2
                bc1t v0					#b condition for v0 (zero)
                li.s $f2 10000000000000000000000000000000
                c.eq.s $f0 $f2
                bc1t v0					#b condition for v0 (zero)
				li.s $f2 01111111100000000000000000000000
                c.eq.s $f0 $f2
                bc1t v1					#b condition for v1 (infinite)      
                li.s $f2 11111111100000000000000000000000
                c.eq.s $f0 $f2
                bc1t v2					#b condition for v2 (minus infinite)
				c.gt.s $f0 $f2			#infinite
                bc1t v3					#b condition for v3 (NaN)
                li.s $f2 01111111100000000000000000000000
                c.gt.s $f0 $f2			#infinite
                bc1t label0				#b condition for v3 (NaN)
                b continue0
                label0:
                	li.s $f2 11111111100000000000000000000000
                    c.lt.s $f0 $f2			#infinite
                	bc1t v3				#b condition for v3 (NaN)
                continue0:
				li.s $f2 00000000100000000000000000000000
                c.lt.s $f0 $f2			#infinite
                bc1t v4				#b condition for v3 (Non nomalized)
                li.s $f2 10000000000000000000000000000000
                c.gt.s $f0 $f2			#infinite
                bc1t label1				#b condition for v3 (Non nomalized)	
                b v5
                label1:
                	li.s $f2 10000000100000000000000000000000
                	c.lt.s $f0 $f2			#infinite
                	bc1t v4				#b condition for v3 (Non nomalized)	
                
                b v5
                v0:
                 	lw $t4 ($t6)
               		addu $t4 $t4 10
                    sw $t4 ($t6)  
                	b whileExtract
                v1:
                 	lw $t4 4($t6)
                    addu $t6 $t6 4
               		addu $t4 $t4 10
                    sw $t4 ($t6)  
                	b whileExtract
                v2:
                 	lw $t4 8($t6)
                    addu $t6 $t6 8
               		addu $t4 $t4 10
                    sw $t4 ($t6)  
                	b whileExtract
                v3:
                 	lw $t4 12($t6)
                    addu $t6 $t6 12
               		addu $t4 $t4 10
                    sw $t4 ($t6)  
                	b whileExtract
                v4:
                 	lw $t4 16($t6)
                    addu $t6 $t6 16
               		addu $t4 $t4 10
                    sw $t4 ($t6)  
                	b whileExtract
                v5:
                 	lw $t4 20($t6)
                    addu $t6 $t6 20
               		addu $t4 $t4 10
                    sw $t4 ($t6)                    
                	b whileExtract
            whileExtract:
            	addu $t2 $t2 4 		#A[][]++
                addu $t1 $t1 1		#i++
            	bge $t0 $t1 doExtract
                b endExtractValues
            
        endExtractValues:
    		li $a0 0
            li $v0 0
            syscall 
            jr $ra
    
#-------END FUNCTIONS-------------------------------------------------------------------
        sucededEnd:
    		li $v0 10
            syscall
        failEnd0:
        	li $a0 0
            li $v0 1
            syscall
            li $v0 10
            syscall
		failEnd1:
        	li $a0 -1
            li $v0 1
            syscall
            li $v0 10
            syscall
    	