###############################################
# 					      #
# Shouzhe Zhang sxz180014@utdallas.edu        #
# Computer Architecture Final Project         #
# Quicksort Implementation in MIPS              #
#                                             #
###############################################
#
# Quicksort C/C++ code fragment:
# 
#  int partition (int arr[], int low, int high) 
# { 
#    int pivot = arr[high];    // pivot 
#    int i = (low - 1);  // Index of smaller element 
  
#    for (int j = low; j <= high- 1; j++) 
#    { 
#       // If current element is smaller than or 
#       // equal to pivot 
#       if (arr[j] <= pivot) 
#        { 
#            i++;    // increment index of smaller element 
#
#             swap(&arr[i], &arr[j]); 
#        } 
#    } 
#    swap(&arr[i + 1], &arr[high]); 
#    return (i + 1); 
# } 
# void quickSort(int arr[], int low, int high) 
# { 
#    if (low < high) 
#    { 
#        /* pi is partitioning index, arr[p] is now 
#           at right place */
#        int pi = partition(arr, low, high); 
#  
#        // Separately sort elements before 
#        // partition and after partition 
#        quickSort(arr, low, pi - 1); 
#        quickSort(arr, pi + 1, high); 
#    } 
#} 
#
# Source for C/C++ code: https://www.geeksforgeeks.org/quick-sort/
#
####################################################################


.data

msg1: .asciiz "Input the number of integers, enter 0 or negative number to exit..."

msg2: .asciiz "Please input the "

msg3: .asciiz " numbers one by one and separate them with one space:\n"

msg4: .asciiz "Quicksort Result: \n"

msg5: .asciiz "done!!\n"

space: .asciiz " "

nl: .asciiz "\n"

.text

.globl start



start:

while0: 
	
	la $a0,msg1		

	li $v0,4		

	syscall			#print 	



	li $v0,5		
	syscall
	
	move $t0,$v0



	beq $t0,$zero,exit 	# N==0 then exit

	slt $t1,$t0,$zero

	bne $t1,$zero,exit 	# N<0 then exit 



	la $a0,msg2		# print 2

	li $v0,4

	syscall

	

	move $a0,$t0		#  output N

	li $v0,1

	syscall



	la $a0,msg3		# print 3

	li $v0,4

	syscall

	

        sll $t0,$t0,2 		# calculate space for storing data, n*4 bytes

	li $t1,3

	mul $a1,$t0,$t1		# a1 incidcates the maximum length for the string

				

				# n< rest of stack / 16， if it == 2^15 bytes， then maximum read-in  2^15 / 16 =2048 integers



	sub $sp,$sp,$t0		# pointer in stack for sp sub for n*4 bytes

	move $s0,$sp		# keep a[0]

	

	sub $sp,$sp,$a1		# pointer keep sub for a1 bytes

	move $a0,$sp		# $a0 is the address for string

	li $v0,8

	syscall			



	move $sp,$s0		# restore a【0】


	
	#ASCII
	addi $t3,$zero,' '	

	addi $t4,$zero,10	#new line

	addi $t5,$zero,'0'	

	addi $t6,$zero,'-'	

	move $t7,$zero		# if $t7 = 0, then $t1 == positive, otherwise negative



	move $t0,$s0		

Loop:	andi $t1,$t1,0x0000     # 0



	tran:	andi $t2,$t2,0x0000	# 0

		lb $t2,0($a0)		# from the string read one byte to $t2

		beq $t2,$t3,store 	# finish read save to $t2

		beq $t2,$t4,store	

		beq $t2,$t6,signed	



		mul $t1,$t1,$t4		# $t1 = $t1 * 10

		sub $t2,$t2,$t5		# $t2 = $t2 - '0'

		add $t1,$t1,$t2		# $t1 = $t1 + $t2

		addi $a0,$a0,1		

		j tran			



	signed:	addi $t7,$zero,-1

		addi $a0,$a0,1

		j tran

		

store:	bne $t7,$zero,add_sign		# determine if t1==negative



lab0:	sw $t1,0($t0)			



	addi $a0,$a0,1			

	addi $t0,$t0,4			

	bne $t2,$t4,Loop		

	j lab1				

add_sign:

	mul $t1,$t1,$t7			

	move $t7,$zero			# 0

	j lab0				



lab1:	move $s1,$t0 		 



	move $a0,$s0		# 'low' of quick_sort(int *low, int *high)

	move $a1,$s1

	addi $a1,$a1,-4		#  high quick_sort(int *low,int *high)

	

	addi $sp,$sp,-32	
	
	sw $ra,28($sp)		

	jal QuickSort		

	lw $ra,28($sp)		

	addi $sp,$sp,32		



	la $a0,msg4		

	li $v0,4

	syscall



	move $sp,$s0		

Output: lw $a0,0($sp)		

	li $v0,1		

	syscall			# print



	la $a0,space

	li $v0,4

	syscall			# print space



	addi $sp,$sp,4		# pointer addi 4 bytes

	bne $sp,$s1,Output	# 



	la $a0,nl		

	li $v0,4

	syscall			# \n

	

	j while0		# while loop



exit:	la $a0,msg5		

	li $v0,4
	
	li $v0, 10	

	
	syscall
	
	jr $ra	

		
	
	
	
	 	



QuickSort:			# void quick_sort(int *low,int *high)



	addi $sp,$sp,-32	# new stack. at least 32 bytes

	sw $ra,28($sp)		

	sw $fp,24($sp)		

	sw $a0,20($sp)		# 0

	sw $a1,16($sp)		# 1

	addi $fp,$sp,32		



	slt $t0,$a0,$a1		

	bne $t0,$zero,less	# if(low<high) then  do less

	j end



	less:	move $t0,$a0	# left = low

		move $t1,$a1	# right = high

		lw $t4,0($a0)	# key = *left



		while1: slt $t2,$t0,$t1  

			bne $t2,$zero,W1	# while(left<high) do W1

			j endW1

		W1:

							# while(left<high && *right>=key) right--;

			while2: slt $t2,$t0,$t1		

				beq $t2,$zero,endW2	# if left>=high) then endW2

				lw $t3,0($t1)		# *right

				slt $t2,$t3,$t4

				bne $t2,$zero,endW2 	# if£ *right<key) then endW2

				addi $t1,$t1,-4		# right--	

				j while2	

			endW2:	lw $t2,0($t1)		# *right

				sw $t2,0($t0)		# *left=*right;



							# while(left<high && *left<key) left++;

			while3: slt $t2,$t0,$t1

				beq $t2,$zero,endW3	# if left>=high) then endW3

				lw $t3,0($t0)		# *left

				slt $t2,$t3,$t4

				beq $t2,$zero,endW3  	# if left>=key) then endW2

				addi $t0,$t0,4		# left++

				j while3

			endW3:	lw $t2,0($t0)		# *left

				sw $t2,0($t1)		# *right=*left

		       j while1



	endW1:

		sw $t4,0($t0)		# *left=key

	

		sw $t0,12($sp)		

		lw $a0,20($sp)		

		addi $t0,$t0,-4		# left-1

		move $a1,$t0		

		jal QuickSort		# quick_sort(low,left-1)

	

		lw $t0,12($sp)		

		addi $t0,$t0,4		# left+1

		move $a0,$t0		

		lw $a1,16($sp)		# high

		jal QuickSort		# quick_sort(left+1,high)

	

end:	lw $ra,28($sp)		

	lw $fp,24($sp)		

	lw $a0,20($sp)		# 0

	lw $a1,16($sp)		# 1

	addi $sp,$sp,32		# restore stack

	jr $ra			