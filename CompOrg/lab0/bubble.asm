#
# FILE:         $File$
# AUTHOR:       J. Breecher, Clark University, 2002
# CONTRIBUTORS:
#		P. White
#		W. Carithers
#		M. Reek
#		Geoff Hotchkiss 
#
# DESCRIPTION:
#	This program is an implementation of bubble sort in MIPS
#	assembly for the SPIM simulator.
#
# ARGUMENTS:
#	None
#
# INPUT:
# 	The 10 numbers to be sorted.
#
# OUTPUT:
#	A "before" line with the 10 numbers in the order they were
#	entered, and an "after" line with the same 10 numbers sorted.
#
# OTHER NOTES:
#	This is a simplistic program, in that it doesn't do much error
#       checking - in an attempt to keep it "short".
#
# REVISION HISTORY:
#	Jan  02		- J. Breecher, Created
#	Sept 03		- P. White, added some comments
#	Sept 03		- W. Carithers, added more comments
#	March 03	- M. Reek, added named constants
#

#-------------------------------

#
# DATA AREAS
#
	.data
	.align	0		# string data doesn't have to be aligned
space:	.asciiz	" "
lf:	.asciiz	"\n"
before:	.asciiz	"Before: "
after:	.asciiz	"After: "
prompt:	.asciiz	"Enter Number: "

	.align	2		# word data must be on word boundaries
array:	.word	-1,-2,-5,-6,-9,-0,-7,-8,-3,-4

#
# CONSTANTS
#

SIZE	= 10			# number of array elements
PRINT_STRING = 4			# arg for syscall to tell it to write
PRINT_INT = 1

#-------------------------------

#
# CODE AREAS
#
	.text			# this is program code
	.align	2		# instructions must be on word boundaries

	.globl	main		# main is a global label

#
# EXECUTION BEGINS HERE
#
main:
	addi	$sp,$sp,-4	# allocate space for the return address
	sw	$ra,0($sp)	# store the ra on the stack

	la	$a0,array	# set up to read in an array of SIZE ints
	li	$a1,SIZE	# and put them at label array
	jal	readarray

	li	$v0,PRINT_STRING	# print a "Before:"
	la	$a0,before
	syscall

	la	$a0,array	# print out the original array
	li	$a1,SIZE
	jal	parray

# ********** BEGIN STUDENT CODE BLOCK 1 **********
#
# Write the code needed to call the sort routine.  The sort routine
# expects the address of the array as its first parameter (i.e., the
# array is passed by reference), and the length of the array as its
# second parameter (passed by value).  Use SIZE as the length of the
# array.
#
# Add your code here:
	la	$a0,array	# print out the original array
	li	$a1,SIZE
	jal sort

# ********** END STUDENT CODE BLOCK 1 **********

	li	$v0,PRINT_STRING		# print "After:	"
	la	$a0,after
	syscall

	la	$a0,array	# print the array again (now sorted)
	li	$a1,SIZE
	jal	parray

	lw	$ra,0($sp)	# restore the ra
	addi	$sp,$sp,-4	# deallocate stack space
	jr	$ra		# return from main and exit spim

#-------------------------------

# printarray prints an array of integers
# called with:
#   $a0 the address of the array
#   $a1 the number of elements in the array

parray:
	li	$t0,0		# i=0;
	move	$t1,$a0		# t1 is pointer to array
pa_loop:
	beq	$t0,$a1,done	# done if i==n

	lw	$a0,0($t1)	# get a[i]
	li	$v0,PRINT_INT
	syscall			# print one int

	li	$v0,PRINT_STRING
	la	$a0,space
	syscall			# print a space

	addi	$t1,$t1,4	# update pointer
	addi	$t0,$t0,1	# and count
	j	pa_loop
done:
	li	$v0,PRINT_STRING
	la	$a0,lf
	syscall			# print a newline

	jr	$ra

#-------------------------------

# readarray reads in an array of integers
# called with:
#   $a0 the address of the array
#   $a1 the number of elements in the array

