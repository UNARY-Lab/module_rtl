`ifndef adder
`define adder

`include "adder.def"

module adder (
    input wire [`BITWIDTH-1 : 0] iData0,
    input wire [`BITWIDTH-1 : 0] iData1,
    output reg [`BITWIDTH : 0] oData
);

    assign oData = iData0 + iData1;
    
endmodule

`endif
