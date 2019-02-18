# Student's Name: Xiaoran Guo
# Net ID: xxg180001
# Student ID: 2021432123
# Course: CS 3340.002 - Computer Architecture - S19
# Instructor: Karen Mazidi

# Homework 3: MIPS Control Structures

.data
prompt:		.asciiz		"Please input a string which just contains words and space. "
input:		.space		101				# reserve space for string
maxNumOfChar:	.word		100				# the max length of string
space:		.word		32				# the ascii of space
inWord:		.word		0				# if the char is space, the value is 0; if not, it is 1.
numOfWord:	.word		0
numOfChar:	.word		0
goodbye:	.asciiz		"Goodbye!"			# valediction
null:		.asciiz		""
words:		.asciiz		" words "			# string used for output
characters:	.asciiz		" characters\n"			# string used for output
test:		.asciiz		"Test saveing and restoring $s1"

.text
main:
		la  	$a0, prompt				# prompt user for string 
		la  	$a1, input				# get string from user
		lw  	$a2, maxNumOfChar
		li  	$v0, 54
		syscall
		
		lw	$t1, input				# load the string to $t1	
		bne	$a1, $zero, exit			# entering a blank string or hits “cancel” will exit
		lw  	$t2, space				# load space to $t2
		la  	$a0, input				# load the string to $a0 as an argument in function count
		
		la	$s1, test				# save $s1 in stack
		addi	$sp, $sp, -4
		sw	$s1, 0($sp)
		
		jal 	count					# call function count
		j	main					# call another prompt
	
count:								# function count
		li  	$t4, 0					# the index of the character in string
		lw  	$t5, inWord				# load inWord to $t5
		li  	$v0, 0					# initialize $v0 (store the num of word) to 0
		li  	$v1, -1					# initialize $v1 (store the num of char) to -1, because the last char is "\n"

loop:								# loop in count
		add 	$t3, $a0, $t4				# $t3: the address of the current char
		lb 	$t6, 0($t3)				# load one byte(one char) to $t6
		beq 	$t6, $zero, isEnd			# if already deal with the whole string
		addi 	$v1, $v1, 1				# the num of char + 1
		beq 	$t6, $t2, isSpace			# if is space	
		beq	$t5, $zero, isWord			# if is the first char of the word
		addi	$t4, $t4, 1				# the index of the character in string + 1			
		j 	loop
		
isWord:								
		addi 	$v0, $v0, 1				# the num of word + 1
		li  	$t5, 1					# change the value of inWord to 1
		addi	$t4, $t4, 1				# the index of the character in string + 1
		j 	loop
isSpace:
		li  	$t5, 0					# change the value of inWord to 0
		addi	$t4, $t4, 1				# the index of the character in string + 1
		j 	loop
isEnd:	
		sw 	$v0, numOfWord				# save the num of word to memory
		sw 	$v1, numOfChar				# save the num of char to memory
		la  	$a0, input				# output the string
		li  	$v0, 4
		syscall
		lw  	$a0, numOfWord				# output the num of word
		li  	$v0, 1
		syscall
		la  	$a0, words
		li  	$v0, 4
		syscall
		lw  	$a0, numOfChar				# output the num of char
		li  	$v0, 1
		syscall
		la  	$a0, characters
		li  	$v0, 4
		syscall
		
		la	$s1, 0($sp)				# restore $s1 from stack
		addi	$sp, $sp, 4
		jr 	$ra
	
exit:
		la  	$a0, null				# output valediction
		la  	$a1, goodbye
		li	$v0, 59
		syscall
		
		li  	$v0, 10					# exit the program
		syscall

# Comments

# Sample 1
# Today is a Good Day
# 5 words 19 characters

# Sample 2
# Tomorrow will be better
# 4 words 23 characters

# -- program is finished running --

	
	
