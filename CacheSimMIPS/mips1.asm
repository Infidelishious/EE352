	.data
endline: .asciiz "\n"
trace: .word     0 : 700

taga: .word	0	

prompt:	.asciiz	"\nEnter line Size (Must be grater than 4 & power of two): "
prompt2: .asciiz "Associativity (0 = associtive, 1 = direct map): "
prompt3: .asciiz "Enter data size in kb (Must be power of two): "	
prompt4: .asciiz "Enter miss penilty: "
A: .asciiz 	"Total Hit Rate:"
B: .asciiz 	"Total Run Time:"
C: .asciiz 	"Average Memory Access Latencty:"
D: .asciiz 	"Hits:"
E: .asciiz	"Misses:"
F: .asciiz	"Total Hit Rate:\nTotal Run Time:\nAverage Memory Access Latencty:\n"

.text  
main:

	
	
	la $a0, prompt
        li $v0, 4       #print string               
        syscall