module registerfile
  #(
    parameter WIDTH=32,                   // ancho de la palabra
    parameter INDEX=5                   	// ancho de la direccion
  )
  (
    input logic               clk_in,         // entrada de reloj
    input logic               we_in,          // habilitacion de escritura
    input logic  [INDEX-1:0]  address_w_in,  // direccion de escritura
    input logic  [INDEX-1:0]  address_ra_in,  // direccion a de lectura
    input logic  [INDEX-1:0]  address_rb_in,  // direccion b de lectura
    input logic  [WIDTH-1:0]  data_w_in,      // dato de escritura
    output logic [WIDTH-1:0]  data_a_out,     // dato a de lectura
    output logic [WIDTH-1:0]  data_b_out      // dato b de lectura
  );

  // Definición del banco de registros
  reg     [WIDTH-1:0]  regFile [0:2**INDEX-1];

  initial begin
    $readmemh("regfile.hex",regFile);
  end

  // Escrituras sincronas en la memoria
  always_ff @ ( negedge clk_in )
    begin
      if (we_in) begin
        regFile[address_w_in] = data_w_in;
      end
    end

  // Lecturas asincronas de la memoria para ambos datos
  assign data_a_out = regFile[address_ra_in];
  assign data_b_out = regFile[address_rb_in];

endmodule
