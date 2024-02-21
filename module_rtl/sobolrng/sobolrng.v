`ifndef sobolrng
`define sobolrng

`include "sobolrng.def"
`include "sobolrng_core.v"
`include "lsz.v"
`include "cntwithen.v"

// this code implements m_i = in paper Algorithm 659: Implementing Sobol's quasirandom sequence generator
// https://dl.acm.org/doi/10.1145/42288.214372
module sobolrng (
    input wire iClk,    // Clock
    input wire iRstN,  // Asynchronous reset active low
    input wire iEn,
    output reg [`BITWIDTH-1:0]sobolSeq
);

    wire [`BITWIDTH-1:0] cntNum;
    wire [`BITWIDTH-1:0] oneHot;
    wire [`BITWIDTH*`BITWIDTH-1:0] dirVec;

    // this value is shared among different sobol rngs to generate position of lsz
    cntwithen u_cntwithen(
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .oCnt(cntNum)
        );

    lsz u_lsz(
        .iGray(cntNum),
        .oOneHot(oneHot),
        .lszIdx()
        );

    /* initialization of directional vectors for current dimension*/
    `ifdef BITWIDTH3
        assign dirVec[1*`BITWIDTH-1 : 0*`BITWIDTH] = 'd4;
        assign dirVec[2*`BITWIDTH-1 : 1*`BITWIDTH] = 'd2;
        assign dirVec[3*`BITWIDTH-1 : 2*`BITWIDTH] = 'd1;
    `endif

    `ifdef BITWIDTH4
        assign dirVec[1*`BITWIDTH-1 : 0*`BITWIDTH] = 'd8;
        assign dirVec[2*`BITWIDTH-1 : 1*`BITWIDTH] = 'd4;
        assign dirVec[3*`BITWIDTH-1 : 2*`BITWIDTH] = 'd2;
        assign dirVec[4*`BITWIDTH-1 : 3*`BITWIDTH] = 'd1;
    `endif

    `ifdef BITWIDTH5
        assign dirVec[1*`BITWIDTH-1 : 0*`BITWIDTH] = 'd16;
        assign dirVec[2*`BITWIDTH-1 : 1*`BITWIDTH] = 'd8;
        assign dirVec[3*`BITWIDTH-1 : 2*`BITWIDTH] = 'd4;
        assign dirVec[4*`BITWIDTH-1 : 3*`BITWIDTH] = 'd2;
        assign dirVec[5*`BITWIDTH-1 : 4*`BITWIDTH] = 'd1;
    `endif

    `ifdef BITWIDTH6
        assign dirVec[1*`BITWIDTH-1 : 0*`BITWIDTH] = 'd32;
        assign dirVec[2*`BITWIDTH-1 : 1*`BITWIDTH] = 'd16;
        assign dirVec[3*`BITWIDTH-1 : 2*`BITWIDTH] = 'd8;
        assign dirVec[4*`BITWIDTH-1 : 3*`BITWIDTH] = 'd4;
        assign dirVec[5*`BITWIDTH-1 : 4*`BITWIDTH] = 'd2;
        assign dirVec[6*`BITWIDTH-1 : 5*`BITWIDTH] = 'd1;
    `endif

    `ifdef BITWIDTH7
        assign dirVec[1*`BITWIDTH-1 : 0*`BITWIDTH] = 'd64;
        assign dirVec[2*`BITWIDTH-1 : 1*`BITWIDTH] = 'd32;
        assign dirVec[3*`BITWIDTH-1 : 2*`BITWIDTH] = 'd16;
        assign dirVec[4*`BITWIDTH-1 : 3*`BITWIDTH] = 'd8;
        assign dirVec[5*`BITWIDTH-1 : 4*`BITWIDTH] = 'd4;
        assign dirVec[6*`BITWIDTH-1 : 5*`BITWIDTH] = 'd2;
        assign dirVec[7*`BITWIDTH-1 : 6*`BITWIDTH] = 'd1;
    `endif

    `ifdef BITWIDTH8
        assign dirVec[1*`BITWIDTH-1 : 0*`BITWIDTH] = 'd128;
        assign dirVec[2*`BITWIDTH-1 : 1*`BITWIDTH] = 'd64;
        assign dirVec[3*`BITWIDTH-1 : 2*`BITWIDTH] = 'd32;
        assign dirVec[4*`BITWIDTH-1 : 3*`BITWIDTH] = 'd16;
        assign dirVec[5*`BITWIDTH-1 : 4*`BITWIDTH] = 'd8;
        assign dirVec[6*`BITWIDTH-1 : 5*`BITWIDTH] = 'd4;
        assign dirVec[7*`BITWIDTH-1 : 6*`BITWIDTH] = 'd2;
        assign dirVec[8*`BITWIDTH-1 : 7*`BITWIDTH] = 'd1;
    `endif

    `ifdef BITWIDTH9
        assign dirVec[1*`BITWIDTH-1 : 0*`BITWIDTH] = 'd256;
        assign dirVec[2*`BITWIDTH-1 : 1*`BITWIDTH] = 'd128;
        assign dirVec[3*`BITWIDTH-1 : 2*`BITWIDTH] = 'd64;
        assign dirVec[4*`BITWIDTH-1 : 3*`BITWIDTH] = 'd32;
        assign dirVec[5*`BITWIDTH-1 : 4*`BITWIDTH] = 'd16;
        assign dirVec[6*`BITWIDTH-1 : 5*`BITWIDTH] = 'd8;
        assign dirVec[7*`BITWIDTH-1 : 6*`BITWIDTH] = 'd4;
        assign dirVec[8*`BITWIDTH-1 : 7*`BITWIDTH] = 'd2;
        assign dirVec[9*`BITWIDTH-1 : 8*`BITWIDTH] = 'd1;
    `endif

    `ifdef BITWIDTH10
        assign dirVec[1*`BITWIDTH-1 : 0*`BITWIDTH] = 'd512;
        assign dirVec[2*`BITWIDTH-1 : 1*`BITWIDTH] = 'd256;
        assign dirVec[3*`BITWIDTH-1 : 2*`BITWIDTH] = 'd128;
        assign dirVec[4*`BITWIDTH-1 : 3*`BITWIDTH] = 'd64;
        assign dirVec[5*`BITWIDTH-1 : 4*`BITWIDTH] = 'd32;
        assign dirVec[6*`BITWIDTH-1 : 5*`BITWIDTH] = 'd16;
        assign dirVec[7*`BITWIDTH-1 : 6*`BITWIDTH] = 'd8;
        assign dirVec[8*`BITWIDTH-1 : 7*`BITWIDTH] = 'd4;
        assign dirVec[9*`BITWIDTH-1 : 8*`BITWIDTH] = 'd2;
        assign dirVec[10*`BITWIDTH-1 : 9*`BITWIDTH] = 'd1;
    `endif

    sobolrng_core u_sobolrng_core(
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(iEn),
        .iOneHot(oneHot),
        .dirVec(dirVec),
        .oRand(sobolSeq)
        );

endmodule

`endif
