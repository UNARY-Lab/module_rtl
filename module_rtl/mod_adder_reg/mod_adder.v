`ifndef mod_adder
`define mod_adder

module mod_adder #(
    parameter BITWIDTH = 32
)(
    input wire [BITWIDTH-1 : 0] iData0,
    input wire [BITWIDTH-1 : 0] iData1,
    input wire [BITWIDTH-1 : 0] iQ,
    output reg [BITWIDTH-1 : 0] oData
);

    wire [BITWIDTH : 0] oSum;

    assign oSum = iData0 + iData1;
    assign oData = (oSum < iQ) ? oSum[BITWIDTH-1 : 0] : (oSum - iQ);
    
endmodule

`endif
