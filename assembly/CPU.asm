j main

j Interrupt

j Exception

main:

	#load systick
	lui $s1 0x00004000		#li $s1 0x40000014
	addi $s1 $s1 0x00000014
	lw $s2 0($s1)
	
	li $s0, 0x00000000
	addi $t0 $zero 128 		#N = buffer[0]
	#addi $s0, $s0, 4
	jal sort
	j finish1
sort:


	addi $t1, $zero, 0		#i = 0
c2:	
	slt $t2, $t1, $t0	
	bnez $t2, loop2			#if(i < n) loop2
	jr $ra
finish1:
	lw $s3 0($s1)			#load systick again
	sub $s4 $s3 $s2
	
	#start the timer
	lui $s1 0x00004000		#li $s1 0x40000000
	addi $s2 $zero 3		#tcon
	sw $s2 8($s1)
	li $s5  0xfffffff0
	sw $s5 0($s1)
	li $s3 0xffffffff		#initialize
	sw $s3 4($s1)

finish2:
	j finish2	
	
c3:	addi $t1, $t1, 1		#i++
	j c2

loop2:


	addi $t3, $t1, -1		#j = i - 1
loop3:
	sll $t3, $t3, 2
	add $t4, $s0, $t3
	srl $t3, $t3, 2
	lw $t5, 0($t4)			#t5 = v[j]
	lw $t6, 4($t4)			#t6 = v[j + 1]
	

	sltu $t7, $t6, $t5		#if(v[j]>v[j + 1])
	slt $t8, $t3, $zero
	bnez $t8, c3
	beqz $t7, c3
	

swap:	xor $t5, $t6, $t5
	xor $t6, $t6, $t5
	xor $t5, $t6, $t5
	sw $t5, 0($t4)
	sw $t6, 4($t4)
	

	addi $t3, $t3, -1
	j loop3


Interrupt:
	#li $s0 0x40000000
	lui $s0 0x00004000
	sw $zero 8($s0)			#disable the timer
	
	li $s0 0x190			#the basic address of LUT
	
	li $t4	0x000f			#get the lower 16bits of systick
	and $t0	$s4 $t4
	srl $s4 $s4 4
	and $t1 $s4 $t4
	srl $s4	$s4 4
	and $t2	$s4 $t4
	srl $s4	$s4 4
	and $t3	$s4 $t4
	
	addi $a0 $t0 0
	jal encode
	addi $t0 $a0 0
	addi $a0 $t1 0
	jal encode
	addi $t1 $a0 0
	addi $a0 $t2 0
	jal encode
	addi $t2 $a0 0
	addi $a0 $t3 0
	jal encode
	addi $t3 $a0 0

	j input

encode:
	#encode the numbers
	add $t4 $zero $zero
	
	beq $a0 $t4 a0
	addi $t4 $t4 1
	beq $a0 $t4 a1
	addi $t4 $t4 1
	beq $a0 $t4 a2
	addi $t4 $t4 1
	beq $a0 $t4 a3
	addi $t4 $t4 1
	beq $a0 $t4 a4
	addi $t4 $t4 1
	beq $0 $t4 a5
	addi $t4 $t4 1
	beq $a0 $t4 a6
	addi $t4 $t4 1
	beq $a0 $t4 a7
	addi $t4 $t4 1
	beq $a0 $t4 a8
	addi $t4 $t4 1
	beq $a0 $t4 a9
	addi $t4 $t4 1
	beq $a0 $t4 a10
	addi $t4 $t4 1
	beq $a0 $t4 a11
	addi $t4 $t4 1
	beq $a0 $t4 a12
	addi $t4 $t4 1
	beq $a0 $t4 a13
	addi $t4 $t4 1
	beq $a0 $t4 a14
	addi $t4 $t4 1
	beq $a0 $t4 a15
	addi $t4 $t4 1
	
a0:
	addi $0 $zero 0x003f
	jr $ra
a1:
	addi $a0 $zero 0x0006
	jr $ra
a2:
	addi $a0 $zero 0x005b
	jr $ra
a3:
	addi $a0 $zero 0x004f
	jr $ra
a4:
	addi $a0 $zero 0x0066
	jr $ra
a5:
	addi $a0 $zero 0x006d
	jr $ra
a6:
	addi $a0 $zero 0x007d
	jr $ra
a7:
	addi $a0 $zero 0x0007
	jr $ra
a8:
	addi $a0 $zero 0x007f
	jr $ra
a9:
	addi $a0 $zero 0x006f
	jr $ra
a10:
	addi $a0 $zero 0x0077
	jr $ra
a11:
	addi $a0 $zero 0x007c
	jr $ra
a12:
	addi $a0 $zero 0x0039
	jr $ra
a13:
	addi $a0 $zero 0x005e
	jr $ra
a14:
	addi $a0 $zero 0x0079
	jr $ra
a15:
	addi $a0 $zero 0x0071
	jr $ra
	
input:
	#li $s0 0x40000010
	lui $s0 0x00004000
	addi $s0 $s0 0x00000010
print:
	sw $t3 0($s0)
	sw $t2 0($s0)
	sw $t1 0($s0)
	sw $t0 0($s0)
	j print
stop:
	j stop
	
Exception:
	j Exception
