.data
    M: .word 5
    N: .word 3
    j: .word 1
    matrixA: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3, 4, 5, 6
    matrixB: .word 10,9, 8, 7, 6, 5, 4, 3, 2, 10,9, 8, 7, 6, 5
    matrixC: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    vectorA: .word 0, 0, 0, 0, 0
.text
	.globl main:
    main:
    		#We get data from memory and call each function			
			la $a0 matrixA
            la $a1 M
            la $a2 N
            la $a3 matrixB			
            subu $sp $sp 4
            la $t0 matrixC
            sw $t0 ($sp)
            jal add					#calls add function
            
            la $a0 matrixA
            la $a1 M
            la $a2 N
            jal set					#calls set function
            
            la $a0 vectorA
            la $a1 matrixB
            la $a2 M
            la $a3 N
            la $t0 j
            subu $sp $sp 4
            sw $t0 ($sp)
            jal extractRow			#calls extract row function
            
			la $a0 matrixA
            la $a1 M
            la $a2 N
            la $a3 matrixB
            jal moreZeros			#calls moreZeros function
        
            b sucededEnd

#------MORE ZEROS FUNCTION-------------------------------------------------------
		moreZeros:
        	#We load the values from input registers and check the MN condition
        	move $t0 $a0			#A[][]
            lw $t1 ($a1)			#M
            lw $t2 ($a2)			#N
            move $t3 $a3			#B[][]
            ble $t2 $zero failEnd1
            ble $t1 $zero failEnd1 	#if (M||N<=0)
            
            #We save the $ra register that stores the address of the previous jal as we are going to call another function
            subu $sp $sp 4
            sw $ra ($sp)
            
            #We load the input values for the function calcular with matrix A[][]
			move $a3 $zero
            jal calcular
            move $t4 $v0 				#$v0 is suposed to return the number of zeros in A, we store that number                       
            #We load the input values for the function calcular with matrix B[][]
            move $a0 $t3
            jal calcular
            move $t5 $v0 				#$v0 is suposed to return the number of zeros in B, we store that number
            
          	#We recover the $ra value from the stack
            lw $ra ($sp)
            addu $sp $sp 4
                      
            #We compare the results and brach depending on the desired output
            sub $t4 $t4 $t5
            bltz $t4 endZeros2
            bgtz $t4 endZeros1
            beqz $t4 endZeros0 
            
        endZeros0:
        	li $a0 0
            li $v0 1
            syscall
        	jr $ra 
        endZeros1:
        	li $a0 1
            li $v0 1
            syscall
        	jr $ra 
        endZeros2:
			li $a0 2
            li $v0 1
            syscall
        	jr $ra 
        
#------EXTRACT ROW FUNCTION------------------------------------------------------
      	extractRow:
        	#We load the values from input registers and stack, and compare the MN condition
        	move $t0 $a0			#A[]
            move $t1 $a1			#B[][]
            lw $t2 ($a2)			#M
            lw $t3 ($a3)			#N
            lw $t4 ($sp)			#j (from stack)
            lw $t4 ($t4)
            addu $sp $sp 4
            
			ble $t2 $zero failEnd1
            ble $t3 $zero failEnd1 	#if (M||N<=0)
            
            #We make some operations necesary for the loop
            mul $t3 $t4 $t2			#N=M·j
            subu $t4 $t4 1			#j--
            mul $t4 $t4 $t2			#MÂ·(j-1)
			li $t5 0				#i=0
            bge $t5 $t4 doExtract2
            
            #We move the pointer in memory until it reachs the selected row
        	doExtract:
            	add $t1 $t1 4		#B[][]++
                add $t5 $t5 1		#i++
            whileExtract:
            	bge $t5 $t4 doExtract2
                b doExtract
                
                #We perform the algorithm of the function in this loop
            	doExtract2:
                	lw $t2 ($t1)		#Content of B[][]
	            	sw $t2 ($t0)		#A[i]=B[i][]
    	            add $t0 $t0 4		#A[]++
        	        add $t1 $t1 4		#B[][]++
            	    add $t5 $t5 1		#i++
            	whileExtract2:
            		bge $t5 $t3 endExtract
                	b doExtract2
        endExtract:
			li $a0 0
            li $v0 1
            syscall
        	jr $ra 
#------ADD FUNCTION--------------------------------------------------------------
		add:
        	#We load the values from input registers and stack, and check the MN condition
			move $t0 $a0			#A[][]
            move $t3 $a3			#B[][]
            lw $t4 ($sp)			
            addu $sp $sp 4			#C[][] (from stack)
            lw $t1 ($a1)			#M value
            lw $t2 ($a2)			#N value
                 
            ble $t2 $zero failEnd1
            ble $t1 $zero failEnd1 	#if (M||N<=0)
            
			#We make some operations necesary for the loop
            mul $t1 $t1 $t2			#M-->M·N
            sub $t1 $t1 1
            move $t2 $zero			#N-->i=0
            
            #We perform the algorithm of the function in this loop
			doAdd:  
            	lw $t5 ($t0)
                lw $t6 ($t3)
            	add $t5 $t5 $t6		
            	sw $t5 ($t4)			#C[i]=A[i]+B[i]          
            	addi $t2 $t2 1			#i++
                addi $t0 $t0 4			#A[i++]
                addi $t3 $t3 4			#B[i++]
				addi $t4 $t4 4			#C[i++]
                
            whileAdd:
            	ble $t2 $t1 doAdd
                b endAdd
        	
        endAdd:
        	li $a0 0
            li $v0 1
            syscall
        	jr $ra 	

#------SET FUNCTION--------------------------------------------------------------   	
        set:	
        	#We load the values from input registers, and check the MN condition
        	move $t0 $a0			#A[][]
            lw $t1 ($a1)			#M value
            lw $t2 ($a2)			#N value 
            ble $t2 $zero failEnd0
            ble $t1 $zero failEnd0 	#if (M||N<=0)
            
            #We make some operations necesary for the loop
            mul $t1 $t1 $t2			#M-->MÂ·N
            sub $t1 $t1 1
            move $t2 $zero			#N-->i=0
            
            #We perform the algorithm of the function in this loop
            doSet:              
            	sw $zero ($t0)		#A[i]=0                
            	addi $t2 $t2 1			#i++
                addi $t0 $t0 4			#A[i++]
                
            whileSet:
            	ble $t2 $t1 doSet
                b endSet
        
        endSet:
        	li $a0 1
            li $v0 1
            syscall
        	jr $ra
#-------END FUNCTIONS------------------------------------------------------------           
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