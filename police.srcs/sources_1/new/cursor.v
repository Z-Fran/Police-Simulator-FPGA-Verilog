`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: 
// Module Name: cursor

//////////////////////////////////////////////////////////////////////////////////


module cursor(
    input clk,reset,pause,
    input frame_refresh,
    output cursor_on,
    output [11:0] cursor_rgb,
    input [9:0] cursorX,cursorY,pixel_x,pixel_y
    );
    
    localparam MAX_X = 640;
    localparam MAX_Y = 480;
    localparam CURSOR_MAX_X = 16;
    localparam CURSOR_MAX_Y = 16;
    
    wire [3:0] rom_y; 
    wire [3:0] rom_x; 
    reg [0:15] rom_data;
    wire rom_bit, canvas_on;
    reg [9:0] x_l = 312,y_t=232;
    wire [9:0] x_r,y_b;
    
    assign cursor_rgb = 12'hf55;
    assign canvas_on =  (x_l<=pixel_x) && (pixel_x<=x_r)
                    && (y_t <= pixel_y) && (pixel_y<=y_b);
    assign rom_y = pixel_y[3:0] - y_t[3:0];
    assign rom_x = pixel_x[3:0] - x_l[3:0]; 
    assign rom_bit = rom_data[rom_x];
    assign cursor_on = canvas_on & rom_bit;
    assign x_r = x_l + CURSOR_MAX_X-1;
    assign y_b = y_t + CURSOR_MAX_Y-1;
    
    always @(posedge clk)
    begin
    if (reset)
    begin
        x_l <= 312; y_t=232;
    end
    else
    begin
        if (cursorX+8>MAX_X) x_l <= 624;
        else if(cursorX<8) x_l <= 0;
        else x_l <= cursorX-8;
        if (cursorY+8>MAX_Y) y_t <= 464;
        else if(cursorY<8) y_t <= 0;
        else y_t <= cursorY-8;
    end
    end 
    
    always @*   
      case(rom_y)
        4'h0: rom_data = 16'b0000011001100000; 
        4'h1: rom_data = 16'b0000011001100000; 
        4'h2: rom_data = 16'b0000011001100000; 
        4'h3: rom_data = 16'b0000011001100000; 
        4'h4: rom_data = 16'b0000011001100000; 
        4'h5: rom_data = 16'b1111111001111111; 
        4'h6: rom_data = 16'b1111111001111111; 
        4'h7: rom_data = 16'b0000000000000000; 
        4'h8: rom_data = 16'b0000000000000000; 
        4'h9: rom_data = 16'b1111111001111111; 
        4'ha: rom_data = 16'b1111111001111111; 
        4'hb: rom_data = 16'b0000011001100000; 
        4'hc: rom_data = 16'b0000011001100000; 
        4'hd: rom_data = 16'b0000011001100000; 
        4'he: rom_data = 16'b0000011001100000; 
        4'hf: rom_data = 16'b0000011001100000; 
    endcase
endmodule










