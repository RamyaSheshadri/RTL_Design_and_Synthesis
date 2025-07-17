module mult8 (
    input [7:0] A,
    input [7:0] B,
    output [15:0] Y
);
    assign Y = A * B;  // For now, use built-in *
endmodule
