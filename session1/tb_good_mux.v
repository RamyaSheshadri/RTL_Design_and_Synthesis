module tb_good_mux;

    reg a, b, sel;
    wire y;

    good_mux dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_good_mux);

        a = 0; b = 0; sel = 0; #10;
        a = 1; b = 0; sel = 0; #10;
        a = 0; b = 1; sel = 1; #10;
        a = 1; b = 1; sel = 1; #10;

        $finish;
    end

endmodule
