module TOP_M(input logic clk, reset, 
	     output logic [31:0] writedata, adr,
	     output logic memwrite);

logic [31:0] readdata;

// microprocessor (control & datapath)
MIPS mips(clk, reset, adr, writedata, memwrite, readdata);

// memory
MEM mem(clk, memwrite, adr, writedata, readdata); 
endmodule
////////////////////**MIPS**///////////////////////////////////////////
module MIPS(input logic	clk, reset,
	    output logic [31:0] adr, writedata, 
	    output logic memwrite,
	    input logic [31:0] readdata);

logic zero, pcen, irwrite, regwrite,alusrca, iord, memtoreg, regdst;
logic [1:0]alusrcb, pcsrc;
logic [2:0]alucontrol; logic [5:0]op, funct;

CONTROLLER c(clk, reset, op, funct, zero,pcen, memwrite, irwrite, regwrite, alusrca, iord, memtoreg, regdst, alusrcb, pcsrc, alucontrol);

DATAPATH dp(clk, reset,pcen, irwrite, regwrite, alusrca, iord, memtoreg, regdst, alusrcb, pcsrc, alucontrol,op, funct, zero,adr, writedata, readdata);
endmodule
//////////////////////**DATAPATH/////////////////////////////////////

module DATAPATH(input logic clk, reset,
		input logic pcen, irwrite, regwrite,
		input logic alusrca, iord, memtoreg, regdst,
	        input logic[1:0]alusrcb, pcsrc,
		input logic[2:0]alucontrol, 
		output logic[5:0]op, funct, 
		output logic zero,
		output logic[31:0] adr, writedata,
		input logic[31:0] readdata);

logic [4:0]writereg;
logic [31:0] pcnext, pc;
logic [31:0] instr, data, srca, srcb; 
logic [31:0] A;
logic [31:0] aluresult, aluout;
logic [31:0] signimm;	// the sign-extended immediate
logic [31:0] signimmsh,signimmsh2; // the sign-extended immediate shifted left by 2 
logic [31:0] wd3, rd1, rd2;

assign op = instr[31:26];
assign funct = instr[5:0];

FLOPR  #(32) pcreg(.clk(clk), .reset(reset), .en(pcen), .d(pcnext), .q(pc)); 
MUX2   #(32) pcmux(.d0(pc), .d1(aluout), .s(iord), .y(adr)); 
FLOPR  #(32) ff2(.clk(clk), .reset(reset),.en(irwrite),.d(readdata),.q(instr));
FLOPR1 #(32) ff3(.clk(clk), .reset(reset),.d(readdata),.q(data));
MUX2   #(32) mu2(.d0(instr[20:16]),.d1(instr[15:11]),.s(regdst),.y(writereg));
MUX2   #(32) mu3(.d0(aluout), .d1(data), .s(memtoreg), .y(wd3));
REGFILE       Rf(.clk(clk),.a1(instr[25:21]),.a2(instr[20:16]),.wd3(wd3),.a3(writereg),.we3(regwrite),.rd1(rd1),.rd2(rd2));
FLOPR2 #(32) ff4(.clk(clk),.reset(reset),.d0(rd1),.d1(rd2),.q0(A),.q1(writedata));
SIGNEXT       se(.a(instr[15:0]), .y(signimm));
Sl2       shift1(.a(signimm), .y(signimmsh));
MUX2   #(32) mu4(.d0(pc),.d1(A),.s(alusrca),.y(srca));
MUX4   #(32) mu5(.d0(writedata), .d1(32'b00000000000000000000000000000100), .d2(signimm), .d3(signimmsh), .s(alusrcb), .y(srcb));
ALU         alu1(.srca(srca), .srcb(srcb), .alucontrol(alucontrol), .zero(zero), .aluresult(aluresult));
FLOPR1  #(32) ff6(.clk(clk),.reset(reset),.d(aluresult),.q(aluout));
Sl2new     shift2(.a(instr), .y(signimmsh2));
MUX3 #(32) mu6(.d0(aluresult), .d1(aluout), .d2(signimmsh2), .s(pcsrc), .y(pcnext));
endmodule
//////////////////////////////////////////////////////////////////////////

module FLOPR #(parameter WIDTH = 8)(input logic clk, reset, en,
				    input logic [WIDTH-1:0] d,
				    output logic [WIDTH-1:0] q);

always_ff @(posedge clk, posedge reset)
begin
if (reset) 
	q <= 0;
