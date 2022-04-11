`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name:顶层模块
// Module Name: police_top
//////////////////////////////////////////////////////////////////////////////////

module police_top(
    //公共
    input CLK, //系统时钟
    input RESET,//系统复位
    
    //Ps2
    inout ps2_clk,//ps2接口时钟
    inout ps2_data,//ps2接口数据
    
    //PWM
    output pwm,//pwm接口
    output aud_on,//The audio output (AUD_PWM) needs to be driven open-drain as opposed to push-pull on the Nexys4.
    input  sound_data,//声音传感器数据
    
    //MP3
    output MP3_RESET,//MP3硬件复位
    output CS,//片选输入信号
    output DCS,//数据片选信号
    output SI,//SPI数据输出
    input  SO,//SPI数据输出
    output SCLK,//MP3内部时钟
    input  DREQ,//数据请求信号
        
    //VGA
    output hsync,   //行同步
    output vsync,   //场同步
    output [11:0] RGB //12位RGB颜色
    );
    wire vga_en;
    wire [9:0] pixel_x,pixel_y;
    wire car_on;
    wire [4:0] people_on,crash,people_kind;
    wire game_reset,pause,wait_start;
    wire vga_clk;
    wire [11:0] score;
    wire [9:0] cursorX,cursorY;
    wire leftClick,rightClick;
    wire enter;
    assign enter=leftClick && cursorX>315;
    wire siren,speaker;
    
    //控制子系统 
    game_state states(
        .CLK(CLK),
        .RESET(RESET),
        .vga_en(vga_en),
        .people_on(people_on),
        .people_kind(people_kind),
        .car_on(car_on),
        .enter(enter),
        .score(score),
        .game_reset(game_reset),
        .pause(pause),
        .wait_start(wait_start),
        .crash(crash)
    );
    //VGA部分
    vga_sync vga(CLK,RESET,hsync,vsync,vga_en,pixel_x,pixel_y,vga_clk);
    vga_display display(
        .clk(CLK),
        .vga_clk(vga_clk),
        .game_reset(game_reset),
        .pause(pause),
        .wait_start(wait_start),
        .vga_en(vga_en),
        .crash(crash),
        .enter(enter),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .people_on(people_on),
        .people_kind(people_kind),
        .car_on(car_on),
        .score(score),
        .RGB(RGB),
        .cursorX(cursorX),
        .cursorY(cursorY),
        .LClick(leftClick),
        .RClick(rightClick),
        .siren(siren),
        .speaker(speaker)
        );
        
    //鼠标部分
    mouse mymouse(
        .clk(CLK),
        .rst(RESET),
        .USB_CLOCK(ps2_clk),
        .USB_DATA(ps2_data),
        .x(cursorX),
        .y(cursorY),
        .leftClick(leftClick),
        .rightClick(rightClick)
    );
    
    //声音传感器部分
    sound sounds(
        .CLK(CLK),
        .sound_data(sound_data),
        .pwm(pwm),
        .aud_on(aud_on),
        .speaker(speaker)
    );
    
    //MP3部分
    siren sirens(
        .CLK(CLK),
        .RESET(RESET),
        .mp3_reset(MP3_RESET),
        .mp3_cs(CS),
        .mp3_dcs(DCS),
        .mp3_SI(SI),
        .mp3_SO(SO),
        .mp3_sclk(SCLK),
        .mp3_DREQ(DREQ),
        .SIREN(siren),
        .CLICK(rightClick),
        .pause(pause)        
    );   
endmodule
