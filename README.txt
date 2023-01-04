Divisor em assembly utilizando arquitetura Cesar:

-Divide 2 números com um resultado inteiro

mov 0, r0 
mov 1, r1
loop:

sub r1, r0
inc r2
inc r0
sob r0, loop

O incremento em 'r0' serve para quando o 'sob' decrementa o resultado, este não ficar errado, pois o que deve ser '0' é o fim das subtrações entre 'r1' e 'r0'.

Instruções implementadas (entre registradores):

2 operandos:      
	--ADD
	--SUB
	--AND
	--OR

1 operando:
	--INC
	--NOT     
	--DEC
	--NEG
	--CLR
	--ROR
	--ROL
	--ASR
	--ASR
	
Acesso a memória RAM (carrega valor da RAM em um registrador, porem não salva o valor de um registrador na RAM, é uma operação de 4 bytes, ocupando duas posiçoes na ROM)
	--MOV
	
Branch (desvio):
	--SOB (decrementa o registrador e se não for zero volta para o laço)
	
*A escrita na RAM só pode ser feita através do ram.vhd
*A escrita das operações é feita no arquivo rom.vhd com os valores obtidos na montagem feita pelo Daedalus
