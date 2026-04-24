`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench: shaper_tb
// DUT     : shaper
// Aplica impulso unitario, sinal zero e um degrau para verificar a saida do filtro
//////////////////////////////////////////////////////////////////////////////////

module shaper_tb;

    // Parametros do DUT
    localparam NBITS_IN = 33;
    localparam FB       = 15;

    // Periodo de clock (10 ns -> 100 MHz)
    localparam CLK_PERIOD = 10;

    // Sinais
    reg                          clk = 0;
    reg  signed [NBITS_IN-1:0]   x   = 0;
    wire signed [NBITS_IN+14:0]  y;

    // Instancia do DUT
    shaper #(
        .NBITS_IN(NBITS_IN),
        .FB(FB)
    ) dut (
        .clk(clk),
        .x(x),
        .y(y)
    );

    // Geracao de clock
    always #(CLK_PERIOD/2) clk = ~clk;

    // Dump de ondas (compativel com Icarus/ModelSim/Vivado)
    initial begin
        $dumpfile("shaper_tb.vcd");
        $dumpvars(0, shaper_tb);
    end

    // Sequencia de estimulos
    integer i;
    initial begin
        // -----------------------------------------------
        // Reset: entrada zero por 10 ciclos
        // -----------------------------------------------
        x = 0;
        repeat (10) @(posedge clk);

        // -----------------------------------------------
        // Impulso unitario: x = 1 por 1 ciclo
        // -----------------------------------------------
        @(negedge clk);
        x = 1;
        @(posedge clk);
        @(negedge clk);
        x = 0;

        // Observa resposta ao impulso por 50 ciclos
        repeat (50) @(posedge clk);

        // -----------------------------------------------
        // Degrau: x = 2^(FB-1) = 16384 (equivale a 0.5 em Q15)
        // -----------------------------------------------
        @(negedge clk);
        x = (1 << (FB-1));   // 16384

        repeat (100) @(posedge clk);

        // -----------------------------------------------
        // Valor maximo positivo
        // -----------------------------------------------
        @(negedge clk);
        x = (1 << (NBITS_IN-1)) - 1;   // 2^32 - 1

        repeat (20) @(posedge clk);

        // -----------------------------------------------
        // Valor maximo negativo
        // -----------------------------------------------
        @(negedge clk);
        x = -(1 << (NBITS_IN-1));       // -2^32

        repeat (20) @(posedge clk);

        // -----------------------------------------------
        // Zero novamente
        // -----------------------------------------------
        @(negedge clk);
        x = 0;
        repeat (20) @(posedge clk);

        $display("Simulacao concluida.");
        $finish;
    end

    // Monitor no terminal
    initial begin
        $monitor("t=%0t  x=%0d  y=%0d", $time, x, y);
    end

endmodule
