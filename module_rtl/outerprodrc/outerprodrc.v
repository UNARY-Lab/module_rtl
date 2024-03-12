`ifndef outerprodrc
`define outerprodrc

`include "outerprodrc.def"
`include "outerprodrc_vvm_bit.v"

// this code implements ugemm as vector-vector outer product with binary output
module outerprodrc #(
) (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [`HIDDEN * `ROWNUM * `BITWIDTH - 1 : 0] iData0, // input vector from row
    input wire [`HIDDEN * `COLNUM * `BITWIDTH - 1 : 0] iData1, // input vector from col
    output reg [`ROWNUM * `COLNUM * `OUTBITWIDTH - 1 : 0] oData
);
    
    wire [`HIDDEN * `ROWNUM * `COLNUM - 1 : 0] osign;
    wire [`HIDDEN * `ROWNUM * `COLNUM - 1 : 0] obit;

    wire [`HIDDEN * `ROWNUM * `COLNUM * `OUTBITWIDTH - 1 : 0] sum;

    genvar i, j, k;
    generate
        for (i = 0; i < `HIDDEN; i = i + 1) begin
            outerprodrc_vvm_bit u_outerprodrc_vvm_bit(
                .iClk(iClk),
                .iRstN(iRstN),
                .iEn(iEn),
                .iClr(iClr),
                .iData0(iData0[(i + 1) * `ROWNUM * `BITWIDTH - 1 : i * `ROWNUM * `BITWIDTH]), // input vector from row
                .iData1(iData1[(i + 1) * `COLNUM * `BITWIDTH - 1 : i * `COLNUM * `BITWIDTH]), // input vector from col
                .oSign(osign[(i + 1) * `ROWNUM * `COLNUM - 1 : i * `ROWNUM * `COLNUM]),
                .oBit(obit[(i + 1) * `ROWNUM * `COLNUM - 1 : i * `ROWNUM * `COLNUM])
                );
        end
        for (i = 0; i < `ROWNUM; i = i + 1) begin
            for (j = 0; j < `COLNUM; j = j + 1) begin
                assign sum[i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH + `OUTBITWIDTH - 1 : i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH]
                        = osign[i * `COLNUM + j] ? ({(`OUTBITWIDTH){1'b0}} - obit[i * `COLNUM + j]) : ({(`OUTBITWIDTH){1'b0}} + obit[i * `COLNUM + j]);
                for (k = 1; k < `HIDDEN; k = k + 1) begin
                    assign sum[k * `ROWNUM * `COLNUM * `OUTBITWIDTH + i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH + `OUTBITWIDTH - 1 : k * `ROWNUM * `COLNUM * `OUTBITWIDTH + i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH]
                        = osign[k * `ROWNUM * `COLNUM + i * `COLNUM + j] ? 
                        (sum[(k-1) * `ROWNUM * `COLNUM * `OUTBITWIDTH + i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH + `OUTBITWIDTH - 1 : (k-1) * `ROWNUM * `COLNUM * `OUTBITWIDTH + i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH]
                        - obit[k * `ROWNUM * `COLNUM + i * `COLNUM + j]) : 
                        (sum[(k-1) * `ROWNUM * `COLNUM * `OUTBITWIDTH + i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH + `OUTBITWIDTH - 1 : (k-1) * `ROWNUM * `COLNUM * `OUTBITWIDTH + i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH]
                        + obit[k * `ROWNUM * `COLNUM + i * `COLNUM + j]);
                end
                always @(posedge iClk or negedge iRstN) begin
                    if (~iRstN) begin
                        oData[i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH + `OUTBITWIDTH - 1 : i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH] <= 0;
                    end else begin
                        oData[i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH + `OUTBITWIDTH - 1 : i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH] <= 
                            oData[i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH + `OUTBITWIDTH - 1 : i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH] + 
                            sum[(`HIDDEN - 1) * `ROWNUM * `COLNUM * `OUTBITWIDTH + i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH + `OUTBITWIDTH - 1 : (`HIDDEN - 1) * `ROWNUM * `COLNUM * `OUTBITWIDTH + i * `COLNUM * `OUTBITWIDTH + j * `OUTBITWIDTH];
                    end
                end
            end
        end
    endgenerate

endmodule

`endif
