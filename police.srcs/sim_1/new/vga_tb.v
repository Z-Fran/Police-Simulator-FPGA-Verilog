`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/07 06:11:38
// Design Name: 
// Module Name: vga_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_tb;
    reg CLK;
    reg RESET;
    wire hsync,vsync;
    wire vga_en;
    wire [9:0] pixel_x,pixel_y;
    wire vga_clk;
    vga_sync test(CLK,RESET,hsync,vsync,vga_en,pixel_x,pixel_y,vga_clk);
    initial begin
        CLK = 1'b0;
        RESET = 1'b0;
        #100 
        RESET = 1'b1;
        #1000
        RESET = 1'b0;
    end
    always #5 CLK <= ~CLK;
endmodule
