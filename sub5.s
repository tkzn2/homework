	.data
p:			.word	node1
operator:	.word	'-','+','*','/'
node1:		.word	'-'
			.word	node2
			.word	node7
node2:		.word	'+'
			.word	node3
			.word	node4
node3:		.word	1
			.word	0
			.word	0
node4:		.word	'*'
			.word	node5
			.word	node6
node5:		.word	5
			.word	0
			.word	0
node6:		.word	3
			.word	0
			.word	0
node7:		.word	'/'
			.word	node8
			.word	node9
node8:		.word	4
			.word	0
			.word	0
node9:		.word	2
			.word	0
			.word	0
	
	.text
	.globl main
	
main:
	la $a0,p
	jal postfix
	
	ori $v0,$zero,10		#EXIT
	syscall
	
postfix:
	lw $a0,0($a0)
	
postfix2:
	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $a0,4($sp)
	
	lw $a0,4($sp)			#左にノードがあるかチェック
	lw $a0,4($a0)
	bne $a0,$zero,postfix3	#あるなら左のノードを引数にしてpostfix2を呼び出し
	
	j postfix4
	
postfix3:
	jal postfix2
	
postfix4:
	lw $a0,4($sp)			#右にノードがあるかチェック
	lw $a0,8($a0)
	bne $a0,$zero,postfix5	#あるなら右のノードを引数にしてpostfix2を呼び出し
	
	j psEnd
	
postfix5:
	jal postfix2
	
psEnd:						#ノードの中身を表示
	lw $a0,4($sp)			#中身がcharかintかで分岐
	lw $a0,0($a0)
	la $t0,operator
	
	lw $t1,0($t0)			#中身が+,-,*,/ならpsEnd2へ
	beq $a0,$t1,psEnd2
	lw $t1,4($t0)
	beq $a0,$t1,psEnd2
	lw $t1,8($t0)
	beq $a0,$t1,psEnd2
	lw $t1,12($t0)
	beq $a0,$t1,psEnd2
	
	j psEnd3
	
psEnd2:
	ori $v0,$zero,11
	syscall
	
	j psEnd4
	
psEnd3:
	ori $v0,$zero,1
	syscall
	
psEnd4:
	lw $ra,0($sp)
	addi $sp,$sp,8
	
	jr $ra