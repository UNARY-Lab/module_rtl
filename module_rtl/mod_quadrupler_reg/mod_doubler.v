`ifndef mod_doubler
`define mod_doubler

module mod_doubler #(
    parameter BITWIDTH = 32
)(
    input wire [BITWIDTH-1 : 0] iData,
    input wire [BITWIDTH-1 : 0] iMod,
    output wire [BITWIDTH-1 : 0] oData
);

    wire [BITWIDTH : 0] oSum;

    assign oSum = {iData, 1'b0};
    assign oData = (oSum < iMod) ? oSum[BITWIDTH-1 : 0] : (oSum - iMod);
    
endmodule

`endif