readarray:
	li	$t0,0		# i=0;
	move	$t1,$a0		# t1 is pointer to array
ra_loop:
	beq	$t0,$a1,ra_done	# done if i==n

	li	$v0,PRINT_STRING
	la	$a0,prompt
	syscall			# print one int

	li	$v0,5
	syscall
	sw	$v0,0($t1)

	addi	$t1,$t1,4	# update pointer
	addi	$t0,$t0,1	# and count
	j	ra_loop
ra_done:
	li	$v0,PRINT_STRING
	la	$a0,lf
	syscall			# print a message

	jr	$ra

#-------------------------------

#
# Bubble sort routine.
#
# Expects the first parameter to be the address of the array,
# and the second parameter to be the length of the array.
#
# Bubble sort routine C code:
#
#	void sort( int v[], int n)
#	{
#		int i, j;
#		for( i = 0; i < n; i++)
#		{
#			for( j = i - 1; (j >= 0) && (v[j] > v[j+1]); j-- )
#			{
#				swap(v, j);
#			}
#		}	
#	} 	
#

sort:
	addi	$sp,$sp,-20	# set up our stack frame
	sw	$ra, 16($sp)	# save return address
	sw	$s3, 12($sp)	# save s0 through s3
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	move	$s2,$a0		# s2 points to the array element
	move	$s3,$a1		# s3 is the length

#
# here is the outer 'for' loop
#
	move	$s0,$zero	# s0 is the outer loop control variable
for1tst:
	slt	$t0,$s0,$s3	# have we reached the end?
	beq	$t0,$zero,exit1	# yes - leave

#
# here is the inner 'for' loop
#
	addi	$s1,$s0,-1	# s1 is the inner loop control variable
for2tst:
	slti	$t0,$s1,0	# j >= 0?
	bne	$t0,$zero,exit2	# no - leave the inner loop

	add	$t1,$s1,$s1	# scale the loop control variable
	add	$t1,$t1,$t1	# t1 = s1 * 4
	add	$t2,$s2,$t1	# t2 now points to v[j]

	lw	$t3,0($t2)	# get v[j]
	lw	$t2,4($t2)	# get v[j+1]
	slt	$t0,$t2,$t3	# v[j] < v[j+1]?
	beq	$t0,$zero,exit2	# yes - leave the inner loop

	move	$a0,$s2		# we found a pair of entries to swap
	move	$a1,$s1
	jal	swap

	addi	$s1,$s1,-1
	j	for2tst
exit2:
#
# end of inner loop
#

	addi	$s0,$s0,1
	j	for1tst
exit1:
#
# end of outer loop
#

	lw	$s0, 0($sp)	# restore our saved registers
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$ra, 16($sp)	# and return address
	addi	$sp,$sp,20	# destroy the stack frame
	jr	$ra		# and return to the caller

#
# End of bubble sort routine.
#


#-------------------------------

# ********** BEGIN STUDENT CODE BLOCK 2 **********
#
# Insert the code to implement this swap routine.  Remember that
# the first parameter is the address of the array, and the second
# parameter is the index of the element to be swapped with its
# successor.
#
#
# Swap routine:
# C code:
#
#	void swap( int v[], int k)
#	{
#		int temp;
#		temp = v[k];
#		v[k] = v[k+1];
#		v[k+1] = temp;
#	} 	
#
# Add your code here:
swap: # a0 is the address of my array, $a1 is the k
	# add $t0, $a1, $a1
	# add $t0, $t0, $t0
	addi $t0, $zero, 4
	mul $t0, $t0, $a1
	add $t0, $a0, $t0	# address of v[k]
	lw $t1, 0($t0)		# get v[k]
	lw $t2, 4($t0)		# get v[k+1]
	sw $t2, 0($t0)		# replace v[k] with v[k+1]
	sw $t1, 4($t0) 		# replace v[k+1] with v[k]i
	jr $ra

# ********** END STUDENT CODE BLOCK 2 **********

#
# End of swap routine.
#
