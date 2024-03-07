`ifndef mod_multiplier_barrett_32b_pp
`define mod_multiplier_barrett_32b_pp

`include "multiplier_32b_pp.v"
`include "multiplier_64b_pp.v"

// implement Algorithm 1 in 'Conceptual Review on NTT and Comprehensive Review on Its Implementations'
// another paper: 'Modular Reduction without Pre-Computation for Special Moduli' is using non 2 base
// original paper: 'Implementing the Rivest Shamir and Adleman Public Key Encryption Algorithm on a Standard Digital Signal Processor'

// this module needs 6 cycles to finish
module mod_multiplier_barrett_32b_pp (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    // precomputed input
    input wire [5 : 0] iK, // number of valid bits in iMod, which does not count the zero MSBs in iMod.
    input wire [2*32-1 : 0] iU,
    // actual input
    input wire [32-1 : 0] iData0,
    input wire [32-1 : 0] iData1,
    input wire [32-1 : 0] iMod,
    output reg [32-1 : 0] oData
);

    // only pipeline multiplication
    // bitwidth analysis can be found here: https://www.nayuki.io/page/barrett-reduction-algorithm
    // z = iData0 * iData1
    wire [2*32-1 : 0] z;
    parameter ZDELAY = 4;
    reg [2*32-1 : 0] z_d [ZDELAY-1:0];
    // m1 = z >> iK
    wire [2*32-1 : 0] m1;
    // m2 = iU * m1
    wire [4*32-1 : 0] m2;
    // m3 = m2 >> iK
    wire [2*32-1 : 0] m3;
    // m3q = m3 * iMod
    wire [2*32-1 : 0] m3q;
    wire [2*32-1 : 0] t;

    reg [5 : 0] iK_d [3:0];
    reg [2*32-1 : 0] iU_d;
    
    always @(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            iK_d[0] <= 0;
            iK_d[1] <= 0;
            iK_d[2] <= 0;
            iK_d[3] <= 0;
            iU_d <= 0;
        end else begin
            if (iClr) begin
                iK_d[0] <= 0;
                iK_d[1] <= 0;
                iK_d[2] <= 0;
                iK_d[3] <= 0;
                iU_d <= 0;
            end else begin
                if (iEn) begin
                    iK_d[0] <= iK;
                    iK_d[1] <= iK_d[0];
                    iK_d[2] <= iK_d[1];
                    iK_d[3] <= iK_d[2];
                    iU_d <= iU;
                end else begin
                    iK_d[0] <= iK_d[0];
                    iK_d[1] <= iK_d[1];
                    iK_d[2] <= iK_d[2];
                    iK_d[3] <= iK_d[3];
                    iU_d <= iU_d;
                end
            end
        end
    end
    // 1 cycle
    multiplier_32b_pp u_multiplier_32b_pp_z (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(iData0),
        .iData1(iData1),
        .oData(z)
    );

    assign m1 = z >> iK_d[0];

    // 3 cycles
    // iU will have more than 32 bits, thus m2 will have more than 32 bit
    multiplier_64b_pp u_multiplier_64b_pp_m2 (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(m1),
        .iData1(iU_d),
        .oData(m2)
    );

    assign m3 = m2 >> iK_d[3];

    // 1 cycles
    multiplier_32b_pp u_multiplier_32b_pp_m3q (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iClr(iClr),
        .iData0(m3),
        .iData1(iMod),
        .oData(m3q)
    );

    genvar i;
    generate
        for (i = 1; i < ZDELAY; i = i + 1) begin
            always@(posedge iClk or negedge iRstN) begin
                if (~iRstN) begin
                    z_d[i] <= 0;
                end else begin
                    if (iClr) begin
                        z_d[i] <= 0;
                    end else begin
                        if (iEn) begin
                            z_d[i] <= z_d[i-1];
                        end else begin
                            z_d[i] <= z_d[i];
                        end
                    end
                end
            end
        end
    endgenerate

    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            z_d[0] <= 0;
        end else begin
            if (iClr) begin
                z_d[0] <= 0;
            end else begin
                if (iEn) begin
                    z_d[0] <= z;
                end else begin
                    z_d[0] <= z_d[0];
                end
            end
        end
    end

    assign t = z_d[ZDELAY-1] - m3q;

    // 1 cycle
    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            oData <= 0;
        end else begin
            if (iClr) begin
                oData <= 0;
            end else begin
                if (iEn) begin
                    // if (t >= {iMod, 1'b0}) begin
                        // oData <= {t, 1'b0} - {iMod, 1'b0};
                    // end else 
                    if (t >= iMod) begin
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
