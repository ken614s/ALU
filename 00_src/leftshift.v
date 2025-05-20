module shift_left (
    input  wire [3:0] a,    // operand A[3:0]
    input  wire [3:0] b,    // shift amount B[3:0]
    output wire [3:0] out   // kết quả
);
    //--- 1 Tạo sel0..sel3 (b == 0,1,2,3) bằng assign gọn:
    //    - sel0 = (b == 4'b0000)  <=>  ~b[3]&~b[2]&~b[1]&~b[0]
    //    - sel1 = (b == 4'b0001)  <=>  ~b[3]&~b[2]&~b[1]&  b[0]
    //    - sel2 = (b == 4'b0010)  <=>  ~b[3]&~b[2]&  b[1]&~b[0]
    //    - sel3 = (b == 4'b0011)  <=>  ~b[3]&~b[2]&  b[1]&  b[0]
    wire sel0 = (~b[3] & ~b[2] & ~b[1] & ~b[0]);
    wire sel1 = (~b[3] & ~b[2] & ~b[1] &  b[0]);
    wire sel2 = (~b[3] & ~b[2] &  b[1] & ~b[0]);
    wire sel3 = (~b[3] & ~b[2] &  b[1] &  b[0]);

    //--- 2 Tính từng bit của out[3:0] bằng assign gọn:
    //    out[3] = sel0&a[3] | sel1&a[2] | sel2&a[1] | sel3&a[0]
    assign out[3] = (sel0 & a[3]) |
                    (sel1 & a[2]) |
                    (sel2 & a[1]) |
                    (sel3 & a[0]);

    //    out[2] = sel0&a[2] | sel1&a[1] | sel2&a[0]
    assign out[2] = (sel0 & a[2]) |
                    (sel1 & a[1]) |
                    (sel2 & a[0]);

    //    out[1] = sel0&a[1] | sel1&a[0]
    assign out[1] = (sel0 & a[1]) |
                    (sel1 & a[0]);

    //    out[0] = sel0&a[0]
    assign out[0] = (sel0 & a[0]);

    // Khi b >= 4 (tức b[3]=1 hoặc b[2]=1), thì sel0..sel3 đều = 0 → out = 0 tự động.
endmodule

