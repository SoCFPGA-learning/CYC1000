`timescale 1ns / 1ps

module counter(
    input clk,
    input rst,
    input en,
    output reg [DATA_WIDTH-1:0] data,
    output wire tc
);
    parameter DATA_WIDTH=8, DATA_MAX=2**DATA_WIDTH-1;
    
    assign tc = (data == DATA_MAX) ? 1'b1 : 1'b0;
    
    always@(posedge clk)
        if (rst == 1'b0)
            data <= 'b0;
        else if (en == 1'b0)
            data <= data;
        else if (tc == 1'b1)
            data <= 'b0;
        else
            data <= data + 1'b1;
            
endmodule
