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
		#Checking M and N bigger than 0
			blez $a2 errorZero
			blez $a3 errorZero

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
		bltz $v0 errorZero
		#If not store the result in S4
		move $s4 $v0

		#checking the number of zeros of matrix B
		move $a0 $s1
		#move $a2 $a3
		#li $a3 0

		jal calcular

		#If calcular returns -1 an error ocurred
		bltz $v0 errorZero
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
		b returnZero

		moreA:
		li $v0 0
		b returnZero

		moreB:
		li $v0 1
		b returnZero

		errorZero:
		li $v0 -1

		returnZero:
		jr $ra
        
#------EXTRACT ROW FUNCTION------------------------------------------------------			
		extractRow:
			#checking positive values for M and N
			blez $a2 errorExtract
			blez $a3 errorExtract

			#poping the 5th parameter
			lw $s0 ($sp)
			addu $sp $sp 4
			#It must holds that 0 <= j < N 
			bltz $s0 errorExtract
			bge $s0 $a3 errorExtract

			#mul j*N = number of elements to skip
			mul $t0 $s0 $a3 
			#numer of bytes to be skiped
			mul $t0 $t0 4
			#N>0, j>=0
			addu $s1 $t0 $a1

			loopExtract:
			#loop's body
				#load from B
				lw $t0 ($s1)
				#save into A
				sw $t0 ($a0)

			#loop's control
				addu $s1 $s1 4
				addu $a0 $a0 4
			#Number of elements not copied yet
				subu $a3 $a3 1

			bgtz $a3 loopExtract

			#function executed successfully
			li $v0 0
			b returnExtract

		errorExtract:
			#funtion ended due to parameter errors
			li $v0 -1
		returnExtract:
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
                 
            ble $t2 $zero endFailAdd
            ble $t1 $zero endFailAdd 	#if (M||N<=0)
            
			#We make some operations necesary for the loop
            mul $t1 $t1 $t2			#M-->MÂ·N
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
            li $v0 0
        	jr $ra 
		endFailAdd:
			li $v0 -1
			jr $ra

#------SET FUNCTION--------------------------------------------------------------   	
        set:	
        	#We load the values from input registers, and check the MN condition
        	move $t0 $a0			#A[][]
            lw $t1 ($a1)			#M value
            lw $t2 ($a2)			#N value 
            ble $t2 $zero endFailSet
            ble $t1 $zero endFailSet 	#if (M||N<=0)
            
            #We make some operations necesary for the loop
            mul $t1 $t1 $t2			#M-->MÃÂ·N
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
            li $v0 1
        	jr $ra
		endFailSet:
			li $v0 0
			jr $ra
#-------END FUNCTIONS------------------------------------------------------------           
        sucededEnd:
    		li $v0 10
            syscall
