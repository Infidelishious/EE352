.data
cf_string: .asciiz "CF(celsius to fahrenheit) or FC(Fahrenheit to celsius): "  
again_string: .asciiz "Again (y or n)? "  
newline: .asciiz "\n"  
prompt: .asciiz "Enter an integer Celsius temperature: "	
prompt2: .asciiz "Enter an integer Fahrenheit temperature: "
sumText: .asciiz "F = "
sumText2: .asciiz "C = "  
answer: .space 256

.text  
.globl main  
  main:
    li  $v0, 4  
    la  $a0, newline
    syscall  
    
    li  $v0, 4  
    la  $a0, cf_string
    syscall  

    la  $a0, answer
    li  $a1, 3
    li  $v0, 8
    syscall

    lb  $t4, 0($a0)
    lb  $t5, 1($a0)
    
    li  $v0, 4  
    la  $a0, newline
    syscall  

    bne $t4, 'C', ftoc
    bne $t5, 'F', exit
    
    	# Display prompt
	ori     $v0, $0, 4
	la $a0, prompt			
	syscall

	# Read 1st integer
	ori     $v0, $0, 5
	syscall

	# C is in $v0	
	addi $t0, $0, 9
	mult $t0, $v0
	mflo $t0    # 9*C
	addi $t1, $0, 5
	div $t0, $t1
	mflo $t0    # 9*C/5
	addi $s0, $t0, 32   # 9*C/5+32

	# Display the sum text
	ori     $v0, $0, 4
	la $a0, sumText			
	syscall
	
	# Display the result
	ori     $v0, $0, 1			
	add 	$a0, $s0, $0	 
	syscall
    
    j again
    
ftoc:
    bne $t4, 'F', exit
    bne $t5, 'C', exit
    
    # Display prompt
	ori     $v0, $0, 4
	la $a0, prompt2		
	syscall

	# Read 1st integer
	ori     $v0, $0, 5
	syscall
	
	addi $t0, $0, 32
	sub $t0, $v0, $t0
	li $t1, 5
	mult $t0, $t1
	mflo $t0 
	li $t1, 9
	div $t0, $t1
	mflo $s0

	# Display the sum text
	ori     $v0, $0, 4
	la $a0, sumText2		
	syscall
	
	# Display the result
	ori     $v0, $0, 1			
	add 	$a0, $s0, $0	 
	syscall
    
again:

    li  $v0, 4  
    la  $a0, newline
    syscall  
    
    li  $v0, 4  
    la  $a0, again_string
    syscall  

    la  $a0, answer
    li  $a1, 2
    li  $v0, 8
    syscall

    lb  $t4, 0($a0)
    
    li  $v0, 4  
    la  $a0, newline
    syscall  

    beq $t4, 'y', main

exit:
    li  $v0, 10 
    syscall 
