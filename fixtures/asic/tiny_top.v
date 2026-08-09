// tiny_top.v — minimal ASIC synthesizable design for yosys smoke test
module tiny_top (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [7:0] sum
);
    assign sum = a * b;
endmodule
