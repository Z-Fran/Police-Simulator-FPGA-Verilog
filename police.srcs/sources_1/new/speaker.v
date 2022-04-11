`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/06 01:10:43
// Design Name: 
// Module Name: score
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


module speaker(
    input clk, reset,
    input [9:0] pixel_x, pixel_y,
    output speaker_on,
    output [2:0] bit_addr,
    output [10:0] rom_addr
);

    localparam text_l=38;
    localparam text_t=256;
    localparam max_x=224;
    localparam max_y=64;
    wire [3:0] row_addr;
    reg [6:0] char_addr;
    wire [3:0] num;  
    reg [3:0] dig_1,dig_10,dig_100;
    assign speaker_on = (text_l<=pixel_x) && (pixel_x<=text_l+max_x-1)
                    && (text_t <= pixel_y) && (pixel_y<=text_t+max_y-1);
    assign row_addr = pixel_y[5:2]-text_t[5:2]; 
    assign bit_addr = pixel_x[4:2]-text_l[4:2]; 
    assign rom_addr = {char_addr, row_addr};
    assign num=pixel_x[8:5]-text_l[8:5];

    always @*
    case (num)
    4'h0: char_addr = 7'h53; //
    4'h1: char_addr = 7'h70; //
    4'h2: char_addr = 7'h65; //
    4'h3: char_addr = 7'h61; //
    4'h4: char_addr = 7'h6b; // 
    4'h5: char_addr = 7'h65; // 
    4'h6: char_addr = 7'h72;
    default: char_addr = 7'h00; 
    endcase

endmodule
