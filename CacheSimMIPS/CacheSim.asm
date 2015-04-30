.data

trace: .word     0 : 1400		#One MB of buffer for the  trace file
					#words are 4bytes(32 bits)

.text  

#generate trace
la $a0, trace       #$a0 =  address of array 
li $t0, 0	    #$t0 is incrementer for 0 - 69
li $t1, 0	    #$t1 is incrementer for 0 - 9
li $t2, 70	    #$t2 is size of straight

fill:
	mult     $t1, $t2       # $s2 = row * #cols  (two-instruction sequence)
        mflo     $s2 
        addu	 $s2, $s2, $t0 
        sll      $s2, $s2, 2
	sw       $t0, trace($s2)
	addi     $t0, $t0, 1
	bne	 $t0, 70, fill
	li 	 $t0, 0	 
	addi     $t1, $t1, 1
	bne	 $t1, 10, fill
	
donefill:
	li $t0, 0	    #$t0 is incrementer for 0 - 69
	li $t1, 0

read:
	mult     $t1, $t2       # $s2 = row * #cols  (two-instruction sequence)
        mflo     $s2 
        addu	 $s2, $s2, $t0 
        sll      $s2, $s2, 2
	lw       $t4, trace($s2)
	
	ori     $v0, $0, 1			
	move	$a0, $t4
	syscall 
	
	addi     $t0, $t0, 1
	bne	 $t0, 70, read
	li 	 $t0, 0	 
	addi     $t1, $t1, 1
	bne	 $t1, 10, read