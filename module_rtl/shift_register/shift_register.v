`ifndef shift_register
`define shift_register

`include "register.v"

module shift_register #(
    parameter BITWIDTH = 32,
    parameter DEPTH = 8
)(
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [BITWIDTH-1 : 0] iData,
    output wire [BITWIDTH-1 : 0] oData
);

    wire [BITWIDTH-1 : 0] buffer [DEPTH-1 : 0];

    assign oData = buffer[DEPTH-1];

    genvar i;
    generate
        for (i = 1; i < DEPTH; i = i + 1) begin
            register #(
                .BITWIDTH(BITWIDTH)
            ) u_register(
                .iClk(iClk),
                .iRstN(iRstN),
                .iEn(iEn),
                .iClr(iClr),
                .iData(buffer[i-1]),
                .oData(buffer[i])
            );
        end
    endgenerate

    register #(
        .BITWIDTH(BITWIDTH)
    ) u_register(
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData(iData),
        .oData(buffer[0])
    );

endmodule

`endif