else if(en) 
	q <= d;
end 
endmodule
////////////////////////////////////////////////////////////////////////// 
module FLOPR1 #(parameter WIDTH = 32)(input logic clk, reset, 
				    input logic [WIDTH-1:0] d,
				    output logic [WIDTH-1:0] q);

always_ff @(posedge clk, posedge reset)
begin
if (reset) 
	q <= 0;
else 
	q <= d;
end 
endmodule
/////////////////////////////////////////////////////////////////////////
module FLOPR2 #(parameter WIDTH = 32)(input logic clk, reset, 
				    input logic [WIDTH-1:0] d0,d1,
				    output logic [WIDTH-1:0] q0,q1);

always_ff @(posedge clk, posedge reset)
begin
if (reset) begin
	q0 <= 0; q1<=0; end
else begin
	q0 <= d0; q1<=d1;end
end 
endmodule
/////////////////////////////////////////////////////////////////////////
module MUX2 #(parameter WIDTH = 32)(input logic [WIDTH-1:0] d0, d1,
				   input logic s,
  				   output logic [WIDTH-1:0] y);
assign y = s ? d1 : d0;
endmodule 
////////////////////////**REGFILE**//////////////////////////////////////////////
module REGFILE(input logic clk,
		input logic we3,
		input logic [4:0] a1, a2, a3,
		input logic [31:0] wd3,
		output logic [31:0] rd1, rd2);
logic [31:0] rf[31:0];

always_ff @(posedge clk)
if (we3) 
	rf[a3] <= wd3;
assign rd1 = (a1 != 0) ? rf[a1] : 0;
assign rd2 = (a2 != 0) ? rf[a2] : 0;
endmodule  
//////////////////////////////////////////////////////////////////////////////////
module SIGNEXT(input logic [15:0] a,
	       output logic [31:0] y);
assign y = {{16{a[15]}},a};
endmodule
///////////////////////////////////////
module Sl2(input logic [31:0] a,
  	   output logic [31:0] y);
// shift left by 2
assign y = {a[29:0], 2'b00};
endmodule
//////////////////////////////////// 
module MUX4 #(parameter WIDTH = 8)(input logic [WIDTH-1:0] d0, d1, d2, d3,
                                   input logic [1:0]s,
				   output logic [WIDTH-1:0] y);

always_comb 
case(s)
2'b00: y = d0;
2'b01: y = d1;
2'b10: y = d2;
2'b11: y = d3;
endcase 
endmodule
////////////////////////**ALU**///////////////////////////////////////////
module ALU(input logic [31:0] srca,srcb,
              input logic [2:0]alucontrol,
	      output logic [31:0]aluresult,
              output logic zero);
 
logic [31:0]bb,S; 
always_comb 
begin
	case(alucontrol[2])
		1'b0: bb=srcb;
		1'b1: bb=~srcb;
	endcase	
end 
assign S= srca+bb+ alucontrol[2];

always_comb 
begin
	case (alucontrol[1:0])
		2'b00 : aluresult=srca&bb;
		2'b01 : aluresult=srca|bb;
		2'b10 : aluresult=S;
		2'b11 : aluresult={31'b0000000000000000000000000000000,S[31]};
				
	endcase
end
always_comb begin
	if(aluresult==32'b00000000000000000000000000000000)
	zero=1'b1;
	else 
	zero=1'b0; 
end
endmodule
///////////////////////////////////////////////////////////////////////////////// 
module Sl2new(input logic [31:0] a,
       	      output logic [31:0] y);
// shift left by 2
assign y = {a[31:28],{a[25:0], 2'b00}};
endmodule
//////////////////////////////////////////////////////////////////////////////////
module MUX3 #(parameter WIDTH = 8)(input logic [WIDTH-1:0] d0, d1, d2, 
                                   input logic [1:0]s,
				   output logic [WIDTH-1:0] y);

assign #1 y = s[1] ? d2 : (s[0] ? d1 : d0); 
endmodule
/////////////////////////**MEMFILE**//////////////////////////////////////////////////////////
module MEM(input logic clk,we,
	   input logic [31:0] a, wd,
           output logic [31:0] rd);

logic	[31:0] RAM[63:0];

initial
begin
$readmemh("C:/altera/15.0/Proj3A/memfile.dat",RAM);
end
assign rd = RAM[a[31:2]]; // word aligned 
always_ff @(posedge clk)
if (we)
RAM[a[31:2]] <= wd;
endmodule

