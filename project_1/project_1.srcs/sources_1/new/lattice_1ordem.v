`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2026 03:03:09 PM
// Design Name: 
// Module Name: lattice_1ordem
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

module lattice_1ordem
    #(
    	parameter NBITS_IN = 33,
    	parameter integer FB = 10,
    	parameter signed k = 1,
    	parameter signed v1 = 1,
    	parameter signed v2 = 1
    
    )
    (
    	input clock,
    	input  signed [NBITS_IN - 1:0] in,
    	output signed [NBITS_IN + 14:0] out
    	);
    
    	reg signed [NBITS_IN:0] f1 = 0;
    
    	wire signed [NBITS_IN+14:0] f;
    	wire signed [NBITS_IN+14:0] g;
    	
    	//reescala
    	wire signed [NBITS_IN+14:0] kf1  = (k * f1)  >>> FB;
    	wire signed [NBITS_IN+14:0] kf   = (k * f)   >>> FB;
    	
    	wire signed [NBITS_IN+14:0] v1g  = (v1 * g)  >>> FB;
    	wire signed [NBITS_IN+14:0] v2f  = (v2 * f)  >>> FB;
    	
    	
    	assign f = in - kf1;
    	assign g = kf + f1;
    	assign out = v1g + v2f;
    	
    	always @(posedge clock)
    	begin
    		f1 <= f;
    	end
    	
endmodule 
