`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2026 03:04:11 PM
// Design Name: 
// Module Name: lattice_2ordem
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

    module lattice_2ordem
    #(
    	parameter NBITS_IN = 33,
    	parameter integer FB = 10,
    	parameter signed k1 = 1,
    	parameter signed k2 = 1,
    	parameter signed v1 = 1,
    	parameter signed v2 = 1,
    	parameter signed v3 = 1
    
    )
    (
    	input clock,
    	input  signed [NBITS_IN - 1:0] in,
    	output signed [NBITS_IN + 14:0] out
    	);
     
    	reg signed [NBITS_IN:0] i1 = 0; // i[n-1]
    	reg signed [NBITS_IN:0] h1 = 0; // h[n-1]
    
    	wire signed [NBITS_IN+14:0] f; // f[n]
    	wire signed [NBITS_IN+14:0] h; // h[n]
    	wire signed [NBITS_IN+14:0] g; // g[n]
    	wire signed [NBITS_IN+14:0] i; // i[n]
    	
    	//reescala
    	wire signed [NBITS_IN+14:0] k2i1  = (k2 * i1) >>> FB;
    	wire signed [NBITS_IN+14:0] k1h1  = (k1 * h1) >>> FB;
    	wire signed [NBITS_IN+14:0] k1h   = (k1 * h)  >>> FB;
    	wire signed [NBITS_IN+14:0] k2f   = (k2 * f)  >>> FB;
    	
    	wire signed [NBITS_IN+14:0] v1g   = (v1 * g)  >>> FB;
    	wire signed [NBITS_IN+14:0] v2i   = (v2 * i)  >>> FB;
    	wire signed [NBITS_IN+14:0] v3h   = (v3 * h)  >>> FB;
    	
    	
    	assign f = in  - k2i1;
    	assign h = f   - k1h1;
    	assign g = k2f + i1;
    	assign i = k1h + h1;
    	assign out = v1g + v2i + v3h;
    
    	
    	always @(posedge clock)
    	begin
    		i1 <= i;
    		h1 <= h;
    	end
    
    
    endmodule
