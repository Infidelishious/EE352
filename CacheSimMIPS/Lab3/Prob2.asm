.data
space: .asciiz " "
#values must be grateer than 0
X: .word 31, 17, 92, 46, 172, 208, 13, 93, 65, 112
N: .word 10

.text
main:   
    la $a0, X       #$a0=load address of array X
    lw $a1, N       #$a1=10  --number elements
    li $t2, 0	#$t2 = current smallest
    li $t3, 0	#$t2 = must be grater than
    li $t4, 0
    
start:
    jal readArray  #call readArray
    
    la $a0, space   #load a space:  " "
    li $v0, 4       #print string               
    syscall
    
    move $a0, $t2
    li $v0, 1       #Print integer              
    syscall
    
    move $t3, $t2
    li $t2, 0	#$t2 = current smallest
    
    add $t4, $t4, 1
    bne $t4, 10, start
    
    li $v0, 10      #exit program   
    syscall 

readArray:
    li $t0, 0       #$t0=0
    li $t1, 0       #$t1=0
    
buc:    
    bge $t0, $a1, final #if  $t0 >= $a1 then goto
    
    lw $a0, X($t1) #$a0 = X(i)

    bgt $a0, $t3, bigger #if $a0 > $t3 then goto
    j no
bigger:
    bge $t2, $a0, smaller #if $t2 > $a0 then goto
    beq $t2, 0, smaller #if $t2 > $a0 then goto
    j no
smaller:
    move $t2, $a0
no:
    addi $t1, $t1, 4    #Every 4 bytes there is an integer in the array
    addi $t0, $t0, 1    #$t0=$t0+1
    b buc       #goto buc
final:  
    jr $ra      #return
