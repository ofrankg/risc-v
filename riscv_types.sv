package riscv_types;

typedef enum bit [6:0] {
    op_br    = 7'b1100011, // branches (SB type)
    op_load  = 7'b0000011, // loads (I type)
    op_store = 7'b0100011, // stores (S type)
    op_imm   = 7'b0010011, // immediate operations (I type)
    op_reg   = 7'b0110011, // register operations (R type)
    op_jump  = 7'b1101111  // jump (SB type)
} riscvi_opcode_t;

typedef enum bit [2:0] {
    beq  = 3'b000,
    bneq  = 3'b001
} branch_funct3_t;

typedef enum bit [2:0] {
    add  = 3'b000,
    sll  = 3'b001,
    slt  = 3'b010,
    sltu = 3'b011,
    axor = 3'b100,
    sr   = 3'b101,
    aor  = 3'b110,
    aand = 3'b111
} arith_funct3_t;

typedef enum bit [3:0] {
    alu_add  = 4'b0000,
    alu_sub  = 4'b0001,
    alu_sll  = 4'b0010,
    alu_slt  = 4'b0011,
    alu_sltu = 4'b0100,
    alu_xor  = 4'b0101,
    alu_srl  = 4'b0110,
    alu_sra  = 4'b0111,
    alu_or   = 4'b1000,
    alu_and  = 4'b1001,
    alu_ndef = 4'b1111
} aluop_t;

typedef struct packed {
  logic       branch;
  logic       branch_neq;
  logic       jump;
  logic       mem_read;
  logic       mem_write;
  logic       mem_to_reg;
  logic       reg_write;
  logic       alu_src;
  aluop_t     alu_op;
} riscv_control_t;

endpackage : riscv_types
