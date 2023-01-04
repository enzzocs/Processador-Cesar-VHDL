#-------------------------------------------------------------------
#-- Name        : tb.do
#-- Author      : Enzzo Comassetto dos Santos
#-- Version     : 0.1
#-- Copyright   : Enzzo, Departamento de Eletrônica, Florianópolis, IFSC
#-- Description : Script Modelsim para verificar o funcionamento do registrador de intruções
#-------------------------------------------------------------------

#Cria biblioteca do projeto
vlib work

#compila projeto: todos os aquivos
vcom -93 reg_inst.vhd testbench.vhd

#Simula (work é o diretorio, testbench é o nome da entity)
vsim -voptargs="+acc" -t ns work.testbench

#Mostra forma de onda
view wave

#Adiciona ondas específicas
# -radix: binary, hex, dec
# -label: nome da forma de onda
add wave -label "Clock" -radix binary /clk
add wave -label "Reset" -radix binary /reset
add wave -label "Synchronous enable" -radix binary /en
add wave -label "Entrada" -radix hex /datain
add wave -label "Opcode" -radix hex /opcode


#Simula até 500ns
run 500ns

wave zoomfull
write wave wave.ps