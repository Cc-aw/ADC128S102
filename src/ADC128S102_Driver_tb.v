// ADC128S102_Driver_tb.v
`timescale 1ns / 1ps
module ADC128S102_Driver_tb;
    reg         clk = 1;
    reg         rst_n;
    reg  [ 2:0] Addr;  //选择线
    reg         Conv_go;  //数据从用户输入到驱动使能信号
    reg         dout;  //由ADC芯片 输入到本驱动 

    wire [11:0] data;  //输出11位数据给用户
    wire        conv_done;  //数据输出信号
    wire        cs_n;
    wire        sclk;
    wire        din;

    always #10 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, ADC128S102_Driver_tb);
    end

    initial begin
        rst_n=0;
        Addr=3'b101;
        #100;
        rst_n=1;
        Conv_go=1;

        #400;
        Conv_go=0;
        dout=1;
        #80;
        dout=0;
        #80;
        dout=1;
        #80;
        dout=0;
        #80;
        dout=1;
        #80;
        dout=0;
        #80;
        dout=1;
        #80;
        dout=0;
        #80;
        dout=1;
        #80;
        dout=0;
        #80;
        dout=1;
        #80;
        dout=0;
        #200;
         Conv_go=1;

        #400;
        Conv_go=0;
        dout=0;
        #80;
        dout=1;
        #80;
        dout=0;
        #80;
        dout=1;
        #80;
        dout=0;
        #80;
        dout=1;
        #80;
        dout=0;
        #80;
        dout=1;
        #80;
        dout=0;
        #80;
        dout=1;
        #80;
        dout=0;
        #80;
        dout=1;
        #200;

        $finish;
    end

    ADC128S102_Driver u_ADC128S102_Driver (
        .clk      (clk),
        .rst_n    (rst_n),
        .Addr     (Addr),
        .Conv_go  (Conv_go),
        .dout     (dout),
        .data     (data),
        .conv_done(conv_done),
        .cs_n     (cs_n),
        .sclk     (sclk),
        .din      (din)
    );


endmodule
