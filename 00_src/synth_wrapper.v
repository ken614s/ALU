module synth_wrapper (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [3:0]  a,
    input  wire [3:0]  b,
    input  wire [2:0]  op,
    output wire [3:0]  result,
    output wire        carry
  );////////////////
  // Dây nối cho kết quả và carry từ các module con
  wire [3:0] add_wire, sub_wire, and_wire, or_wire, xor_wire, not_wire, left_wire, right_wire;
  wire add_carry, sub_carry;

  // Instance các module con
  adder_4bit adder_4bit (
          .a(a),
          .b(b),
          .carry_in(1'b0),       // Carry đầu vào = 0 cho phép cộng
          .sum(add_wire),
          .carry_out(add_carry)
        );

  subtract subtract_4bit (
             .a(a),
             .b(b),
             .carry_in(1'b1),       // Carry đầu vào = 1 cho phép trừ
             .sum(sub_wire),
             .carry_out(sub_carry)
           );

  and_logic and_logic (
             .a(a),
             .b(b),
             .out(and_wire)
           );

  or_logic  or_logic (
            .a(a),
            .b(b),
            .out(or_wire)
          );

  xor_logic xor_logic (
             .a(a),
             .b(b),
             .out(xor_wire)
           );

  not_logic not_logic (
             .a(a),
             .out(not_wire)
           );

  shift_left left_logic (
        .a(a),
        .b(b[3:0]),
        .out(left_wire)
      );

  shift_right right_logic (
        .a(a),
        .b(b[3:0]),
        .out(right_wire)
      );

  // Thanh ghi lưu kết quả và carry
  reg [3:0] result_reg;
  reg carry_reg;

  always @(posedge clk or negedge rst_n)
  begin
    if (!rst_n)
    begin
      result_reg <= 4'b0000;
      carry_reg <= 1'b0;
    end
    else
    begin
      case (op)
        3'b000:
        begin // Cộng
          result_reg <= add_wire;
          carry_reg <= add_carry;
        end
        3'b001:
        begin // Trừ
          result_reg <= sub_wire;
          carry_reg <= sub_carry;
        end
        3'b010:
        begin // AND
          result_reg <= and_wire;
          carry_reg <= 1'b0;
        end
        3'b011:
        begin // OR
          result_reg <= or_wire;
          carry_reg <= 1'b0;
        end
        3'b100:
        begin // XOR
          result_reg <= xor_wire;
          carry_reg <= 1'b0;
        end
        3'b101:
        begin // NOT
          result_reg <= not_wire;
          carry_reg <= 1'b0;
        end
        3'b110:
        begin // Dịch trái
          result_reg <= left_wire;
          carry_reg <= 1'b0;
        end
        3'b111:
        begin // Dịch phải
          result_reg <= right_wire;
          carry_reg <= 1'b0;
        end
        default:
        begin
          result_reg <= 4'b0000;
          carry_reg <= 1'b0;
        end
      endcase
    end
  end

  // Gán đầu ra
  assign result = result_reg;
  assign carry = carry_reg;
endmodule
