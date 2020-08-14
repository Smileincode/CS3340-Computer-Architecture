# Student's Name: Xiaoran Guo
# Net ID: xxg180001
# Student ID: 2021432123
# Course: CS 3340.002 - Computer Architecture - S19
# Instructor: Karen Mazidi

# Homework 6: MIPS FP Operations

		.data
file:		.asciiz 	"input.txt"		# input filename
buffer:		.space 		80			# place the text from file in a buffer
		.align 		2
array:		.space		80			# store integers in an array
mean:		.float		0			# store the mean in memory as a float
medianfloat:	.float		0			# store the median in memory as a float
medianint:	.word		0			# store the median in memory as a int
std:		.float		0			# store the standard deviation in memory as a float
float2:		.float		2.0			# floating constant 2.0
float0:		.float		0			# floating constant 0
error:		.asciiz		"There is no text in the input file and the program will be terminated."
before:		.asciiz		"\nThe array before:    "
after:		.asciiz		"\nThe array after:     "
meantxt:	.asciiz		"\nThe mean is:"
mediantxt:	.asciiz		"\nThe median is:"
stdtxt:		.asciiz		"\nThe standard deviation is:"

		.text 
main:
		la	$a0, file			# argu 1 for readtext, $a0 = the address of filename
		la	$a1, buffer			# argu 2 for readtext, $a1 = the address of buffer
		jal	readtext			# call function readtext to read text from file
		
		bgt 	$v0, $zero, filenoerr		# if $v0 <= 0, print error and exit program; else, jump over error
		li	$v0, 4
		la	$a0, error
		syscall
		j	exit
filenoerr:	
		li	$s6, 0				# $s6 record the number of interger in buffer
		la	$a0, array			# argu 0 for extractint, $a0 = address of the array
		li	$a1, 20				# argu 1 for extractint, $a1 = 20
		la	$a2, buffer			# argu 2 for extractint, $a1 = address where the buffer starts
		jal	extractint			# call function extractint to extract int from buffer
		
		li	$v0, 4				# print "\nThe array before:    "
		la	$a0, before
		syscall
		
		la	$a0, array			# argu 0 for printarray, $a0 = address of the array
		la	$a1, ($s6)			# argu 1 for printarray, $a1 = the number of integer in array
		jal	printarray			# call function printarray to print array
		
		la	$a0, array			# argu 0 for sortarray, $a0 = address of the array
		la	$a1, ($s6)			# argu 1 for sortarray, $a1 = the number of integer in array
		jal	sortarray			# call function sortarray to sort the array by selection sort

		
		li	$v0, 4				# print "\nThe array after:     "
		la	$a0, after
		syscall
		
		la	$a0, array			# print array after sort
		la	$a1, ($s6)
		jal	printarray
		
		
		li	$v0, 4				# print "\nThe mean is:"
		la	$a0, meantxt
		syscall
		la	$a0, array			# argu 0 for calcmean, $a0 = address of the array
		la	$a1, ($s6)			# argu 1 for calcmean, $a1 = the number of integer in array
		jal	calcmean			# call function calcmean to calculate mean
		li	$v0, 2				# print mean
		lwc1	$f12, mean			
		syscall
		
		li	$v0, 4				# print "\nThe median is:"
		la	$a0, mediantxt
		syscall
		la	$a0, array			# argu 0 for calcmedian, $a0 = address of the array
		la	$a1, ($s6)			# argu 1 for calcmedian, $a1 = the number of integer in array
		jal	calcmedian			# call function calcmedian to calculate median
		beq	$v1, $zero, medianisint		# check if $v1 = zero(flag that indicate median is int)
		li	$v0, 2				# print medianfloat
		lwc1	$f12, medianfloat
		syscall
		j	outmedian
medianisint:
		li	$v0, 1				# print medianint
		lw	$a0, medianint
		syscall
outmedian:		
		li	$v0, 4				# print "\nThe standard deviation is:"
		la	$a0, stdtxt
		syscall
		la	$a0, array			# argu 0 for calcstd, $a0 = address of the array
		la	$a1, ($s6)			# argu 1 for calcstd, $a1 = the number of integer in array
		jal	calcstd				# call function calcstd to calculate standard deviation
		li	$v0, 2				# print standard deviation
		lwc1	$f12, std
		syscall
		j	exit
