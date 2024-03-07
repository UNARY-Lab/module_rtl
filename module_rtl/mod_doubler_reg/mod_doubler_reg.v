`ifndef mod_doubler_reg
`define mod_doubler_reg

`include "mod_doubler.v"
`include "register.v"

module mod_doubler_reg #(
    parameter BITWIDTH = 32
)(
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [BITWIDTH-1 : 0] iData,
    input wire [BITWIDTH-1 : 0] iMod,
    output wire [BITWIDTH-1 : 0] oData
);

    wire [BITWIDTH-1 : 0] tmp_data;

    mod_doubler #(
        .BITWIDTH(BITWIDTH)
    ) u_mod_doubler (
        .iData(iData),
        .iMod(iMod),
        .oData(tmp_data)
    );

    register #(
        .BITWIDTH(BITWIDTH)
    ) u_register (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData(tmp_data),
        .oData(oData)
    );

endmodule

`endif
