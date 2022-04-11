`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: 
// Module Name: road
//////////////////////////////////////////////////////////////////////////////////


module road(
    input clk,
    input [9:0] pixel_x,pixel_y,
    output road_on,
    output reg [11:0] road_rgb
    );
    localparam DEVIDE_LEFT=310;
    localparam DEVIDE_RIGHT=315;
    
    assign road_on=1;
    
    always@(posedge clk)
        if((pixel_x>=DEVIDE_LEFT)&&(pixel_x<=DEVIDE_RIGHT)) road_rgb<=12'h733;//bian
        else if(pixel_x<DEVIDE_LEFT) road_rgb<=12'h888;
        else road_rgb<=12'h444;
 
endmodule
