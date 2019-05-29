module tb_controller();
logic clk;
logic reset;
logic [5:0]op, funct;
logic zero;
logic pcen, memwrite, irwrite, regwrite;
logic alusrca, iord, memtoreg, regdst;
logic [1:0] alusrcb, pcsrc;
logic [2:0] alucontrol;
// instantiate device to be tested
CONTROLLER dut (clk, reset, op, funct, zero, pcen, memwrite, irwrite, regwrite, alusrca, iord, memtoreg, 
		regdst, alusrcb, pcsrc, alucontrol);
// initialize test

initial
begin
reset <= 1; #10; reset <= 0;
end
// generate clock to sequence tests
always
begin
clk <= 1; # 5; clk <= 0; # 5;
end
// check results
initial begin
op=6'b100011;funct=000000;zero=0;	//Lw
#50;op=6'b101011;funct=6'b000000;zero=1'b0;	//Sw
#40;op=6'b000100;funct=6'b000000;zero=1'b0;	//Beq
#30;op=6'b000100;funct=6'b000000;zero=1'b1;	//Beq
#30;op=6'b001000;funct=6'b000000;zero=1'b0;	//addi	
#40;op=6'b000000;funct=6'b100101;zero=1'b0;	//Rtype.....
#40;op=6'b000000;funct=6'b100100;zero=1'b0;
#40;op=6'b000000;funct=6'b100000;zero=1'b0;
#40;op=6'b000000;funct=6'b101010;zero=1'b0;
#40;op=6'b000000;funct=6'b100010;zero=1'b0;	//.....Rtype
#40;op=6'b000010;funct=6'b000000;zero=1'b0;	//j
end
endmodule 
