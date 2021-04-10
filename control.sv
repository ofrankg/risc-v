import riscv_types::*;
module control
  (
    input riscvi_opcode_t opcode_in,
    input logic [2:0] funct3_in,
    input logic [6:0] funct7_in,
    output riscv_control_t control_out
  );

  always_comb begin
    case (opcode_in)
      op_br     : begin
        control_out.mem_read    = 1'b0;
        control_out.jump        = 1'b0;
        control_out.mem_write   = 1'b0;
        control_out.mem_to_reg  = 1'b0;
        control_out.reg_write   = 1'b0;
        control_out.alu_src     = 1'b0;
        control_out.alu_op      = alu_sub;
        case (funct3_in)
          bneq    : begin
            control_out.branch      = 1'b0;
            control_out.branch_neq  = 1'b1;
          end
          default : begin
            control_out.branch      = 1'b1;
            control_out.branch_neq  = 1'b0;
          end
        endcase
      end
      op_jump    : begin
        control_out.branch      = 1'b0;
        control_out.branch_neq  = 1'b0;
        control_out.jump        = 1'b1;
        control_out.mem_read    = 1'b0;
        control_out.mem_write   = 1'b0;
        control_out.mem_to_reg  = 1'b0;
        control_out.reg_write   = 1'b0;
        control_out.alu_src     = 1'b1;
        control_out.alu_op      = alu_add;
      end
      op_load   : begin
        control_out.branch      = 1'b0;
        control_out.branch_neq  = 1'b0;
        control_out.jump        = 1'b0;
        control_out.mem_read    = 1'b1;
        control_out.mem_write   = 1'b0;
        control_out.mem_to_reg  = 1'b1;
        control_out.reg_write   = 1'b1;
        control_out.alu_src     = 1'b1;
        control_out.alu_op      = alu_add;
      end
      op_store  : begin
        control_out.branch      = 1'b0;
        control_out.branch_neq  = 1'b0;
        control_out.jump        = 1'b0;
        control_out.mem_read    = 1'b0;
        control_out.mem_write   = 1'b1;
        control_out.mem_to_reg  = 1'b0;
        control_out.reg_write   = 1'b0;
        control_out.alu_src     = 1'b1;
        control_out.alu_op      = alu_add;
      end
      op_imm    : begin
        control_out.branch      = 1'b0;
        control_out.branch_neq  = 1'b0;
        control_out.jump        = 1'b0;
        control_out.mem_read    = 1'b0;
        control_out.mem_write   = 1'b0;
        control_out.mem_to_reg  = 1'b0;
        control_out.reg_write   = 1'b1;
        control_out.alu_src     = 1'b1;
        case (funct3_in)
          add     : begin
            case (funct7_in)
              7'b0100000: control_out.alu_op = alu_sub;
              default   : control_out.alu_op = alu_add;
            endcase
          end
          sll     : begin
            control_out.alu_op = alu_sll;
          end
          default : begin
            control_out.alu_op = alu_add;
          end
        endcase
      end
      op_reg    : begin
        control_out.branch      = 1'b0;
        control_out.branch_neq  = 1'b0;
        control_out.jump        = 1'b0;
        control_out.mem_read    = 1'b0;
        control_out.mem_write   = 1'b0;
        control_out.mem_to_reg  = 1'b0;
        control_out.reg_write   = 1'b1;
        control_out.alu_src     = 1'b0;
        case (funct3_in)
          add     : begin
            case (funct7_in)
              7'b0100000: control_out.alu_op = alu_sub;
              default   : control_out.alu_op = alu_add;
            endcase
          end
          sll     : begin
            control_out.alu_op = alu_sll;
          end
          axor    : begin
            control_out.alu_op = alu_xor;
          end
          slt     : begin
            control_out.alu_op = alu_slt;
          end
          sltu     : begin
            control_out.alu_op = alu_sltu;
          end
          sr      : begin
            case (funct7_in)
              7'b0100000: control_out.alu_op = alu_srl;
              default   : control_out.alu_op = alu_sra;
            endcase
          end
          aor     : begin
            control_out.alu_op = alu_or;
          end
          aand    : begin
            control_out.alu_op = alu_and;
          end
          default : begin
            control_out.alu_op = alu_add;
          end
        endcase
      end
      default   : begin
        control_out.branch      = 1'b0;
        control_out.branch_neq  = 1'b0;
        control_out.jump        = 1'b0;
        control_out.mem_read    = 1'b0;
        control_out.mem_write   = 1'b0;
        control_out.mem_to_reg  = 1'b0;
        control_out.reg_write   = 1'b0;
        control_out.alu_src     = 1'b0;
        control_out.alu_op      = alu_add;
      end
    endcase
  end

endmodule // control
