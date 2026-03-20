IVERILOG ?= iverilog
VVP ?= vvp

RTL := rtl/trigger.v rtl/timestamp_counter.v rtl/fifo.v rtl/crc8.v rtl/daq_frontend.v
TB_TARGETS := tb_trigger tb_timestamp tb_fifo tb_crc8 tb_daq_frontend

.PHONY: test clean waves

test: $(TB_TARGETS)

tb_trigger:
	@mkdir -p sim/build sim/waves
	@$(IVERILOG) -g2012 -o sim/build/$@ $(RTL) tb/$@.v
	@$(VVP) sim/build/$@

tb_timestamp:
	@mkdir -p sim/build sim/waves
	@$(IVERILOG) -g2012 -o sim/build/$@ $(RTL) tb/$@.v
	@$(VVP) sim/build/$@

tb_fifo:
	@mkdir -p sim/build sim/waves
	@$(IVERILOG) -g2012 -o sim/build/$@ $(RTL) tb/$@.v
	@$(VVP) sim/build/$@

tb_crc8:
	@mkdir -p sim/build sim/waves
	@$(IVERILOG) -g2012 -o sim/build/$@ $(RTL) tb/$@.v
	@$(VVP) sim/build/$@

tb_daq_frontend:
	@mkdir -p sim/build sim/waves
	@$(IVERILOG) -g2012 -o sim/build/$@ $(RTL) tb/$@.v
	@$(VVP) sim/build/$@

clean:
	@rm -rf sim/build sim/waves

waves: test
	@printf "Waveforms are in sim/waves\n"
