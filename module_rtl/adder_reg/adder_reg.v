`ifndef adder_reg
`define adder_reg

`include "adder.v"
`include "register.v"

module adder_reg #(
    parameter BITWIDTH = 32
)(
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [BITWIDTH-1 : 0] iData0,
    input wire [BITWIDTH-1 : 0] iData1,
    output wire [BITWIDTH : 0] oData
);

    wire [BITWIDTH : 0] sum;

    adder #(
        .BITWIDTH(BITWIDTH)
    ) u_adder (
        .iData0(iData0),
        .iData1(iData1),
        .oData(sum)
    );

    register #(
        .BITWIDTH(BITWIDTH+1)
    ) u_register (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData(sum),
        .oData(oData)
    );
    
endmodule

`endif
