    `timescale 1ns/1ns

    `include "multiplier_64b_reg.v"

    module multiplier_64b_reg_tb ();
        logic iClk;
        logic iRstN;
        logic iEn;
        logic iClr;
        logic [64-1 : 0] iData0;
        logic [64-1 : 0] iData1;
        logic [2*64-1 : 0] oData;

        assign result_correct = (oData == (iData0 * iData1));

        multiplier_64b_reg u_multiplier_64b_reg (
            .iClk(iClk),
            .iRstN(iRstN),
            .iEn(iEn),
            .iClr(iClr),
            .iData0(iData0),
            .iData1(iData1),
            .oData(oData)
        );

        // clk define
        always #5 iClk = ~iClk;

        initial begin
            $dumpfile("multiplier_64b_reg.vcd"); $dumpvars;
        end

        initial
        begin
            iClk = 1;
            iRstN = 0;
            iEn = 1;
            iClr = 0;
            iData0 = 64'b1010101010101011010101011101010010101001010100101001010101001011;
            iData1 = 64'b1010101010101011010101011101010010101001010100101001010101001011;
            
            #15;
            iRstN = 1;
            #100;
            iClr = 1;
            #400;
            $finish;
        end

    endmodule