readtext:	
		la	$t1, ($a1)			# save $a1
		
		li	$v0, 13				# open file
		li	$a1, 0
		li	$a2, 0
		syscall
		move	$t2, $v0			# save file descriptor
		
		li	$v0, 14				# read file
		move	$a0, $t2
		la	$a1, ($t1)
		li	$a2, 80
		syscall
		move	$t3, $v0			# save number of characters read
		
		li	$v0, 16				# close file
		move	$a0, $t2
		syscall
		
		move	$v0, $t3			# load number of characters read to $v0
		jr	$ra
extractint:
		li	$s0, 48				# save const 48 (ASCII for 0)
		li	$s1, 57				# save const 57 (ASCII for 9)
		li	$s2, 10				# save const 10 (ASCII for new line)
		la	$t0, ($a0)			# sace $a0
		la	$t1, ($a2)			# sace $a2
		move	$t3, $zero
readnextbyte:	
		lb	$t2, ($t1)			# load byte from buffer
		blt 	$t2, $s0, notdigit		# if < 48, jump to notdigit
		bgt  	$t2, $s1, notdigit		# if > 57, jump to notdigit
		sub	$t2, $t2, $s0			# subtract 48 to convert it from ASCII to int
		mul	$t3, $t3, $s2			# multiply the register as accumulator by 10
		add	$t3, $t3, $t2			# add the new digit
		addi	$t1, $t1, 1			# the address of buffer + 1 byte
		j	readnextbyte			# loop for next byte
notdigit:
		bne 	$t2, $s2, notten		# if != 10, jump to notten
		sw	$t3, ($t0)			# save the int to array
		move	$t3, $zero
		addi	$t0, $t0, 4			# the address of array + 4 bytes(1 word)
		addi	$t1, $t1, 1			# the address of buffer + 1 byte
		addi	$s6, $s6, 1			# the number of integer + 1
		j	readnextbyte			# loop for next byte
notten:		
		bne 	$t2, $zero, notzero		# if != 0, jump to notzero
		jr	$ra
notzero:		
		addi	$t1, $t1, 1			# the address of buffer + 1 byte
		j	readnextbyte			# loop for next byte
printarray:
		la	$t0, ($a0)			# save $a0
		
		li	$t1, 0				# i = 0
		sll	$t2, $a1, 2			# size * 4
		add	$s0, $t0, $t2			# address of array[size]
		move	$t4, $t0			# address of array
printnextint:	
		li	$v0, 1				# print int
		lw	$a0, ($t4)
		syscall
		li	$v0, 11				# print space
		li	$a0, 32
		syscall
		addi	$t1, $t1, 1			# i = i + 1
		sll	$t3, $t1, 2
		add	$t4, $t0, $t3			# current address = address of array + i * 4
		blt 	$t4, $s0, printnextint		# if current address < array[size], print next int
		jr 	$ra
sortarray:	# outer loop
		li	$t0, 0				# i = 0
for1tst:
		bge   	$t0, $a1, exit1			# check if i < n
		move	$t1, $t0			# min = i
		# inner loop
		addi	$t2, $t0, 1			# j = i + 1
for2tst:
		bge	$t2, $a1, exit2			# check if j < n
		
		sll	$t3, $t2, 2			# j * 4
		add	$t4, $a0, $t3			# array + j * 4
		lw	$t5, ($t4)			# array[j]
		sll	$t6, $t1, 2			# min * 4
		add	$t7, $a0, $t6			# array + min * 4
		lw	$t8, ($t7)			# array[min]
		bge 	$t5, $t8, jplusone		# check if arr[j] < arr[min]
		move	$t1, $t2			# if arr[j] < arr[min], min = j
jplusone:	
		addi	$t2, $t2, 1			# j++
		j	for2tst
exit2:		
		beq	$t1, $t0, iplusone		# check if min != i
		
		sll	$t3, $t1, 2			# $t3 = min * 4
		add	$t4, $a0, $t3			# $t4 = array + min * 4
		lw	$t5, ($t4)			# load word of array[min]
		sll	$t7, $t0, 2			# $t7 = i * 4
		add	$t8, $a0, $t7			# $t8 = array + i * 4
		lw	$t9, ($t8)			# load word of array[i]
		sw	$t9, ($t4)			# swap the two values
		sw	$t5, ($t8)
iplusone:
		addi	$t0, $t0, 1			# i++
		j	for1tst
