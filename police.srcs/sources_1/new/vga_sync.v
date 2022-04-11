`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: vga时序部分
// Module Name: vga_sync
//////////////////////////////////////////////////////////////////////////////////
module vga_sync(
    input CLK,
    input RESET,
    output hsync,vsync,
    output vga_en,
    output [9:0] pixel_x,pixel_y,
    output vga_clk
    );
    
    localparam h_total=800;//同步96+显示后沿48有效数据640+显示前沿16
    localparam v_total=525;//同步2+显示后沿33有效数据480+显示前沿10
    localparam h_s=96;
    localparam h_b=16;
    localparam h_d=640;
    localparam h_f=48;
    localparam v_s=2;
    localparam v_b=33;
    localparam v_d=480;
    localparam v_f=10;
    
    reg [1:0] cnt_clk; //生成25MHx时钟
    reg [9:0] cnt_h,cnt_v;
    reg [9:0] cnt_h_next,cnt_v_next;
    reg h_sync,v_sync;
    wire h_sync_next,v_sync_next;
     
    always @(posedge CLK,posedge RESET)
        if(RESET)   //复位
            begin
            cnt_clk<=0;
            cnt_h<=0;
            cnt_v<=0;
            v_sync<=0;
            h_sync<=0;
            end
        else
            begin
            cnt_clk<=cnt_clk+1;
            cnt_h<=cnt_h_next;
            cnt_v<=cnt_v_next;
            h_sync<=h_sync_next;
            v_sync<=v_sync_next;
            end
    
    //行计数器计数    
    always @*
        if(vga_clk)    
            if(cnt_h==h_total-1)
                cnt_h_next=0;
            else
                cnt_h_next=cnt_h+1;
        else cnt_h_next=cnt_h;  
     //场计数器计数  
    always @*
        if(vga_clk & cnt_h==h_total-1)
            if(cnt_v==v_total-1)
                cnt_v_next=0;
            else
                cnt_v_next=cnt_v+1;
        else cnt_v_next=cnt_v;

assign h_sync_next = (cnt_h>=(h_d+h_b) && cnt_h<=(h_d+h_b+h_s-1));
assign v_sync_next = (cnt_v>=(v_d+v_b) && cnt_v<=(v_d+v_b+v_s-1));    
                    
assign vga_clk=&cnt_clk;//缩减与              
assign pixel_x=cnt_h;
assign pixel_y=cnt_v;
assign hsync=h_sync;     
assign vsync=v_sync;
assign vga_en=(cnt_h<h_d)&&(cnt_v<v_d);               
endmodule