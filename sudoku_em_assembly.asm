.data
   # Forma para acessar as posições da matriz: (L * 9) + (C * 1)
   # (2 * 9) + (3 * 1)
   # 18 + 3
   # 21
   # (0 * 9) + (0 * 1)
   # 0 + 0
   #Limite até 8 pra C e L
   #matriz: .word:   
   #L             C 00 01 02 03 04 05 06 07 08                  
   #0        .word: 00 01 02 03 04 05 06 07 08
   #1        .word: 09 10 11 12 13 14 15 16 17
   #2        .word: 18 19 20 21 22 23 24 25 26
   #3        .word: 27 28 29 30 31 32 33 34 35
   #4        .word: 36 37 38 39 40 41 42 43 44
   #5        .word: 45 46 47 48 49 50 51 52 53
   #6        .word: 54 55 56 57 58 59 60 61 62
   #7        .word: 63 64 65 66 67 68 69 70 71
   #8        .word: 72 73 74 75 76 77 78 79 80
    
   sudoku: .space 81 # 81 bytes
   primeiraLinha: .space 9 # 9 bytes
   submatriz: .space 9
   mensagemL: .asciiz "Linha: "
   mensagemC: .asciiz "Coluna: "
   mensagemDeAlerta: .asciiz "Posicao preenchida!!!"
   novalinha: .asciiz "\n"
   
   mensagemNum: .asciiz "Digite o número: "
   espaco: .asciiz " "
   mensagemVL: .asciiz "Verificar Linha: "
   mensagemVC: .asciiz "Verificar Coluna "
   mensagemVSM: .asciiz "Verificar SubMs: "
   mensagemSudoku: .asciiz "Sudoku valido!!!"
   mensagemSudokuInvalido: .asciiz "Sudoku invalido!!!"
   
