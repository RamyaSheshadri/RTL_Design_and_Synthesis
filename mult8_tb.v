`timescale 1ns/1ps
module mult8_tb;
    reg [7:0] A, B;
    wire [15:0] Y;

    mult8 uut (
        .A(A), .B(B), .Y(Y)
    );

    initial begin
        $dumpfile("out/mult8.vcd");
        $dumpvars(0, mult8_tb);

        A = 8'h0A; B = 8'h03; #10;  // 10×3 = 30
        A = 8'hFF; B = 8'h01; #10;  // 255×1 = 255

        $finish;
    end
endmodule