exit1:
		jr	$ra
		
calcmean:
		sll	$t0, $a1, 2			# $t0 = size * 4
		add	$t1, $a0, $t0			# $t1 = array + size * 4
		la	$t2, ($a0)			# save the address of array
		li	$t4, 0				
loopformean:
		lw	$t3, ($t2)			# load integer
		add	$t4, $t4, $t3			# add integer to accumulator 
		addi	$t2, $t2, 4			# address + 4
		blt	$t2, $t1, loopformean		# load next integer
		mtc1 	$t4, $f2			# convert accumulator to float
		cvt.s.w	$f2, $f2
		mtc1 	$a1, $f4			# convert n to float
		cvt.s.w	$f4, $f4
		div.s	$f2, $f2, $f4			# sum / n
		swc1	$f2, mean			# store mean
		jr	$ra
calcmedian:
		li	$t0, 2				# $t0 = 2
		div	$a1, $t0			# n / 2
		mfhi	$t1				# remainder
		mflo	$t2				# quotient
		bne 	$t1, $zero, isint		# if remainder != 0, median is int
		li	$v1, 1				# set flag $v1 = 1(flag that indicate median is float)		
		sll	$t2, $t2, 2			# $t2 * 4
		add	$t3, $a0, $t2			# $t3 = array + $t2 * 4
		addi	$t4, $t3, -4			# $t4 = array + $t2 * 4 - 4
		lw	$t5, ($t3)			# load one integer in the middle of the array
		lw	$t6, ($t4)			# load another integer in the middle of the array
		add	$t6, $t6, $t5			# sum the two integer
		mtc1 	$t6, $f6			# convert sum to float
		cvt.s.w	$f6, $f6
		lwc1	$f8, float2			# load float 2.0
		div.s	$f6, $f6, $f8			# sum / 2.0
		swc1	$f6, medianfloat		# store medianfloat
		j	exitmedian
isint:
		li	$v1, 0				# set flag $v1 = 0(flag that indicate median is int)
		sll	$t2, $t2, 2			# $t2 * 4
		add	$t3, $a0, $t2			# $t3 = array + $t2 * 4
		lw	$t4, ($t3)			# load integer
		sw	$t4, medianint			# store medianint
exitmedian:
		jr	$ra
calcstd:
		lwc1	$f0, float0			# load float 0
		lwc1	$f2, mean			# load float mean
		lwc1	$f6, float0			# load float 0
		sll	$t1, $a1, 2			# $t1 = size * 4
		add	$t2, $a0, $t1			# $t2 = array + size * 4
		la	$t0, ($a0)			# store the address of array
loopforstd:
		bge 	$t0, $t2, exitstd		# check if current address < &array[size]
		lw	$t3, ($t0)			# load integer
		mtc1	$t3, $f4			# convert integer to float
		cvt.s.w	$f4, $f4
		sub.s	$f4, $f4, $f2			# float = float - mean
		mul.s	$f4, $f4, $f4			# float = float * float
		add.s	$f6, $f6, $f4			# add float to accumulator
		addi	$t0, $t0, 4			# current address + 4
		j	loopforstd
exitstd:
		la	$t4, ($a1)			# store size
		addi	$t4, $t4, -1			# size - 1
		mtc1	$t4, $f8			# convert (size - 1) to float
		cvt.s.w	$f8, $f8
		div.s	$f6, $f6, $f8			# sum / (size - 1)
		sqrt.s 	$f6, $f6			# square root
		swc1	$f6, std			# store the standard deviation
		jr	$ra
		
exit:
		li	$v0, 10				# exit program
		syscall
		
# Comments

# Sample 1
# The array before:    18 9 27 5 48 16 2 53 64 98 49 82 7 17 53 38 65 71 24 31 
# The array after:     2 5 7 9 16 17 18 24 27 31 38 48 49 53 53 64 65 71 82 98 
# The mean is:38.85
# The median is:34.5
# The standard deviation is:27.686735
# -- program is finished running --

# Sample 2
# The array before:    12 15 7 37 56 201 137 55 1 98 98 78 23 568 33 25 33 
# The array after:     1 7 12 15 23 25 33 33 37 55 56 78 98 98 137 201 568 
# The mean is:86.882355
# The median is:37
# The standard deviation is:134.63881
# -- program is finished running --
		
		
		
