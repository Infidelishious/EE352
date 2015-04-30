#Ian Glow Lab 5, 2966519814
.data
data:    .word     0 : 256       # storage for 16x16 matrix of words
data2:   .word     0 : 256       # storage for 16x16 matrix of words
data3:   .word     0 : 256       # storage for 16x16 matrix of words
data4:   .word     0 : 256       # storage for 16x16 matrix of words
newline: .asciiz "\n" 
a_string: .asciiz "\nMatrix A\n" 
b_string: .asciiz "\nMatrix B\n" 
c_string: .asciiz "\nMatrix A+B\n" 
d_string: .asciiz "\nMatrix AxB\n" 
comma: .asciiz "," 

.text
        li       $t0, 16        # $t0 = number of rows
        li       $t1, 16        # $t1 = number of columns
        move     $s0, $zero     # $s0 = row counter
        move     $s1, $zero     # $s1 = column counter
        move     $t2, $zero     # $t2 = the value to be stored

loop:   
	mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
        mflo     $s2            # move multiply result from lo register to $s2
        add      $s2, $s2, $s1  # $s2 += column counter
        sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
        sw       $t2, data($s2) # store the value in matrix element
        addi     $t2, $t2, 1    # increment value to be stored

        addi     $s1, $s1, 1    # increment column counter
        bne      $s1, $t1, loop # not at end of row so loop back
        move     $s1, $zero     # reset column counter
        addi     $s0, $s0, 1    # increment row counter
        bne      $s0, $t0, loop # not at end of matrix so loop back

	jal printA
	
	move     $s0, $zero     # $s0 = row counter
        move     $s1, $zero     # $s1 = column counter
        li     $t2, 255     # $t2 = the value to be stored
         
loop2:   
	mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
        mflo     $s2            # move multiply result from lo register to $s2
        add      $s2, $s2, $s1  # $s2 += column counter
        sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
        sw       $t2, data2($s2) # store the value in matrix element
        subi     $t2, $t2, 1    # increment value to be stored

        addi     $s1, $s1, 1    # increment column counter
        bne      $s1, $t1, loop2 # not at end of row so loop back
        move     $s1, $zero     # reset column counter
        addi     $s0, $s0, 1    # increment row counter
        bne      $s0, $t0, loop2 # not at end of matrix so loop back
	
	jal printB
	
	move     $s0, $zero     # $s0 = row counter
        move     $s1, $zero     # $s1 = column counter
        move     $t2, $zero     # $t2 = the value to be stored
         
loop3:   
	mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
        mflo     $s2            # move multiply result from lo register to $s2
        add      $s2, $s2, $s1  # $s2 += column counter
        sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
        lw	 $t3, data($s2)
        lw	 $t4, data2($s2)
        add	 $t2, $t3, $t4
        sw       $t2, data3($s2) # store the value in matrix element

        addi     $s1, $s1, 1    # increment column counter
        bne      $s1, $t1, loop3 # not at end of row so loop back
        move     $s1, $zero     # reset column counter
        addi     $s0, $s0, 1    # increment row counter
        bne      $s0, $t0, loop3 # not at end of matrix so loop back
	
	jal printC
	
	move     $s0, $zero     # $s0 = row counter
        move     $s1, $zero     # $s1 = column counter
        move     $t2, $zero     # $t2 = the value to be stored
        move     $t5, $zero     # $t2 = the value to be stored
         
loop4:   
	mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
        mflo     $s2            # move multiply result from lo register to $s2
        add      $s2, $s2, $s1  # $s2 += column counter
        sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
        
        #t7 = A pos
        #t8 = b pos
        mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
        mflo     $t7            # move multiply result from lo register to $s2
        add      $t7, $t7, $t5  # $s2 += column counter
        sll      $t7, $t7, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
        
        mult     $t5, $t1       
        mflo     $t8            
        add      $t8, $t8, $s1  
        sll      $t8, $t8, 2    
        
        lw	 $t3, data($t7)
        lw	 $t4, data2($t8)
        
        mult     $t3, $t4 
        mflo     $t6
        add	 $t2, $t2, $t6
        
        addi     $t5, $t5, 1    
        bne      $t5, $t1, loop4 
        move     $t5, $zero     
        
        sw       $t2, data4($s2) # store the value in matrix element
        move     $t2, $zero 

        addi     $s1, $s1, 1    # increment column counter
        bne      $s1, $t1, loop4 # not at end of row so loop back
        move     $s1, $zero     # reset column counter
        addi     $s0, $s0, 1    # increment row counter
        bne      $s0, $t0, loop4 # not at end of matrix so loop back
	
	jal printD
	
