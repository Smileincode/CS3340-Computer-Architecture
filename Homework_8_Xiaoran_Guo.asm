# Student's Name: Xiaoran Guo
# Net ID: xxg180001
# Student ID: 2021432123
# Course: CS 3340.002 - Computer Architecture - S19
# Instructor: Karen Mazidi

# Homework 8: Compression Program

# file for main program

.include		"macro_file.asm"		# include a file of macros into the current file
		.data
file:		.space	20				# store filename
buffer:		.space	1024
pointer:	.word 	0				# pointer to store the compressed data
		
		.text
main:
		allocate_heap_memory(1024, pointer)	# allocate 1024 bytes of dynamic memory
loop:		
		print_str("\nPlease enter the filename to compress or <enter> to exit: ")
		get_str_from_user(file, 20)
		lb	$t0, file
		beq	$t0, $zero, exit		# if enter nothing, exit the program
		open_file(file, $t0)
		blt 	$t0, $zero, filenotexist	# file descriptor < 0, file doesn't exist 
		read_file($t0, buffer, 1024, $s0)
		close_file($t0)
		print_str("\nOriginal data:\n")
		print_buffer(buffer, $s0)
		
		la	$a0, buffer			# set $a0 to the address of the input buffer
		lw	$a1, pointer			# set $a1 to the address of the compression buffer
		move	$a2, $s0			# set $a2 to the size of the original file
		jal	compression			# call compression function
		move	$s1, $v0			# store the size of the compressed data
		
		lw	$a0, pointer			# set $a0 to the address of the compression buffer
		move	$a1, $s1			# set $a1 to the size of the compressed data
		jal	printcompressed			# call printcompressed function
		
		lw	$a0, pointer			# set $a0 to the address of the compression buffer
		move	$a1, $s1			# set $a1 to the size of the compressed data
		jal	uncompress			# call uncompress function
		
		print_str("\nOriginal file size:")
		print_int($s0)
		print_str("\nCompressed file size:")
		print_int($s1)
		clear_data(file, 20)			# erase the content of file
		j	loop				# main program with loop
compression:
		add	$t0, $a0, $a2			# set $t0 to the max address of the input buffer
		li	$t1, 0				# i = 0
		li	$t2, 0				# j = 0
		li	$t3, 0				# the num of some character n = 0
		li	$t8, 0				# return
loop1:	
		add	$t4, $a0, $t1			# the address of the input buffer + i bytes
		lb	$s4, ($t4)			# load byte buffer[i]
		add	$t5, $a0, $t2			# the address of the input buffer + j bytes
		beq	$t5, $t0, break1		# if the address of buffer[j] = max address, break loop
		lb	$s5, ($t5)			# load byte buffer[j]
		beq	$s5, $s4, add1			# if buffer[i] = buffer[j], jump to add1
							# if buffer[i] != buffer[j], save the compressed data
		sb	$s4, ($a1)			# save buffer[i] which is the character
		addi	$t8, $t8, 1			# return++
		addi	$a1, $a1, 1			# the address of the compression buffer + 1
		sb	$t3, ($a1)			# save n which is the num of char
		addi	$t8, $t8, 1			# return++
		addi	$a1, $a1, 1			# the address of the compression buffer + 1
		
		move	$t1, $t2			# i = j
		li	$t3, 0				# n = 0
		j	loop1				# loop
add1:			
		addi	$t3, $t3, 1			# n++
		addi	$t2, $t2, 1			# j++
		j	loop1				# loop
checkloop1:
		blt	$t1, $a2, loop1			# if i < the size of the original file, loop
break1:		
		sb	$s4, ($a1)			# save buffer[i] which is the character
		addi	$t8, $t8, 1			# return++
		addi	$a1, $a1, 1			# the address of the compression buffer + 1

		sb	$t3, ($a1)			# save n which is the num of char
		addi	$t8, $t8, 1			# return++
		addi	$a1, $a1, 1			# the address of the compression buffer + 1
exit1:
		move	$v0, $t8			# save return to $v0
		jr	$ra
printcompressed:
		print_str("\nCompressed data:\n")
		li	$t0, 0				# i = 0
