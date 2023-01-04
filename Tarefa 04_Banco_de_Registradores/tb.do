#-------------------------------------------------------------------
#-- Name        : tb.do
#-- Author      : Enzzo Comassetto dos Santos
#-- Version     : 0.1
#-- Copyright   : Enzzo, Departamento de Eletr�nica, Florian�polis, IFSC
#-- Description : Script Modelsim para verificar o funcionamento do Banco de Registradores
#-------------------------------------------------------------------

#Cria biblioteca do projeto
vlib work

#compila projeto: todos os aquivo. Ordem é importante
vcom -93 banco.vhd testbench.vhd

#Simula (work é o diretorio, testbench é o nome da entity)
vsim -voptargs="+acc" -t ns work.testbench

#Mosta forma de onda
view wave

#Adiciona ondas específicas
# -radix: binary, hex, dec
# -label: nome da forma de onda
add wave -label "Clock" -radix binary /clk
add wave -label "reset" -radix binary /reset
add wave -label "w_wr" -radix binary /w_wr
add wave -label "Entrada" -radix hex /w_data
add wave -label "w_addr" -radix binary /w_addr
add wave -label "ra_addr" -radix binary /ra_addr
add wave -label "rb_addr" -radix binary /rb_addr
add wave -label "ra_data" -radix hex /ra_data
add wave -label "rb_data" -radix hex /rb_data
add wave -label "R0" -radix hex /dut/reg(0)
add wave -label "R1" -radix hex /dut/reg(1)
add wave -label "R2" -radix hex /dut/reg(2)
add wave -label "R3" -radix hex /dut/reg(3)
add wave -label "R" -radix hex /dut/reg

#Simula até um 500ns
run 500ns

wave zoomfull
write wave wave.ps