end:
        li       $v0, 10        # system service 10 is exit
        syscall                 # we are outta here.

printA:
	li  $v0, 4  
    	la  $a0, a_string
   	syscall 
    	
	move     $s0, $zero   
        move     $s1, $zero 
        move     $t2, $zero     
print1:
 	mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
        mflo     $s2            # move multiply result from lo register to $s2
        add      $s2, $s2, $s1  # $s2 += column counter
        sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
        lw       $t2, data($s2) # store the value in matrix element
         
	ori     $v0, $0, 1			
	move	$a0, $t2
	syscall 
	
	li  $v0, 4  
    	la  $a0, comma
    	syscall 

        addi     $s1, $s1, 1    # increment column counter
        bne      $s1, $t1, print1 # not at end of row so loop back
         
        li  $v0, 4  
    	la  $a0, newline
   	syscall 
   	
        move     $s1, $zero     # reset column counter
        addi     $s0, $s0, 1    # increment row counter
        bne      $s0, $t0, print1# not at end of matrix so loop back

        jr $ra
        
printB:
	li  $v0, 4  
    	la  $a0, b_string
   	syscall 
   	
	move     $s0, $zero   
        move     $s1, $zero 
        move     $t2, $zero     
print2:
 	mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
        mflo     $s2            # move multiply result from lo register to $s2
        add      $s2, $s2, $s1  # $s2 += column counter
        sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
        lw       $t2, data2($s2) # store the value in matrix element
         
	ori     $v0, $0, 1			
	move	$a0, $t2
	syscall 
	
	li  $v0, 4  
    	la  $a0, comma
    	syscall 

        addi     $s1, $s1, 1    # increment column counter
        bne      $s1, $t1, print2 # not at end of row so loop back
         
        li  $v0, 4  
    	la  $a0, newline
   	syscall 
   	
        move     $s1, $zero     # reset column counter
        addi     $s0, $s0, 1    # increment row counter
        bne      $s0, $t0, print2# not at end of matrix so loop back

        jr $ra

printC:
	li  $v0, 4  
    	la  $a0, c_string
   	syscall 
   	
	move     $s0, $zero   
        move     $s1, $zero 
        move     $t2, $zero     
print3:
 	mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
        mflo     $s2            # move multiply result from lo register to $s2
        add      $s2, $s2, $s1  # $s2 += column counter
        sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
        lw       $t2, data3($s2) # store the value in matrix element
         
	ori     $v0, $0, 1			
	move	$a0, $t2
	syscall 
	
	li  $v0, 4  
    	la  $a0, comma
    	syscall 

        addi     $s1, $s1, 1    # increment column counter
        bne      $s1, $t1, print3 # not at end of row so loop back
         
        li  $v0, 4  
    	la  $a0, newline
   	syscall 
   	
        move     $s1, $zero     # reset column counter
        addi     $s0, $s0, 1    # increment row counter
        bne      $s0, $t0, print3# not at end of matrix so loop back

        jr $ra
        
printD:
	li  $v0, 4  
    	la  $a0, d_string
   	syscall 
   	
	move     $s0, $zero   
        move     $s1, $zero 
        move     $t2, $zero     
print4:
 	mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
        mflo     $s2            # move multiply result from lo register to $s2
        add      $s2, $s2, $s1  # $s2 += column counter
        sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
        lw       $t2, data4($s2) # store the value in matrix element
         
	ori     $v0, $0, 1			
	move	$a0, $t2
	syscall 
	
	li  $v0, 4  
    	la  $a0, comma
    	syscall 

        addi     $s1, $s1, 1    # increment column counter
        bne      $s1, $t1, print4 # not at end of row so loop back
         
        li  $v0, 4  
    	la  $a0, newline
   	syscall 
   	
        move     $s1, $zero     # reset column counter
        addi     $s0, $s0, 1    # increment row counter
        bne      $s0, $t0, print4# not at end of matrix so loop back

        jr $ra
