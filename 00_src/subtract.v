module subtract (
    input  wire [3:0] a     ,
    input  wire [3:0] b     ,
    input  wire       carry_in  ,
    output wire [3:0] sum ,
    output wire       carry_out
);
    wire [3:0] b_negative        ;
    assign b_negative = ~b       ;

    adder_4bit u_adder (
        .a(a)               ,
        .b(b_negative)           ,
        .carry_in(carry_in)         ,
        .sum(sum)       ,
        .carry_out(carry_out)
    );
endmodule



