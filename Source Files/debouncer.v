module debouncer(clk, rst, in, out);
    input clk, rst, in;
    output reg out;
    reg[4:0] shiftReg;
    always @(posedge clk, posedge rst) begin
        if (rst) shiftReg <= 0;
        else shiftReg <= (shiftReg << 1) + in;
        out = (shiftReg[4:2] == 3'b111);
    end
endmodule