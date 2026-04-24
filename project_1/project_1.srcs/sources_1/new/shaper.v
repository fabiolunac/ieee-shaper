`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2026 02:39:03 PM
// Design Name: 
// Module Name: shaper
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


module shaper
#(
    parameter NBITS_IN = 33,
    parameter integer FB = 15

)
(   
    input clk,
    input signed [NBITS_IN-1:0] x,
    output signed [NBITS_IN+14:0] y
);

// FILTRO 1
lattice_1ordem 
#(
    .NBITS_IN(33), 
    .FB(15), 
    .k(-32766), 
    .v1(-8), 
    .v2(8)
) 
lat1
(
    .clock(clk),
    .in(x),
    .out(y)
);

// FILTRO 2
lattice_1ordem 
#(
    .NBITS_IN(33), 
    .FB(15), 
    .k(-19875), 
    .v1(534729), 
    .v2(881620)
) 
lat2
(
    .clock(clk),
    .in(x),
    .out(y)
);

// FILTRO 3
lattice_1ordem 
#(
    .NBITS_IN(33), 
    .FB(15), 
    .k(-17983), 
    .v1(-544293), 
    .v2(-991767)
) 
lat3
(
    .clock(clk),
    .in(x),
    .out(y)
);

// FILTRO 4
lattice_2ordem 
#(
    .NBITS_IN(33), 
    .FB(15), 
    .k1(842), 
    .k2(14),
    .v1(7916), 
    .v2(-307901),
    .v3(-875)
) 
lat4
(
    .clock(clk),
    .in(x),
    .out(y)
);

// FILTRO 5
lattice_1ordem 
#(
    .NBITS_IN(33), 
    .FB(15), 
    .k(-221), 
    .v1(1979), 
    .v2(293709)
) 
lat5
(
    .clock(clk),
    .in(x),
    .out(y)
);

// FILTRO 6
lattice_1ordem 
#(
    .NBITS_IN(33), 
    .FB(15), 
    .k(-221), 
    .v1(1048), 
    .v2(155530)
) 
lat6
(
    .clock(clk),
    .in(x),
    .out(y)
);
endmodule
