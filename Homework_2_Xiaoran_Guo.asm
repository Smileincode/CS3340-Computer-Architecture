# Student's Name: Xiaoran Guo
# Net ID: xxg180001
# Student ID: 2021432123
# Course: CS 3340.002 - Computer Architecture - S19
# Instructor: Karen Mazidi

# Homework 2: MIPS Programmming Basics

.data
# 3 variables to hold input values: a, b, c
a:	.word	0
b:	.word	0
c:	.word	0

# 3 variables to hold output values
ans1:	.word	0
ans2:	.word	0
ans3:	.word	0

# a variable to hold the user’s name
name:	.space 	20

# 3 variables for messages
msg1:	.asciiz	"What's your name ? "
msg2:	.asciiz	"Please enter an integer between 1 and 100 : "
msg3:	.asciiz	"Your answers are : "

# a space character 
space:	.asciiz	" "

.text
main:
	# prompt user for name 
	li	$v0, 4
	la	$a0, msg1
	syscall
	
	# get name from user and save it in memory
	li	$v0, 8
	la	$a0, name
	li	$a1, 20
	syscall
	
	# prompt user for an integer for the first time
	li	$v0, 4
	la	$a0, msg2
	syscall
	
	# get the first int from user and store it in a
	li	$v0, 5
	syscall
	sw	$v0, a
	
	# prompt user for an integer for the second time
	li	$v0, 4
	la	$a0, msg2
	syscall
	
	# get the second int from user and store it in b
	li	$v0, 5
	syscall
	sw	$v0, b
	
	# prompt user for an integer for the third time
	li	$v0, 4
	la	$a0, msg2
	syscall
	
	# get the third int from user and store it in c
	li	$v0, 5
	syscall
	sw	$v0, c
	
	lw	$t0, a			# $t0 = a
	lw	$t1, b			# $t1 = b
	lw	$t2, c			# $t2 = c
	
	add	$t3, $t0, $t0		# $t3 = a + a = 2a
	sub	$t3, $t3, $t1		# $t3 = 2a - b
	addi	$t3, $t3, 9		# $t3 = 2a - b + 9
	sw	$t3, ans1		# store the result in ans1
	
	sub	$t4, $t2, $t1		# $t4 = c - b
	subi	$t5, $t0, 5		# $t5 = a - 5
	add	$t4, $t4, $t5		# $t4 = c - b + (a - 5)
	sw	$t4, ans2		# store the result in ans2
	
	subi	$t6, $t0, 3		# $t6 = a - 3
	addi	$t7, $t1, 4		# $t7 = b + 4
	addi	$t8, $t2, 7		# $t8 = c + 7
	add	$t6, $t6, $t7		# $t6 = (a - 3) + (b + 4) 
	sub	$t6, $t6, $t8		# $t6 = (a - 3) + (b + 4) - (c + 7)
	sw	$t6, ans3		# store the result in ans3
	
	# display the user name
	li	$v0, 4
	la	$a0, name
	syscall
	
	# display a message for result
	li	$v0, 4
	la	$a0, msg3
	syscall
	
	# display the first result
	li	$v0, 1
	lw	$a0, ans1
	syscall
	
	# print a space
	li	$v0, 4
	la	$a0, space
	syscall
	
	# display the second result
	li	$v0, 1
	lw	$a0, ans2
	
	# print a space
	syscall
	li	$v0, 4
	la	$a0, space
	syscall
	
	# display the third result
	li	$v0, 1
	lw	$a0, ans3
	syscall
	
	# syscall to exit program
	li	$v0, 10
	syscall
	
# Comments

# Sample 1
# What's your name ? Xiaoran
# Please enter an integer between 1 and 100 : 20
# Please enter an integer between 1 and 100 : 21
# Please enter an integer between 1 and 100 : 43
# Xiaoran
# Your answers are : 28 37 -8

# Sample 2
# What's your name ? Xuan
# Please enter an integer between 1 and 100 : 21
# Please enter an integer between 1 and 100 : 23
# Please enter an integer between 1 and 100 : 20
# Xuan
# Your answers are : 28 13 18
