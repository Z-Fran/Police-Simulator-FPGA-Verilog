`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Design Name: 
// Module Name: siren

//////////////////////////////////////////////////////////////////////////////////


module siren(
    input CLK,RESET,
    output reg mp3_reset=1,
    output reg mp3_cs=1,
    output reg mp3_dcs=1,
    output reg mp3_SI=0,
    output reg mp3_sclk=0,
    input mp3_SO,mp3_DREQ,
    input SIREN,CLICK,pause
);      
    wire clk;
    Divider #(100) divider(CLK,clk);

    integer cnt=0;
    integer cmd_cnt=0;
    parameter cmd_cnt_max=4;
    reg [31:0] next_cmd;
    reg [127:0] cmd_init={32'h02000804,32'h02000804,32'h020B0000,32'h020000800};
    reg [127:0] cmd={32'h02000804,32'h02000804,32'h020B0000,32'h020000800};
    //0x0 MODE寄存器 bit2 软复位 bit11本地模式 最大音量0000
    wire [15:0] siren1;
    wire [15:0] siren2;
    reg [15:0] data;
    reg [20:0] addr=0;
    blk_mem_gen_1 siren_1(.clka(CLK),.addra(addr[16:0]),.douta(siren1));
    blk_mem_gen_2 siren_2(.clka(CLK),.addra(addr[16:0]),.douta(siren2));

    parameter INITIALIZE = 3'd0;
    parameter SEND_CMD = 3'd1;
    parameter WAIT = 3'd2;
    parameter DATA_SEND = 3'd3;
    parameter RSET_OVER = 3'd4;

    reg[2:0] state=0;
    always @(posedge clk) begin
        if(RESET) begin
            mp3_reset<=0;
            cmd_cnt<=0;
            state<=RSET_OVER;
            cmd<=cmd_init;
            mp3_sclk<=0;
            mp3_cs<=1;
            mp3_dcs<=1;
            cnt<=0;
            addr<=0;
        end
        else begin
            case(state)
            INITIALIZE:begin
                mp3_sclk<=0;
                if(cmd_cnt>=cmd_cnt_max) begin
                    state<=WAIT;
                end
                else if(mp3_DREQ) begin
                    mp3_cs<=0;
                    cnt<=1;
                    state<=SEND_CMD;
                    mp3_SI<=cmd[127];
                    cmd<={cmd[126:0],cmd[127]};
                end
            end
            SEND_CMD:begin
                if(mp3_DREQ) begin
                    if(mp3_sclk) begin
                        if(cnt<32)begin
                            cnt<=cnt+1;
                            mp3_SI<=cmd[127];
                            cmd<={cmd[126:0],cmd[127]};
                        end
                        else begin
                            mp3_cs<=1;
                            cnt<=0;
                            cmd_cnt<=cmd_cnt+1;
                            state<=INITIALIZE;
                        end
                    end
                    mp3_sclk<=~mp3_sclk;
                end
            end
            WAIT:begin
                if(mp3_DREQ & CLICK & !pause) begin
                    mp3_dcs<=0;
                    mp3_sclk<=0;
                    state<=DATA_SEND;
                    if(SIREN)begin
                        data<={siren1[14:0],siren1[15]};
                        mp3_SI<=siren1[15];
                    end
                    else begin
                        data<={siren2[14:0],siren2[15]};
                        mp3_SI<=siren2[15];
                    end                    
                    cnt<=1;
                end
            end
            DATA_SEND:begin 
                if(mp3_sclk)begin
                    if(cnt<16)begin
                        cnt<=cnt+1;
                        mp3_SI<=data[15];
                        data<={data[14:0],data[15]};
                    end
                    else begin
                        mp3_dcs<=1;
                        addr<=addr+1;
                        state<=WAIT;
                    end
                end
                mp3_sclk<=~mp3_sclk;
            end
            RSET_OVER:begin
                if(cnt<1000000) begin
                    cnt<=cnt+1;
                end
                else begin
                    cnt<=0;
                    state<=INITIALIZE;
                    mp3_reset<=1;
                end
            end
            endcase
        end
    end
endmodule

