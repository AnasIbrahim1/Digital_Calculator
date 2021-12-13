module digitSwitcher(clk, rst, digit0, digit1, digit2, digit3, enable, out);
    input clk, rst;
    input[7:0] digit0, digit1, digit2, digit3;
    output reg[3:0] enable;
    output reg[7:0] out;
    wire[7:0] digit[3:0]; 
    assign digit[0] = digit0, digit[1] = digit1, digit[2] = digit2, digit[3] = digit3;
    reg[1:0] cnt;
    wire clk_out;
    clockDivider #(50000) divide(clk, rst, clk_out);
    always @(posedge clk_out, posedge rst) begin
        cnt <= (rst ? 0 : cnt + 1);
        enable <= 4'b1111 - (1 << cnt);
        out <= digit[cnt];
    end
endmodule