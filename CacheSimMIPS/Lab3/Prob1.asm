.data
big_s: .asciiz "\nbiggest:\n"
small_s: .asciiz "\nsmallest:\n"
average_s: .asciiz "\naverage:\n"
space: .asciiz " "
X: .word 31, 17, 92, 46, 172, 208, 13, 93, 65, 112
N: .word 10

.text
main:   
    la $a0, X       #$a0=load address of array X
    lw $a1, N       #$a1=10  --number elements
    lw $t2, X($t1)	#$t2 = min
    lw $t3, X($t1)	#$t3 = max
    jal readArray  #call readArray
    
    la $a0, small_s
    li $v0, 4       #print string               
    syscall
    
    li $v0, 1      
    move $a0, $t2
    syscall 
    
    la $a0, big_s
    li $v0, 4       #print string               
    syscall
    
    li $v0, 1      
    move $a0, $t3
    syscall 
    
    la $a0, average_s
    li $v0, 4       #print string               
    syscall
    
    add $t5, $t2, $t3 
    div $t5, $t5, 2
    
    li $v0, 1      
    move $a0, $t5
    syscall 
    
    li $v0, 10      #exit program   
    syscall 

readArray:
    li $t0, 0       #$t0=0
    li $t1, 0       #$t1=0
    
buc:    
    bge $t0, $a1, final #if  $t0 >= $a1 then goto final
    
    la $a0, space   #load a space:  " "
    li $v0, 4       #print string               
    syscall
    
    lw $a0, X($t1) #$a0 = X(i)
    li $v0, 1       #Print integer              
    syscall

    bgt $a0, $t3, bigger #if  $a0 > $t3 then goto final
    j nob
bigger:
    move $t3, $a0
nob:
    bgt $t2, $a0, smaller #if  $t2 > $a0 then goto final
    j nos
smaller:
    move $t2, $a0
nos:
    addi $t1, $t1, 4    #Every 4 bytes there is an integer in the array
    addi $t0, $t0, 1    #$t0=$t0+1
    b buc       #goto buc
final:  
    jr $ra      #return
