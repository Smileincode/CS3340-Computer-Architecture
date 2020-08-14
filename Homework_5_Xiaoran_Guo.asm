# Student's Name: Xiaoran Guo
# Net ID: xxg180001
# Student ID: 2021432123
# Course: CS 3340.002 - Computer Architecture - S19
# Instructor: Karen Mazidi

# Homework 5: BMI Calculator

		.data
prompt1:	.asciiz 	"What is your name? "
prompt2:	.asciiz 	"Please enter your height in inches: "
prompt3:	.asciiz 	"Now enter your weight in pounds (round to a whole number): "
output1:	.asciiz		"Your bmi is: "
output2:	.asciiz		"\nThis is considered underweight. "
output3:	.asciiz		"\nThis is a normal weight. "
output4:	.asciiz		"\nThis is considered overweight. "
output5:	.asciiz		"\nThis is considered obese. "
name:		.space		20
height:		.float		0
weight:		.float		0
bmi:		.float		0
const703:	.float		703.0
const18dot5:	.float 		18.5
const25:	.float		25
const30:	.float		30

		.text
main:
		# Prompt user for their data
		li	$v0, 4				# print prompt1
		la	$a0, prompt1
		syscall
	
		li	$v0, 8				# get name from user and save it in memory
		la	$a0, name
		li	$a1, 20
		syscall
		
		li	$v0, 4				# print prompt2
		la	$a0, prompt2
		syscall
	
		li	$v0, 6				# get height from user and save it in memory
		syscall
		swc1	$f0, height
		
		li	$v0, 4				# print prompt3
		la	$a0, prompt3
		syscall
	
		li	$v0, 6				# get weight from user and save it in memory
		syscall
		swc1	$f0, weight
		
		# Calculate the bmi
		lwc1	$f2, height
		lwc1	$f4, weight
		lwc1	$f6, const703
		lwc1	$f16, const18dot5
		lwc1	$f18, const25
		lwc1	$f20, const30
		
		mul.s	$f2, $f2, $f2			# height *= height
		mul.s	$f4, $f4, $f6			# weight *= 703
		div.s	$f8, $f4, $f2			# bmi = weight / height
		swc1	$f8, bmi
		
		# Output the results
		li	$v0, 4				# print name
		la	$a0, name
		syscall
		
		li	$v0, 4				# print output1
		la	$a0, output1
		syscall
		
		li	$v0, 2				# print bmi
		lwc1	$f12, bmi
		syscall
		
		c.lt.s	$f8, $f16			# if bmi < 18.5, jump to underweight
		bc1t 	underweight
		c.lt.s	$f8, $f18			# if bmi < 25 and bmi >= 18.5, jump to normal
		bc1t	normal
		c.lt.s	$f8, $f20			# if bmi < 30 and bmi >= 25, jump to overweight
		bc1t	overweight
		
		li	$v0, 4				# if bmi >= 30, print output5
		la	$a0, output5
		syscall
		
		j	exit

underweight:	li	$v0, 4				# print output2
		la	$a0, output2
		syscall
		
		j	exit

normal:		li	$v0, 4				# print output3
		la	$a0, output3
		syscall
		
		j	exit
		
overweight:	li	$v0, 4				# print output4
		la	$a0, output4
		syscall
		
		# Exit program		
exit:		li	$v0, 10
		syscall

# Comments

# Sample 1
# What is your name? Xiaoran Guo
# Please enter your height in inches: 72
# Now enter your weight in pounds (round to a whole number): 200
# Xiaoran Guo
# Your bmi is: 27.121914
# This is considered overweight. 
# -- program is finished running --

# Sample 2
# What is your name? Daisy Li
# Please enter your height in inches: 65
# Now enter your weight in pounds (round to a whole number): 125
# Daisy Li
# Your bmi is: 20.798817
# This is a normal weight. 
# -- program is finished running --
