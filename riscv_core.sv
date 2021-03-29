//`include "riscv_types.sv"
import riscv_types::*;
module riscv_core
 #(
     parameter WIDTH=32
  )
  (
    input logic  				master_clk,
    input logic  				master_nrst,
	 output logic [WIDTH-1:0]	instruction,
    output logic [WIDTH-1:0]	pc_current
  );

     riscv_control_t control_vector;
     logic [WIDTH-1:0]	signimm;
     logic [WIDTH-1:0]	alu_res;
     logic [WIDTH-1:0]	data_mem;
     logic [WIDTH-1:0]	rs1;
     logic [WIDTH-1:0]	rs2;
     logic [WIDTH-1:0]	data_to_write;
     logic [WIDTH-1:0]	pc_next;
     logic [WIDTH-1:0]	pc_plus4;


    IF #(.WIDTH(32)) FETCH
    (
      .clk_in         ( master_clk  ),
      .rst_in         ( master_nrst ),
      .pc_next_in     ( pc_next     ),
      .pc_current_out ( pc_current  ),
      .pc_plus4_out   ( pc_plus4    )
    );

    imem #(.WIDTH(32),.INDEX(6)) ICACHE
    (
      .clk_in     ( master_clk  ),
      .data_in    ( ),
      .address_in ( pc_current[7:2]  ),
      .we_in      ( ),
      .data_out   ( instruction )
    );

    ID #(.WIDTH(32),.INDEX(5)) DECODE
    (
      .clk_in           ( master_clk      ),
      .instr_in         ( instruction     ),
      .data_in          ( data_to_write   ),
      .rs1_alu_out      ( rs1             ),
      .rs2_alu_out      ( rs2             ),
      .signimm_out      ( signimm         ),
      .ctrl_vector_out  ( control_vector  )
    );

    EX #(.WIDTH(32),.INDEX(5)) EXECUTION
    (
      .pc_in          ( pc_current      ),
      .pc_plus4_in    ( pc_plus4        ),
      .rs1_in         ( rs1             ),
      .rs2_in         ( rs2             ),
      .signimm_in     ( signimm         ),
      .ctrl_vector_in ( control_vector  ),
      .pc_next_out    ( pc_next         ),
      .alu_res_out    ( alu_res         )
    );

    MEM #(.WIDTH(32),.INDEX(5)) MEMORY
    (
      .clk_in         ( master_clk                  ),
      .we_in          ( control_vector.mem_write    ),
      .re_in          ( control_vector.mem_read     ),
      .address_in     ( alu_res                     ),
      .data_in        ( rs2                         ),
      .data_out       ( data_mem                    )
    );

    WB  #(.WIDTH(32)) WRITEBACK
    (
      .data_in        ( data_mem                   ),
      .alu_res_in     ( alu_res                    ),
      .sel_in         ( control_vector.mem_to_reg  ),
      .data_out       ( data_to_write              )
    );

endmodule
