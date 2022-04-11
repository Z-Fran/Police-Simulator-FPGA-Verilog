`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: 
// Module Name: people
//////////////////////////////////////////////////////////////////////////////////

module people #(parameter RANDOM=100000000)(
    input clk,game_reset,pause,enter,
    input frame_refresh,
    output people_on,
    output people_kind,
    input crash,
    input [9:0] pixel_x,pixel_y,
    output reg [11:0] people_rgb,
    input [9:0] car_loc
    );
    
    localparam XMIN=315;
    localparam YMIN=0;
    localparam XMAX=640;
    localparam YMAX=480;
    localparam H_VELOCITY=1;
    reg [1:0] V_VELOCITY=1;

    reg [9:0] people_left=480,people_top=0;
    wire [9:0] people_right,people_bottom;
    
    wire [3:0] people_rom_y,people_rom_x;
    reg [0:15] people_rom_data;
    wire people_rom_bit,canvas_on;
    reg display=0;
    reg h_move=1,v_move=1;
    reg kind=0;
    assign people_kind=kind;
    assign canvas_on=(people_left<=pixel_x)&&(pixel_x<=people_right)&&(people_top<=pixel_y)&&(pixel_y<=people_bottom);
    assign people_rom_y=pixel_y[4:1] - people_top[4:1];
    assign people_rom_x=(pixel_x-people_left)>>1;
    assign people_rom_bit=people_rom_data[people_rom_x];
    assign people_right=people_left+31;
    assign people_bottom=people_top+31; 
    assign people_on=canvas_on && people_rom_bit && display;
    
    integer cnt=0;
    always@(posedge clk)
    begin
        if(game_reset || crash || (people_bottom>=YMAX && random[26]==1))
        begin 
            cnt<=0;
            display<=0;                              
        end
        else if(cnt<RANDOM) cnt<=cnt+1;
        if(cnt==RANDOM) display<=1;
    end
    
    reg[26:0] random=0;
    always@(posedge clk)
        random=random+1;
    //碰到边界变向
    always @(posedge clk)
    begin
    if(~display) begin h_move<=random[25]; v_move<=random[26];kind<=random[26]; end
    else if(frame_refresh && !pause)
    begin
        if(people_left<=XMIN) h_move<=1;
        else if(people_right>=XMAX) h_move<=0;
        else h_move<=h_move;
        if(people_top<=YMIN) v_move<=1; 
        else if(people_bottom>=YMAX) v_move=0;
        else v_move<=v_move;
    end
    end
      
    always @(posedge clk)
    begin
    if(~display) begin people_left<=car_loc; people_top<=0; end
    else if(frame_refresh && !pause)
    begin
        if(h_move) people_left<=people_left+H_VELOCITY;
        else people_left<=people_left-H_VELOCITY;
        if(v_move) people_top<=people_top+V_VELOCITY;
        else people_top<=people_top-H_VELOCITY;
    end
    else
    begin
        if(enter) V_VELOCITY<=3;
        else V_VELOCITY<=1;
    end
    end
    
    always @*
      case(people_rom_y)
        4'h0: people_rom_data = 16'b0001111111111000; 
        4'h1: people_rom_data = 16'b0011111111111100; 
        4'h2: people_rom_data = 16'b0111111111111110; 
        4'h3: people_rom_data = 16'b1111111111111111; 
        4'h4: people_rom_data = 16'b1111111111111111; 
        4'h5: people_rom_data = 16'b1111111111111111;
        4'h6: people_rom_data = 16'b1111111111111111;
        4'h7: people_rom_data = 16'b1111111111111111;
        4'h8: people_rom_data = 16'b1111111111111111;
        4'h9: people_rom_data = 16'b1111111111111111;
        4'ha: people_rom_data = 16'b1111111111111111;
        4'hb: people_rom_data = 16'b1111111111111111;
        4'hc: people_rom_data = 16'b1111111111111111;
        4'hd: people_rom_data = 16'b0111111111111110;
        4'he: people_rom_data = 16'b0111111111111110;   
        4'hf: people_rom_data = 16'b0000111111110000; 
    endcase    
    always @*
        case(people_rom_y)
        0:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'h000;
            4'h2:people_rgb=12'h000;
            4'h3:people_rgb=12'h000;
            4'h4:people_rgb=12'h000;
            4'h5:people_rgb=12'h000;
            4'h6:people_rgb=12'h000;
            4'h7:people_rgb=12'h000;
            4'h8:people_rgb=12'h000;
            4'h9:people_rgb=12'h000;
            4'ha:people_rgb=12'h000;
            4'hb:people_rgb=12'h000;
            4'hc:people_rgb=12'h000;
            4'hd:people_rgb=12'h000;
            4'he:people_rgb=12'h000;
            4'hf:people_rgb=12'h000;
            endcase
        1:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'h000;
            4'h2:people_rgb=12'h000;
            4'h3:people_rgb=12'h000;
            4'h4:people_rgb=12'hfff;
            4'h5:people_rgb=12'hfff;
            4'h6:people_rgb=12'hfff;
            4'h7:people_rgb=12'hfff;
            4'h8:people_rgb=12'hfff;
            4'h9:people_rgb=12'hfff;
            4'ha:people_rgb=12'hfff;
            4'hb:people_rgb=12'hfff;
            4'hc:people_rgb=12'h000;
            4'hd:people_rgb=12'h000;
            4'he:people_rgb=12'h000;
            4'hf:people_rgb=12'h000;
            endcase
        2:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'h000;
            4'h2:people_rgb=12'hfff;
            4'h3:people_rgb=12'hfff;
            4'h4:people_rgb=12'hfff;
            4'h5:people_rgb=12'hfff;
            4'h6:people_rgb=12'hfff;
            4'h7:people_rgb=12'hfff;
            4'h8:people_rgb=12'hfff;
            4'h9:people_rgb=12'hfff;
            4'ha:people_rgb=12'hfff;
            4'hb:people_rgb=12'hfff;
            4'hc:people_rgb=12'hfff;
            4'hd:people_rgb=12'hfff;
            4'he:people_rgb=12'h000;
            4'hf:people_rgb=12'h000;
            endcase
        3:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'h000;
            4'h2:people_rgb=12'hfff;
            4'h3:people_rgb=12'hfff;
            4'h4:people_rgb=12'hfff;
            4'h5:people_rgb=12'hfff;
            4'h6:people_rgb=12'hfff;
            4'h7:people_rgb=12'hfff;
            4'h8:people_rgb=12'hfff;
            4'h9:people_rgb=12'hfff;
            4'ha:people_rgb=12'hfff;
            4'hb:people_rgb=12'hfff;
            4'hc:people_rgb=12'hfff;
            4'hd:people_rgb=12'hfff;
            4'he:people_rgb=12'h000;
            4'hf:people_rgb=12'h000;
            endcase
        4:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'hfff;
            4'h2:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h3:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h4:people_rgb=12'h000;
            4'h5:people_rgb=12'hfff;
            4'h6:people_rgb=12'hfff;
            4'h7:people_rgb=12'hfff;
            4'h8:people_rgb=12'hfff;
            4'h9:people_rgb=12'hfff;
            4'ha:people_rgb=12'hfff;
            4'hb:people_rgb=12'h000;
            4'hc:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'hd:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'he:people_rgb=12'hfff;
            4'hf:people_rgb=12'h000;
        endcase
        5:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'hfff;
            4'h2:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h3:people_rgb=12'hfff;
            4'h4:people_rgb=12'h000;
            4'h5:people_rgb=12'hfff;
            4'h6:people_rgb=12'hfff;
            4'h7:people_rgb=12'hfff;
            4'h8:people_rgb=12'hfff;
            4'h9:people_rgb=12'hfff;
            4'ha:people_rgb=12'hfff;
            4'hb:people_rgb=12'h000;
            4'hc:people_rgb=12'hfff;
            4'hd:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'he:people_rgb=12'hfff;
            4'hf:people_rgb=12'h000;
            endcase
        6:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'hfff;
            4'h2:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h3:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h4:people_rgb=12'h000;
            4'h5:people_rgb=12'hfff;
            4'h6:people_rgb=12'hfff;
            4'h7:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h8:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h9:people_rgb=12'hfff;
            4'ha:people_rgb=12'hfff;
            4'hb:people_rgb=12'h000;
            4'hc:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'hd:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'he:people_rgb=12'hfff;
            4'hf:people_rgb=12'h000;
            endcase
        7:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'hfff;
            4'h2:people_rgb=12'hfff;
            4'h3:people_rgb=12'hfff;
            4'h4:people_rgb=12'hfff;
            4'h5:people_rgb=12'hfff;
            4'h6:people_rgb=12'hfff;
            4'h7:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h8:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h9:people_rgb=12'hfff;
            4'ha:people_rgb=12'hfff;
            4'hb:people_rgb=12'hfff;
            4'hc:people_rgb=12'hfff;
            4'hd:people_rgb=12'hfff;
            4'he:people_rgb=12'hfff;
            4'hf:people_rgb=12'h000;
            endcase
        8:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'hfff;
            4'h2:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h3:people_rgb=12'hfff;
            4'h4:people_rgb=12'hfff;
            4'h5:people_rgb=12'hfff;
            4'h6:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h7:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h8:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h9:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'ha:people_rgb=12'hfff;
            4'hb:people_rgb=12'hfff;
            4'hc:people_rgb=12'hfff;
            4'hd:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'he:people_rgb=12'hfff;
            4'hf:people_rgb=12'h000;
            endcase
        9:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'hfff;
            4'h2:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h3:if(kind)people_rgb=12'h000;else people_rgb=12'hfff;
            4'h4:people_rgb=12'hfff;
            4'h5:people_rgb=12'hfff;
            4'h6:people_rgb=12'hfff;
            4'h7:people_rgb=12'hfff;
            4'h8:people_rgb=12'hfff;
            4'h9:people_rgb=12'hfff;
            4'ha:people_rgb=12'hfff;
            4'hb:people_rgb=12'hfff;
            4'hc:if(kind)people_rgb=12'h000;else people_rgb=12'hfff;
            4'hd:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'he:people_rgb=12'hfff;
            4'hf:people_rgb=12'h000;
            endcase 
        10:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'hfff;
            4'h2:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h3:people_rgb=12'h000;
            4'h4:people_rgb=12'h000;
            4'h5:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h6:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h7:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h8:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h9:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'ha:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'hb:people_rgb=12'h000;
            4'hc:people_rgb=12'h000;
            4'hd:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'he:people_rgb=12'hfff;
            4'hf:people_rgb=12'h000;
            endcase
        11:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'hfff;
            4'h2:people_rgb=12'hfff;
            4'h3:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h4:if(kind)people_rgb=12'h000;else people_rgb=12'hfff;
            4'h5:people_rgb=12'h000;
            4'h6:people_rgb=12'hfff;
            4'h7:people_rgb=12'hfff;
            4'h8:people_rgb=12'hfff;
            4'h9:people_rgb=12'hfff;
            4'ha:people_rgb=12'h000;
            4'hb:if(kind)people_rgb=12'h000;else people_rgb=12'hfff;
            4'hc:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'hd:people_rgb=12'hfff;
            4'he:people_rgb=12'hfff;
            4'hf:people_rgb=12'h000;
            endcase                            
        12:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'hfff;
            4'h2:people_rgb=12'hfff;
            4'h3:people_rgb=12'hfff;
            4'h4:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h5:people_rgb=12'h000;
            4'h6:people_rgb=12'h000;
            4'h7:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h8:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'h9:people_rgb=12'h000;
            4'ha:people_rgb=12'h000;
            4'hb:if(kind)people_rgb=12'hfff;else people_rgb=12'h000;
            4'hc:people_rgb=12'hfff;
            4'hd:people_rgb=12'hfff;
            4'he:people_rgb=12'hfff;
            4'hf:people_rgb=12'h000;
            endcase                            
        13:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'h000;
            4'h2:people_rgb=12'hfff;
            4'h3:people_rgb=12'hfff;
            4'h4:people_rgb=12'hfff;
            4'h5:people_rgb=12'hfff;
            4'h6:if(kind)people_rgb=12'h000;else people_rgb=12'hfff;
            4'h7:if(kind)people_rgb=12'h000;else people_rgb=12'hfff;
            4'h8:if(kind)people_rgb=12'h000;else people_rgb=12'hfff;
            4'h9:if(kind)people_rgb=12'h000;else people_rgb=12'hfff;
            4'ha:people_rgb=12'hfff;
            4'hb:people_rgb=12'hfff;
            4'hc:people_rgb=12'hfff;
            4'hd:people_rgb=12'hfff;
            4'he:people_rgb=12'h000;
            4'hf:people_rgb=12'h000;
            endcase 
        14:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'h000;
            4'h2:people_rgb=12'h000;
            4'h3:people_rgb=12'h000;
            4'h4:people_rgb=12'hfff;
            4'h5:people_rgb=12'hfff;
            4'h6:people_rgb=12'hfff;
            4'h7:people_rgb=12'hfff;
            4'h8:people_rgb=12'hfff;
            4'h9:people_rgb=12'hfff;
            4'ha:people_rgb=12'hfff;
            4'hb:people_rgb=12'hfff;
            4'hc:people_rgb=12'h000;
            4'hd:people_rgb=12'h000;
            4'he:people_rgb=12'h000;
            4'hf:people_rgb=12'h000;
            endcase                           
         15:
            case(people_rom_x)
            4'h0:people_rgb=12'h000;
            4'h1:people_rgb=12'h000;
            4'h2:people_rgb=12'h000;
            4'h3:people_rgb=12'h000;
            4'h4:people_rgb=12'h000;
            4'h5:people_rgb=12'h000;
            4'h6:people_rgb=12'h000;
            4'h7:people_rgb=12'h000;
            4'h8:people_rgb=12'h000;
            4'h9:people_rgb=12'h000;
            4'ha:people_rgb=12'h000;
            4'hb:people_rgb=12'h000;
            4'hc:people_rgb=12'h000;
            4'hd:people_rgb=12'h000;
            4'he:people_rgb=12'h000;
            4'hf:people_rgb=12'h000;
            endcase                           
        endcase
endmodule
