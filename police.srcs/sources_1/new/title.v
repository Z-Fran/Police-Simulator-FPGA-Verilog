`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/05 23:06:42
// Design Name: 
// Module Name: title
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


module title(
    input clk,reset,
    input [9:0] pixel_x, pixel_y,
    output title_on,
    output [2:0] bit_addr,
    output [10:0] rom_addr
    );
    localparam text_l=64;
    localparam text_t=10;
    localparam max_x=192;
    localparam max_y=64;
    wire [3:0] row_addr;
    reg [6:0] char_addr;
    wire [2:0] num;  
     
    assign title_on=(text_l<=pixel_x) && (pixel_x<=text_l+max_x-1)
                    && (text_t <= pixel_y) && (pixel_y<=text_t+max_y-1);
    assign row_addr=pixel_y[5:2]-text_t[5:2];
    assign bit_addr=pixel_x[4:2]-text_l[4:2];
    assign rom_addr = {char_addr, row_addr};
    assign num=pixel_x[7:5]-text_l[7:5];
    always @*
    case(num)
    0:char_addr=7'h50;
    1:char_addr=7'h4f;
    2:char_addr=7'h4c;
    3:char_addr=7'h49;
    4:char_addr=7'h43;
    5:char_addr=7'h45;
    default:char_addr=7'h00;
    endcase
endmodule
