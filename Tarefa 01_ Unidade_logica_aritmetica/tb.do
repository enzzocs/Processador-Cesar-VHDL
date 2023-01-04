# ============================================================================
# Name        : tb.do
# Author      : Enzzo Comassetto dos Santos
# Version     : 0.1
# Copyright   : Enzzo, Departamento de Eletrônica, Florianópolis, IFSC
# Description : Script Modelsim para verificar o funcionamento da ULA
# ============================================================================


#Cria biblioteca do projeto
vlib work

#compila projeto: todos os aquivo. Ordem é importante
vcom ULA.vhd testbench.vhd

#Simula (work é o diretorio, testbench é o nome da entity)
vsim -voptargs="+acc" -t ns work.testbench

#Mosta forma de onda
view wave

#Adiciona ondas específicas
# -radix: binary, hex, dec
# -label: nome da forma de onda
add wave -radix dec  /A
add wave -radix dec  /B
add wave -radix dec  /aluop
add wave -radix dec /result_lsb
add wave -radix dec  /C
add wave -radix dec  /V
add wave -radix dec  /N
add wave -radix dec  /Z

#Simulação ate 1000ns
run 400ns

wave zoomfull
write wave wave.ps