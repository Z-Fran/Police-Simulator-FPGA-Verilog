`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: ϵͳ״̬
// Module Name: game_state
//////////////////////////////////////////////////////////////////////////////////

module game_state(
    input CLK,RESET,
    input vga_en,
    input [4:0] people_on,people_kind,
    input car_on,
    input enter,
    output reg [11:0] score,
    output reg game_reset,pause,wait_start,
    output reg [4:0] crash
    );
    
    reg [1:0] state = 2'd0;
    
    always@(posedge CLK)
    begin
        if(RESET) state<=2'b0;
        case(state)      
        2'd0: //�ȴ���Ϸ��ʼ
            if(enter) 
            begin 
                state<= 2'd1;   
                pause<=1'b0; 
                game_reset<=1'b0;
                wait_start<=1'b0; 
            end      
            else
            begin 
                pause<= 1'b1;
                crash=5'b00000; 
                game_reset<= 1'b1;
                wait_start<=1'b1; 
                score<=0;
            end                

        2'd1: //��Ϸ������
            if(vga_en && car_on)
            begin
                if(people_on[0] && people_kind[0]||people_on[1] && people_kind[1]||
                people_on[2] && people_kind[2]||people_on[3] && people_kind[3]||people_on[4] && people_kind[4])
                begin
                pause <=1'b1;
                state <=2'd2;   
                end
                //��ײ�¼����ж�
                else if(people_on[0] && !people_kind[0]) begin score<=score+1; crash[0]=1; end
                else if(people_on[1] && !people_kind[1]) begin score<=score+1; crash[1]=1; end
                else if(people_on[2] && !people_kind[2]) begin score<=score+1; crash[2]=1; end
                else if(people_on[3] && !people_kind[3]) begin score<=score+1; crash[3]=1; end
                else if(people_on[4] && !people_kind[4]) begin score<=score+1; crash[4]=1; end
                else crash=5'b00000;
            end    
                        
        2'd2: if(enter) begin  state<= 2'd3; end //��Ϸʧ��
        2'd3: if(!enter) state<= 2'd0; //��ֱֹ���ֿ�ʼ��Ϸ 
        default: state <= 2'd0;
        endcase
    end
endmodule
