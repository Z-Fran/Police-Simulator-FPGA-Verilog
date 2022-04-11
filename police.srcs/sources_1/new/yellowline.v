`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: 
// Module Name: yellowline
//////////////////////////////////////////////////////////////////////////////////


module yellowline(
    input clk,reset,pause,enter,
    input frame_refresh,
    input [9:0] pixel_x,pixel_y,
    output yellowline_on,
    output [11:0] yellowline_rgb
    );
    
    localparam line_left=461;
    localparam line_right=491;
    reg [2:0]velocity=1;
    reg y;
    wire x_on,y_on;
    reg [9:0] y_bias=0;
    reg [21:0] cnt;

    always @(posedge clk)
    begin
        if(reset) y_bias<=0;
        else if(frame_refresh && !pause)
            if(y_bias+velocity<480) y_bias<=y_bias+velocity;
            else y_bias<=0;
        else
            begin
            if(enter) velocity<=3;
            else velocity<=1;
            end
    end  
    assign yellowline_rgb=12'hfa0;
    assign x_on=(pixel_x>=line_left)&&(pixel_x<=line_right);
    assign yellowline_on=x_on & y_on;
    assign y_on=((480-pixel_y+y_bias)%160<=99);    
endmodule
