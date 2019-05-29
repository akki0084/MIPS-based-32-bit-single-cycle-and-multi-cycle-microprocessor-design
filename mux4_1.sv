module mux4_1(input logic a,b,c,d, sel_1,sel_0, output logic f);
assign f = sel_1 ?(sel_0 ? d : c)
	 	 :(sel_0 ? b : a);
endmodule 

