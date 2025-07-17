`timescale 1ns/1ps
module mult2_tb;
    reg [1:0] A, B;
    wire [3:0] Y;

    mult2 uut (
        .A(A), .B(B), .Y(Y)
    );

    initial begin
        $dumpfile("out/mult2.vcd");
        $dumpvars(0, mult2_tb);

        A = 2'b00; B = 2'b00; #10;
        A = 2'b01; B = 2'b10; #10;
        A = 2'b11; B = 2'b11; #10;

        $finish;
    end
endmodule
