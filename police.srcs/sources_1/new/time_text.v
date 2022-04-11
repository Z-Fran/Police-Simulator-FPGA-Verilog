`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/05 21:40:56
// Design Name: 
// Module Name: time_text
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


module time_text(
    input clk, reset, pause,
    input frame_refresh,
    input [9:0] pixel_x, pixel_y,
    output time_on,
    output [2:0] bit_addr,
    output [10:0] rom_addr
);

    localparam text_l=6;
    localparam text_t=410;
    localparam max_x=288;
    localparam max_y=64;
    wire [3:0] row_addr;
    reg [6:0] char_addr;
    wire [3:0] num;  
    reg [26:0] time_cnt;
    reg [9:0] pass;
    reg [3:0] dig_1s, dig_10s, dig_100s;

    assign time_on = (text_l<=pixel_x) && (pixel_x<=text_l+max_x-1)
                    && (text_t <= pixel_y) && (pixel_y<=text_t+max_y-1);
    assign row_addr = pixel_y[5:2]-text_t[5:2];  //放大两倍
    assign bit_addr = pixel_x[4:2]-text_l[4:2]; 
    assign rom_addr = {char_addr, row_addr};
    assign num=pixel_x[8:5]-text_l[8:5];
    
    always@(posedge clk)
    begin
    time_cnt <= time_cnt + 1;
    if(reset)
        pass<=0;  
    else if(pause)
        pass <=pass;
    else if(time_cnt==100000000) //1s
    begin
        time_cnt<=0;
        pass <= pass + 1;
    end
    
    //计算十进制时间
    if(frame_refresh)
        begin
        dig_1s <= pass%10;
        dig_10s <= (pass%100)/10;
        dig_100s <= (pass%1000)/100;
        end
    end 
   
    always @*
    case (num)
    4'h0: char_addr = 7'h54; // T
    4'h1: char_addr = 7'h69; // i
    4'h2: char_addr = 7'h6d; // m
    4'h3: char_addr = 7'h65; // e
    4'h4: char_addr = 7'h3a; // :
    4'h5: char_addr = {3'b011, dig_100s};
    4'h6: char_addr = {3'b011, dig_10s};
    4'h7: char_addr = {3'b011, dig_1s};
    4'h8: char_addr = 7'h53;
    default: char_addr = 7'h00; 
    endcase

endmodule