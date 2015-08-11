	.data
buffer:	.space 256
endWord:	.word '\n'
ZERO:		.word '0'
operator:	.word	'-','+','*','/'
str:	.asciiz	"AAAAA"
	.text
	.globl main

main:
	la $a0,buffer
	addi $a1,$zero,40
	ori $v0,$zero,8
	syscall
	
	la $a0,buffer
	jal calc
	
	add $a0,$zero,$v0
	ori $v0,$zero,1
	syscall
	
	ori $v0,$zero,10
	syscall
	
Num:
	la $t0,ZERO
	lb $t0,0($t0)
	sub $v0,$a0,$t0
	jr $ra
	
calc:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	add $s0,$zero,$a0
	
calcL:						#ループ
	lb $t0,0($s0)			#t0 = *p
	la $t1,endWord
	lb $t1,0($t1)			#t1 = '\n'
	beq $t0,$t1,calcEnd		#*p == '\n'ならループ抜ける
	
	la $t1,operator
	lw $t2,0($t1)			# check '-'
	beq $t0,$t2,calcSub
	
	la $t1,operator
	lw $t2,4($t1)			# check '+'
	beq $t0,$t2,calcAdd
	
	la $t1,operator
	lw $t2,8($t1)			# check '*'
	beq $t0,$t2,calcMult
	
	la $t1,operator
	lw $t2,12($t1)			# check '/'
	beq $t0,$t2,calcDiv
	
	add $a0,$zero,$t0		#Num呼び出し
	jal Num
	addi $sp,$sp,-4			#Numの返り値をpush
	sw $v0,0($sp)
	
	j calc2
	
calcSub:
	lw $t1,0($sp)			#pop
	lw $t2,4($sp)			#pop
	addi $sp,$sp,8			#stuckをpopした数だけ進める
	
	sub $t3,$t2,$t1
	
	addi $sp,$sp,-4			#計算結果をpush
	sw $t3,0($sp)
	
	j calc2
	
calcAdd:
	lw $t1,0($sp)
	lw $t2,4($sp)
	addi $sp,$sp,8
	
	add $t3,$t1,$t2
	
	addi $sp,$sp,-4
	sw $t3,0($sp)
	
	j calc2
	
calcMult:
	lw $t1,0($sp)
	lw $t2,4($sp)
	addi $sp,$sp,8
	
	mul $t3,$t1,$t2
	
	addi $sp,$sp,-4
	sw $t3,0($sp)
	
	j calc2
	
calcDiv:
	lw $t1,0($sp)
	lw $t2,4($sp)
	addi $sp,$sp,8
	
	div $t3,$t2,$t1
	
	addi $sp,$sp,-4
	sw $t3,0($sp)
	
	j calc2
	
calc2:
	addi $s0,$s0,1			#p++
	
	j calcL
	
calcEnd:
	lw $v0,0($sp)
	addi $sp,$sp,4
	
	lw $ra,0($sp)
	addi $sp,$sp,4
	
	jr $ra