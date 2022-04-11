`timescale 1ns / 1ps

module text(
    input clk,reset,pause,wait_start,enter,
    input frame_refresh,
    output text_on,
    output reg [11:0] text_rgb,
    input [9:0] pixel_x,pixel_y,
    input [11:0] scores,
    input siren_choice,
    input speaker_choice
    );
wire [7:0] font_word;
wire font_bit, time_on, score_on, start_on, crash_on, title_on, paratitle_on, speaker_on;
wire siren1_on,siren2_on,speaker_on;

wire [10:0] time_rom_addr, start_rom_addr, crash_rom_addr, title_rom_addr,paratitle_rom_addr, score_rom_addr, siren1_rom_addr,siren2_rom_addr, speaker_rom_addr;
wire [2:0] time_bit_addr, start_bit_addr, crash_bit_addr, title_bit_addr,paratitle_bit_addr, score_bit_addr, siren1_bit_addr,siren2_bit_addr, speaker_bit_addr;
reg [10:0] rom_addr;
reg [2:0] bit_addr;

assign font_bit = font_word[~bit_addr];

assign text_on = time_on | (start_on&font_bit) |  (crash_on&font_bit) | (title_on&font_bit) | (speaker_on&font_bit)
                | (paratitle_on&font_bit) | (score_on&font_bit) | (siren1_on&font_bit) | (siren2_on&font_bit);

font_rom font_unit(.clk(clk), .addr(rom_addr), .data(font_word)); //×Ö·û±àÂë±í


title (clk,reset,pixel_x,pixel_y,title_on,title_bit_addr,title_rom_addr);
paratitle (clk,reset,pixel_x,pixel_y,paratitle_on,paratitle_bit_addr,paratitle_rom_addr);
time_text (clk, reset, pause, frame_refresh,pixel_x, pixel_y, time_on, time_bit_addr, time_rom_addr);
score (clk, reset, pause, frame_refresh, pixel_x, pixel_y, score_on, score_bit_addr, score_rom_addr,scores);
siren1 (clk, reset,pixel_x,pixel_y, siren1_on, siren1_bit_addr, siren1_rom_addr);
siren2 (clk, reset,pixel_x,pixel_y, siren2_on, siren2_bit_addr, siren2_rom_addr);
speaker (clk, reset,pixel_x,pixel_y, speaker_on, speaker_bit_addr, speaker_rom_addr);
start_text (clk, reset,pixel_x,pixel_y, start_on, start_bit_addr, start_rom_addr,wait_start);
game_over (clk, reset,pixel_x,pixel_y, crash_on, crash_bit_addr, crash_rom_addr,wait_start,pause);

always @*
    begin
    if(time_on)
        begin
        bit_addr <= time_bit_addr;
        rom_addr <= time_rom_addr;
        text_rgb <= 12'h888; 
        if (font_bit)
        text_rgb <= 12'hee0; 
        end
    else if(title_on)
        begin
        bit_addr <= title_bit_addr;
        rom_addr <= title_rom_addr;
        text_rgb <= 12'h55e;
        end  
    else if(paratitle_on)
        begin
        bit_addr <= paratitle_bit_addr;
        rom_addr <= paratitle_rom_addr;
        text_rgb <= 12'h55e;
        end
    else if(score_on)
        begin
        bit_addr <= score_bit_addr;
        rom_addr <= score_rom_addr;
        text_rgb <= 12'hee0; 
        end   
    else if(siren1_on)
       begin
       bit_addr <= siren1_bit_addr;
       rom_addr <= siren1_rom_addr;
       if(siren_choice==1) text_rgb <= 12'h0f0;
       else text_rgb <= 12'hf00;
       end   
    else if(siren2_on)
      begin
      bit_addr <= siren2_bit_addr;
      rom_addr <= siren2_rom_addr;
      if(siren_choice==1) text_rgb <= 12'hf00;
      else text_rgb <= 12'h0f0;
      end
    else if(speaker_on) 
      begin
      bit_addr <= speaker_bit_addr;
      rom_addr <= speaker_rom_addr;
      if(speaker_choice==1) text_rgb <= 12'hfff;
      else text_rgb <= 12'h000;
      end
    else if(start_on)
        begin
        bit_addr <= start_bit_addr;
        rom_addr <= start_rom_addr;
        text_rgb <= 12'h501; 
        end    
    else if(crash_on)
        begin
        bit_addr <= crash_bit_addr;
        rom_addr <= crash_rom_addr;
        text_rgb <= 12'h501; 
        end  
end
endmodule