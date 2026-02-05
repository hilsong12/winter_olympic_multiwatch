`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 09:16:19 AM
// Design Name: 
// Module Name: test_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_top(
            input [15:0] slide,
            output [15:0] led );
        
            assign led = slide;
            
endmodule

module FND_top(
    input clk, reset_p,
    input [15:0] hex_value,
    output [7:0] seg,
    output [3:0] com);
     
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value(hex_value), .seg(seg), .com(com));
    
endmodule


module watch_top(
    input clk,reset_p,
    input [3:0] button,
    output [7:0] seg,
    output [3:0] com);
    
    wire [2:0] btn_pedge, btn_nedge;
    button_cntr btncntr0( .clk(clk), .reset_p(reset_p), .btn(button[0]),
                               .btn_pedge(btn_pedge[0]), .btn_nedge(btn_nedge[0]));
    button_cntr btncntr1( .clk(clk), .reset_p(reset_p), .btn(button[1]),
                               .btn_pedge(btn_pedge[1]), .btn_nedge(btn_nedge[1]));
    button_cntr btncntr2( .clk(clk), .reset_p(reset_p), .btn(button[2]),
                               .btn_pedge(btn_pedge[2]), .btn_nedge(btn_nedge[2]));
    
    wire[7:0] sec,min;
    watch watch0(.clk(clk), .reset_p(reset_p), .btn(btn_pedge) ,.sec(sec), .min(min));
    
    wire [7:0] sec_bcd,min_bcd;
    bin_to_dec btd_sec( .bin(sec), .bcd(sec_bcd));
    bin_to_dec btd_min( .bin(min), .bcd(min_bcd));
    
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value({min_bcd,sec_bcd}), .seg(seg), .com(com));
    
endmodule

module cook_timer_top(
    input clk, reset_p,
    input [3:0] button,
    output [7:0] seg,
    output [3:0] com,
    output [15:0] led);


    wire [3:0] btn_pedge, btn_nedge;
    wire alarm;
    
    button_cntr btncntr0( .clk(clk), .reset_p(reset_p), .btn(button[0]),
                               .btn_pedge(btn_pedge[0]), .btn_nedge(btn_nedge[0]));
    button_cntr btncntr1( .clk(clk), .reset_p(reset_p), .btn(button[1]),
                               .btn_pedge(btn_pedge[1]), .btn_nedge(btn_nedge[1]));
    button_cntr btncntr2( .clk(clk), .reset_p(reset_p), .btn(button[2]),
                               .btn_pedge(btn_pedge[2]), .btn_nedge(btn_nedge[2]));
    button_cntr btncntr3( .clk(clk), .reset_p(reset_p), .btn(button[3]),
                               .btn_pedge(btn_pedge[3]), .btn_nedge(btn_nedge[3]));
    
    wire [7:0] sec,min;   //버스일때는 wire 연결해주어야 한다. 한비트때는 자동으로 만들어준다.
    cook_timer ctimer(.clk(clk), .reset_p(reset_p), 
                    .btn_start(btn_pedge[0]), .inc_sec(btn_pedge[1]),
                    .inc_min(btn_pedge[2]), .alarm_off(btn_pedge[3]),
                    .sec(sec) , .min(min), .alarm(alarm));
    
    wire [7:0] sec_bcd,min_bcd;  
    bin_to_dec btd_sec( .bin(sec), .bcd(sec_bcd));
    bin_to_dec btd_min( .bin(min), .bcd(min_bcd));
    
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value({min_bcd,sec_bcd}), .seg(seg), .com(com));
    
   assign led[0] =alarm;
   
endmodule


module stop_watch_top(
    input clk,reset_p,
    input [3:0] button,
    output [7:0] seg,
    output [3:0] com,
    output [15:0] led);
    
    wire [3:0] btn_pedge, btn_nedge;
    button_cntr btncntr0( .clk(clk), .reset_p(reset_p), .btn(button[0]),
                               .btn_pedge(btn_pedge[0]), .btn_nedge(btn_nedge[0]));
    button_cntr btncntr1( .clk(clk), .reset_p(reset_p), .btn(button[1]),
                               .btn_pedge(btn_pedge[1]), .btn_nedge(btn_nedge[1]));
    button_cntr btncntr2( .clk(clk), .reset_p(reset_p), .btn(button[2]),
                               .btn_pedge(btn_pedge[2]), .btn_nedge(btn_nedge[2]));
    button_cntr btncntr3( .clk(clk), .reset_p(reset_p), .btn(button[3]),
                               .btn_pedge(btn_pedge[3]), .btn_nedge(btn_nedge[3]));  //현재 시간이랑 latest 랩타입 확인 
                
    wire [7:0] fnd_sec,fnd_c_sec;                       
//    stop_watch swatch(.clk(clk), .reset_p(reset_p), .start_stop(btn_pedge[0]), .lap(btn_pedge[1]),
//                       .clear(btn_pedge[2]),.option(btn_pedge[3]),.fnd_sec(fnd_sec), .fnd_c_sec(fnd_c_sec),
//                       .running_stop(led[0]));
                       
//    stop_watch_btn3 swatch_btn3 (.clk(clk), .reset_p(reset_p), .start_stop(btn_pedge[0]), .lap(btn_pedge[1]),
//                                 .clear(btn_pedge[2]), .fnd_sec(fnd_sec), .fnd_c_sec(fnd_c_sec));                   
    
    stop_watch2 sw0(.clk(clk), .reset_p(reset_p), .enable(1), 
                   .btn_start(btn_pedge[0]), .btn_lap(btn_pedge[1]),
                    .btn_clear(btn_pedge[2]),
                    .fnd_sec(fnd_sec), .fnd_csec(fnd_c_sec),
                    .start_stop(led[0]), .lap(led[1]));
    
    
    wire [7:0] sec_bcd,c_sec_bcd;  
   
    bin_to_dec btd_sec( .bin(fnd_sec), .bcd(sec_bcd));
    bin_to_dec btd_c_sec ( .bin(fnd_c_sec), .bcd(c_sec_bcd));
    
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value({sec_bcd,c_sec_bcd}), .seg(seg), .com(com)); 
endmodule

module multiple_watch(
    input clk,reset_p,
    input [3:0] button,
    input sw,
    output [7:0] seg,
    output [3:0] com,
    output [15:0] led);
    
    wire [3:0] btn_pedge, btn_nedge;
    button_cntr btncntr0( .clk(clk), .reset_p(reset_p), .btn(button[0]),
                               .btn_pedge(btn_pedge[0]), .btn_nedge(btn_nedge[0]));
    button_cntr btncntr1( .clk(clk), .reset_p(reset_p), .btn(button[1]),
                               .btn_pedge(btn_pedge[1]), .btn_nedge(btn_nedge[1]));
    button_cntr btncntr2( .clk(clk), .reset_p(reset_p), .btn(button[2]),
                               .btn_pedge(btn_pedge[2]), .btn_nedge(btn_nedge[2]));
    button_cntr btncntr3( .clk(clk), .reset_p(reset_p), .btn(button[3]),
                               .btn_pedge(btn_pedge[3]), .btn_nedge(btn_nedge[3]));
                               
    wire [2:0] mode_select;                         
    ring_counter_3 r3( .clk(clk), .reset_p(reset_p),.btn_ring(btn_pedge[3]), .q(mode_select));
    
    wire enable_watch = (mode_select == 3'b001);
    wire enable_cook  = (mode_select == 3'b010);
    wire enable_stop  = (mode_select == 3'b100); 
    
    assign led[5]= enable_watch;
    assign led[4]= enable_cook;
    assign led[3]= enable_stop;
    
//---------------------------------------------------------    
    
    wire[7:0] w_sec,w_min;
    watch watch0(.clk(clk), .reset_p(reset_p), .enable(enable_watch),.btn(btn_pedge[2:0]) ,.sec(w_sec), .min(w_min));
    
    wire [7:0] w_sec_bcd,w_min_bcd;
    bin_to_dec btd_sec( .bin(w_sec), .bcd(w_sec_bcd));
    bin_to_dec btd_min( .bin(w_min), .bcd(w_min_bcd));
//----------------------------------------------------------------
    
    
    
    wire [7:0] sec,min;  
    wire alarm;
    cook_timer ctimer(.clk(clk), .reset_p(reset_p), .enable(enable_cook),
                    .btn_start(btn_pedge[0]), .inc_sec(btn_pedge[1]),
                    .inc_min(btn_pedge[2]), .alarm_off(sw),
                    .sec(sec) , .min(min), .alarm(alarm));
    
    assign led[2] = enable_cook? alarm :1'b0;
    
    wire [7:0] sec_bcd,min_bcd;  
    bin_to_dec c_btd_sec( .bin(sec), .bcd(sec_bcd));
    bin_to_dec c_btd_min( .bin(min), .bcd(min_bcd));
    
    
 //-------------------------------------------------------------------
    wire [7:0] fnd_sec,fnd_c_sec; 
    wire start_stop, lap;
    stop_watch2 sw0(.clk(clk), .reset_p(reset_p), .enable(enable_stop),
                   .btn_start(btn_pedge[0]), .btn_lap(btn_pedge[1]),
                    .btn_clear(btn_pedge[2]),
                    .fnd_sec(fnd_sec), .fnd_csec(fnd_c_sec),
                    .start_stop(start_stop), .lap(lap));
     
    assign led[0] = enable_stop? start_stop :1'b0;
    assign led[1] = enable_stop? lap :1'b0;
     
    wire [7:0] s_sec_bcd,s_c_sec_bcd;  
   
    bin_to_dec s_btd_sec( .bin(fnd_sec), .bcd(s_sec_bcd));
    bin_to_dec s_btd_c_sec ( .bin(fnd_c_sec), .bcd(s_c_sec_bcd));
//-----------------------------------------------------------              
    
    reg [15:0] fnd_value_sel;

    always @(*) begin
        case (mode_select)
            3'b001: fnd_value_sel = {w_min_bcd, w_sec_bcd};
            3'b010: fnd_value_sel = {min_bcd, sec_bcd};
            3'b100: fnd_value_sel = {s_sec_bcd, s_c_sec_bcd};
            default: fnd_value_sel = 16'h0000;
        endcase
    end
    
    
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value(fnd_value_sel), .seg(seg), .com(com));
    
endmodule


module mutifunction_watch_top(
    input clk, reset_p,
    input [3:0] button,
    input [15:0] slide,
    output [7:0] seg,
    output [3:0] com,
    output [15:0] led,
    output buz);
    
    localparam WATCH = 3'b001;
    localparam COOK_TIMER = 3'b010;
    localparam STOPWATCH = 3'b100;  //define이랑 똑같다. 
    
    wire [3:0] btn_pedge, btn_nedge;
    button_cntr btncntr0( .clk(clk), .reset_p(reset_p), .btn(button[0]),
                               .btn_pedge(btn_pedge[0]), .btn_nedge(btn_nedge[0]));
    button_cntr btncntr1( .clk(clk), .reset_p(reset_p), .btn(button[1]),
                               .btn_pedge(btn_pedge[1]), .btn_nedge(btn_nedge[1]));
    button_cntr btncntr2( .clk(clk), .reset_p(reset_p), .btn(button[2]),
                               .btn_pedge(btn_pedge[2]), .btn_nedge(btn_nedge[2]));
    button_cntr btncntr3( .clk(clk), .reset_p(reset_p), .btn(button[3]),
                               .btn_pedge(btn_pedge[3]), .btn_nedge(btn_nedge[3]));
                            
    reg[2:0] mode, next_mode;
    assign led[7:5] =mode;
    always@(*)begin
        if(reset_p)next_mode= WATCH;
        else if(btn_pedge[3])begin
            if(mode == WATCH) next_mode=COOK_TIMER;
            else if(mode == COOK_TIMER && next_mode == COOK_TIMER) next_mode= STOPWATCH;
            else if(mode == STOPWATCH) next_mode= WATCH;
        end
        else if(mode == COOK_TIMER && (btn_pedge[0] || btn_pedge[1] || btn_pedge[2])) next_mode= WATCH;
        else next_mode= WATCH;
    end
    always@(posedge clk, posedge reset_p)begin
        if(reset_p)mode=WATCH;
        else if(btn_pedge[3]) begin
            mode= next_mode;
        end
    end
    reg [2:0]watch_btn,cook_btn,stopwatch_btn;
    always @(*)begin  //조합회로여서 edge 안쓴다.
        case(mode)
            WATCH: begin
                watch_btn=btn_pedge[2:0];
                cook_btn=0;
                stopwatch_btn=0;
            end
            COOK_TIMER: begin
                watch_btn=0;
                cook_btn=btn_pedge[2:0];
                stopwatch_btn=0;
            end
            STOPWATCH: begin
                watch_btn=0;
                cook_btn=0;
                stopwatch_btn=btn_pedge[2:0];
            end
        endcase
    end
                             
    wire[7:0] watch_sec,watch_min;
    watch watch0(.clk(clk), .reset_p(reset_p), .enable(1), .btn(watch_btn) ,.sec(watch_sec), .min(watch_min));
    
    wire [7:0] cook_sec,cook_min; 
    wire alarm; 
    cook_timer ctimer(.clk(clk), .reset_p(reset_p), .enable(1),
                    .btn_start(cook_btn[0]), .inc_sec(cook_btn[1]),
                    .inc_min(cook_btn[2]), .alarm_off(slide[0]),
                    .sec(cook_sec) , .min(cook_min), .alarm(alarm));
                    
                    
    wire [7:0] stopwatch_sec,stopwatch_csec;                       
    wire start_stop,lap;
    assign led[0]= start_stop;
    assign led[1]= lap;
    stop_watch2 sw0(.clk(clk), .reset_p(reset_p),.enable(1),
                    .btn_start(stopwatch_btn[0]), .btn_lap(stopwatch_btn[1]),
                    .btn_clear(stopwatch_btn[2]),
                    .fnd_sec(stopwatch_sec), .fnd_csec(stopwatch_csec),
                    .start_stop(start_stop), .lap(lap));
    
    wire [7:0] bcd_low,bcd_high, bin_low,bin_high;  
    
    
    assign bin_low = mode == COOK_TIMER ? cook_sec:
                     mode == STOPWATCH ? stopwatch_csec : watch_sec;
    assign bin_high = mode == COOK_TIMER ? cook_min:
                      mode == STOPWATCH ? stopwatch_sec : watch_min;
                
   
    bin_to_dec btd_low(.bin(bin_low), .bcd(bcd_low));
    bin_to_dec btd_high (.bin(bin_high), .bcd(bcd_high));
    
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value({bcd_high,bcd_low}), .seg(seg), .com(com)); 
    
    assign buz =alarm;
    assign led[15] =alarm;
   
endmodule


module play_buzz_top(
    input clk,reset_p,
    output buz);
    
    freq_generator #(.FREQ(15750)) fg( .clk(clk), .reset_p(reset_p), 
                                       .trans_cp(buz));
    //FREQ 값을 800으로 바뀐다.
endmodule


module led_pwm_top(
    input clk,reset_p,
    output led_r,led_g,led_b,
    output [15:0]led,
    output [7:0] seg,
    output [3:0] com );
    
    
    integer cnt;
    always@(posedge clk)cnt= cnt+1;
    
    reg [7:0] cnt_200;
    reg flag; 
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            cnt_200 = 0;
            flag= 0;
        end
        else if(cnt[23] && flag == 0)begin
            flag = 1;
            if(cnt_200 >=199)cnt_200 = 0;
            else cnt_200 = cnt_200 +1;
        end
        else if(cnt[23] ==0) flag = 0;
    end
    
    pwm_Nfreq_Nstep led_pwm (.clk(clk), .reset_p(reset_p), .duty(cnt_200), .pwm(led[0]));
        // 하위비트주면 밝기변화가 너무 빠르다?
    pwm_Nfreq_Nstep led_red (.clk(clk), .reset_p(reset_p), .duty(cnt[27:20]), .pwm(led_r));
    pwm_Nfreq_Nstep led_green (.clk(clk), .reset_p(reset_p), .duty(cnt[28:21]), .pwm(led_g));
    pwm_Nfreq_Nstep led_blue (.clk(clk), .reset_p(reset_p), .duty(cnt[29:22]), .pwm(led_b));
    
    wire [15:0] bcd_duty;
    bin_to_dec btd_duty (.bin(cnt_200), .bcd(bcd_duty));
    
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value(bcd_duty), .seg(seg), .com(com)); 
    

endmodule


module sg_90_top(
    input clk,reset_p,
    input [3:0] button,
    output sg90_pwm,
    output [7:0] seg,
    output [3:0] com);
    
    wire [3:0] btn_pedge, btn_nedge;
    button_cntr btncntr0( .clk(clk), .reset_p(reset_p), .btn(button[0]),
                               .btn_pedge(btn_pedge[0]), .btn_nedge(btn_nedge[0]));
    button_cntr btncntr1( .clk(clk), .reset_p(reset_p), .btn(button[1]),
                               .btn_pedge(btn_pedge[1]), .btn_nedge(btn_nedge[1]));
    button_cntr btncntr2( .clk(clk), .reset_p(reset_p), .btn(button[2]),
                               .btn_pedge(btn_pedge[2]), .btn_nedge(btn_nedge[2]));
    button_cntr btncntr3( .clk(clk), .reset_p(reset_p), .btn(button[3]),
                               .btn_pedge(btn_pedge[3]), .btn_nedge(btn_nedge[3]));
    
    
    reg [7:0] duty;
    always @(posedge clk, posedge reset_p)begin
        if(reset_p) duty=26; // 90도 (중간값)
        else begin
//            if(btn_pedge[1]) duty = duty-1;
//            if(btn_pedge[2]) duty = duty+1;
            if(btn_pedge[1] && duty> 8) duty = duty-1;
            if(btn_pedge[2] && duty <44) duty = duty+1;
        end
    end
    pwm_Nfreq_Nstep #(.PWM_FREQ(50), .DUTY_STEP(360)) sg_pwm(.clk(clk), .reset_p(reset_p), .duty(duty), .pwm(sg90_pwm));
    
    //duty_step을 180에서 360으로 올림   더 잘게 쪼갬 4-> 8, 22->44
//    wire [15:0] bcd_duty;
//    bin_to_dec btd_duty (.bin((duty-8)), .bcd(bcd_duty));
    
        // 1. 진짜 각도를 계산합니다. (0 ~ 180 사이의 숫자가 나옴)
    wire [7:0] real_angle;
    assign real_angle = (duty - 8) * 5;
    
    // 2. 그 각도를 BCD로 바꿉니다.
    wire [15:0] bcd_duty;
    bin_to_dec btd_duty (.bin(real_angle), .bcd(bcd_duty));
    
    // 3. FND에 출력합니다. (이제 끝자리에 0을 강제로 붙이면 안 됩니다!)
    // bcd_duty[11:0]을 쓰면 100의 자리까지 표현됩니다.
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value(bcd_duty), // 그냥 변환된 값 그대로 넣으세요
        .seg(seg), .com(com) );
    
    
//    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value(bcd_duty), .seg(seg), .com(com)); 
//    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value({4'b0,bcd_duty[7:0],4'd0}), .seg(seg), .com(com)); 
endmodule

module adc_ch6_top(
    input clk,reset_p,
    input vauxp6,vauxn6,
    output [7:0] seg,
    output [3:0] com,
    output [15:0] led);
     
    wire [4:0] channel_out;
    wire eoc_out;
    wire [15:0] do_out;
    
    xadc_wiz_0 adc_ch6(
          .daddr_in({2'b00,channel_out}),            // Address bus for the dynamic reconfiguration port
          .dclk_in(clk),             // Clock input for the dynamic reconfiguration port
          .den_in(eoc_out),              // Enable Signal for the dynamic reconfiguration port
          .reset_in(reset_p),            // Reset signal for the System Monitor control logic
          .vauxp6(vauxp6),              // Auxiliary channel 6
          .vauxn6(vauxn6),
          .channel_out(channel_out),         // Channel Selection Outputs
          .do_out(do_out),              // Output data bus for dynamic reconfiguration port
          .eoc_out(eoc_out));        // End of Conversion Signal
     
     wire eoc_out_pedge;
     edge_detector_n( .clk(clk),.reset_p(reset_p), .cp(eoc_out) , .p_edge(eoc_out_pedge));
     
     reg [11:0] adc_value;
     always @(posedge clk, posedge reset_p)begin
        if(reset_p)adc_value=0;
        else if(eoc_out_pedge)adc_value = do_out[15:4];
     end
     
     wire [15:0] bcd_adc_value;
     bin_to_dec btd (.bin(adc_value), .bcd(bcd_adc_value));
     
     FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value(bcd_adc_value), // 그냥 변환된 값 그대로 넣으세요
        .seg(seg), .com(com) );
        
        
     assign led[0] = adc_value[11:8] >= 4'b0001;
     assign led[1] = adc_value[11:8] >= 4'b0010;
     assign led[2] = adc_value[11:8] >= 4'b0011;
     assign led[3] = adc_value[11:8] >= 4'b0100;     
     assign led[4] = adc_value[11:8] >= 4'b0101;
     assign led[5] = adc_value[11:8] >= 4'b0110;
     assign led[6] = adc_value[11:8] >= 4'b0111;
     assign led[7] = adc_value[11:8] >= 4'b1000;   
     assign led[8] = adc_value[11:8] >= 4'b1001;
     assign led[9] = adc_value[11:8] >= 4'b1010;
     assign led[10] = adc_value[11:8] >= 4'b1011;
     assign led[11] = adc_value[11:8] >= 4'b1100;   
     assign led[12] = adc_value[11:8] >= 4'b1101;
     assign led[13] = adc_value[11:8] >= 4'b1110;
     assign led[14] = adc_value[11:8] >= 4'b1111;
    
endmodule

module adc_sequence_top(
    input clk,reset_p,
    input vauxp6,vauxn6,vauxp15,vauxn15,
    output [7:0] seg,
    output [3:0] com,
    output [15:0] led);
    
    wire [4:0] channel_out;
    wire eoc_out;
    wire [15:0] do_out;
    adc_2ch_sequence joystick(
          .daddr_in({2'b00,channel_out}),            // Address bus for the dynamic reconfiguration port
          .dclk_in(clk),             // Clock input for the dynamic reconfiguration port
          .den_in(eoc_out),              // Enable Signal for the dynamic reconfiguration port
          .reset_in(reset_p),            // Reset signal for the System Monitor control logic
          .vauxp6(vauxp6),              // Auxiliary channel 6
          .vauxn6(vauxn6),
          .vauxp15(vauxp15),             // Auxiliary channel 15
          .vauxn15(vauxn15),
          .channel_out(channel_out),         // Channel Selection Outputs
          .do_out(do_out),              // Output data bus for dynamic reconfiguration port
          .eoc_out(eoc_out));        // End of Conversion Signal
         
    reg [11:0] adc_value_x, adc_value_y;
    wire eoc_out_pedge;
     edge_detector_n( .clk(clk),.reset_p(reset_p), .cp(eoc_out) , .p_edge(eoc_out_pedge));
   
     always @(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            adc_value_x=0;
            adc_value_y=0;
        end
        
        else if(eoc_out_pedge) begin
            case(channel_out[3:0])
                6: adc_value_x =do_out[15:4];
                15:adc_value_y =do_out[15:4];
            endcase
        end
     end
     
     wire [7:0] x_bcd, y_bcd;
     bin_to_dec btd_x (.bin(adc_value_x[11:6]), .bcd(x_bcd));
     bin_to_dec btd_y (.bin(adc_value_y[11:6]), .bcd(y_bcd));
     
     FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value({x_bcd,y_bcd}), // 그냥 변환된 값 그대로 넣으세요
        .seg(seg), .com(com) );
        
     assign led[0] = adc_value_x[11:9] >= 8;
     assign led[1] = adc_value_x[11:9] >= 7;
     assign led[2] = adc_value_x[11:9] >= 6;
     assign led[3] = adc_value_x[11:9] >= 5;     
     assign led[4] = adc_value_x[11:9] >= 4;
     assign led[5] = adc_value_x[11:9] >= 3;
     assign led[6] = adc_value_x[11:9] >= 2;
     assign led[7] = adc_value_x[11:9] >= 1;   
     assign led[8] = adc_value_y[11:9] >= 1;
     assign led[9] = adc_value_y[11:9] >= 2;
     assign led[10] = adc_value_y[11:9] >= 3;
     assign led[11] = adc_value_y[11:9] >= 4;  
     assign led[12] = adc_value_y[11:9] >= 5;
     assign led[13] = adc_value_y[11:9] >= 6;
     assign led[14] = adc_value_y[11:9] >= 7;
     assign led[15] = adc_value_y[11:9] >= 8;
    
endmodule

module ultra_sonic_top(
    input clk,reset_p,
    input echo,
    output trig,
    output [7:0] seg,
    output [3:0] com,
    output [15:0] led);
    
    wire [8:0]distance_cm;
    hc_sr04_cntr ultra(.clk(clk),.reset_p(reset_p),.echo(echo),.trig(trig),.distance_cm(distance_cm));
    
    wire [15:0] distance_bcd;
    bin_to_dec btd_distance (.bin(distance_cm), .bcd(distance_bcd));

     
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value(distance_bcd), 
        .seg(seg), .com(com) );

endmodule


module dht11_top(
    input clk, reset_p,
    inout dht11_data,
    output [7:0] seg,
    output [3:0] com,
    output [15:0] led);
    
    wire [7:0] humidity, temperature;
    dht11_cntr dht( clk, reset_p,dht11_data,
                humidity,temperature,led);

    wire [7:0] humidity_bcd, temperature_bcd;
    bin_to_dec btd_humi (.bin(humidity), .bcd(humidity_bcd));
    bin_to_dec btd_tmpr (.bin(temperature), .bcd(temperature_bcd));
     
    FND_cntr fnd(.clk(clk), .reset_p(reset_p), .fnd_value({humidity_bcd,temperature_bcd}), 
        .seg(seg), .com(com) );

endmodule

module i2c_master_top(
    input clk,reset_p,
    input slide,
    input comm_start,
    output scl, sda,
    output [15:0] led);
    
    localparam light_on  = 8'b0000_1000;
    localparam light_off = 8'b0000_0000;
    
    wire [7:0] data;
    wire busy;
    assign data = slide ? light_on : light_off;
    I2C_master i2c(clk, reset_p, 7'h27, data, 1'b0, comm_start, scl, sda, busy,led);
    
endmodule


module i2c_txtlcd_top(
    input clk, reset_p,
    input [3:0] button,
    output scl,sda,
    output [15:0] led);
    
    wire [3:0] btn_pedge;
    button_cntr btncntr0( clk, reset_p, button[0], btn_pedge[0]);
    button_cntr btncntr1( clk, reset_p, button[1], btn_pedge[1]);
    button_cntr btncntr2( clk, reset_p, button[2], btn_pedge[2]);
    button_cntr btncntr3( clk, reset_p, button[3], btn_pedge[3]);
    
    integer cnt_sysclk;
    reg count_clk_e;
    always @(negedge clk, posedge reset_p)begin
        if(reset_p)cnt_sysclk = 0;
        else if(count_clk_e)cnt_sysclk = cnt_sysclk +1;
        else cnt_sysclk = 0;
    end                       

    reg [7:0] send_buffer;
    reg send,rs;
    wire busy;
    i2c_lcd_send_byte send_byte(clk,reset_p, 7'h27, send_buffer,
                               send, rs, scl, sda, busy, led);
    
    localparam IDLE                = 6'b00_0001;
    localparam INIT                = 6'b00_0010;
    localparam SEND_CHARACTER      = 6'b00_0100;
    localparam SHIFT_RIGHT_DISPLAY = 6'b00_1000;
    localparam SHIFT_LEFT_DISPLAY  = 6'b01_0000;
   
    reg [5:0] state,next_state;
    always @(negedge clk, posedge reset_p) begin
        if(reset_p)state = IDLE;
        else state = next_state;
    end
    
    reg init_flag;
    reg [10:0] cnt_data;
    always @( posedge clk, posedge reset_p)begin
        if(reset_p)begin
            next_state = IDLE;
            init_flag =0;
            cnt_data = 0;
            count_clk_e = 0;
            send = 0;
            send_buffer = 0;
            rs = 0;
        end
        else begin
            case(state)
                IDLE                   :begin
                    if(init_flag)begin
                        if(btn_pedge[0])next_state = SEND_CHARACTER;
                        if(btn_pedge[1])next_state = SHIFT_LEFT_DISPLAY;
                        if(btn_pedge[2])next_state = SHIFT_RIGHT_DISPLAY;
                    end
                    else begin
                        if(cnt_sysclk <= 8_000_000)begin
                           count_clk_e = 1; 
                        end
                        else begin
                           count_clk_e = 0;
                           next_state = INIT;
                        end
                    end
                end
                INIT                   :begin
                    if(busy)begin
                        send = 0;
                        if(cnt_data >=6) begin
                            cnt_data = 0;
                            next_state = IDLE;
                            init_flag = 1;
                        end
                    end
                    else if(!send)begin
                        case(cnt_data)
                            0: send_buffer = 8'h33;
                            1: send_buffer = 8'h32;
                            2: send_buffer = 8'h28;
                            3: send_buffer = 8'h0f;
                            4: send_buffer = 8'h01;
                            5: send_buffer = 8'h06;
                        endcase
                        send = 1;
                        cnt_data = cnt_data +1;
                    end
                end
                SEND_CHARACTER         :begin
                    if(busy)begin
                        if(cnt_data >= 9) cnt_data =0;
                        send = 0;
                        next_state= IDLE;
                    end
                    else if(!send)begin
                        rs =1;
//                        send_buffer ="A";
                        send_buffer = "0" +cnt_data;
                        send =1;
                        cnt_data = cnt_data +1;
                    end
                end
                SHIFT_RIGHT_DISPLAY    :begin
                    if(busy)begin
                        send = 0;
                        next_state= IDLE;
                    end
                    else if(!send)begin
                        rs =0;
                        send_buffer =8'h1c;
                        send =1;
                        end
                end
                SHIFT_LEFT_DISPLAY     :begin
                    if(busy)begin
                        send = 0;
                        next_state= IDLE;
                    end
                    else if(!send) begin
                        rs =0;
                        send_buffer =8'h18;
                        send =1;
                    end
                end
            endcase
        end
    end    
    
endmodule



















