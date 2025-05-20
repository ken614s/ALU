module shift_right (
    input  wire [3:0] a,    // dữ liệu vào 4 bit
    input  wire [3:0] b,    // số bit shift-right (0..15)
    output wire [3:0] out   // kết quả
);
    // 1. Đảo ngược thứ tự bit của a → revA
    wire [3:0] revA;
    assign revA = { a[0], a[1], a[2], a[3] };

    // 2. Gọi module shift_left_4bit_by_b trên revA
    wire [3:0] revOut;
    shift_left right_logic (
        .a   (revA),
        .b   (b),
        .out (revOut)
    );

    // 3. Đảo ngược lại revOut để ra out (chính là shift-right của a)
    assign out = { revOut[0], revOut[1], revOut[2], revOut[3] };
endmodule



