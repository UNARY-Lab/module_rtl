`ifndef outerprodrc
`define outerprodrc

`include "outerprodrc.def"
`include "sobolrng.v"

// this code implements ugemm as vector-vector outer product with binary output
module outerprodrc #(
) (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [`ROWNUM * `BITWIDTH - 1 : 0] iData0, // input vector from row
    input wire [`COLNUM * `BITWIDTH - 1 : 0] iData1, // input vector from col
    output reg [`ROWNUM * `COLNUM * `OUTBITWIDTH - 1 : 0] oData
);

    // this code assumes all data have a sign-magnitude format, where the MSB is the sign bit.
    wire [`ROWNUM*`BITWIDTH-1:0] ctlSeq;
    wire [`ROWNUM-1:0] bitStream0; // this is also the control signal in uGEMM
    wire [`ROWNUM*`BITWIDTH-1:0] sobolSeq;
    wire [`ROWNUM*`COLNUM-1:0] bitStream1; // this is also the control signal in uGEMM
    wire [`ROWNUM*`COLNUM-1:0] signBit;
    wire [`ROWNUM*`COLNUM-1:0] prodBit;

    genvar i, j;
    generate
        for (i = 0; i < `ROWNUM; i = i + 1) begin
            sobolrng u_sobolrng_ctl(
                .iClk(iClk),
                .iRstN(iRstN),
                .iEn(iEn),
                .sobolSeq(ctlSeq[(i+1)*`BITWIDTH-1:i*`BITWIDTH])
                );
            
            // generate bitstream with LSBs of data, and MSBs of RNG
            assign bitStream0[i] = iData0[(i+1)*`BITWIDTH-2:i*`BITWIDTH] >= ctlSeq[(i+1)*`BITWIDTH-1:i*`BITWIDTH+1];

            // one control sequence will control one entire row, thus needing only one rng per row
            sobolrng u_sobolrng(
                .iClk(iClk),
                .iRstN(iRstN),
                .iEn(bitStream0[i]),
                .sobolSeq(sobolSeq[(i+1)*`BITWIDTH-1:i*`BITWIDTH])
                );
            
            for (j = 0; j < `COLNUM; j = j + 1) begin
                assign bitStream1[i*`COLNUM+j] = iData1[(j+1)*`BITWIDTH-2:j*`BITWIDTH] >= sobolSeq[(i+1)*`BITWIDTH-1:i*`BITWIDTH+1];
                assign signBit[i*`COLNUM+j] = iData0[(i+1)*`BITWIDTH-1] ^ iData1[(j+1)*`BITWIDTH-1];
                assign prodBit[i*`COLNUM+j] = bitStream0[i] & bitStream1[i*`COLNUM+j];

                always@(posedge iClk or negedge iRstN) begin
                    if (~iRstN) begin
                        oData[(i*`COLNUM+j+1)*`OUTBITWIDTH-1:(i*`COLNUM+j)*`OUTBITWIDTH] <= 0;
                    end else begin
                        if (iClr) begin
                            oData[(i*`COLNUM+j+1)*`OUTBITWIDTH-1:(i*`COLNUM+j)*`OUTBITWIDTH] <= 0;
                        end else begin
                            if (iEn) begin
                                // generate bitstream with LSBs of data, and MSBs of RNG
                                // if sign is 0 (positive), add; otherwise, substract
                                oData[(i*`COLNUM+j+1)*`OUTBITWIDTH-2:(i*`COLNUM+j)*`OUTBITWIDTH] <= oData[(i*`COLNUM+j+1)*`OUTBITWIDTH-2:(i*`COLNUM+j)*`OUTBITWIDTH] + prodBit[i*`COLNUM+j];
                                oData[(i*`COLNUM+j+1)*`OUTBITWIDTH-1] <= signBit[i*`COLNUM+j];
                            end else begin
                                oData[(i*`COLNUM+j+1)*`OUTBITWIDTH-1:(i*`COLNUM+j)*`OUTBITWIDTH] <= oData[(i*`COLNUM+j+1)*`OUTBITWIDTH-1:(i*`COLNUM+j)*`OUTBITWIDTH];
                            end
                        end
                    end
                end
            end
        end
    endgenerate

endmodule

`endif
