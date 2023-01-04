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
vcom -93 fsm_ctrl.vhd testbench.vhd

#Simula (work é o diretorio, testbench é o nome da entity)
vsim -voptargs="+acc" -t ns work.testbench

#Mostra forma de onda
view wave

#Adiciona ondas específicas
# -radix: binary, hex, dec
# -label: nome da forma de onda
add wave -label "Clock" -radix binary /clk
add wave -label "Standby" -radix binary /stby
add wave -label "test" -radix binary /test
add wave -label "vermelho_1" -radix binary /vermelho_1
add wave -label "amarelo_1" -radix binary /amarelo_1
add wave -label "verde_1" -radix binary /verde_1
add wave -label "vermelho_2" -radix binary /vermelho_2
add wave -label "amarelo_2" -radix binary /amarelo_2
add wave -label "verde_2" -radix binary /verde_2
add wave -label "1s" -radix binary /fsm/pulso_1hz

#Simula até 10000ns
run 10000ms

wave zoomfull
write wave wave.ps