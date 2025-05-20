module tb_synth_wrapper;
    // Khai báo tín hiệu
    reg        clk;
    reg        rst_n;
    reg [3:0]  a;
    reg [3:0]  b;
    reg [2:0]  op;
    wire [3:0] result;
    wire       carry;

    // Biến để kiểm tra PASS/FAIL
    reg [3:0] check_result;
    reg       check_carry;
    integer   testcase = 0;

    // Instance module synth_wrapper
    synth_wrapper dut (
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .carry(carry)
    );
    initial begin
      $shm_open("waves.shm");
      $shm_probe("ASM");
  end
    // Tạo clock (chu kỳ 10ns)
    initial begin
        clk = 0;
        forever #2 clk = ~clk;
    end

    // Hàm veryfy
    task verify;
        input [3:0] exp_result;
        input       exp_carry;
        input [31:0] test_num;
        input [255:0] discription;
          begin
        if (result === exp_result && carry === exp_carry) begin
            $display("SUCCCESS! Testcase %0d: %0s", test_num, discription);
            $display("  Output match: Result = %b, Carry = %b | Expected result = %b, %b", 
                     result, carry, exp_result, exp_carry);
        end
        else begin
            $display("ERROR! Testcase %0d: %0s", test_num, discription);
            $display("  Mismatch detected:");
            $display("    Result   = %b (Expected result: %b)", result,    exp_result);
            $display("    Carry    = %b (Expected result: %b)", carry,     exp_carry);
            #4;
            $finish;
        end
    end
    endtask

  // các testcase
    initial begin
        // Khởi tạo giá trị ban đầu
        rst_n = 0;
        a = 4'b0101;
        b = 4'b0100;
        op = 3'b001;
        check_result = 4'b0000;
        check_carry = 1'b0;

        // Testcase 1: Kiểm tra reset
        testcase = testcase + 1;
        #4;
        verify(4'b0000, 1'b0, testcase, "Reset (rst_n = 0)");

        // Bỏ reset
        rst_n = 1;
        #4;

        // Testcase 2: Cộng (11 + 4 = 15)
        testcase = testcase + 1;
        op = 3'b000; a = 4'b1011; b = 4'b0100;
        check_result = 4'b1111; check_carry = 1'b0;
        #4;
        verify(check_result, check_carry, testcase, "Add (a = 10, b = 3)");

        // Testcase 3: Cộng với carry (15 + 1 = 16)
        testcase = testcase + 1;
        op = 3'b000; a = 4'b1111; b = 4'b0001;
        check_result = 4'b0000; check_carry = 1'b1;
        #4;
        verify(check_result, check_carry, testcase, "Add with carry (a = 15, b = 1)");

        // Testcase 4: Trừ (5 - 4 = 1)
        testcase = testcase + 1;
        op = 3'b001; a = 4'b0101; b = 4'b0100;
        check_result = 4'b0001; check_carry = 1'b1;
        #4;
        verify(check_result, check_carry, testcase, "Subtract (a = 10, b = 3)");

        // Testcase 5: Trừ với borrow (8 - 14 = -6)
        testcase = testcase + 1;
        op = 3'b001; a = 4'b1000; b = 4'b1110;
        check_result = 4'b1010; check_carry = 1'b0;
        #4;
        verify(check_result, check_carry, testcase, "Subtract with borrow (a = 2, b = 4)");

        // Testcase 6: AND (1101 & 0111 = 0101)
        testcase = testcase + 1;
        op = 3'b010; a = 4'b1101; b = 4'b0111;
        check_result = 4'b0101; check_carry = 1'b0;
        #4;
        verify(check_result, check_carry, testcase, "AND (a = 1010, b = 1100)");

        // Testcase 7: OR (1011 | 0100 = 1111)
        testcase = testcase + 1;
        op = 3'b011; a = 4'b1011; b = 4'b0100;
        check_result = 4'b1111; check_carry = 1'b0;
        #4;
        verify(check_result, check_carry, testcase, "OR (a = 1010, b = 1100)");

        // Testcase 8: XOR (0101 ^ 1000 = 1101)
        testcase = testcase + 1;
        op = 3'b100; a = 4'b0101; b = 4'b1000;
        check_result = 4'b1101; check_carry = 1'b0;
        #4;
        verify(check_result, check_carry, testcase, "XOR (a = 1010, b = 1100)");

        // Testcase 9: NOT (~1110 = 0001)
        testcase = testcase + 1;
        op = 3'b101; a = 4'b1110; b = 4'b0000;
        check_result = 4'b0001; check_carry = 1'b0;
        #4;
        verify(check_result, check_carry, testcase, "NOT (a = 1010)");

        // Testcase 10: Dịch trái (1101 << 3 = 1000)
        testcase = testcase + 1;
        op = 3'b110; a = 4'b1101; b = 4'b0011;
        check_result = 4'b1000; check_carry = 1'b0;
        #4;
        verify(check_result, check_carry, testcase, "Logical Shift Left (a = 1100, b = 1)");

        // Testcase 11: Dịch trái (0101 << 4 = 0000)
        testcase = testcase + 1;
        op = 3'b110; a = 4'b0101; b = 4'b0100;
        check_result = 4'b0000; check_carry = 1'b0;
        #4;
        verify(check_result, check_carry, testcase, "Logical Shift Left (a = 1100, b = 2)");

        // Testcase 12: Dịch phải (1011 >> 2 = 0010)
        testcase = testcase + 1;
        op = 3'b111; a = 4'b1011; b = 4'b0010;
        check_result = 4'b0010; check_carry = 1'b0;
        #4;
        verify(check_result, check_carry, testcase, "Logical Shift Right (a = 1100, b = 1)");

        // Testcase 13: Dịch phải (1111 >> 4 = 0000)
        testcase = testcase + 1;
        op = 3'b111; a = 4'b1111; b = 4'b0100;
        check_result = 4'b0000; check_carry = 1'b0;
        #4;
        verify(check_result, check_carry, testcase, "Logical Shift Right (a = 1100, b = 2)");

        // Testcase 14: Giá trị biên (0 - 0 = 0)
        testcase = testcase + 1;
        op = 3'b001; a = 4'b0000; b = 4'b0000;
        check_result = 4'b0000; check_carry = 1'b1;
        #4;
        verify(check_result, check_carry, testcase, "Subtract (a = 0, b = 0)");

        // Kết thúc mô phỏng
        #4;
        $display("Simulation completed. Total testcases: %0d", testcase);
        $finish;
    end

    
endmodule