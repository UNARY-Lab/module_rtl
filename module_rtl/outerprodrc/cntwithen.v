`ifndef cntwithen
`define cntwithen

`include "sobolrng.def"

module cntwithen (
    input wire iClk,    // Clock
    input wire iRstN,  // Asynchronous reset active low
    input wire iEn,
    output reg [`BITWIDTH-1:0] oCnt
);

    always@(posedge iClk or negedge iRstN) begin
        if(~iRstN) begin
            oCnt <= 0;
        end else begin
            oCnt <= oCnt + iEn;
        end
    end

endmodule

`endif
