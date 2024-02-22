`timescale 1ns/1ns

`include "fifo_sync.v"

module fifo_sync_tb();
    reg iClk, iRstN;
    reg iEnW, iEnR;
    reg iClr;
    reg [7:0] iData;
    wire [7:0] oData;
    wire oFull, oEmpty;

    fifo_sync u_fifo_sync(iClk, iRstN, iEnW, iEnR, iClr, iData, oData, oFull, oEmpty);

    always #2 iClk = ~iClk;
    initial begin
        iClk = 0; iRstN = 0;
        iEnW = 0; iEnR = 0;
        iClr = 0;
        #3 iRstN = 1;
        drive(20);
        drive(40);
        $finish;
    end

    task push();
        if(!oFull) begin
            iEnW = 1;
            iData = $random;
            #1 $display("Push In: iEnW=%b, iEnR=%b, iData=%h",iEnW, iEnR,iData);
        end
        else $display("FIFO oFull!! Can not push iData=%d", iData);
    endtask 

    task pop();
        if(!oEmpty) begin
            iEnR = 1;
            #1 $display("Pop Out: iEnW=%b, iEnR=%b, oData=%h",iEnW, iEnR,oData);
        end
        else $display("FIFO oEmpty!! Can not pop oData");
    endtask

    task drive(int delay);
        iEnW = 0; iEnR = 0;
        fork
            begin
            repeat(10) begin @(posedge iClk) push(); end
            iEnW = 0;
            end
            begin
            #delay;
            repeat(10) begin @(posedge iClk) pop(); end
            iEnR = 0;
            end
        join
    endtask

    initial begin 
        $dumpfile("fifo_sync.vcd"); $dumpvars;
    end
endmodule
