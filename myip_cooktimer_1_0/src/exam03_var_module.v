`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2025 09:38:53 AM
// Design Name: 
// Module Name: exam03_var_module
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


//module watch(
//    input clk, reset_p,
//    input [2:0] btn,
//    output reg [7:0] sec, min);
    
//    reg set_watch; //1이면 set 0이면 watch
//    always @(posedge clk, posedge reset_p)begin
//        if(reset_p)set_watch = 0;
//        else if(btn[0])set_watch = ~set_watch;
//    end
    
//    integer cnt_sysclk;
//    always@(posedge clk, posedge reset_p)begin
//        if(reset_p)begin
//            cnt_sysclk = 0;
//            sec = 0;
//            min = 0;
//        end
//        else begin
//            if(set_watch) begin
//                if(btn[1])begin
//                    if(sec >=59) sec= 0;
//                    else sec= sec+1;
//                end
//                if(btn[2]) begin
//                    if(min >=59) min= 0;
//                    else min= min+1;
//                end
//            end
//            else begin
//                if(cnt_sysclk >= 27'd99_999_999)begin
//                    cnt_sysclk = 0;
//                    if(sec>=59)begin
//                        sec=0;
//                        if(min>=59) min= 0;
//                        else min=min+1;
//                    end
//                    else sec = sec+1;
//                end
//                else cnt_sysclk =cnt_sysclk +1;
//            end
//        end
    
//    end
//endmodule


module watch(
    input clk, reset_p,
    input enable,          // ⭐ 추가된 포트 (Top 제어용)
    input [2:0] btn,
    output reg [7:0] sec, min
);
    
    reg set_watch; //1이면 set 0이면 watch
    always @(posedge clk, posedge reset_p) begin
        if (reset_p)
            set_watch = 0;
        else if (enable && btn[0])   // ⭐ enable만 추가
            set_watch = ~set_watch;
    end
    
    integer cnt_sysclk;

    always @(posedge clk, posedge reset_p) begin
        if (reset_p) begin
            cnt_sysclk = 0;
            sec = 0;
            min = 0;
        end
        else if (enable) begin       // ⭐ enable 가드만 추가
            if (set_watch) begin
                if (btn[1]) begin
                    if (sec >= 59) sec = 0;
                    else sec = sec + 1;
                end
                if (btn[2]) begin
                    if (min >= 59) min = 0;
                    else min = min + 1;
                end
            end
            else begin
                if (cnt_sysclk >= 27'd99_999_999) begin
                    cnt_sysclk = 0;
                    if (sec >= 59) begin
                        sec = 0;
                        if (min >= 59) min = 0;
                        else min = min + 1;
                    end
                    else sec = sec + 1;
                end
                else cnt_sysclk = cnt_sysclk + 1;
            end
        end
    end
endmodule







module cook_timer(
    input clk, reset_p,
    input [7:0] set_sec, set_min,
    input dcnt_start, //모드 바꾸기 
    input alarm_off,
    output reg [7:0] sec, min,
    output reg alarm);
    
    wire dcnt_start_pedge;
    edge_detector_n ed_start(.clk(clk),.reset_p(reset_p),
                    .cp(dcnt_start),.p_edge(dcnt_start_pedge));
    reg dcnt_set;
    
    always @(negedge clk, posedge reset_p)begin
        if(reset_p)begin
            alarm = 0;
            dcnt_set=0;
        end
        else begin
            if(dcnt_start_pedge)dcnt_set=1;
            if(sec == 0 && min == 0 && dcnt_set)begin
                alarm = 1;
            end
            if(alarm_off) begin
                alarm = 0;
                dcnt_set=0;
            
            end
        end
    end
    integer cnt_sysclk;
    always @(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            cnt_sysclk = 0;
            sec = 0;
            min = 0;
        end
        else begin
            if(dcnt_set && !alarm)begin
                if(cnt_sysclk >= 99_999_999)begin
                    cnt_sysclk = 0;
                    if(sec == 0 && min)begin
                        sec = 59;
                        min = min - 1;
                    end
                    else sec = sec - 1;
                end
                else cnt_sysclk = cnt_sysclk + 1;
            end
            else if(dcnt_start_pedge)begin
                sec = set_sec;
                min = set_min;
            end
        end
    end

endmodule



//module cook_timer(
//    input clk, reset_p,
//    input enable,              // ⭐ 추가
//    input btn_start, inc_sec, inc_min, alarm_off,
//    output reg [7:0] sec, min,
//    output reg alarm
//);

//    reg dcnt_set;
//    reg [7:0] m_sec, m_min;

//    always @(posedge clk, posedge reset_p) begin
//        if (reset_p) begin
//            dcnt_set = 0;
//            alarm = 0;
//        end
//        else if (enable) begin       // ⭐ enable 가드만 추가
//            if (btn_start && !(sec == 0 && min == 0))
//                dcnt_set = ~dcnt_set;

//            if (sec == 0 && min == 0 && dcnt_set) begin
//                dcnt_set = 0;
//                alarm = 1;
//            end

//            if (alarm_off || inc_sec || inc_min)
//                alarm = 0;

//            if (alarm_off && !dcnt_set && !(sec == 0 && min == 0)) begin
//                m_min = min;
//                m_sec = sec;
//            end
//        end
//    end
    
//    integer cnt_sysclk;

//    always @(posedge clk, posedge reset_p) begin
//        if (reset_p) begin
//            cnt_sysclk = 0;
//            sec = 0;
//            min = 0;
//        end
//        else if (enable) begin       // ⭐ enable 가드만 추가
//            if (dcnt_set) begin
//                if (cnt_sysclk >= 99_999_999) begin
//                    cnt_sysclk = 0;
//                    if (sec == 0 && min) begin
//                        sec = 59;
//                        min = min - 1;
//                    end
//                    else
//                        sec = sec - 1;
//                end
//                else
//                    cnt_sysclk = cnt_sysclk + 1;
//            end
//            else begin
//                if (inc_sec) begin
//                    if (sec >= 59) sec = 0;
//                    else sec = sec + 1;
//                end
//                if (inc_min) begin
//                    if (min >= 59) min = 0;
//                    else min = min + 1;
//                end
//                if (alarm_off && !dcnt_set && sec == 0 && min == 0) begin
//                    min = m_min;
//                    sec = m_sec;
//                end
//            end
//        end
//    end
//endmodule












module stop_watch (
    input clk, reset_p,
    input start_stop,
    input lap,
    input clear,
    input option,
    output reg [7:0] fnd_sec, fnd_c_sec,
    output reg running_stop);
    
   
    
    always@( posedge clk, posedge reset_p)begin
        if(reset_p) begin
            running_stop=0;
        
        end
        else begin
            if(start_stop) running_stop = ~running_stop;
            if(clear) running_stop=0; 
        end
    end

   
    integer cnt_sysclk;
    reg [7:0] sec, c_sec;
    reg [7:0] lap_sec,lap_c_sec; //lap기록 저장 
    reg lap_flag;
    reg present_latestlap; //option버튼이랑 연결됨
    always@( posedge clk, posedge reset_p)begin
        if(reset_p)begin
            cnt_sysclk=0;
            sec=0;
            c_sec=0;
            lap_sec=0;
            lap_c_sec=0;
            lap_flag=0;
            present_latestlap=0;
        end
        else begin
            if(running_stop)begin
                if(cnt_sysclk >= 999_999)begin  //0.01초가 기준
                    cnt_sysclk=0;
                    if(c_sec >=99)begin
                        sec= sec+1;
                        c_sec=0;
                    end   
                    else c_sec = c_sec+1;
                end
                else cnt_sysclk = cnt_sysclk +1;
                if(lap)begin
                    lap_sec=sec;
                    lap_c_sec=c_sec;
                    lap_flag=1;
                    present_latestlap=0;
                end
                if(option)  present_latestlap=~present_latestlap;
            end
            else begin
                if(clear)begin
                    cnt_sysclk=0;
                    sec=0;
                    c_sec=0;
                    lap_sec=0;
                    lap_c_sec=0;
                    lap_flag=0;
                    present_latestlap=0;
                end
            end
        end
    end

    
  
    always@(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            fnd_sec=0;
            fnd_c_sec=0;
        end
        else begin
            if(lap_flag)begin
                fnd_sec=lap_sec;
                fnd_c_sec=lap_c_sec;
                if(present_latestlap)begin
                    fnd_sec=sec;
                    fnd_c_sec=c_sec;
                end
            end
            else begin
                fnd_sec=sec;
                fnd_c_sec=c_sec;
            end
        end
    end
    
    

endmodule


module stop_watch_btn3 (
    input clk, reset_p,
    input start_stop,
    input lap,
    input clear,
    output reg [7:0] fnd_sec, fnd_c_sec);
    
 
    
    reg running_stop;
    always@( posedge clk, posedge reset_p)begin
        if(reset_p) begin
            running_stop=0;
        end
        else begin
            if(start_stop) running_stop = ~running_stop;
            if(clear) running_stop=0;
        end
    end

   
    integer cnt_sysclk;
    reg [7:0] sec, c_sec;
    reg [7:0] lap_sec,lap_c_sec; //lap기록 저장 
    reg lap_flag;
    always@( posedge clk, posedge reset_p)begin
        if(reset_p)begin
            cnt_sysclk=0;
            sec=0;
            c_sec=0;
            lap_sec=0;
            lap_c_sec=0;
            lap_flag=0;
        end
        else begin
            if(running_stop)begin
                if(cnt_sysclk >= 999_999)begin  //0.01초가 기준
                    cnt_sysclk=0;
                    if(c_sec >=99)begin
                        sec= sec+1;
                        c_sec=0;
                    end   
                    else c_sec = c_sec+1;
                end
                else cnt_sysclk = cnt_sysclk +1;
                if(lap)begin
                    lap_sec=sec;
                    lap_c_sec=c_sec;
                    lap_flag=~lap_flag;
                end
                
            end
            else begin
                if(clear)begin
                    cnt_sysclk=0;
                    sec=0;
                    c_sec=0;
                    lap_sec=0;
                    lap_c_sec=0;
                    lap_flag=0;
                end
            end
        
        end
    end

    

    always@(posedge clk, posedge reset_p)begin
        if(reset_p)begin
            fnd_sec=0;
            fnd_c_sec=0;
          
        end
        else begin
            if(lap_flag)begin
                fnd_sec=lap_sec;
                fnd_c_sec=lap_c_sec;
            end
            else begin
                fnd_sec=sec;
                fnd_c_sec=c_sec;
            end
        end
    end
    
    

endmodule


//module stop_watch2(
//    input clk,reset_p,
//    input btn_start,btn_lap,btn_clear,
//    output reg [7:0] fnd_sec, fnd_csec,
//    output reg start_stop,lap);
    
    
//    always@(posedge clk, posedge reset_p)begin
//        if(reset_p)begin
//            start_stop=0;
//        end
//        else begin
//            if(btn_start) start_stop= ~start_stop;
//            else if(btn_clear) start_stop=0;
//        end
//    end
    
//    reg[7:0] sec, csec, lap_sec,lap_csec;
//    integer cnt_sysclk;
//    always @(posedge clk, posedge reset_p)begin
//        if(reset_p)begin
//            cnt_sysclk=0;
//            sec=0;
//            csec=0; 
//        end
//        else begin
//            if(start_stop)begin
//                if(cnt_sysclk >=999_999)begin
//                    cnt_sysclk=0;
//                    if(csec >=99)begin
//                        csec=0;
//                        if(sec >=59)begin
//                            sec=0;
//                        end
//                        else sec=sec+1;
//                    end    
//                    else csec= csec+1;
//                end
//                else cnt_sysclk= cnt_sysclk+1;
//            end
//            if(btn_clear)begin
//                sec=0;
//                csec=0;
//                cnt_sysclk=0;
//            end
//        end
//    end
    
//    always @(posedge clk, posedge reset_p)begin
//        if(reset_p)begin
//            lap_sec=0;
//            lap_csec=0;
//            lap=0;
//        end
//        else begin
//            if(btn_lap)begin
//                if(start_stop)lap= ~lap;
//                lap_sec=sec;
//                lap_csec=csec;    
//            end
//            if(btn_clear)begin
//                lap= 0;
//                lap_sec=0;
//                lap_csec=0;
//            end
//        end
//    end
    
//    always@(posedge clk, posedge reset_p)begin
//        if(reset_p)begin
//            fnd_sec=0;
//            fnd_csec=0;
//        end
//        else begin
//            if(lap)begin
//                fnd_sec=lap_sec;
//                fnd_csec=lap_csec;    
//            end
//            else begin
//                fnd_sec=sec;
//                fnd_csec=csec;
//            end
//        end
//    end
    
//endmodule 



module stop_watch2(
    input clk, reset_p,
    input enable,                 // ⭐ 추가
    input btn_start, btn_lap, btn_clear,
    output reg [7:0] fnd_sec, fnd_csec,
    output reg start_stop, lap
);
    
    always @(posedge clk, posedge reset_p) begin
        if (reset_p) begin
            start_stop = 0;
        end
        else if (enable) begin      // ⭐ enable 가드
            if (btn_start)
                start_stop = ~start_stop;
            else if (btn_clear)
                start_stop = 0;
        end
    end
    
    reg [7:0] sec, csec, lap_sec, lap_csec;
    integer cnt_sysclk;

    always @(posedge clk, posedge reset_p) begin
        if (reset_p) begin
            cnt_sysclk = 0;
            sec = 0;
            csec = 0; 
        end
        else if (enable) begin      // ⭐ enable 가드
            if (start_stop) begin
                if (cnt_sysclk >= 999_999) begin
                    cnt_sysclk = 0;
                    if (csec >= 99) begin
                        csec = 0;
                        if (sec >= 59)
                            sec = 0;
                        else
                            sec = sec + 1;
                    end    
                    else
                        csec = csec + 1;
                end
                else
                    cnt_sysclk = cnt_sysclk + 1;
            end
            if (btn_clear) begin
                sec = 0;
                csec = 0;
                cnt_sysclk = 0;
            end
        end
    end
    
    always @(posedge clk, posedge reset_p) begin
        if (reset_p) begin
            lap_sec = 0;
            lap_csec = 0;
            lap = 0;
        end
        else if (enable) begin      // ⭐ enable 가드
            if (btn_lap) begin
                if (start_stop)
                    lap = ~lap;
                lap_sec = sec;
                lap_csec = csec;    
            end
            if (btn_clear) begin
                lap = 0;
                lap_sec = 0;
                lap_csec = 0;
            end
        end
    end
    
    always @(posedge clk, posedge reset_p) begin
        if (reset_p) begin
            fnd_sec = 0;
            fnd_csec = 0;
        end
        else if (enable) begin      // ⭐ enable 가드
            if (lap) begin
                fnd_sec = lap_sec;
                fnd_csec = lap_csec;    
            end
            else begin
                fnd_sec = sec;
                fnd_csec = csec;
            end
        end
    end
endmodule



