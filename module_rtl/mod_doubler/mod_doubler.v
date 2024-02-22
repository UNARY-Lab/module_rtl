`ifndef mod_doubler
`define mod_doubler

`include "mod_doubler.def"

module mod_doubler (
    input wire [`BITWIDTH-1 : 0] iData,
    input wire [`BITWIDTH-1 : 0] iQ,
    output reg [`BITWIDTH-1 : 0] oData
);

    wire [`BITWIDTH : 0] oSum;

    assign oSum = {iData, 1'b0};
    assign oData = (oSum < iQ) ? oSum[`BITWIDTH-1 : 0] : (oSum - iQ);
    
endmodule

`endif
