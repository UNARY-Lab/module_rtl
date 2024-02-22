`ifndef cntwithen
`define cntwithen

`include "sobolrng.def"

module cntwithen (
    input wire iClk,    // Clock
    input wire iRstN,  // Asynchronous reset active low
    input wire iEn,
    input wire iClr,
    output reg [`BITWIDTH-1:0] oCnt
);

    always@(posedge iClk or negedge iRstN) begin
        if(~iRstN) begin
            oCnt <= 0;
        end else begin
            if (iClr) begin
                oCnt <= 0;
            end else begin
                oCnt <= oCnt + iEn;
            end
        end
    end

endmodule

`endif
