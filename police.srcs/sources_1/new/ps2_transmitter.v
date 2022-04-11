`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: 
// Module Name: ps2_transmitter
//////////////////////////////////////////////////////////////////////////////////


module ps2_transmitter(
    input            clk,
    input            rst,
    
    // 数据输入
    input            clock_in,           // ps2_Clk
    input            serial_data_in,     // ps2_data
    output reg [7:0] parallel_data_in,   // 转并行
    output reg       parallel_data_valid,// 是否开始数据输入
    output reg       data_in_error,      // 奇偶校验错误
    
    // 数据输出
    output reg       clock_out,          
    output reg       serial_data_out,  
    input      [7:0] parallel_data_out,   
    input            parallel_data_enable, //开始写数据指令
    output reg       data_out_complete,
    
    output reg       busy,                // 正在传输
    output reg       clock_output_oe,    
    output reg       data_output_oe    
    );
    
    //状态机
    parameter [3:0] IDLE = 4'd0;
    parameter [3:0] WAIT_IO = 4'd1;
    parameter [3:0] DATA_IN = 4'd2;
    parameter [3:0] DATA_OUT = 4'd3;
    parameter [3:0] INITIALIZE = 4'd4;
    reg  [3:0]  state;
    reg  [3:0]  next_state;
    
    //并行数据buffer
    reg  [10:0] data_out_buf;
    reg  [10:0] data_in_buf;
    reg  [3:0]  data_count;
    reg  [15:0] clock_count;
    
    // 检测下降沿则鼠标发出数据请求，开始接收数据（检测到时钟由高电平变低电平即为下降沿）
    reg  [1:0]  clock_in_delay;
    wire        clock_in_negedge;
    always @(posedge clk) begin
        clock_in_delay <= {clock_in_delay[0], clock_in};
    end
    assign clock_in_negedge = (clock_in_delay == 2'b10) ? 1'b1 : 1'b0;
    
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
        IDLE: begin //初始化
            next_state <= WAIT_IO;
            clock_output_oe <= 1'b0;
            data_output_oe <= 1'b0;
            data_in_error <= 1'b0;
            data_count <= 4'd0;
            busy <= 1'b0;
            parallel_data_valid <= 1'b0;
            clock_count <= 16'd0;
            data_in_buf <= 11'h0;
            data_out_buf <= 11'h0;
            clock_out <= 1'b1;
            serial_data_out <= 1'b1;
            data_out_complete <= 1'b0;
            parallel_data_in <= 8'h00;
        end

        WAIT_IO: begin  //等待输入输出请求，离开此状态时则busy变有效
            if(clock_in_negedge) begin  // 鼠标时钟下降沿时进入数据输入状态
                next_state <= DATA_IN;
                busy <= 1'b1;
                data_count <= 4'd0;
            end
            else if(parallel_data_enable) begin // 输出使能时进入数据输出状态
                next_state <= INITIALIZE;
                busy <= 1'b1;
                data_count <= 4'd0;
                clock_output_oe <= 1'b1;
                clock_out <= 1'b0; //拉低鼠标时钟
                data_out_buf <= {parallel_data_out[0],parallel_data_out[1],parallel_data_out[2],parallel_data_out[3],
                                 parallel_data_out[4],parallel_data_out[5],parallel_data_out[6],parallel_data_out[7],
                                 ~^(parallel_data_out), 2'b11};//~^按位异或形成奇偶校验码
                data_output_oe <= 1'b1;
                serial_data_out <= 1'b0;
            end
        end
      
        DATA_IN: begin
            if(clock_in_negedge && (data_count < 4'd10)) begin //每次接收10位数据
                data_in_buf <= {data_in_buf[9:0], serial_data_in};
                data_count <= data_count + 4'd1;
            end
            else if(data_count == 4'd10) begin
                next_state <= IDLE;
                data_count <= 4'd0;
                busy <= 1'b0;
                parallel_data_valid <= 1'b1;
                parallel_data_in <= {data_in_buf[2],data_in_buf[3],data_in_buf[4],data_in_buf[5],
                                     data_in_buf[6],data_in_buf[7],data_in_buf[8],data_in_buf[9]};//逆向输出
                if(data_in_buf[1] == ^(data_in_buf[9:2])) begin
                    data_in_error <= 1'b1;//奇偶校验
                end
            end
        end
        // 拉低60微妙
        INITIALIZE : begin
            if(clock_count < 16'd6000) begin
                clock_count <= clock_count + 16'd1;
                clock_output_oe <= 1'b1;
                clock_out <= 1'b0;
            end
            else begin
                next_state <= DATA_OUT;
                clock_output_oe <= 1'b0;
                clock_out <= 1'b1;
            end
        end
        // 鼠标开始接收剩下的10位指令
        DATA_OUT : begin
            if(clock_in_negedge) begin
                if(data_count < 4'd10) begin
                    data_count <= data_count + 4'd1;
                    serial_data_out <= data_out_buf[10];
                    data_out_buf <= {data_out_buf[9:0], 1'b0};
                end
                else if(data_count == 4'd10) begin
                    data_out_complete <= 1'b1;
                    next_state <= IDLE;
                    busy <= 1'b0;
                end
            end
        end
        endcase
    end
endmodule

