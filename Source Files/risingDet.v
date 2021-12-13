module risingDet(clk, rst, in, out);
    input clk, rst, in;
    output reg out;
    reg[1:0] shiftReg;
    always @(posedge clk, posedge rst) begin
        if (rst) shiftReg <= 0;
        else shiftReg <= (shiftReg << 1) + in;
        out = (shiftReg == 1);
    end    
endmodule