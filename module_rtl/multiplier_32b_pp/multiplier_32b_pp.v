`ifndef multiplier_32b_pp
`define multiplier_32b_pp

// this module takes 1 cycles to finish
module multiplier_32b_pp (
    input wire iClk,
    input wire iRstN,
    input wire iEn,
    input wire iClr,
    input wire [32-1 : 0] iData0,
    input wire [32-1 : 0] iData1,
    output reg [2*32-1 : 0] oData
);

    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            oData <= 0;
        end else begin
            if (iClr) begin
                oData <= 0;
            end else begin
                if (iEn) begin
                    oData <= iData0 * iData1;
                end else begin
                    oData <= oData;
                end
            end
        end
    end
    
endmodule

`endif
