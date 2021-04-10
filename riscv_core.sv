//`include "riscv_types.sv"
import riscv_types::*;
module riscv_core
 #(
     parameter WIDTH=32,
     parameter INDEX=5
  )
  (
    input logic  				master_clk,
    input logic  				master_nrst,
	 output logic [WIDTH-1:0]	instruction,
    output logic [WIDTH-1:0]	pc_current
  );

     riscv_control_t ctrl_vector;
     logic [WIDTH-1:0]	signimm;
     logic [WIDTH-1:0]	alu_res;
     logic [WIDTH-1:0]	data_mem;
     logic [WIDTH-1:0]	drs1;
     logic [WIDTH-1:0]	drs2;
     logic [WIDTH-1:0]	data_to_write;
     logic [WIDTH-1:0]	pc_next;
     logic [WIDTH-1:0]	pc_plus4;

     logic [WIDTH-1:0]	ifid_pc;
     logic [WIDTH-1:0]	ifid_instr;

     logic [INDEX-1:0]  rs1;
     logic [INDEX-1:0]  rs2;
     logic [INDEX-1:0]  rd;

     logic [WIDTH-1:0]  idex_pc;
     logic [INDEX-1:0]  idex_rs1;
     logic [INDEX-1:0]  idex_rs2;
	   logic [WIDTH-1:0]  idex_drs1;
     logic [WIDTH-1:0]  idex_drs2;
     logic [WIDTH-1:0]  idex_signimm;
     riscv_control_t    idex_ctrl_vector;
     logic [INDEX-1:0]  idex_rd;

     logic [WIDTH-1:0]  pc_branch;
     logic [WIDTH-1:0]  ex_drs2;
     logic              zero;

     logic              exmem_pc_src;
     logic              exmem_zero;
     logic [WIDTH-1:0]  exmem_pc;
     logic [WIDTH-1:0]  exmem_pc_branch;
     logic [WIDTH-1:0]  exmem_alu_res;
     logic [INDEX-1:0]  exmem_rd;
     logic [WIDTH-1:0]  exmem_drs2;

     riscv_control_t    exmem_ctrl_vector;

     logic              memwb_mem_to_reg;
     logic              memwb_reg_write;
     logic [INDEX-1:0]  memwb_rd;
     logic [WIDTH-1:0]  memwb_data_mem;
     logic [WIDTH-1:0]  memwb_alu_res;

     logic [1:0]        rs1_src;
     logic [1:0]        rs2_src;

     logic              stall;
     logic              flush;
     logic              exmem_prediction;
     logic              prediction;
     logic [WIDTH-1:0]  pc_restore;
     logic [WIDTH-1:0]  fetch_pc_prediction;
     logic [1:0]        exmem_confidence;


     BPU #(.PC(32),.TAG(22)) BPU
     (
       .clk_in                (master_clk),
       .nrst_in               (master_nrst),
       .exmem_jmp_br_in       (exmem_ctrl_vector.branch|exmem_ctrl_vector.branch_neq|exmem_ctrl_vector.jump),
       .exmem_pc_src_in       (exmem_pc_src),
       .fetch_pc_in           (pc_current),
       .exmem_pc_in           (exmem_pc),
       .exmem_pc_branch_in    (exmem_pc_branch),
       .fetch_prediction_out  (prediction),
       .exmem_confidence_out  (exmem_confidence),
       .pc_prediction_out     (fetch_pc_prediction),
       .pc_restore_out        (pc_restore)
     );


    IF #(.WIDTH(32)) FETCH
    (
      .clk_in             (master_clk),
      .rst_in             (master_nrst),
      .stall_in           (stall),
      .pc_src_in          (),
      .prediction_in      (prediction),
      .flush_in           (flush),
      .pc_prediction_in   (fetch_pc_prediction),
      .pc_branch_in       (pc_restore),
      .pc_current_out     (pc_current)
    );

    imem #(.WIDTH(32),.INDEX(6)) ICACHE
    (
      .clk_in     (master_clk),
      .data_in    (),
      .address_in (pc_current[7:2]),
      .we_in      (),
      .data_out   (instruction)
    );

    IFID #(.WIDTH(32)) IFID
    (
      .clk_in     (master_clk),
      .rst_in     (master_nrst),
      .stall_in   (stall),
      .flush_in   (flush),
      .pc_in      (pc_current),
      .instr_in   (instruction),
      .pc_out     (ifid_pc),
      .instr_out  (ifid_instr)
    );

    ID #(.WIDTH(32),.INDEX(5)) DECODE
    (
      .clk_in           (master_clk),
      .stall_in         (stall),
      .we_in            (memwb_reg_write),
      .rd_in            (memwb_rd),
      .instr_in         (ifid_instr),
      .data_in          (data_to_write),
      .rs1_out          (rs1),
      .rs2_out          (rs2),
      .rd_out           (rd),
      .drs1_out         (drs1),
      .drs2_out         (drs2),
      .signimm_out      (signimm),
      .ctrl_vector_out  (ctrl_vector)
    );

    IDEX #(.WIDTH(32),.INDEX(5)) IDEX
    (
      .clk_in           (master_clk),
      .rst_in           (master_nrst),
      .flush_in         (flush),
      .pc_in            (ifid_pc),
      .rs1_in           (rs1),
      .rs2_in           (rs2),
      .rd_in            (rd),
      .drs1_in          (drs1),
      .drs2_in          (drs2),
      .signimm_in       (signimm),
      .ctrl_vector_in   (ctrl_vector),
      .pc_out           (idex_pc),
      .rs1_out          (idex_rs1),
      .rs2_out          (idex_rs2),
      .rd_out           (idex_rd),
      .drs1_out         (idex_drs1),
      .drs2_out         (idex_drs2),
      .signimm_out      (idex_signimm),
      .ctrl_vector_out  (idex_ctrl_vector)
    );


    EX #(.WIDTH(32),.INDEX(5)) EXECUTION
    (
      .rs1_src_in           (rs1_src),
      .rs2_src_in           (rs2_src),
      .pc_in                (idex_pc),
      .rs1_in               (idex_drs1),
      .rs2_in               (idex_drs2),
      .signimm_in           (idex_signimm),
      .wb_data_to_write_in  (data_to_write),
      .exmem_alu_res_in     (exmem_alu_res),
      .ctrl_vector_in       (idex_ctrl_vector),
      .zero_out             (zero),
      .pc_branch_out        (pc_branch),
      .drs2_fw_out          (ex_drs2),
      .alu_res_out          (alu_res)
    );

    EXMEM #(.WIDTH(32),.INDEX(5)) EXMEM
    (
      .clk_in          (master_clk),
      .rst_in          (master_nrst),
      .flush_in        (flush),
      .pc_in           (idex_pc),
      .pc_branch_in    (pc_branch),
      .alu_res_in      (alu_res),
      .zero_in         (zero),
      .rd_in           (idex_rd),
      .drs2_in         (ex_drs2),
      .ctrl_vector_in  (idex_ctrl_vector),
      .pc_out          (exmem_pc),
      .pc_branch_out   (exmem_pc_branch),
      .alu_res_out     (exmem_alu_res),
      .zero_out        (exmem_zero),
      .rd_out          (exmem_rd),
      .drs2_out        (exmem_drs2),
      .ctrl_vector_out (exmem_ctrl_vector)
    );

    MEM #(.WIDTH(32),.INDEX(6)) MEMORY
    (
      .clk_in         (master_clk),
      .we_in          (exmem_ctrl_vector.mem_write),
      .re_in          (exmem_ctrl_vector.mem_read),
      .zero_in        (exmem_zero),
      .ctrl_vector_in (exmem_ctrl_vector),
      .address_in     (exmem_alu_res),
      .data_in        (exmem_drs2),
      .pc_src_out     (exmem_pc_src),
      .data_out       (data_mem)
    );

    MEMWB #(.WIDTH(32),.INDEX(5)) MEMWB
      (
        .clk_in           (master_clk),
        .rst_in           (master_nrst),
        .flush_in         (),
        .mem_to_reg_in    (exmem_ctrl_vector.mem_to_reg),
        .reg_write_in     (exmem_ctrl_vector.reg_write),
        .rd_in            (exmem_rd),
        .data_mem_in      (data_mem),
        .alu_res_in       (exmem_alu_res),
        .mem_to_reg_out   (memwb_mem_to_reg),
        .reg_write_out    (memwb_reg_write),
        .rd_out           (memwb_rd),
        .data_mem_out     (memwb_data_mem),
        .alu_res_out      (memwb_alu_res)
      );


    WB  #(.WIDTH(32)) WRITEBACK
    (
      .data_in        (memwb_data_mem),
      .alu_res_in     (memwb_alu_res),
      .sel_in         (memwb_mem_to_reg),
      .data_out       (data_to_write)
    );

    FW  #(.WIDTH(32),.INDEX(5)) FORWARD_UNIT
    (
      .exmem_reg_write_in (exmem_ctrl_vector.reg_write),
      .memwb_reg_write_in (memwb_reg_write),
      .idex_rs1_in        (idex_rs1),
      .idex_rs2_in        (idex_rs2),
      .exmem_rd_in        (exmem_rd),
      .memwb_rd_in        (memwb_rd),
      .rs1_src_out        (rs1_src),
      .rs2_src_out        (rs2_src)
    );

    HZD #(.WIDTH(32),.INDEX(5)) HAZARD_UNIT
    (
      .idex_mem_read_in (idex_ctrl_vector.mem_read),
      .branch_in        (exmem_pc_src),
      .prediction_in    (exmem_confidence[1]),
      .exmem_branch_in  (exmem_pc_branch),
      .idex_pc_in       (idex_pc),
      .idex_rd_in       (idex_rd),
      .ifid_rs1_in      (rs1),
      .ifid_rs2_in      (rs2),
      .stall_out        (stall),
      .flush_out        (flush)
    );

endmodule
