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
	
	la $a0,ListA			#sort
	la $a1,ListB
	jal sortlist
	
	la $a0,ListA			#Print ListA
	jal plist
	
	la $a0,ListB			#Print ListB
	jal plist
	
	ori $v0,$zero,10		#EXIT
	syscall
	
plist:
	add $t0,$zero,$a0
	
	ori $v0,$zero,4			#Print "("
	la $a0,str1
	syscall
	
	lw $t1,0($t0)			#次のノードが無かったらおわり
	beq $t1,$zero,plEnd
	
	lw $t0,0($t0)
	
plist2:
	ori $v0,$zero,1			#Print Value
	lw $a0,4($t0)
	syscall
	
	lw $t0,0($t0)
	beq $t0,$zero,plEnd		#次のノードが無かったらおわり
	
	ori $v0,$zero,4			#Print ","
	la $a0,str2
	syscall
	
	j plist2
	
plEnd:
	ori $v0,$zero,4			#Print ")\n"
	la $a0,str3
	syscall
	
	jr $ra
	
maxlist:
	lw $t0,0($a0)		
	add $t1,$zero,$t0		#$t1に最大値のノードのアドレスを格納していく
	
maxlist2:					#ループ
	lw $t0,0($t0)			#次のノードを確認
	beq $t0,$zero,mlEnd		#次のノードが無かったら終わり
	
	lw $t2,4($t0)
	lw $t3,4($t1)
	
	slt $t4,$t3,$t2			#t1の値 < t0の値ならt4 = 1,t1 = t0をする
	beq $t4,$zero,maxlist2
	
	add $t1,$zero,$t0		#t1のノードを更新
	
	j maxlist2
	
mlEnd:
	add $v0,$zero,$t1
	jr $ra
	
deletelist:
	add $t0,$zero,$a0		#t0で検索
	
deletelist2:
	lw $t1,0($t0)			#t0の次が削除対象を指していたらループを抜ける
	beq $t1,$a1,dlEnd
	
	add $t0,$zero,$t1
	
	j deletelist2
	
dlEnd:
	lw $t1,0($t0)			#t1 = t0->Next
	lw $t1,0($t1)			#t1 = t1->Next
	sw $t1,0($t0)			#t0->Next = t1
	
	add $v0,$zero,$a1
	
	jr $ra
	
insertlist:
	lw $t0,0($a0)			#t0 = a0->Next
	sw $t0,0($a1)			#a1->Next = t0
	sw $a1,0($a0)			#a0->Next = a1
	
	add $v0,$zero,$a1
	
	jr $ra
	
emptylist:
	add $v0,$zero,$zero
	lw $t0,0($a0)
	beq $t0,$zero,elEnd		#次のノードが無ければv0 = 0
	
	addi $v0,$zero,1		#次のノードがあればv0 = 1
	
elEnd:
	jr $ra
	
sortlist:
	addi $sp,$sp,-12		#ra,ListA,ListBを退避
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	
sortlist2:					#ループ
	lw $t0,4($sp)			#ListAの中身が空でないか確認
	add $a0,$zero,$t0
	jal emptylist
	beq $v0,$zero,slEnd		#ListAが空なら終了
	
	lw $t0,4($sp)			#ListAの最大値を持つノードを調べる
	add $a0,$zero,$t0
	jal maxlist
	
	lw $t0,4($sp)			#調べたノードをListAから削除
	add $a0,$zero,$t0
	add $a1,$zero,$v0
	jal deletelist
	
	lw $t0,8($sp)			#ListBの先頭に挿入する
	add $a0,$zero,$t0
	add $a1,$zero,$v0
	jal insertlist
	
	j sortlist2
	
slEnd:
	lw $ra,0($sp)
	addi $sp,$sp,12
	
	jr $ra