`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name:����ģ��
// Module Name: police_top
//////////////////////////////////////////////////////////////////////////////////

module police_top(
    //����
    input CLK, //ϵͳʱ��
    input RESET,//ϵͳ��λ
    
    //Ps2
    inout ps2_clk,//ps2�ӿ�ʱ��
    inout ps2_data,//ps2�ӿ�����
    
    //PWM
    output pwm,//pwm�ӿ�
    output aud_on,//The audio output (AUD_PWM) needs to be driven open-drain as opposed to push-pull on the Nexys4.
    input  sound_data,//��������������
    
    //MP3
    output MP3_RESET,//MP3Ӳ����λ
    output CS,//Ƭѡ�����ź�
    output DCS,//����Ƭѡ�ź�
    output SI,//SPI�������
    input  SO,//SPI�������
    output SCLK,//MP3�ڲ�ʱ��
    input  DREQ,//���������ź�
        
    //VGA
    output hsync,   //��ͬ��
    output vsync,   //��ͬ��
    output [11:0] RGB //12λRGB��ɫ
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
    
    //������ϵͳ 
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
    //VGA����
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
        
    //��겿��
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
    
    //��������������
    sound sounds(
        .CLK(CLK),
        .sound_data(sound_data),
        .pwm(pwm),
        .aud_on(aud_on),
        .speaker(speaker)
    );
    
    //MP3����
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
