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
vcom -93  fsm_ctrl.vhd ULA.vhd banco.vhd reg_inst.vhd rom.vhd ram.vhd contador.vhd CPU.vhd testbench.vhd 

#Simula (work é o diretorio, testbench é o nome da entity)
vsim -voptargs="+acc" -t ns work.testbench

#Mosta forma de onda
view wave

#Adiciona ondas específicas
# -radix: binary, hex, dec
# -label: nome da forma de onda
add wave -label "Clock" -radix binary /clk
add wave -label "reset" -radix binary /reset
add wave -label "enable" -radix binary /en

add wave -label "PC" -radix hex /dut/data_addr_rom

add wave -label "Q" -radix hex /dut/q
add wave -label "Q2" -radix hex /dut/addr_ram

add wave -label "reg2" -radix hex /dut/reg2
add wave -label "reg" -radix hex /dut/reg
add wave -label "opcode" -radix hex /dut/opcode
add wave -label "opcode2" -radix hex /dut/opcode2



add wave -label "R" -radix hex /dut/banco/reg
add wave -label "Banco_in" -radix hex /dut/banco_in
add wave -label "RAM" -radix hex /dut/ram/ram
add wave -label "addr_ram" -radix hex /dut/addr_ram
add wave -label "q_ram" -radix hex /dut/ram/q
add wave -label "data_banco" -radix hex /dut/data_banco
add wave -label "datain" -radix hex /dut/datain



#Simula até um 500ns
run 10000ns

wave zoomfull
write wave wave.ps