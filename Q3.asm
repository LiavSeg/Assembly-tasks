#Title: Maman11	Question 3	Filename: Q3
#Author:Liav Segev	Date:29/12/23
#Description: Prints 16 ls bits of the input in both directions and converts the revered 16 number to a 32 bits sign extented decimal number
#input: Integer X, such that |X|<=9999
#output:16 lsb printed,16 lsb revered printed, 32 bits sign extened decimal value of the 16 revesed bits
#
############ Data Segment ############
.data
Input_msg:	.asciiz "Please enter a value between -9999 to 9999\n"
Wrong_msg:	.asciiz "Wrong input \n"
Null:	.asciiz "\n"
Converted:	.byte
########### Section A ###########
.text
.globl main 
main:
	li $v0,4
	la $a0,Input_msg
	syscall
	li $v0,5
	syscall
	move $s0,$v0
	bgt $s0,9999,isValid
	blt $s0-9999,isValid
	addi $t0,$zero,0x8000 #bit mask
	j print_bits
isValid:	 	
	li $v0,4
	la $a0,Wrong_msg
	syscall
	j main
	
######### Section B ###########
print_bits:
	and $t1,$t0,$s0 #t1 stores the bit
	sgt $t1,$t1,$zero #t1 stores the bit
	li $v0,1
	move $a0,$t1
	syscall
	srl $t0,$t0,1
	bnez $t0,print_bits
	addi $t0,$zero,1
	addi $s1,$zero,0x8000
	li $v0,4
	la $a0,Null
	syscall
######### Section C ###########
print_bits_left:
	and $t1,$t0,$s0 #bit masking
	sgt $t1,$t1,$zero #sets the value of the bit
	beqz $t1,next_digit
	add $s2,$s2,$s1 #Calculates the reversed 16 bit number
next_digit:	
	li $v0,1
	move $a0,$t1
	syscall
	sll $t0,$t0,1
	srl $s1,$s1,1
	bgtz $s1,print_bits_left
	li $v0,4 #newLine 
	la $a0,Null
	syscall

######### Section d ###########
print_dec_left:
	li $v0,1 
	sw $s2,Converted
	lh  $a0,Converted
	syscall	

########## exit ############
exit:
	li $v0 10
	syscall
