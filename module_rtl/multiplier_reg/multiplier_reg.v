`ifndef multiplier_reg
`define multiplier_reg

`include "multiplier.v"
`include "register.v"

module multiplier_reg #(
    parameter BITWIDTH = 32
)(
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [BITWIDTH-1 : 0] iData0,
    input wire [BITWIDTH-1 : 0] iData1,
    output wire [2*BITWIDTH-1 : 0] oData
);

    wire [2*BITWIDTH-1 : 0] prod;

    multiplier #(
        .BITWIDTH(BITWIDTH)
    ) u_multiplier (
        .iData0(iData0),
        .iData1(iData1),
        .oData(prod)
    );

    register #(
        .BITWIDTH(2*BITWIDTH)
    ) u_register (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData(prod),
        .oData(oData)
    );
    
endmodule

`endif
