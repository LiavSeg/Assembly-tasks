#Title: Maman 11	Question 4	Filename: Q4
#Author:Liav Segev	Date:11/01/24
#Description: "Bullseye" game 
#input: Three digits and a string of 3 digits
#output: string representaion of hits or misses 
#

.macro isequal %reg1,%reg2,%reg3
	beq %reg1,%reg2,same_inp
	beq %reg1,%reg3,same_inp
	beq %reg2,%reg3,same_inp	
.end_macro

.macro isvalid %reg1,%reg2,%reg3
	beq %reg1,%reg2,is_valid_st
	beq %reg1,%reg3,is_valid_st
	beq %reg2,%reg3,is_valid_st
.end_macro

.macro isdigit %reg1
	bgt %reg1,'9',is_valid_st
	blt %reg1,'0',is_valid_st
.end_macro

.macro anothergame %v0,%a0 
	li %v0,4
	la %a0,new_game
	syscall
	
	li %v0,12
	syscall	
	beq %v0,'y',main
	beq %v0,'Y',main
	j exit	
.end_macro

############ Data Segment ############
.data
bool:	.space 4 
guess:	.space 4
N:	.asciiz "n"
P:	.asciiz "p"
B:	.asciiz "b"
input_msg:	.asciiz "\nPlease enter a number between 0-9 "
wrong_msg:	.asciiz "\nWrong input\n"
wrong_string:	.asciiz "\n\nWrong guess foramt"
identical_msg:	.asciiz "\n\nWrong input, identical numbers are not allowed\n"
guess_msg:	.asciiz "\n\nGuess my number\t\t"
tab:	.asciiz "\t\t"
nline:	.asciiz "\n"
new_game: "\n\tPress y to play again\n"

########### Section A ###########
.text
.globl main 
main:	
	#calls for get_number procedure
	la $a0,bool #loads bool's address as an argument
	jal get_number	
	
	#calls for get_guess procedure with bool's address as an argument
	la $a0,bool #loads bool's address as an argument
	la $a1,guess #loads guess's address as an argument
	jal get_guess
	bne $v0,-1,main
	anothergame $v0,$a0
	
get_number:
	move $t0,$a0 #$t0 gets bool's address for loop usage
	move $s0,$a0 #$s0 gets bool's address
	li $t4,0
	li $v0,4
	la $a0,input_msg
	syscall
get_char: #loop that reads a single character at time 
	li $v0,12
	syscall
	sb $v0,($t0) #saves a character in bool
	j check_input #character validation

check_input: #character validation
	lb $t1,($t0) #t1 gets a value from bool
	# checks if 0<=$t1<=9
	bgt $t1,'9',wrong_inp
	blt $t1,'0',wrong_inp
	addi $t4,$t4,1 #counter for the loop condition 
	addi $t0,$t0,1 #next value's addres in bool array
	bne $t4,3,get_char #checks the loop conditon 
	#this segment checks for identical values stored in bool
	lb $t1,($s0)
	lb $t2,1($s0)
	lb $t3,2($s0)
	isequal $t1,$t2,$t3 #validation macro
	jr $ra
	
same_inp: #in case of one or more identical values
	li $v0,4
	la $a0,identical_msg
	syscall
	move $a0,$s0 #restores the address of bool
	j get_number #gets a new input	

wrong_inp: #in case of an invalid character reading 
	li $v0,4
	la $a0,wrong_msg
	syscall
	move $a0,$s0 #restores the address of bool
	j get_number #gets a new input	
		
########### Section B ###########
get_guess:
	move $s0,$a0 #s0 gets bool's address
	move $s1,$a1 #s1 gets guess's address
	addi $sp,$sp,-4 #push
	sw $ra,($sp) #stores return address in the current stack position

get: # handles actuall string input
	li $v0,4
	la $a0,guess_msg
	syscall
	#gets a string 
	li $v0,8
	la $a0,($s1) #string input will be stored in $s1 	
	li $a1,4 #string size limit null terminator included
	syscall
	
	li $v0,4
	la $a0,tab
	syscall
	# nested procedure calling
 	la $a0,($s0) #bool's address
	la $a1,($s1) #guess's address
	jal compare
	lw $ra,($sp) #restores the right return address
	addi $sp,$sp,4 #pop stack 
	jr $ra
					
compare:
	move $t0,$a0 #t0 gets bool address 	
	move $t1,$a1 #t1 gets guess address
	move $t8,$zero #counter of b 
	move $t9,$zero	#counter of p
	
	#loads values stored in bool to registers t2-t4
	lb $t2,($t0)
	lb $t3,1($t0)
	lb $t4,2($t0)
	#loads values stored in guess to registers t5-t7
	lb $t5,($t1)
	lb $t6,1($t1)
	lb $t7,2($t1)
	#validation of guess values 	
	isvalid $t5,$t6,$t7 #validation macro 
	isdigit $t5 #validation macro 
	isdigit $t6 #validation macro 
	isdigit $t7 #validation macro 
	
	li $v0,4
	la $a0,P
	j first_p

is_valid_st:
	li $v0,4
	la $a0,wrong_string
	syscall
	j return
#the following segment checks for equal values in unmatched positons
#for each label the documentation remains the same					
first_p: 
	bne $t2,$t6,second_p #check the next possible matched pair in case this pair isn't matched
	addi $t9,$t9,1 #counts the number of equal pairs in different positions
	syscall #prints p in case of a match		
second_p:
	bne $t2,$t7,third_p
	addi $t9,$t9,1
	syscall			
third_p:
	bne $t3,$t5,fourth_p
	addi $t9,$t9,1	
	syscall		
fourth_p:
	bne $t3,$t7,fifth_p
	addi $t9,$t9,1
	syscall
fifth_p:
	bne $t4,$t5,sixth_p
	addi $t9,$t9,1
	syscall
sixth_p:
	bne $t4,$t6,first_pair_b
	addi $t9,$t9,1
	syscall

#the following segment checks for equal values in equal positons
#for each label the documentation remains the same				
first_pair_b:
	la $a0,B #loads "b" string address in case of an equal pair
	bne $t2,$t5,second_pair_b #check the next possible equal pair
	addi $t8,$t8,1 # counts the number of equal pairs and positions
	syscall	#prints b in case of a match
second_pair_b:	
	bne $t3,$t6,third_pair_b
	addi $t8,$t8,1	
	syscall
third_pair_b:
	bne $t4,$t7,done
	addi $t8,$t8,1
	syscall

done:
	beq $t8,3,win #checks for a win 
	add $t0,$t8,$t9 #calculats the sum of both counters
	bne $t0,0,return #return if one match or more occured
	li $v0,4 #prints n in case of zero total matches
	la $a0,N
	syscall
	j return
win:	#finishes a winning guess 
	li $v0,4
	la $a0,nline
	syscall
	li $v0,-1
	jr $ra
return: #finishes a "losing" guess 
	li $v0,4
	la $a0,nline
	syscall
	li $v0,1
	jr $ra
																																																																																																																																																																																																																																																											
########## exit ############
exit:
	li $v0 10
	syscall
