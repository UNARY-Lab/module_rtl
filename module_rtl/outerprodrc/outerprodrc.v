`ifndef outerprodrc
`define outerprodrc

`include "outerprodrc.def"
`include "outerprodrc_vvm.v"

// this code implements ugemm as vector-vector outer product with binary output
module outerprodrc #(
) (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [`HIDDEN * `ROWNUM * `BITWIDTH - 1 : 0] iData0, // input vector from row
    input wire [`HIDDEN * `COLNUM * `BITWIDTH - 1 : 0] iData1, // input vector from col
    output reg [`ROWNUM * `COLNUM * 2*`OUTBITWIDTH - 1 : 0] oData
);
    
    wire [`HIDDEN * `ROWNUM * `COLNUM * `OUTBITWIDTH - 1 : 0] sum;

    genvar i, j, k;
    generate
        for (i = 0; i < `HIDDEN; i = i + 1) begin
            outerprodrc_vvm u_outerprodrc_vvm(
                .iClk(iClk),
                .iRstN(iRstN),
                .iEn(iEn),
                .iClr(iClr),
                .iData0(iData0[(i + 1) * `ROWNUM * `BITWIDTH - 1 : i * `ROWNUM * `BITWIDTH]), // input vector from row
                .iData1(iData1[(i + 1) * `COLNUM * `BITWIDTH - 1 : i * `COLNUM * `BITWIDTH]), // input vector from col
                .oData(sum[(i + 1) * `ROWNUM * `COLNUM * `OUTBITWIDTH - 1 : i * `ROWNUM * `COLNUM * `OUTBITWIDTH])
                );
        end
        for (i = 0; i < `ROWNUM; i = i + 1) begin
            for (j = 0; j < `COLNUM; j = j + 1) begin
                for (k = 0; k < `HIDDEN; k = k + 1) begin
                    always @(*) begin
                        oData[(i * j + 1) * 2*`OUTBITWIDTH - 1 : i * j * 2*`OUTBITWIDTH] = oData[(i * j + 1) * 2*`OUTBITWIDTH - 1 : i * j * 2*`OUTBITWIDTH] + sum[(k * i * j + 1) * `OUTBITWIDTH - 1 : k * i * j * `OUTBITWIDTH];
                    end
                end
            end
        end
    endgenerate

endmodule

`endif
