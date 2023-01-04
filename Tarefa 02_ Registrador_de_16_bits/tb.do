#-------------------------------------------------------------------
#-- Name        : tb.do
#-- Author      : Enzzo Comassetto dos Santos
#-- Version     : 0.1
#-- Copyright   : Enzzo, Departamento de Eletr�nica, Florian�polis, IFSC
#-- Description : Script Modelsim para verificar o funcionamento do Registrador
#-------------------------------------------------------------------

#Cria biblioteca do projeto
vlib work

#compila projeto: todos os aquivo. Ordem é importante
vcom -93 reg.vhd testbench.vhd

#Simula (work é o diretorio, testbench é o nome da entity)
vsim -voptargs="+acc" -t ns work.testbench

#Mosta forma de onda
view wave

#Adiciona ondas específicas
# -radix: binary, hex, dec
# -label: nome da forma de onda
add wave -label "Clock" -radix binary /clk
add wave -label "Clear" -radix binary /clear
add wave -label "Synchronous enable" -radix binary /w_flag
add wave -label "Entrada" -radix hex /datain
add wave -label "Saida" -radix hex /reg_out

#Simula até um 500ns
run 500ns

wave zoomfull
write wave wave.ps