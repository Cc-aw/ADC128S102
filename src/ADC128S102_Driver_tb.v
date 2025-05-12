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
        rst_n   = 0;
        Conv_go = 0;
        Addr    = 0;
        #101;
        rst_n = 1;
        #100;
        Conv_go = 1;
        Addr    = 3;
        #20;
        Conv_go = 0;
        wait(!cs_n);
        @(negedge sclk);
        dout=0;//DB15
        @(negedge sclk);
        dout=0;//DB14
        @(negedge sclk);
        dout=0;//DB13
        @(negedge sclk);
        dout=0;//DB12
        @(negedge sclk);
        dout=1;//DB11
        @(negedge sclk);
        dout=0;//DB10
        @(negedge sclk);
        dout=1;//DB9
        @(negedge sclk);
        dout=0;//DB8
        @(negedge sclk);
        dout=1;//DB7
        @(negedge sclk);
        dout=0;//DB6
        @(negedge sclk);
        dout=1;//DB5
        @(negedge sclk);
        dout=0;//DB4
        @(negedge sclk);
        dout=1;//DB3
        @(negedge sclk);
        dout=0;//DB2
        @(negedge sclk);
        dout=1;//DB1
        @(negedge sclk);
        dout=0;//DB0
        #100;
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
