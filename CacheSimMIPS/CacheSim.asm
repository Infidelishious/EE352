.data
endline: .asciiz "\n"
trace: .word     0 : 2000

taga: .word	0
tagt: .word	0	

prompt:	.asciiz	"\nEnter line Size (Must be grater than 4 & power of two): "
prompt2: .asciiz "Associativity (0 = associtive, 1 = direct map): "
prompt3: .asciiz "Enter data size in kb (Must be power of two): "	
prompt4: .asciiz "Enter miss penilty: "
F: .asciiz	"\n\nTotal Hit Rate:\nTotal Run Time:\nAverage Memory Access Latencty:\n"

.text  
main:

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
li $t2, 200	    #$t2 is size of straight

fill:
	mult    $t1, $t2     
	mflo    $s0 
	addu	$s0, $s0, $t0 
	sll     $s0, $s0, 2 #times 4
	
	li  $t9, 3
	div $t1, $t9
	mfhi $t9
	
	bne $t9, 0, mulof3
	move $t3, $t0
	j store
mulof3:	
	li  $t9, 10
	mult $t9, $t0
	mflo $t3
store:
	sw      $t3, trace($s0)
	addi    $t0, $t0, 1
	bne	$t0, 200, fill
	li 	$t0, 0	 
	addi    $t1, $t1, 1
	bne	$t1, 10, fill
	
donefill:
	li 	$t0, 0	    #$t0 is incrementer for 0 - 1400

read:
	sll     $s0, $t0, 2
	lw      $t4, trace($s0)
	
	li     $v0, 1			
	move	$a0, $t4
	#syscall 
	
	#jal endl
	
	addi    $t0, $t0, 1
	bne	$t0, 200, read
	
	la $a0, prompt
        li $v0, 4       #print string               
        syscall
	
    	li  $v0, 5
    	syscall
    	move $s6, $v0
    	
    	div $s6, $s6, 4
	
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
	div	$t1, $s6       # $t1 = 1024 * datasize($s4))/linesize
	mflo   	$t1
	li 	$t0, 4	       #acount for bytes, t1 = t1 * 4
	mult    $t0, $t1 
	mflo   	$s2
	
	la $a0, F
        li $v0, 4       #print string               
        syscall
	
#$s7 = adress of tag array 
#$s6 = line size 
#$s5 = associtivity (0 = asssoicitive, 1 = direct)
#$s4 = datasize
#$s3 = miss penalty
#$s2 = size of cache in bytes/line size = size of cache tags in bytes
#$s1 = adress of time array 

#t7 = hits
#t6 = misses

#create arrays
	move $a0, $s2 
	li $v0, 9	#allocates $a0 bytes 
	syscall 	#The address is returned in $v0
	move $s7, $v0
	sw $s7, taga
	
	move $a0, $s2 
	li $v0, 9	#allocates $a0 bytes 
	syscall 	#The address is returned in $v0
	sw $v0, tagt
	
	li $t4, 0
loop5:
	move 	$t9, $t4 
	mflo	$t9
	sll     $t9, $t9, 2
	
	li $t8, -1
	sw $t8, tagt($t9) #set arrays to -1
	
	add $t4, $t4, 4
	bne $t4, $s2, loop5
	
	li $t7, 0 	#t7 = hits
	li $t6, 0	#t6 = misses
	
	li $t5, 0
	
read2:
	#li 	$t9, 4
	#mult	$t5, $t9
	#mflo	$t8
	
	jal	incTime
	move 	$t8, $t5
	sll     $t8, $t8, 2
	lw      $t0, trace($t8)
	
	jal isadressintagarray
	
	beq $t2, 1, hit
	add $t6, $t6, 1
	bne $s5, 0, amiss
dmiss:
	#t1 sould be tag of adress
	
	#cacheTags[(int) (addressToTag(address) % cacheSize)] = addressToTag(address);
	div $t1, $s2
	mfhi $t0
	sll $t0, $t0, 2
	
	#add $t0, $t0, $s7
	sw $t1, taga($t0)
	j done
amiss:
	jal storetaginoldest
	j done
hit:
	add $t7, $t7, 1
	#increment time
