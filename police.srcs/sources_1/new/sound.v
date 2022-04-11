`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: 
// Module Name: sound
//////////////////////////////////////////////////////////////////////////////////

module sound(
    input CLK,
    input sound_data,
    output pwm,
    output aud_on,
    input speaker
);
    reg [4:0]clk_cntr_reg;
    reg pwm_val_reg;
    always @(posedge CLK)
    begin
        clk_cntr_reg <= clk_cntr_reg + 1;
    end
    always @(posedge CLK)
    begin
        if(clk_cntr_reg == 5'b00011) 
        begin
            pwm_val_reg <= sound_data;
        end
    end
    assign pwm = (speaker==1)? pwm_val_reg:0;
    assign aud_on = 1;
endmodule
