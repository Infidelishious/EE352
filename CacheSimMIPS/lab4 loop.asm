.data
again:
    .asciiz "Again (y or n)? "  
answer:
    .space 256

.text  
.globl main  
  main:
    li  $v0, 4  
    la  $a0, again  
    syscall  

    la  $a0, answer
    li  $a1, 3
    li  $v0, 8
    syscall

    lb  $t4, 0($a0)

    beq $t4, 'y', main

    li  $v0, 10 
    syscall 