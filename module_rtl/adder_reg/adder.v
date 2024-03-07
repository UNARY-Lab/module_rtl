`ifndef adder
`define adder

module adder #(
    parameter BITWIDTH = 32
)(
    input wire [BITWIDTH-1 : 0] iData0,
    input wire [BITWIDTH-1 : 0] iData1,
    output wire [BITWIDTH : 0] oData
);

    assign oData = iData0 + iData1;
    
endmodule

`endif
