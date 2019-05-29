module max_length(input logic [7:0]Y, output logic [3:0]Z);
always_comb
begin
casez(Y)			  // Using the Priority Encoder 
	8'b00000000 : Z=4'b0000;  // Max. length --> 0

	8'b?0?010?0 : Z=4'b0001;  // Max. length--> 1 
	8'b0?0?010? : Z=4'b0001; 
	8'b?0?0?010 : Z=4'b0001; 
	8'b0?0?0?01 : Z=4'b0001;
	8'b10?0?0?0 : Z=4'b0001;  
	8'b010?0?0? : Z=4'b0001; 
	8'b?010?0?0 : Z=4'b0001; 
	8'b0?010?0? : Z=4'b0001; 
	8'b0000100? : Z=4'b0001;	
	8'b000100?0 : Z=4'b0001;
	8'b00100?01 : Z=4'b0001;
	8'b0100?010 : Z=4'b0001;
	8'b100?0?0? : Z=4'b0001;

	8'b110??0?? : Z=4'b0010;  // Max. length--> 2
	8'b0110??0? : Z=4'b0010;
	8'b?0110??0 : Z=4'b0010;
	8'b??0110?? : Z=4'b0010;
	8'b0??0110? : Z=4'b0010;
	8'b?0??0110 : Z=4'b0010;
	8'b??0??011 : Z=4'b0010;
	8'b?01100?? : Z=4'b0010;
	
	8'b1110???0 : Z=4'b0011;  // Max. length--> 3
	8'b01110??? : Z=4'b0011;
	8'b?01110?? : Z=4'b0011;
	8'b??000111 : Z=4'b0011;
	8'b111000?? : Z=4'b0011;
	8'b??01110? : Z=4'b0011;
	8'b???01110 : Z=4'b0011;
	8'b0???0111 : Z=4'b0011;

	
	8'b11110??? : Z=4'b0100;  // Max. length--> 4
	8'b???01111 : Z=4'b0100;
	8'b011110?? : Z=4'b0100;
	8'b??011110 : Z=4'b0100;
	8'b?011110? : Z=4'b0100;

	8'b111110?? : Z=4'b0101;  // Max. length--> 5
	8'b??011111 : Z=4'b0101;
	8'b0111110? : Z=4'b0101;
	8'b?0111110 : Z=4'b0101;

	8'b1111110? : Z=4'b0110;  // Max. length--> 6
	8'b?0111111 : Z=4'b0110;
	8'b01111110 : Z=4'b0110;
	
	8'b11111110 : Z=4'b0111;  // Max. length--> 7	
	8'b01111111 : Z=4'b0111;

	8'b11111111 : Z=4'b1000;  // Max. length--> 8	
endcase
end
endmodule 