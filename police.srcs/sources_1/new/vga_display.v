`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: vgaÏÔÊ¾
// Module Name: vga_display
//////////////////////////////////////////////////////////////////////////////////


module vga_display(
    input clk,
    input vga_clk,
    input game_reset,pause,wait_start,
    input [4:0] crash,
    input enter,
    input vga_en,
    input [9:0] pixel_x,pixel_y,
    output car_on,
    output [4:0] people_on,people_kind,
    output reg [11:0] RGB,
    input [11:0] score,
    input LClick,RClick,
    input [9:0] cursorX,cursorY,
    output siren,
    output speaker
    );

    reg siren_choice;
    assign siren=siren_choice;
    wire speaker_choice;
    assign speaker=speaker_choice;
    assign speaker_choice=(LClick && (cursorX>=38) && (cursorX<=262) && (cursorY>=256) && (cursorY<=320))? 1:0;

    reg frame_refresh; reg [1:0] state;
    wire [11:0] car_rgb,road_rgb,text_rgb,yellowline_rgb,cursor_rgb;
    wire [11:0] people0_rgb,people1_rgb,people2_rgb,people3_rgb,people4_rgb;
    wire road_on,yellowline_on,cursor_on,text_on;
    wire [9:0] car_loc;
    wire car_left,car_right;
    assign car_left=(car_loc+32>cursorX);
    assign car_right=(car_loc+32<cursorX);
    
    text texts(
        .clk(clk),
        .frame_refresh(frame_refresh),
        .reset(game_reset),
        .pause(pause),
        .wait_start(wait_start),
        .enter(enter),
        .text_on(text_on),
        .text_rgb(text_rgb),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .scores(score),
        .siren_choice(siren_choice),
        .speaker_choice(speaker_choice)
    );
    
    cursor cursors(
        .clk(clk),
        .frame_refresh(frame_refresh),
        .reset(game_reset),
        .pause(pause),
        .cursor_on(cursor_on),
        .cursor_rgb(cursor_rgb),
        .cursorX(cursorX),
        .cursorY(cursorY),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );
    road roads(
        .clk(vga_clk),
        .road_on(road_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .road_rgb(road_rgb)
    );
    yellowline yellowlines(
        .clk(clk),
        .frame_refresh(frame_refresh),
        .reset(game_reset),
        .pause(pause),
        .enter(enter),
        .yellowline_on(yellowline_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .yellowline_rgb(yellowline_rgb)
    );
    car cars(
        .clk(clk),
        .frame_refresh(frame_refresh),
        .reset(game_reset),
        .car_on(car_on),
        .pause(pause),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .car_rgb(car_rgb),
        .left(car_left),
        .right(car_right),
        .car_loc(car_loc)
    );
    people #(.RANDOM(100000000)) people0(
        .clk(clk),
        .frame_refresh(frame_refresh),
        .game_reset(game_reset),
        .pause(pause),
        .enter(enter),
        .people_on(people_on[0]),
        .people_kind(people_kind[0]),
        .crash(crash[0]),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .people_rgb(people0_rgb),
        .car_loc(car_loc)       
    );
    people #(.RANDOM(200000000)) people1(
        .clk(clk),
        .frame_refresh(frame_refresh),
        .game_reset(game_reset),
        .pause(pause),
        .enter(enter),
        .people_on(people_on[1]),
        .people_kind(people_kind[1]),
        .crash(crash[1]),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .people_rgb(people1_rgb),
        .car_loc(car_loc)        
    );
    people #(.RANDOM(300000000)) people2(
        .clk(clk),
        .frame_refresh(frame_refresh),
        .game_reset(game_reset),
        .pause(pause),
        .enter(enter),
        .people_on(people_on[2]),
        .people_kind(people_kind[2]),
        .crash(crash[2]),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .people_rgb(people2_rgb),
        .car_loc(car_loc)         
    );
    people #(.RANDOM(400000000)) people3(
        .clk(clk),
        .frame_refresh(frame_refresh),
        .game_reset(game_reset),
        .pause(pause),
        .enter(enter),
        .people_on(people_on[3]),
        .people_kind(people_kind[3]),
        .crash(crash[3]),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .people_rgb(people3_rgb),
        .car_loc(car_loc)         
    );
    people #(.RANDOM(500000000)) people4(
        .clk(clk),
        .frame_refresh(frame_refresh),
        .game_reset(game_reset),
        .pause(pause),
        .enter(enter),
        .people_on(people_on[4]),
        .people_kind(people_kind[4]),
        .crash(crash[4]),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .people_rgb(people4_rgb),
        .car_loc(car_loc)         
    );
    
    always @(posedge clk)
    begin
        case(state)
        0: if((pixel_y==481) && (pixel_x==0))
            begin
            frame_refresh<=1'b1;
            state<=2'b1;
            if(LClick && (cursorX>=32) && (cursorX<=128) && (cursorY>=160) && (cursorY<=192)) siren_choice<=1;
            else if(LClick && (cursorX>=160) && (cursorX<=256) && (cursorY>=160) && (cursorY<=192)) siren_choice<=0;
            else  siren_choice<=siren_choice;
            end
        1: begin frame_refresh<=1'b0; state<=2'b10; end
        2: state<=2'b11;
        3: state<=2'b00;
        endcase
    end
    
    always @*
        if(~vga_en) RGB=12'b0;
        else
           if(cursor_on) RGB=cursor_rgb;
           else if(text_on) RGB=text_rgb;
           else if(car_on) RGB=car_rgb;
           else if(people_on[0]) RGB=people0_rgb;
           else if(people_on[1]) RGB=people1_rgb;
           else if(people_on[2]) RGB=people2_rgb;
           else if(people_on[3]) RGB=people3_rgb;
           else if(people_on[4]) RGB=people4_rgb;
           else if(yellowline_on) RGB=yellowline_rgb;
           else if(road_on) RGB=road_rgb;
           else RGB=12'h777;
endmodule
