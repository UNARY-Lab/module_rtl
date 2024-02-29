`ifndef mod_multiplier_barrett_32b
`define mod_multiplier_barrett_32b

`include "multiplier_32b_reg.v"
`include "multiplier_64b_reg.v"

// implement Algorithm 1 in 'Conceptual Review on NTT and Comprehensive Review on Its Implementations'
// another paper: 'Modular Reduction without Pre-Computation for Special Moduli' is using non 2 base
// original paper: 'Implementing the Rivest Shamir and Adleman Public Key Encryption Algorithm on a Standard Digital Signal Processor'

// this module needs 10 cycles to finish, and the iMod requires the value to have 32 bits, iK is fixed to 32
module mod_multiplier_barrett_32b (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    // precomputed input
    // input wire [32-1 : 0] iK, // number of valid bits in iMod, which does not count the zero MSBs in iMod.
    input wire [2*32-1 : 0] iU,
    // actual input
    input wire [32-1 : 0] iData0,
    input wire [32-1 : 0] iData1,
    input wire [32-1 : 0] iMod,
    output reg [32-1 : 0] oData
);

    // only pipeline multiplication
    // z = iData0 * iData1
    wire [2*32-1 : 0] z;
    // m1 = z >> 32
    wire [32-1 : 0] m1;
    // m2 = iU * m1
    // 64 bits + 32 bits, i.e., 96 valid bits
    // use a 64 bit multiplier
    wire [4*32-1 : 0] m2;
    // m3 = m2 >> 32
    // 64 bits
    wire [2*32-1 : 0] m3;
    // m3q = m3 * iMod
    // 64 bits + 32 bits, i.e., 96 valid bits
    // use a 64 bit multiplier
    wire [4*32-1 : 0] m3q;
    wire [2*32-1 : 0] t;
    
    // 1 cycle
    multiplier_32b_reg u_multiplier_32b_reg_z (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0),
        .iData1(iData1),
        .oData(z)
    );

    assign m1 = z[2*32-1 : 32];

    // 4 cycles
    // iU will have more than 32 bits, thus m2 will have more than 32 bit
    multiplier_64b_reg u_multiplier_64b_reg_m2 (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0({32'b0, m1}),
        .iData1(iU),
        .oData(m2)
    );

    // approximately 20-30 MSBs are 0 for m3
    assign m3 = m2[3*32-1 : 32];

    // 4 cycles
    multiplier_64b_reg u_multiplier_64b_reg_m3q (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(m3),
        .iData1({32'b0, iMod}),
        .oData(m3q)
    );

    assign t = z - m3q[2*32-1 : 0];

    // 1 cycle
    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            oData <= 0;
        end else begin
            if (iClr) begin
                oData <= 0;
            end else begin
                if (iEn) begin
                    if (t >= {iMod, 1'b0}) begin
                        oData <= {t, 1'b0} - {iMod, 1'b0};
                    end else if (t >= iMod) begin
                        oData <= t - iMod;
                    end else begin
                        oData <= t;
                    end
                end else begin
                    oData <= oData;
                end
            end
        end
    end
    
endmodule

`endif
