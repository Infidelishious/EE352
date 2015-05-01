.data
endline: .asciiz "\n"
trace: .word     0 : 700		

prompt: .asciiz "\nEnter line Size (Must be grater than 4 & power of two): "
prompt2: .asciiz "Associativity (0 = associtive, 1 = direct map): "
prompt3: .asciiz "Enter data size in kb (Must be power of two): "	
prompt4: .asciiz "Enter miss penilty: "
.text  

#$s7 = adress of tag array 
#$s6 = line size 
#$s5 = associtivity 
#$s4 = datasize
#$s3 = miss penalty
#$s2 = size of cache in bytes/line size = size of cache tags in bytes


#generate trace
la $a0, trace       #$a0 =  address of array 
li $t0, 0	    #$t0 is incrementer for 0 - 69
li $t1, 0	    #$t1 is incrementer for 0 - 9
li $t2, 70	    #$t2 is size of straight

fill:
	mult    $t1, $t2     
	mflo    $s0 
	addu	$s0, $s0, $t0 
	sll     $s0, $s0, 2
	sw      $t0, trace($s0)
	addi    $t0, $t0, 1
	bne	$t0, 70, fill
	li 	$t0, 0	 
	addi    $t1, $t1, 1
	bne	$t1, 10, fill
	
donefill:
	li 	$t0, 0	    #$t0 is incrementer for 0 - 1400

read:
	sll     $s0, $t0, 2
	lw      $t4, trace($s0)
	
	ori     $v0, $0, 1			
	move	$a0, $t4
	syscall 
	
	la $a0, endline
        li $v0, 4       #print string               
        syscall
	
	addi    $t0, $t0, 1
	bne	$t0, 700, read
	
	la $a0, prompt
        li $v0, 4       #print string               
        syscall
	
    	li  $v0, 5
    	syscall
    	move $s6, $v0
	
	la $a0, prompt2
        li $v0, 4       #print string               
        syscall
	
    	li  $v0, 5
    	syscall
    	move $s5, $v0
    	
    	la $a0, prompt3
        li $v0, 4       #print string               
        syscall
	
    	li  $v0, 5
    	syscall
    	move $s4, $v0
    	
    	la $a0, prompt4
        li $v0, 4       #print string               
        syscall
	
    	li  $v0, 5
    	syscall
    	move $s3, $v0

	li 	$t0, 1024
	mult    $t0, $s4       # $t1 = 1024 * datasize($s4)
	mflo   	$t1
	div	$t1, $s6       # $t1 = *1024 * datasize($s4))/linesize
	mflo   	$t1
	li 	$t0, 4	       #acount for bytes
	mult    $t0, $t1 
	mflo   	$s2
	
#$s7 = adress of tag array 
#$s6 = line size 
#$s5 = associtivity (0 = asssoicitive, 1 = direct)
#$s4 = datasize
#$s3 = miss penalty
#$s2 = size of cache in bytes/line size = size of cache tags in bytes
#$s1 = adress of time array 

#t7 = hits
#t6 = misses

	move $a0, $s2 
	li $v0, 9	#allocates $a0 bytes 
	syscall 	#The address is returned in $v0
	move $s7, $v0
	
	li $t7, 0 	#t7 = hits
	li $t6, 0	#t6 = misses
	
read2:
	sll     $s0, $t0, 2
	lw      $t4, trace($s0)
	
	ori     $v0, $0, 1			
	move	$a0, $t4
	syscall 
	
	la $a0, endline
        li $v0, 4       #print string               
        syscall
	
	addi    $t0, $t0, 1
	bne	$t0, 700, read2
	
addressToTag: #truns adress in $t0 into tag stored in $t1
	li 	$t1, 4
	mult	$t1, $s6 
	mflo	$t1
	div	$t0, $t1       # $t1 = t0/linzsize
	mflo   	$t0
	mult	$t0, $t1       # $t1 = t1*linzsize
	mflo   	$t0
	jr $ra
	
isaddressintag: #sets $t2 to 1 if $t0 is the tag of $t1, uses $s0
	move $s0, $ra
	move $t2, $t1
	
	jal adressToTag
	move $t0, $t2
	
	li $t2, 0
	bne $t1, $t0, over1
	li $t2, 1
over1:
	move $ra, $s0
	jr $ra
	

	
exit:
    li  $v0, 10 
    syscall 