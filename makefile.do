transcript on

vlib work

vlog -sv +incdir+./ ./rtl/day_of_year_calc.sv
vlog -sv +incdir+./ ./tb/day_of_year_calc_tb.sv

vsim -t 1ns -voptargs="+acc" day_of_year_calc_tb

