#-------------------------------------------------------------------
#-- Name        : tb.do
#-- Author      : Enzzo Comassetto dos Santos
#-- Version     : 0.1
#-- Copyright   : Enzzo, Departamento de Eletr�nica, Florian�polis, IFSC
#-- Description : Script Modelsim para verificar o funcionamento do contador de programa
#-------------------------------------------------------------------

#Cria biblioteca do projeto
vlib work

#compila projeto: todos os aquivos
vcom -93 contador.vhd testbench.vhd

#Simula (work � o diretorio, testbench � o nome da entity)
vsim -voptargs="+acc" -t ns work.testbench

#Mostra forma de onda
view wave

#Adiciona ondas
# -radix: binary, hex, dec
# -label: nome da forma de onda
add wave -label "Clock" -radix binary /clk
add wave -label "Reset" -radix binary /reset
add wave -label "Load" -radix binary /load
add wave -label "Up" -radix binary /up
add wave -label "Entrada" -radix hex /datain
add wave -label "Saida" -radix hex /data

#Simula at� 500ns
run 500ns

wave zoomfull
write wave wave.ps