done:
	addi    $t5, $t5, 1
	bne	$t5, 2000, read2
        
        move $a0, $t7
        li  $v0, 1	             
        syscall
        
        jal endl

	move $a0, $t6
        li    $v0, 1	           
        syscall
	
	jal endl
	
	add $t0, $t7, $t6
	
	mtc1 $t0, $f0
	cvt.s.w $f0, $f0
	
	mtc1 $t7, $f2
	cvt.s.w $f2, $f2
	
	div.s $f12, $f2, $f0
	
	li $v0, 2       #print f12             
        syscall
        
        jal endl
        
	mult $t6, $s3
	mflo $a0
	
	add $a0, $a0, $t7
	move $t9, $a0
	li $v0, 1	           
        syscall

	jal endl
	
	mtc1 $t9, $f0
	cvt.s.w $f0, $f0
	
	add $t0, $t6, $t7
	mtc1 $t0, $f2
	cvt.s.w $f2, $f2
	#mfc1 $t1, $f0
	
	div.s $f12, $f0, $f2
	
	#mfc1 $t1, $f0
	
	li $v0, 2       #print f12             
        syscall
	
	j exit

##################################################################3
	
addressToTag: #truns adress in $t0 into tag stored in $t1
	move	$t1, $s6
	div	$t0, $t1       # $t1 = t0/linzsize
	mflo   	$t0
	mult	$t0, $t1       # $t1 = t1*linzsize
	mflo   	$t1
	jr $ra
	
isaddressintag: #sets $t2 to 1  (tag $t0, adress $t1), uses $s0
	move $s0, $ra
	move $t2, $t0
	move $t0, $t1 
	
	jal addressToTag
	move $t0, $t2
	
	li $t2, 0
	bne $t1, $t0, over1
	li $t2, 1
over1:
	move $ra, $s0
	jr $ra
	
isadressintagarray:  #sets $t2 to 1 if $t0 is in the array, uses $s0, $t2, $t3, $t4
	move $t3, $ra
	jal addressToTag	#now tag of adress is in t1
	
	li $t4, 0
	li $t2, 0
loop1:
	#li 	$t9, 4
	#mult	$t4, $t9
	move 	$t9, $t4 
	#mflo	$t9
	sll     $t9, $t9, 2
	
	lw  $t0, taga($t9)
	beq $t0, -1, neg1
	#set t0 to current tag 
	jal isaddressintag
	
	beq $t2, 1, over2
neg1:
	add $t4, $t4, 4
	bne $t4, $s2, loop1
	
	li $t2, 0
	move $ra, $t3
	jr $ra
	
over2:
	li $t4, 0
	sw $t4, tagt($t9) #found
	move $ra, $t3
	jr $ra
	
endl:
	addi $a0, $0, 0xA #ascii code for LF, if you have any trouble try 0xD for CR.
        addi $v0, $0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.        
        syscall
	jr $ra
	
incTime:
	li $t4, 0
loop3:
	move 	$t9, $t4 
	mflo	$t9
	sll     $t9, $t9, 2
	
	lw  $t8, tagt($t9)
	#set t0 to current tag age
	add $t8, $t8, 1
	sw $t8, tagt($t9)
	
	add $t4, $t4, 4
	bne $t4, $s2, loop3
	
	jr $ra

storetaginoldest: #t1 stores tag in t1 in oldest location
	li $t4, 0 #incromenter
	li $t3, 0 #high adress
	li $t2, 0 #high value
loop4:
	move 	$t9, $t4 
	mflo	$t9
	sll     $t9, $t9, 2
	
	lw  $t8, tagt($t9)
	bgt $t2, $t8, notbigger
	move $t2, $t8
	move $t3, $t9
	
notbigger:
	#set t0 to current tag age
	add $t8, $t8, 1
	sw $t8, tagt($t9)
	
	add $t4, $t4, 4
	bne $t4, $s2, loop4
	
	li $t8, 0 
	sw $t8, tagt($t3) #reset value at location
	sw $t1, taga($t3) #store tag in location
	
	jr $ra 

exit:
    li  $v0, 10 
    syscall 
