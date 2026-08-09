// counter_tb.v — testbench for counter module
`timescale 1ns / 1ps

module counter_tb;
    reg  clk;
    reg  rst_n;
    wire [3:0] count;

    counter #(.WIDTH(4)) uut (
        .clk(clk),
        .rst_n(rst_n),
        .count(count)
    );

    initial begin
        clk = 0;
        rst_n = 0;
        #20 rst_n = 1;
    end

    always #5 clk = ~clk;

    initial begin
        #100;
        if (count == 4'b1000) begin
            $display("PASS: count reached expected value");
        end else begin
            $display("FAIL: count = %b (expected 1000)", count);
        end
        $finish;
    end
endmodule
