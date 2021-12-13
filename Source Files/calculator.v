module calculator(clk, rst, operation, buttons, showResult, enable, toDisplay);
    input clk, rst, showResult;
    input[3:0] buttons;
    input[1:0] operation; // 00 addition, 01 subtraction, 10 multiplication, 11 division
    output[3:0] enable;
    output[7:0] toDisplay;
    genvar i;
    wire[3:0] debOut, detOut;
    generate for (i = 0; i < 4; i = i + 1) begin: block1
        debouncer deb(clk, rst, buttons[i], debOut[i]);
        risingDet det(clk, rst, debOut[i], detOut[i]); 
    end endgenerate
    
    // incrementing digits
    reg[3:0] digitsIn[3:0];
    integer j, k;
    always @(posedge clk, posedge rst) begin
        if (rst) for (j = 0; j < 4; j = j + 1) digitsIn[j] <= 0;
        else if (detOut != 0) begin
            for (j = 0; j < 4; j = j + 1) if (detOut[j]) k = j;
            digitsIn[k] <= (digitsIn[k] == 9 ? 0 : digitsIn[k] + 1);
        end
    end
    
    wire[7:0] segmentsIn[3:0];
    generate for (i = 0; i < 4; i = i + 1) begin: block2
        segDisplay segdisplayIn(digitsIn[i], 1, (i == 2), segmentsIn[i]);
    end endgenerate
    
    reg[3:0] digitsOut[3:0];
    wire[6:0] num1, num2; reg[14:0] result; reg isNegative;
    assign num1 = digitsIn[3] * 10 + digitsIn[2];
    assign num2 = digitsIn[1] * 10 + digitsIn[0];
    always @(posedge clk) begin
        isNegative = 0;
        case (operation) 
            0: result = num1 + num2;
            1: begin
                if (num1 > num2) result = num1 - num2;
                else begin
                    result = num2 - num1;
                    isNegative = 1;
                end
            end
            2: result = num1 * num2;
            3: result = (2 * num1 + num2)/(2 * num2);
        endcase
        digitsOut[0] = result % 10;
        digitsOut[1] = (result % 100)/10;
        digitsOut[2] = (isNegative ? 10 : (result % 1000)/100);
        digitsOut[3] = (isNegative ? 11 : result/1000);
    end
    wire[7:0] segmentsOut[3:0];                                                              
    generate for (i = 0; i < 4; i = i + 1) begin: block3                                    
        segDisplay segdisplayOut(digitsOut[i], 1, 0, segmentsOut[i]);                     
    end endgenerate
    
    wire[7:0] finalIn, finalOut; wire[3:0] enableIn, enableOut;
    digitSwitcher switchIn(clk, rst, segmentsIn[0], segmentsIn[1], segmentsIn[2], segmentsIn[3], enableIn, finalIn);
    digitSwitcher switchOut(clk, rst, segmentsOut[0], segmentsOut[1], segmentsOut[2], segmentsOut[3], enableOut, finalOut);
    
    assign enable = (showResult ? enableOut : enableIn);
    assign toDisplay = (showResult ? finalOut : finalIn);
endmodule