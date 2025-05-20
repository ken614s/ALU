module not_logic(
    input   wire [3:0]  a   ,
    output  wire [3:0]  out
);
    
    assign  out =   ~a      ;

endmodule


