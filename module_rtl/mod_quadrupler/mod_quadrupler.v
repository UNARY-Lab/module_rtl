`ifndef mod_quadrupler
`define mod_quadrupler

`include "mod_quadrupler.def"

module mod_quadrupler (
    input wire [`BITWIDTH-1 : 0] iData,
    input wire [`BITWIDTH-1 : 0] iQ,
    output reg [`BITWIDTH-1 : 0] oData
);

    wire [`BITWIDTH+1 : 0] oSum4;
    wire [`BITWIDTH : 0] oSum;

    assign oSum4 = {iData, 2'b00};
    assign oSum = (oSum4 < iQ) ? oSum4[`BITWIDTH : 0] : (oSum4 - iQ);
    assign oData = (oSum < iQ) ? oSum[`BITWIDTH-1 : 0] : (oSum - iQ);
    
endmodule

`endif