.text
    main: 
        jal inicializarsudoku
        jal construtordetabela
        
        addi $v0, $zero, 4
        la $a0, novalinha
        syscall
        
        jal inserirnosudoku

        jal verificarlinha
        add $t0, $zero, $v0        
        
 
        jal verificacoluna
        add $t1, $zero, $v0        
        
 
        jal verificarsubmatrizes
        add $t3, $zero, $v0        
        
        mul $t0, $t0, $t1
        mul $t0, $t0, $t3

        if67: bne $t0, 1, endIf67Else67
            addi $v0, $zero, 55
            addi $a1, $zero, 0
		    la $a0, mensagemSudoku
            j endIf67Else67 
        else67:  
            addi $v0, $zero, 55
            addi $a1, $zero, 0
		    la $a0, mensagemSudokuInvalido
        endIf67Else67:
    
	addi $v0, $zero, 10
        syscall
    

    rand:
        addi $a1, $zero, 9
        
        addi $v0, $zero, 42
        syscall
         
		add $v0, $zero, $zero
        add $v0, $v0, $a0
        jr $ra

    inserirnosudoku:
        addi $t0, $t0, 50			# $t0 = $t0 + 50
        do2:
            # Ler o valor de L
            #Linha:
            addi $v0, $zero, 51
		    la $a0, mensagemL
		    syscall
            move $t1, $a0

            # Ler o valor de C
            #Coluna:
            addi $v0, $zero, 51
		    la $a0, mensagemC
		    syscall
            move $t2, $a0
            
            # (L * 9) + (C * 1)
            mul $t1, $t1, 9
            add	$t3, $t1, $t2	
            
            lb $t4, sudoku($t3)
            if4: bne $t4, 0, else4
                #Digite o número:
                addi $v0, $zero, 51
		        la $a0, mensagemNum
		        syscall
                
                sb $a0, sudoku($t3) 
                #quant++
                addi $t0, $t0, 1
                j endIf4Else4
            else4: 
                #Posição preenchida
                addi $v0, $zero, 55
                addi $a1, $zero, 0
		        la $a0, mensagemDeAlerta
		        syscall
            endIf4Else4:
                
            addi $t5, $zero, 0
            for: beq $t5, 81, endFor
				addi $v0, $zero, 1
                lb $a0, sudoku($t5)
                syscall

                addi $v0, $zero, 4
                la $a0, espaco
                syscall

                addi $t5, $t5, 1
                rem $t6, $t5, 9 
                if22: bne  $t6, 0, endIf22
                    addi $v0, $zero, 4
                    la $a0, novalinha
                    syscall

                endIf22:
                
                j for
            endFor: 
			addi $v0, $zero, 4
            la $a0, novalinha
            syscall
            
            addi $v0, $zero, 4
            la $a0, novalinha
            syscall
        while2: blt	$t0, 81, do2 # if $t1 < 81 then do2
        jr $ra
    

    verificarlinha:
        addi $t0, $zero, 0 
        for3: beq $t0, 9, endFor3 # $t0 IGUAL 9? pula para endFor3
            # L = 0
            mul $t6,$t0,9 # $t6 = $t0 * 9 
                
            addi $t2, $zero, 0 # k = 0
            for4: beq $t2, 9, endFor4 # $t2 IGUAL 9? pula para endFor4
                
                add $t4, $t6, $t2    
                lb $s1, sudoku($t4)
                
                # $t3 é o x
                addi $t3, $t2, 0 # x = $t2 + 0
                for5: beq $t3, 9, endFor5 # $t4 IGUAL 9? pula para endFor5

                    add $t7 ,$t6, $t3 
                    lb $s2, sudoku($t7)
                    
                    # if (sudoku[L][k] == sudoku[L][x] && x != k)
                    
                    seq $s3, $s1, $s2
                    sne $t5, $t3, $t2 # $t5 = $t3 != $t2
                    and	$s4, $s3, $t5 # $s4 = $s3 & $t5
                    if20: beq $s4, $zero, endIf20	# if $s4 == $t1 then target
                        addi $v0, $zero, 0    	
                        jr $ra # return $ra
                    endIf20: #syscall
                
                    addi $t3, $t3, 1
                    j for5
                endFor5:

                addi $t2, $t2, 1
                j for4
            endFor4:

            addi $t0, $t0, 1 # $t0 = $t0 + 1
            j for3
        endFor3:
        addi $v0, $zero, 1
        jr $ra

    verificacoluna:
        
        # $t0 = c
        addi $t0, $zero, 0 
        for6: beq $t0, 9, endFor6 # $t0 IGUAL 9? pula para endFor6
            
            # $t2 = L
            addi $t2, $zero, 0
            for7: beq $t2, 9, endFor7	# if $t2 ==zerot1endtarget
            
                mul $t6,$t2,9
                

                # $t3 = f
                addi $t3, $t6, 9 # $t3 = $t6 + 1
                for8: beq $t3, 81 endFor8

                    #(L * 9) + (C * 1)
                    add $t4, $t3, $t0
                    add $t6, $t6, $t0
                    lb $t5, sudoku($t4)
                    lb $t1, sudoku($t6)
 
                    if5: bne $t5, $t1, endIf5	# if $t5 == $t1 then target
                        addi	$v0, $zero, 0			# $v0 =$zero + 0
                        jr $ra
                    endIf5:
                    addi $t3, $t3, 9
                endFor8:

                addi $t2, $t2, 1
            endFor7:
            #C = 0
            addi $t0, $t0, 1 # $t0 = $t0 + 1 // C = C + 1
            j for6
        endFor6:
        addi $v0, $zero, 1
        jr $ra

    #(L*3) + (C*1) 
    #  0  1  2
    #0 00 01 02
    #1 03 04 05
    #2 06 07 08
    
    verificarsubmatrizes:
        addi $t0, $zero, 0
        for12: beq $t0, 9, endFor12
                
            addi $t1, $zero, 0
            for13: beq $t1, 9, endFor13

               addi $t2, $t2, 0
                for14: beq $t2, 3, endFor14
                    
                    addi $t3, $t3, 0
                    for15: beq $t3, 3, endFor15
                        #$t4 é a submatriz
                        mul $t4, $t2,3
                        add	$t4, $t4, $t3		# $t2 = $t4 + $t3
                        
                        #nesse momento $t5 é matriz[i][j]
                        mul $t5, $t0, 9
                        add $t5, $t5, $t1
                        
                        #$t5 agora é matriz[y+i][x+j]
                        add $t5, $t5, $t4 #matriz[y+i][x+j]


                    addi $t3, $t3, 1
                    j for15
                    endFor15:
                addi $t2, $t2, 1
                j for14
                endFor14:
                
                addi $sp, $sp, -4
                sw $ra, 0($sp)
                jal verificarsubmatriz
                lw $ra, 0($sp)
                addi $sp, $sp, 4

                add $t7, $zero, $v0 
                if9: bne $t7, 1, endIf9	# if $t7 == $t1 then target
                    addi $v0, $zero, 0
                    jr $ra
                endIf9:

                addi $t1, $t1, 3
                j for13
            endFor13:
            

            addi $t0, $t0, 3
            j for12
        endFor12:
        addi $v0, $zero, 1
        jr $ra
        
        
    verificarsubmatriz:
        # Fórmula para percorrer os índices da matriz: (L*3) + (C*1)
        addi $t0, $zero, 1
        for9: beq	$t0, 10, endFor9	# if $t0 == $t1 then target

            addi $t1, $zero, 0
            #i = $t1
            for10: beq $t1, 3, endFor10
                mul $t2, $t1, 3
                #j = $t3
                addi $t3, $zero, 0
                for11: beq $t3, 3, endFor11	# if $t0 == $t1 then target
                    add $t2, $t2, $t3
                    lb	$t4, submatriz($t2) 

                    if6: bne $t4, $t0, endIf6	
                        addi $s0, $s0, 0
                    endIf6: 


                    addi $t3, $t3, 1
                    j for11
                endFor11:
                addi $t1, $t1, 1
                j for10        
            endFor10:

            if7: ble $s0, 1, endIf7
                addi $v0, $zero, 0
                jr $ra
            endIf7:
            addi $s0, $zero, 0

            addi $t0, $t0, 1		# $t0 = $01 1
            j for9
        endFor9:
        addi $v0, $zero, 1
        jr $ra

    direcionador:
        addi $t0, $a0,0 
        lb  $a1, sudoku($t0) # Trocar lw por lb
        

        if: ble $a1, 9, endIf # $a1 <= 9, pula para endIf
            
            sub $a1, $a1, 9 # $s1 = $s1 -9
            sb $a1, sudoku($a0) # Troca sw por sb
            endIf:
        jr $ra
        
    direcionadorP:
        #addi $t0, $a0,0 
        lb  $a1, primeiraLinha($a0) # Trocar lw por lb
        

        if30: ble $a1, 9, endIf30 # $a1 <= 9, pula para endIf
            
            sub $a1, $a1, 9 # $s1 = $s1 -9
            sb $a1, primeiraLinha($a0) # Troca sw por sb
            endIf30:
        jr $ra    
        
          
    preencherVetor:
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
        jal rand
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        # $t0 é igual a variável number
        move $t0, $v0 # $t0 = $v0 //$t0 é igual ao conteudo de $v0
        addi $t0, $t0, 1
        
        # indices do vetor
        addi $t3, $zero, 0 # $t3 = 0
        addi $t2, $zero, 1 # $t2 = 1
        #addi $s1, $t0, 48
        
        sb $t0, primeiraLinha($t3)
        addi $t1, $zero, 0 # $t1 = $t1 + 1
        add $t5, $zero, $t0
        
        do:
            #OBS: $t3 e o indice atual
            addi $t3, $t3, 1 # $t3 = $t3 + 1

            # $t5 recebeu o valor de $t0
            addi $t5, $t5, 3 
            add $s1, $zero, $t5
            #addi $s1, $t5, 48
            if70: ble $t5, 9, endIf70
            	addi $t5, $t5, -9
            endIf70:
            
            sb $t5, primeiraLinha($t3)   
            
            #OBS: $t2 é o índice posterior a $t3 
            addi $t2, $t2, 1 # $t2 = 4 

            rem $t6, $t2, 3 # 
            seq $t4, $t6, 0 # Se $t6 == 0, $t4 = 1, senao, $t4 = 0
            sne $t7, $t2, 9 # Se $t2 != 9, $t7 = 1, senao, $t7 = 0	
            
            and	$t6, $t4, $t7 # $t4 E $t7 = 1, $t6 = 1, senão, $t6 = 0 
            
            if0: beq $t6, $zero, endIf0
                addi $t3, $t3, 1
                addi $t2, $t2, 1

                addi $t0, $t0, 1
                add $t5, $zero, $t0 
                
                if71: ble $t5, 9, endIf71
            		addi $t5, $t5, -9
            	endIf71:
                
                sb $t0, primeiraLinha($t3)


            endIf0: 
            addi $t1, $t1, 1
        while:  blt	$t1, 9, do	# if $t1 < 9 then do
        
        addi $s2, $zero, 0
            #for500: beq $s2, 9, endFor500
			#	addi $v0, $zero, 1
            #    lb $a0, primeiraLinha($s2)
            #    syscall

               # addi $s2, $s2, 1               
               # j for500
            #endFor500: 

          #  addi $v0, $zero, 4
          #  la $a0, novalinha
          #  syscall
        jr $ra
        
    inicializarsudoku:
        addi $s0, $s0, 0 
        addi $t0, $zero, 0  # $t0 = 0, valor de inicialização

        while0:slti	$t1, $t0, 81    # se $t0 < 81, $t1 = 1, senão $t1 = 0 
            beq $t1, $zero, fimWhile    # se $t1 IGUAL 0, pula para fimWhile
            sb $zero, sudoku($s0)
            addi $t0, $t0, 1    # $t0 = $t0 + 1
            addi $s0, $s0, 1    # $s0 = $s0 + 4
            j while0 
        fimWhile: 
        jr $ra      
         
    construtordetabela:
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
        jal preencherVetor
 		lw $ra, 0($sp)
 		addi $sp, $sp, 4
 		                      
        do1:
            addi $sp, $sp, -4
            sw $ra, 0($sp)
            jal rand
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            # $t0 é igual a variável L
            add $t0, $zero, $v0
            
            addi $sp, $sp, -4
            sw $ra, 0($sp)
            jal rand
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            
            # $t1 é igual a variável C
            add $t1, $zero, $v0
            
            # (L * 9) + (C * 1)
            mul $t3, $t0, 9  
            add $t4, $t3, $t1
            #00
            lb $t6, sudoku($t4)
            #if(sudoku[L][C] == 0)
            if2: bne $t6, 0, endIf2
                #sudoku[L][C] = primeiraLinha[C];
                
                lb $t5, primeiraLinha($t1) 
                #add $t6, $zero, $t5
                if3: beq $t0, 0, endIf3
                    #sudoku[L][C] += L;
                    #sudoku[L][C] = sudoku[L][C] + L;
                    add $t5, $t5, $t0
                endIf3: 

                if80: ble $t5, 9, endIf80
                    addi $t5, $t5, -9
                endIf80:

                sb $t5, sudoku($t4)
                
                addi $t2, $t2, 1 # $t2 = $t2 + 1

            endIf2:
                
        while1: blt	$t2, 60, do1 #enquanto $t2<50 fica rodando o do1
        addi $t5, $zero, 0
            for333: beq $t5, 81, endFor333
				addi $v0, $zero, 1
                lb $a0, sudoku($t5)
                syscall

		        addi $v0, $zero, 4
                la $a0, espaco
                syscall

                addi $t5, $t5, 1
                rem $t6, $t5, 9 
                if222: bne  $t6, 0, endIf222
                    addi $v0, $zero, 4
                    la $a0, novalinha
                    syscall
                    
                endIf222:

            j for333
            
        endFor333:
        jr $ra
