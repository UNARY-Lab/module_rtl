`ifndef multiplier
`define multiplier

module multiplier #(
    parameter BITWIDTH = 32
)(
    input wire [BITWIDTH-1 : 0] iData0,
    input wire [BITWIDTH-1 : 0] iData1,
    output wire [2*BITWIDTH-1 : 0] oData
);

    assign oData = iData0 * iData1;
    
endmodule

`endif
