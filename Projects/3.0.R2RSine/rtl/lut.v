`timescale 1ns / 1ps

module lut(
    input clk,
    input      [ADDRESS_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] data
);
    parameter ADDRESS_WIDTH=8,
              DATA_WIDTH=8,
              FILENAME="sin.hex";
    
    reg [DATA_WIDTH-1:0] mem [2**ADDRESS_WIDTH-1:0];
    
    initial $readmemh(FILENAME, mem);
    
    always@(posedge clk)
        data <= mem[addr];
        
endmodule
