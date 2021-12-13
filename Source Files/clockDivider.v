module clockDivider #(n = 50000000) (clk, rst, clk_out);
    input clk, rst; output reg clk_out;
    reg[31:0] cnt;
    always @(posedge clk, posedge rst) begin
        if (rst) cnt <= 0;
        else begin
            if (cnt == n - 1) begin
                cnt <= 0;
                clk_out = ~clk_out;
            end
            else cnt <= cnt + 1;
        end
    end
endmodule