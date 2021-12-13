module segDisplay(digit, enable, decPointFlag, display);
    input[3:0] digit;
    input enable, decPointFlag;
    output reg[7:0] display;
    always @(digit, enable) begin
        if (enable) begin
            case (digit) 
                 0: display = 8'b00000011; 
                 1: display = 8'b10011111; 
                 2: display = 8'b00100101;
                 3: display = 8'b00001101;
                 4: display = 8'b10011001;
                 5: display = 8'b01001001;
                 6: display = 8'b01000001;
                 7: display = 8'b00011111;
                 8: display = 8'b00000001;
                 9: display = 8'b00001001;
                 10: display = 8'b11111101;
                default: display = 8'b11111111;
            endcase
            display = display - decPointFlag;
        end
        else display = 8'b11111111;
    end
endmodule
