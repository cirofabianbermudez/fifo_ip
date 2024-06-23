
SRCS = rtl/reg_file.sv \
			 rtl/fifo_ctrl.sv \
			 rtl/fifo.sv \
			 tb/test.sv \
			 tb/tb.sv \
			 tb/fifo_if.sv

all: format

format:
	verible-verilog-format --inplace $(SRCS)
