// blinky.v — minimal FPGA blinky for yosys smoke test
module blinky (
    input  wire clk,
    input  wire rst_n,
    output reg led
);
    reg [23:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            led <= 0;
        else
            led <= counter[23];
    end
endmodule
