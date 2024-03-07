`ifndef fifo_sync
`define fifo_sync

module fifo_sync #(
    parameter BITWIDTH = 32,
    parameter DEPTH = 8,
    parameter PTRWIDTH = $clog2(DEPTH)
)(
    input wire iClk, 
    input wire iRstN,
    input wire iEnW, 
    input wire iEnR,
    input wire iClr,
    input wire [BITWIDTH-1:0] iData,
    output reg [BITWIDTH-1:0] oData,
    output wire oFull, 
    output wire oEmpty
);

    reg [PTRWIDTH:0] w_ptr; // addition bit to detect oFull/oEmpty condition
    reg [PTRWIDTH:0] r_ptr; // addition bit to detect oFull/oEmpty condition
    reg [PTRWIDTH-1:0] w_ptr_valid;
    reg [PTRWIDTH-1:0] r_ptr_valid;
    reg [BITWIDTH-1:0] fifo [DEPTH-1:0];
    reg wrap_around;
    wire ptr_valid_identical;
    wire w_valid;
    wire r_valid;

    assign w_ptr_valid = w_ptr[PTRWIDTH-1:0];
    assign r_ptr_valid = r_ptr[PTRWIDTH-1:0];

    assign w_valid = iEnW & ~oFull;
    assign r_valid = iEnR & ~oEmpty;

    always@(posedge iClk or negedge iRstN) begin
        if(~iRstN) begin
            w_ptr <= 0;
        end else begin
            if (iClr) begin
                w_ptr <= 0;
            end else begin
                if(w_valid)begin
                    w_ptr <= w_ptr + 1;
                end
            end
        end
    end

    always@(posedge iClk or negedge iRstN) begin
        if(~iRstN) begin
            r_ptr <= 0;
        end else begin
            if (iClr) begin
                r_ptr <= 0;
            end else begin
                if(r_valid)begin
                    r_ptr <= r_ptr + 1;
                end
            end
        end
    end

    // read data from FIFO
    always@(posedge iClk or negedge iRstN) begin
        if(~iRstN) begin
            oData <= 0;
        end else begin
            if (iClr) begin
                oData <= 0;
            end else begin
                if(r_valid)begin
                    oData <= fifo[r_ptr_valid];
                end
            end
        end
    end

    // write data to FIFO
    always@(posedge iClk or negedge iRstN) begin
        if(w_valid)begin
            fifo[w_ptr_valid] <= iData;
        end
    end

    assign wrap_around = w_ptr[PTRWIDTH] ^ r_ptr[PTRWIDTH]; // To check MSB of write and read pointers are different
    assign ptr_valid_identical = w_ptr_valid == r_ptr_valid;

    //oFull condition: MSB of write and read pointers are different and remainimg bits are same.
    assign oFull = wrap_around & ptr_valid_identical;

    //oEmpty condition: All bits of write and read pointers are same.
    assign oEmpty = ~wrap_around & ptr_valid_identical;

endmodule

`endif
