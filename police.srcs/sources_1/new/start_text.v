`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/06 14:11:58
// Design Name: 
// Module Name: start_text
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


module start_text(
    input clk,reset,
    input [9:0] pixel_x, pixel_y,
    output start_on,
    output [2:0] bit_addr,
    output [10:0] rom_addr,
    input wait_start
    );
    localparam text_l=384;
    localparam text_t=192;
    localparam max_x=160;
    localparam max_y=64;
    wire [3:0] row_addr;
    reg [6:0] char_addr;
    wire [2:0] num;  
    assign start_on = (text_l<=pixel_x) && (pixel_x<=text_l+max_x-1) && 
           (text_t <= pixel_y) && (pixel_y<=text_t+max_y-1) && wait_start;
    assign row_addr = pixel_y[5:2]-text_t[5:2]; 
    assign bit_addr = pixel_x[4:2]-text_l[4:2]; 
    assign rom_addr = {char_addr, row_addr};
    assign num=pixel_x[7:5]-text_l[7:5];
   
    always @*
      case (num)
      3'h0: char_addr = 7'h53; //
      3'h1: char_addr = 7'h74; //
      3'h2: char_addr = 7'h61; //
      3'h3: char_addr = 7'h72; //
      3'h4: char_addr = 7'h74; // 
      default: char_addr = 7'h00; 
      endcase
endmodule
