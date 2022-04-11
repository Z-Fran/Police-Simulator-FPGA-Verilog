`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: 
// Module Name: mous
//////////////////////////////////////////////////////////////////////////////////
module mouse(
    input             clk,
    input             rst,
    output reg [9:0] x,y,
    output reg       leftClick, rightClick,
    inout             USB_CLOCK,
    inout             USB_DATA
    );
    
    // 状态机
    parameter [3:0] IDLE = 4'd0;
    parameter [3:0] SEND_RESET = 4'd1;
    parameter [3:0] WAIT_ACKNOWLEDGE1 = 4'd2;
    parameter [3:0] WAIT_SELF_TEST = 4'd3;
    parameter [3:0] WAIT_MOUSE_ID = 4'd4;
    parameter [3:0] ENABLE_DATA_REPORT = 4'd5;
    parameter [3:0] WAIT_ACKNOWLEDGE2 = 4'd6;
    parameter [3:0] GET_DATA1 = 4'd7;
    parameter [3:0] GET_DATA2 = 4'd8;
    parameter [3:0] GET_DATA3 = 4'd9;    
    reg [3:0] state;
    reg [3:0] next_state;
    
    wire   USB_CLOCK_OE;
    wire   USB_DATA_OE;
    wire   USB_CLOCK_out;
    wire   USB_CLOCK_in;
    wire   USB_DATA_out;
    wire   USB_DATA_in;
    assign USB_CLOCK = (USB_CLOCK_OE) ? USB_CLOCK_out : 1'bz;   
    assign USB_DATA = (USB_DATA_OE) ? USB_DATA_out : 1'bz;
    assign USB_CLOCK_in = USB_CLOCK;
    assign USB_DATA_in = USB_DATA;
    
    wire       PS2_valid;
    wire [7:0] PS2_data_in;
    wire       PS2_busy;
    wire       PS2_error;
    wire       PS2_complete;
    reg        PS2_enable;
    (* dont_touch = "true" *)reg  [7:0] PS2_data_out;
     
    ps2_transmitter ps2_transmitter(
        .clk(clk),
        .rst(rst),
        .clock_in(USB_CLOCK_in),
        .serial_data_in(USB_DATA_in),
        .parallel_data_in(PS2_data_in),
        .parallel_data_valid(PS2_valid),
        .busy(PS2_busy),
        .data_in_error(PS2_error),
        .clock_out(USB_CLOCK_out),
        .serial_data_out(USB_DATA_out),
        .parallel_data_out(PS2_data_out),
        .parallel_data_enable(PS2_enable),
        .data_out_complete(PS2_complete),       
        .clock_output_oe(USB_CLOCK_OE),
        .data_output_oe(USB_DATA_OE)
    );
      reg x_new,y_new;
      reg x_sign, y_sign, x_overflow, y_overflow;
      reg[7:0] deltaX, deltaY;
      wire [7:0] deltaX_sign, deltaY_sign;
      
      assign deltaX_sign = ~deltaX + 1'b1;
      assign deltaY_sign = ~deltaY + 1'b1;
      always @(posedge clk) begin
        if(x_new && y_new) begin
            if(x_sign) begin
                if(x_overflow) begin 
                    if(x - 255 < 10'd640)  x <= x - 255;
                    else x <= 0;
                end
                else begin
                    if(x -deltaX_sign < 10'd640) x <= x - deltaX_sign;
                    else x <= 0;
                end 
            end
            else 
            begin if(x_overflow) 
                    if(x + 255 < 10'd640) x <= x + 255;
                    else x <= 10'd640;
                else begin
                    if(x + deltaX < 10'd640) x <= x + deltaX;
                    else x <= 10'd640;
                end 
            end
            
            if(y_sign) begin 
                if(y_overflow) begin 
                    if(y + 255 < 10'd480)  y <= y + 255;
                    else y <= 10'd480;
                end
                else begin
                    if(y + deltaY_sign < 10'd480) y <= y + deltaY_sign;
                    else y <= 10'd480;
                end 
            end
            else begin  
                if(y_overflow) begin
                    if(y - 255 < 10'd640) y <= y - 255;
                    else y <= 10'd0;
                 end
                else begin
                    if(y - deltaY < 10'd640) y <= y - deltaY;
                    else y <= 10'd0;
                end 
            end
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end

        
    always @(posedge clk) begin
        case(state)
        IDLE: begin
            next_state <= SEND_RESET;
            PS2_enable <= 1'b0;
            PS2_data_out <= 8'h00;
        end
        // FF复位指令
        SEND_RESET: begin
            if(~PS2_busy && PS2_complete) begin
                next_state <= WAIT_ACKNOWLEDGE1;
                PS2_enable <= 1'b0;
            end
            else begin
                next_state <= SEND_RESET;
                PS2_enable <= 1'b1;
                PS2_data_out <= 8'hFF;
            end
        end
        // 等待自测完成
        WAIT_ACKNOWLEDGE1: begin
            if(PS2_valid && (PS2_data_in == 8'hFA)) begin   
                next_state <= WAIT_SELF_TEST;
            end
            else begin
                next_state <= WAIT_ACKNOWLEDGE1;
            end
        end
        // 完成自测，鼠标发送AA
        WAIT_SELF_TEST: begin
            if(PS2_valid && (PS2_data_in == 8'hAA)) begin 
                next_state <= WAIT_MOUSE_ID;
            end
            else begin
                next_state <= WAIT_SELF_TEST;
            end
        end
        // 鼠标发送设备号00
        WAIT_MOUSE_ID: begin
            if(PS2_valid && (PS2_data_in == 8'h00)) begin 
                next_state <= ENABLE_DATA_REPORT;
            end
            else begin
                next_state <= WAIT_MOUSE_ID;
            end
        end
        // 发送数据流使能指令
        ENABLE_DATA_REPORT: begin
            if(~PS2_busy && PS2_complete) begin
                next_state <= WAIT_ACKNOWLEDGE2;
                PS2_enable <= 1'b0;
            end
            else begin
                next_state <= ENABLE_DATA_REPORT;
                PS2_enable <= 1'b1;
                PS2_data_out <= 8'hF4;
            end
        end
        // 等待鼠标回应FA
        WAIT_ACKNOWLEDGE2: begin
            if(PS2_valid && (PS2_data_in == 8'hFA)) begin 
                next_state <= GET_DATA1;
            end
            else begin
                next_state <= WAIT_ACKNOWLEDGE2;
            end
        end
        //开始循环接收数据
        GET_DATA1: begin
            x_new <= 1'b0;
            y_new <= 1'b0;
            if(PS2_valid) begin
                x_sign <= PS2_data_in[4];
                y_sign <= PS2_data_in[5];
                y_overflow <= PS2_data_in[7];
                x_overflow <= PS2_data_in[6];
                leftClick <= PS2_data_in[0];
                rightClick <= PS2_data_in[1];
                next_state <= GET_DATA2;
            end
            else begin
                next_state <= GET_DATA1;
            end
        end
        GET_DATA2: begin
            if(PS2_valid) begin
                deltaX <= PS2_data_in;
                next_state <= GET_DATA3;
                x_new <= 1'b1;
            end
            else begin
                next_state <= GET_DATA2;
                y_new <= 1'b0;
            end
        end
        GET_DATA3: begin
            if(PS2_valid) begin
                deltaY <= PS2_data_in;
                next_state <= GET_DATA1;
                y_new <= 1'b1;
            end
            else begin
                next_state <= GET_DATA3;
                y_new <= 1'b0;
            end
        end
        endcase
    end   
endmodule
