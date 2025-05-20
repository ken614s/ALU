module adder_4bit (
  output wire [3:0] sum,
  output wire       carry_out,
  input  wire [3:0] a,
  input  wire [3:0] b,
  input  wire       carry_in
);
  // internal carry signals
  wire c1, c2, c3;

  // bit 0
  assign sum[0] = a[0] ^ b[0] ^ carry_in;
  assign c1     = (a[0] & b[0]) | ((a[0] ^ b[0]) & carry_in);

  // bit 1
  assign sum[1] = a[1] ^ b[1] ^ c1;
  assign c2     = (a[1] & b[1]) | ((a[1] ^ b[1]) & c1);

  // bit 2
  assign sum[2] = a[2] ^ b[2] ^ c2;
  assign c3     = (a[2] & b[2]) | ((a[2] ^ b[2]) & c2);

  // bit 3
  assign sum[3] = a[3] ^ b[3] ^ c3;
  assign carry_out   = (a[3] & b[3]) | ((a[3] ^ b[3]) & c3);

endmodule


