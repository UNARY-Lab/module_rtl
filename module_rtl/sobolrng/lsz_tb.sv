`timescale 1ns/1ns

`include "lsz.v"

module lsz_tb ();

    logic [`BITWIDTH-1:0]iGray;
    logic [`BITWIDTH-1:0]oOneHot;
    logic [`LOGBITWIDTH-1:0]lszIdx;

    lsz u_lsz (
        .iGray(iGray),
        .oOneHot(oOneHot),
        .lszIdx(lszIdx)
        );

    initial begin
        $dumpfile("lsz.vcd"); $dumpvars;
    end

    initial
    begin
        iGray = 0;
        
        #15;
        repeat(500) begin
            #10 iGray = iGray+1;
        end
        $finish;
    end

endmodule
