
SRCS = rtl/reg_file.sv \
			 rtl/fifo_ctrl.sv \
			 rtl/fifo.sv

all: format

format:
	verible-verilog-format --inplace $(SRCS)
