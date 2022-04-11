`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/06 13:00:51
// Design Name: 
// Module Name: siren1
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


module siren1(
    input clk,reset,
    input [9:0] pixel_x, pixel_y,
    output siren1_on,
    output [2:0] bit_addr,
    output [10:0] rom_addr
    );
    
     localparam text_l=32;
     localparam text_t=160;
     localparam max_x=96;
     localparam max_y=32;
     wire [3:0] row_addr;
     reg [6:0] char_addr;
     wire [2:0] num;  
     assign siren1_on = (text_l<=pixel_x) && (pixel_x<=text_l+max_x-1)
                     && (text_t <= pixel_y) && (pixel_y<=text_t+max_y-1);
     assign row_addr = pixel_y[4:1]-text_t[4:1];  //·Å´óÁ½±¶
     assign bit_addr = pixel_x[3:1]-text_l[3:1]; 
     assign rom_addr = {char_addr, row_addr};
     assign num=pixel_x[6:4]-text_l[6:4];
    
     always @*
       case (num)
       3'h0: char_addr = 7'h53; //
       3'h1: char_addr = 7'h69; //
       3'h2: char_addr = 7'h72; //
       3'h3: char_addr = 7'h65; //
       3'h4: char_addr = 7'h6e; // 
       3'h5: char_addr = 7'h31; // 
       default: char_addr = 7'h00; 
       endcase
endmodule
