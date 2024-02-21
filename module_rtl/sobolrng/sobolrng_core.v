`ifndef sobolrng_core
`define sobolrng_core

`include "sobolrng.def"

module sobolrng_core (
    input wire iClk,    // Clock
    input wire iRstN,  // Asynchronous reset active low
    input wire iEn,
    input wire [`BITWIDTH-1:0] iOneHot, // iOneHot
    input wire [`BITWIDTH*`BITWIDTH-1:0] dirVec,
    output reg [`BITWIDTH-1:0] oRand // output random number
);
    
    wire [`BITWIDTH*`BITWIDTH-1:0] orVec;
    wire [`BITWIDTH-1:0] vec;

    assign orVec[`BITWIDTH-1 : 0] = iOneHot[0] ? dirVec[`BITWIDTH-1 : 0] : 0;
    genvar i;
    generate
        for (i = 1; i<`BITWIDTH; i = i + 1) begin
            assign orVec[(i+1)*`BITWIDTH-1:i*`BITWIDTH] = orVec[i*`BITWIDTH-1:(i-1)*`BITWIDTH] | (iOneHot[i] ? dirVec[(i+1)*`BITWIDTH-1 : i*`BITWIDTH] : 0);
        end
    endgenerate

    assign vec = orVec[`BITWIDTH*`BITWIDTH-1:(`BITWIDTH-1)*`BITWIDTH];

    always@(posedge iClk or negedge iRstN) begin
        if(~iRstN) begin
            oRand <= 0;
        end else begin
            if(iEn) begin
                oRand <= oRand ^ vec;
            end else begin
                oRand <= oRand;
            end
        end
    end

endmodule

`endif
