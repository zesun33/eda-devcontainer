// counter.v — simple binary counter for smoke testing
module counter #(
    parameter WIDTH = 4
) (
    input  wire       clk,
    input  wire       rst_n,
    output reg [WIDTH-1:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 0;
        else
            count <= count + 1;
    end
endmodule
