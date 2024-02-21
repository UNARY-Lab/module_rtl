`ifndef lsz
`define lsz

`include "sobolrng.def"

module lsz (
    input wire [`BITWIDTH-1:0] iGray, // input gray number
    output wire [`BITWIDTH-1:0] oOneHot, // output one-hot encoding
    output reg [`LOGBITWIDTH-1:0] lszIdx // index of least siginificant 0
);

    // priority based
    wire [`BITWIDTH-1:0] tc;

    genvar i;

    // temporal/thermometer coding
    assign tc[0] = ~iGray[0];
    generate
        for (i = 1; i < `BITWIDTH; i++) begin
            assign tc[i] = tc[i-1] | ~iGray[i];
        end
    endgenerate

    // one hot coding
    assign oOneHot[0] = tc[0];
    generate
        for (i = 1; i < `BITWIDTH; i++) begin
            assign oOneHot[i] = tc[i-1] ^ tc[i];
        end
    endgenerate

    always@(*) begin
        case(oOneHot)
            'd1 : lszIdx = 'd0;
            'd2 : lszIdx = 'd1;
            'd4 : lszIdx = 'd2;
            'd8 : lszIdx = 'd3;
            'd16 : lszIdx = 'd4;
            'd32 : lszIdx = 'd5;
            'd64 : lszIdx = 'd6;
            'd128 : lszIdx = 'd7;
            'd256 : lszIdx = 'd8;
            'd512 : lszIdx = 'd9;
            default : lszIdx = 'd0;
        endcase
    end

endmodule

`endif
