`ifndef mod_adder_reg
`define mod_adder_reg

`include "mod_adder.v"
`include "register.v"

module mod_adder_reg #(
    parameter BITWIDTH = 32
)(
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [BITWIDTH-1 : 0] iData0,
    input wire [BITWIDTH-1 : 0] iData1,
    input wire [BITWIDTH-1 : 0] iMod,
    output wire [BITWIDTH-1 : 0] oData
);

    wire [BITWIDTH-1 : 0] oSum;

    mod_adder #(
        .BITWIDTH(BITWIDTH)
    ) u_mod_adder (
        .iData0(iData0),
        .iData1(iData1),
        .iMod(iMod),
        .oData(oSum)
    );

    register #(
        .BITWIDTH(BITWIDTH)
    ) u_register (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData(oSum),
        .oData(oData)
    );

endmodule

`endif
