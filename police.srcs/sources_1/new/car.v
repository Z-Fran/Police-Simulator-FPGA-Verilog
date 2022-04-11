`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: 
// Module Name: car
//////////////////////////////////////////////////////////////////////////////////
module car(
    input clk,
    input frame_refresh,
    input reset,pause,
    input left,right,
    output car_on,
    input [9:0] pixel_x,pixel_y,
    output reg [11:0] car_rgb,
    output [9:0] car_loc
    );
    
localparam MAX_X = 640;
localparam MAX_Y = 480;
localparam CAR_MAX_X = 64;
localparam CAR_MAX_Y = 128;
localparam car_y_t = 320; 
localparam car_y_b = car_y_t + CAR_MAX_Y-1;
localparam CAR_VELOCITY = 3'd02;


wire [3:0] car_rom_y; 
wire [3:0] car_rom_x; 
reg [0:15] car_rom_data;
wire car_rom_bit, canvas_on;
reg [9:0] car_x_l = 500;
wire [9:0] car_x_r;

assign canvas_on =  (car_x_l<=pixel_x) && (pixel_x<=car_x_r)
                && (car_y_t <= pixel_y) && (pixel_y<=car_y_b);
assign car_rom_y = pixel_y[6:3] - car_y_t[6:3];
assign car_rom_x = (pixel_x - car_x_l)>>2; 
assign car_rom_bit = car_rom_data[car_rom_x];
assign car_on = canvas_on & car_rom_bit;
assign car_x_r = car_x_l + CAR_MAX_X-1;
assign car_loc=car_x_l;

always @(posedge clk)
begin
if (reset)
    begin
    car_x_l <= 500;
    end
else if (frame_refresh && !pause)
    begin
    if (right & (car_x_r < (MAX_X-1-CAR_VELOCITY)))
        begin
        car_x_l <= car_x_l + CAR_VELOCITY; 
        end
    else if (left & (car_x_l > 315+CAR_VELOCITY))
        begin
        car_x_l <= car_x_l - CAR_VELOCITY; 
        end
     end  
       
end

always @*
  case(car_rom_y)
    4'h0: car_rom_data = 16'b0011111111111100; 
    4'h1: car_rom_data = 16'b0011111111111100;
    4'h2: car_rom_data = 16'b0111111111111110; 
    4'h3: car_rom_data = 16'b1111111111111111; 
    4'h4: car_rom_data = 16'b1111111111111111;
    4'h5: car_rom_data = 16'b1111111111111111; 
    4'h6: car_rom_data = 16'b0111111111111110; 
    4'h7: car_rom_data = 16'b0111111111111110; 
    4'h8: car_rom_data = 16'b0111111111111110; 
    4'h9: car_rom_data = 16'b0111111111111110; 
    4'ha: car_rom_data = 16'b1111111111111111;
    4'hb: car_rom_data = 16'b1111111111111111; 
    4'hc: car_rom_data = 16'b1111111111111111;
    4'hd: car_rom_data = 16'b1111111111111111; 
    4'he: car_rom_data = 16'b0111111111111110; 
    4'hf: car_rom_data = 16'b0111111111111110; 
endcase

always @*
    case(car_rom_y)
    0:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'hf22;
        4'h3:car_rgb=12'hf22;
        4'h4:car_rgb=12'h000;
        4'h5:car_rgb=12'h000;
        4'h6:car_rgb=12'h000;
        4'h7:car_rgb=12'h000;
        4'h8:car_rgb=12'h000;
        4'h9:car_rgb=12'h000;
        4'ha:car_rgb=12'h000;
        4'hb:car_rgb=12'h000;
        4'hc:car_rgb=12'hf22;
        4'hd:car_rgb=12'hf22;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase
    1:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'h000;
        4'h3:car_rgb=12'h000;
        4'h4:car_rgb=12'h000;
        4'h5:car_rgb=12'hfff;
        4'h6:car_rgb=12'hfff;
        4'h7:car_rgb=12'hfff;
        4'h8:car_rgb=12'hfff;
        4'h9:car_rgb=12'hfff;
        4'ha:car_rgb=12'hfff;
        4'hb:car_rgb=12'h000;
        4'hc:car_rgb=12'h000;
        4'hd:car_rgb=12'h000;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase
    2:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'h000;
        4'h3:car_rgb=12'h000;
        4'h4:car_rgb=12'h000;
        4'h5:car_rgb=12'hfff;
        4'h6:car_rgb=12'hfff;
        4'h7:car_rgb=12'hfff;
        4'h8:car_rgb=12'hfff;
        4'h9:car_rgb=12'hfff;
        4'ha:car_rgb=12'hfff;
        4'hb:car_rgb=12'h000;
        4'hc:car_rgb=12'h000;
        4'hd:car_rgb=12'h000;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase
    3:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'hfff;
        4'h3:car_rgb=12'hfff;
        4'h4:car_rgb=12'hfff;
        4'h5:car_rgb=12'hfff;
        4'h6:car_rgb=12'hfff;
        4'h7:car_rgb=12'hfff;
        4'h8:car_rgb=12'hfff;
        4'h9:car_rgb=12'hfff;
        4'ha:car_rgb=12'hfff;
        4'hb:car_rgb=12'hfff;
        4'hc:car_rgb=12'hfff;
        4'hd:car_rgb=12'hfff;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase
    4:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'h8be;
        4'h3:car_rgb=12'h8be;
        4'h4:car_rgb=12'h8be;
        4'h5:car_rgb=12'h8be;
        4'h6:car_rgb=12'h8be;
        4'h7:car_rgb=12'h8be;
        4'h8:car_rgb=12'h8be;
        4'h9:car_rgb=12'h8be;
        4'ha:car_rgb=12'h8be;
        4'hb:car_rgb=12'h8be;
        4'hc:car_rgb=12'h8be;
        4'hd:car_rgb=12'h8be;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
    endcase
    5:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'hfff;
        4'h3:car_rgb=12'h8be;
        4'h4:car_rgb=12'h8be;
        4'h5:car_rgb=12'h8be;
        4'h6:car_rgb=12'h8be;
        4'h7:car_rgb=12'h8be;
        4'h8:car_rgb=12'h8be;
        4'h9:car_rgb=12'h8be;
        4'ha:car_rgb=12'h8be;
        4'hb:car_rgb=12'h8be;
        4'hc:car_rgb=12'h8be;
        4'hd:car_rgb=12'hfff;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase
    6:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'hfff;
        4'h3:car_rgb=12'hfff;
        4'h4:car_rgb=12'h8be;
        4'h5:car_rgb=12'h8be;
        4'h6:car_rgb=12'h8be;
        4'h7:car_rgb=12'h8be;
        4'h8:car_rgb=12'h8be;
        4'h9:car_rgb=12'h8be;
        4'ha:car_rgb=12'h8be;
        4'hb:car_rgb=12'h8be;
        4'hc:car_rgb=12'hfff;
        4'hd:car_rgb=12'hfff;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase
    7:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'h000;
        4'h3:car_rgb=12'h000;
        4'h4:car_rgb=12'h000;
        4'h5:car_rgb=12'h000;
        4'h6:car_rgb=12'h000;
        4'h7:car_rgb=12'h000;
        4'h8:car_rgb=12'h000;
        4'h9:car_rgb=12'h000;
        4'ha:car_rgb=12'h000;
        4'hb:car_rgb=12'h000;
        4'hc:car_rgb=12'h000;
        4'hd:car_rgb=12'h000;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase
    8:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'hfff;
        4'h3:car_rgb=12'h000;
        4'h4:car_rgb=12'hf00;
        4'h5:car_rgb=12'hf00;
        4'h6:car_rgb=12'hf00;
        4'h7:car_rgb=12'hf00;
        4'h8:car_rgb=12'h00f;
        4'h9:car_rgb=12'h00f;
        4'ha:car_rgb=12'h00f;
        4'hb:car_rgb=12'h00f;
        4'hc:car_rgb=12'h000;
        4'hd:car_rgb=12'hfff;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase
    9:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'hfff;
        4'h3:car_rgb=12'h000;
        4'h4:car_rgb=12'hf00;
        4'h5:car_rgb=12'hf00;
        4'h6:car_rgb=12'hf00;
        4'h7:car_rgb=12'hf00;
        4'h8:car_rgb=12'h00f;
        4'h9:car_rgb=12'h00f;
        4'ha:car_rgb=12'h00f;
        4'hb:car_rgb=12'h00f;
        4'hc:car_rgb=12'h000;
        4'hd:car_rgb=12'hfff;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase 
    10:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'h000;
        4'h3:car_rgb=12'h000;
        4'h4:car_rgb=12'h000;
        4'h5:car_rgb=12'h000;
        4'h6:car_rgb=12'h000;
        4'h7:car_rgb=12'h000;
        4'h8:car_rgb=12'h000;
        4'h9:car_rgb=12'h000;
        4'ha:car_rgb=12'h000;
        4'hb:car_rgb=12'h000;
        4'hc:car_rgb=12'h000;
        4'hd:car_rgb=12'h000;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase
    11:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'hfff;
        4'h3:car_rgb=12'h000;
        4'h4:car_rgb=12'hfff;
        4'h5:car_rgb=12'hfff;
        4'h6:car_rgb=12'hfff;
        4'h7:car_rgb=12'h000;
        4'h8:car_rgb=12'h000;
        4'h9:car_rgb=12'hfff;
        4'ha:car_rgb=12'hfff;
        4'hb:car_rgb=12'hfff;
        4'hc:car_rgb=12'h000;
        4'hd:car_rgb=12'hfff;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase                            
    12:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'hfff;
        4'h3:car_rgb=12'h000;
        4'h4:car_rgb=12'hfff;
        4'h5:car_rgb=12'hfff;
        4'h6:car_rgb=12'hfff;
        4'h7:car_rgb=12'h000;
        4'h8:car_rgb=12'h000;
        4'h9:car_rgb=12'hfff;
        4'ha:car_rgb=12'hfff;
        4'hb:car_rgb=12'hfff;
        4'hc:car_rgb=12'h000;
        4'hd:car_rgb=12'hfff;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase                            
    13:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'hfff;
        4'h3:car_rgb=12'h000;
        4'h4:car_rgb=12'hfff;
        4'h5:car_rgb=12'hfff;
        4'h6:car_rgb=12'hfff;
        4'h7:car_rgb=12'h000;
        4'h8:car_rgb=12'h000;
        4'h9:car_rgb=12'hfff;
        4'ha:car_rgb=12'hfff;
        4'hb:car_rgb=12'hfff;
        4'hc:car_rgb=12'h000;
        4'hd:car_rgb=12'hfff;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase 
    14:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'h000;
        4'h2:car_rgb=12'h000;
        4'h3:car_rgb=12'h000;
        4'h4:car_rgb=12'h000;
        4'h5:car_rgb=12'h000;
        4'h6:car_rgb=12'h000;
        4'h7:car_rgb=12'h000;
        4'h8:car_rgb=12'h000;
        4'h9:car_rgb=12'h000;
        4'ha:car_rgb=12'h000;
        4'hb:car_rgb=12'h000;
        4'hc:car_rgb=12'h000;
        4'hd:car_rgb=12'h000;
        4'he:car_rgb=12'h000;
        4'hf:car_rgb=12'h000;
        endcase                           
     15:
        case(car_rom_x)
        4'h0:car_rgb=12'h000;
        4'h1:car_rgb=12'hf22;
        4'h2:car_rgb=12'hf22;
        4'h3:car_rgb=12'hf22;
        4'h4:car_rgb=12'h000;
        4'h5:car_rgb=12'h000;
        4'h6:car_rgb=12'h000;
        4'h7:car_rgb=12'h000;
        4'h8:car_rgb=12'h000;
        4'h9:car_rgb=12'h000;
        4'ha:car_rgb=12'h000;
        4'hb:car_rgb=12'h000;
        4'hc:car_rgb=12'hf22;
        4'hd:car_rgb=12'hf22;
        4'he:car_rgb=12'hf22;
        4'hf:car_rgb=12'h000;
        endcase                           
    endcase
endmodule