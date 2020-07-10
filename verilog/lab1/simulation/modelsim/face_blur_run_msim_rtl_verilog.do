transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/read_data.v}
vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/output_jpg.v}
vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/face_blur.v}
vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/ram1.v}
vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/ram2.v}
vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/data_ctrl.v}
vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/blur.v}
vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/covAB.v}
vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/calcu_a.v}
vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/calcu_b.v}
vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/result.v}

vlog -vlog01compat -work work +incdir+F:/intelFPGA/signal2/face_blur/verilog/lab1 {F:/intelFPGA/signal2/face_blur/verilog/lab1/face_TB.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  face_TB

add wave *
view structure
view signals
run 0 sec
