	.data
ListA:	.word	A0
ListB:	.word	0
A0:		.word	A1
		.word	5
A1:		.word	A2
		.word	7
A2:		.word	A3
		.word	2
A3:		.word	0
		.word	12
str1:	.asciiz	"("
str2:	.asciiz	","
str3:	.asciiz	")\n"
		
	.text
	.globl main
	
main:
	la $a0,ListA			#Print ListA
	jal plist
	
	la $a0,ListB			#Print ListB
	jal plist
	
	ori $v0,$zero,10		#EXIT
	syscall
	
plist:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	
	add $t0,$zero,$a0
	
	ori $v0,$zero,4			#Print "("
	la $a0,str1
	syscall
	
	lw $t1,0($t0)			#次のノードをt1にセット
	beq $t1,$zero,plEnd		#次のノードが無かったらおわり
	
	lw $t0,0($t0)
	
	j plist2
	
plist2:						#ループする部分
	ori $v0,$zero,1			#Print Value
	lw $a0,4($t0)
	syscall
	
	lw $t0,0($t0)
	beq $t0,$zero,plEnd		#次のノードが無かったらおわり
	
	ori $v0,$zero,4			#Print ","
	la $a0,str2
	syscall
	
	j plist2				#ループ頭へ
	
plEnd:
	ori $v0,$zero,4			#Print ")\n"
	la $a0,str3
	syscall
	
	lw $ra,0($sp)
	addi $sp,$sp,4
	
	jr $ra