loop2:
		add	$t1, $a0, $t0			# the address of the input buffer + i
		lb	$t2, ($t1)			# load byte
		print_char($t2)				# print character
		addi	$t0, $t0, 1			# i++
		add	$t1, $a0, $t0			# the address of the input buffer + i
		lb	$t2, ($t1)			# load byte
		print_int($t2)				# print integer
		addi	$t0, $t0, 1			# i++
		blt	$t0, $a1, loop2			# if i < the size of the compressed data, loop
		jr	$ra
uncompress:
		print_str("\nUncompressed data:\n")
		li	$t0, 0				# i = 0
loop3:
		add	$t1, $a0, $t0			# the address of the input buffer + i
		lb	$t2, ($t1)			# load byte
		addi	$t0, $t0, 1			# i++
		add	$t1, $a0, $t0			# the address of the input buffer + i
		lb	$t3, ($t1)			# load byte which is the num of character
		addi	$t0, $t0, 1			# i++
		li	$t4, 0				# j = 0
loop4:
		print_char($t2)				# print the character
		addi	$t4, $t4, 1			# j++
		blt	$t4, $t3, loop4			# if j < the num of character, loop 4
		blt	$t0, $a1, loop3			# if i < the size of the compressed data, loop 3
		jr	$ra
filenotexist:	
		print_str("Error opening file. Program terminating.")
exit:
		li	$v0, 10				# exit program
		syscall

# Comments

# Sample

# Please enter the filename to compress or <enter> to exit: tmp.txt
# Error opening file. Program terminating.
# -- program is finished running --
				
# Please enter the filename to compress or <enter> to exit: hello_art.txt

# Original data:
#   ___ ___         .__  .__            __      __            .__       .___._.
#  /   |   \   ____ |  | |  |   ____   /  \    /  \___________|  |    __| _/| |
# /    ~    \_/ __ \|  | |  |  /  _ \  \   \/\/   /  _ \_  __ \  |   / __ | | |
# \    Y    /\  ___/|  |_|  |_(  <_> )  \        (  <_> )  | \/  |__/ /_/ |  \|
#  \___|_  /  \___  >____/____/\____/    \__/\  / \____/|__|  |____/\____ |  __
#        \/       \/                          \/                         \/  \/
# Compressed data:
#  2_3 1_3 9.1_2 2.1_2 12_2 6_2 12.1_2 7.1_3.1_1.1
# 1 1/1 3|1 3\1 3_4 1|1 2|1 1|1 2|1 3_4 3/1 2\1 4/1 2\1_11|1 2|1 4_2|1 1_1/1|1 1|1
# 1/1 4~1 4\1_1/1 1_2 1\1|1 2|1 1|1 2|1 2/1 2_1 1\1 2\1 3\1/1\1/1 3/1 2_1 1\1_1 2_2 1\1 2|1 3/1 1_2 1|1 1|1 1|1
# 1\1 4Y1 4/1\1 2_3/1|1 2|1_1|1 2|1_1(1 2<1_1>1 1)1 2\1 8(1 2<1_1>1 1)1 2|1 1\1/1 2|1_2/1 1/1_1/1 1|1 2\1|1
# 1 1\1_3|1_1 2/1 2\1_3 2>1_4/1_4/1\1_4/1 4\1_2/1\1 2/1 1\1_4/1|1_2|1 2|1_4/1\1_4 1|1 2_2
# 1 7\1/1 7\1/1 26\1/1 25\1/1 2\1/1
# Uncompressed data:
#   ___ ___         .__  .__            __      __            .__       .___._.
#  /   |   \   ____ |  | |  |   ____   /  \    /  \___________|  |    __| _/| |
# /    ~    \_/ __ \|  | |  |  /  _ \  \   \/\/   /  _ \_  __ \  |   / __ | | |
# \    Y    /\  ___/|  |_|  |_(  <_> )  \        (  <_> )  | \/  |__/ /_/ |  \|
#  \___|_  /  \___  >____/____/\____/    \__/\  / \____/|__|  |____/\____ |  __
#        \/       \/                          \/                         \/  \/
# Original file size:467
# Compressed file size:462
# Please enter the filename to compress or <enter> to exit: hello.txt

# Original data:
# hello
# Compressed data:
# h1e1l2o1
# Uncompressed data:
# hello
# Original file size:5
# Compressed file size:8
# Please enter the filename to compress or <enter> to exit: 

# -- program is finished running --
