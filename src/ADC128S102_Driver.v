// ADC128S102_Driver.v
module ADC128S102_Driver (
    input       clk,
    input       rst_n,
    input [2:0] Addr,     //选择线
    input       Conv_go,  //数据从用户输入到驱动使能信号
    input       dout,     //由ADC芯片 输入到本驱动 

    output reg [11:0] data,       //输出11位数据给用户
    output reg        conv_done,  //数据输出信号
    output reg        cs_n,
    output reg        sclk,
    output reg        din         //地址选择
);

    parameter CLOCK_FREQ = 50_000_000;  //50Mhz
    parameter SRCLK_FREQ = 12_500_000;  //12.5Mhz
    parameter MCNT_DIV = CLOCK_FREQ / (SRCLK_FREQ * 2) - 1;

    reg [29:0] div_cnt;
    reg [11:0] r_data;
    reg [ 2:0] r_Addr;
    reg        en;  //使能信号
    //分频计数器 实现12.5Mhz下的最小时间单位 40ns
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            div_cnt <= 0;
        end
        else if (div_cnt == MCNT_DIV) begin
            div_cnt <= 0;
        end
        else begin
            div_cnt <= div_cnt + 1'd1;
        end
    end

    reg [5:0] count;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count <= 6'd0;
        end
        else if ((div_cnt == MCNT_DIV) && (en)) begin
            if (count == 6'd34) begin
                count <= 6'd0;
            end
            else begin
                count <= count + 1'd1;
            end
        end
    end

    //en生产信号
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            en <= 0;
        end
        else if (Conv_go) begin
            en <= 1;
        end
        else if ((count == 34) && (div_cnt == MCNT_DIV)) begin
            en <= 0;
        end
        else begin
            en <= en;
        end
    end

    //暂存addr值 防止addr不稳定
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            r_Addr<=0;
        end
        else begin
            r_Addr<=Addr;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sclk      <= 0;
            conv_done <= 0;
            din       <= 0;
            data      <= 12'd0;
        end
        else if (div_cnt == MCNT_DIV) begin
            case (count)
                0: begin
                    sclk <= 1;
                    cs_n <= 1;
                end
                1: cs_n <= 0;
                2: sclk <= 0;
                3: sclk <= 1;
                4: sclk <= 0;
                5: sclk <= 1;
                6: begin
                    sclk <= 0;
                    din  <= r_Addr[2];
                end
                7: sclk <= 1;
                8: begin
                    sclk <= 0;
                    din  <= r_Addr[1];
                end
                9: sclk <= 1;
                10: begin
                    sclk <= 0;
                    din  <= r_Addr[0];
                end

                11: begin
                    sclk       <= 1;
                    r_data[11] <= dout;
                end
                12:      sclk <= 0;
                13: begin
                    sclk       <= 1;
                    r_data[10] <= dout;
                end
                14:      sclk <= 0;
                15: begin
                    sclk      <= 1;
                    r_data[9] <= dout;
                end
                16:      sclk <= 0;
                17: begin
                    sclk      <= 1;
                    r_data[8] <= dout;
                end
                18:      sclk <= 0;
                19: begin
                    sclk      <= 1;
                    r_data[7] <= dout;
                end
                20:      sclk <= 0;
                21: begin
                    sclk      <= 1;
                    r_data[6] <= dout;
                end
                22:      sclk <= 0;
                23: begin
                    sclk      <= 1;
                    r_data[5] <= dout;
                end
                24:      sclk <= 0;
                25: begin
                    sclk      <= 1;
                    r_data[4] <= dout;
                end
                26:      sclk <= 0;
                27: begin
                    sclk      <= 1;
                    r_data[3] <= dout;
                end
                28:      sclk <= 0;
                29: begin
                    sclk      <= 1;
                    r_data[2] <= dout;
                end
                30:      sclk <= 0;
                31: begin
                    sclk      <= 1;
                    r_data[1] <= dout;
                end
                32:      sclk <= 0;
                33: begin
                    sclk      <= 1;
                    r_data[0] <= dout;
                end
                34: begin
                    cs_n <= 1;
                end
                default: sclk <= 1;
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data      <= 0;
            conv_done <= 0;
        end
        else if ((count == 34) && (div_cnt == MCNT_DIV)) begin
            data      <= r_data;
            conv_done <= 1;
        end
        else begin
            data      <= 0;
            conv_done <= 0;
        end
    end



endmodule
