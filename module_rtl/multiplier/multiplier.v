`ifndef multiplier
`define multiplier

`include "multiplier.def"

module multiplier (
    input wire [`BITWIDTH-1 : 0] iData0,
    input wire [`BITWIDTH-1 : 0] iData1,
    output reg [2*`BITWIDTH-1 : 0] oData
);

    assign oData = iData0 * iData1;
    
endmodule

`endif
