`ifndef mod_quadrupler
`define mod_quadrupler

`include "mod_doubler.v"

module mod_quadrupler #(
    parameter BITWIDTH = 32
)(
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

    mod_doubler #(
        .BITWIDTH(BITWIDTH)
    ) u_mod_doubler_1 (
        .iData(tmp_data),
        .iMod(iMod),
        .oData(oData)
    );

endmodule

`endif
