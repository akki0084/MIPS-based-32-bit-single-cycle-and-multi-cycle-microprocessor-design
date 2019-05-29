module ctrl_fault(input logic [7:0]A, [3:0]B, [2:0]f_loc, [1:0]f_type,
		  output logic [7:0]C, [7:0]Y);

wire [7:0]m;
wire [7:0]n;
// Level 0 //Structural Modelling using Port Mapping
multiply mul(.c(m), .b(B)); // squaring the bits 

// selecting fault_type // Level 1
mux4_1 mux1(.a(m[0]), .b(1'b0), .c(1'b1), .d(~m[0]), .sel_1(f_type[1]), .sel_0(f_type[0]), .f(n[0]));
mux4_1 mux2(.a(m[1]), .b(1'b0), .c(1'b1), .d(~m[1]), .sel_1(f_type[1]), .sel_0(f_type[0]), .f(n[1]));
mux4_1 mux3(.a(m[2]), .b(1'b0), .c(1'b1), .d(~m[2]), .sel_1(f_type[1]), .sel_0(f_type[0]), .f(n[2]));
mux4_1 mux4(.a(m[3]), .b(1'b0), .c(1'b1), .d(~m[3]), .sel_1(f_type[1]), .sel_0(f_type[0]), .f(n[3]));
mux4_1 mux5(.a(m[4]), .b(1'b0), .c(1'b1), .d(~m[4]), .sel_1(f_type[1]), .sel_0(f_type[0]), .f(n[4]));
mux4_1 mux6(.a(m[5]), .b(1'b0), .c(1'b1), .d(~m[5]), .sel_1(f_type[1]), .sel_0(f_type[0]), .f(n[5]));
mux4_1 mux7(.a(m[6]), .b(1'b0), .c(1'b1), .d(~m[6]), .sel_1(f_type[1]), .sel_0(f_type[0]), .f(n[6]));
mux4_1 mux8(.a(m[7]), .b(1'b0), .c(1'b1), .d(~m[7]), .sel_1(f_type[1]), .sel_0(f_type[0]), .f(n[7]));

// injecting fault_type // Level 2
mux8_1 mux9(.a(n[0]), .b(m[0]), .c(m[0]), .d(m[0]), .e(m[0]), .f(m[0]), .g(m[0]), .h(m[0]), .sel(f_loc[2:0]), .p(C[0]));
mux8_1 mux10(.a(m[1]), .b(n[1]), .c(m[1]), .d(m[1]), .e(m[1]), .f(m[1]), .g(m[1]), .h(m[1]), .sel(f_loc[2:0]), .p(C[1]));
mux8_1 mux11(.a(m[2]), .b(m[2]), .c(n[2]), .d(m[2]), .e(m[2]), .f(m[2]), .g(m[2]), .h(m[2]), .sel(f_loc[2:0]), .p(C[2]));
mux8_1 mux12(.a(m[3]), .b(m[3]), .c(m[3]), .d(n[3]), .e(m[3]), .f(m[3]), .g(m[3]), .h(m[3]), .sel(f_loc[2:0]), .p(C[3]));
mux8_1 mux13(.a(m[4]), .b(m[4]), .c(m[4]), .d(m[4]), .e(n[4]), .f(m[4]), .g(m[4]), .h(m[4]), .sel(f_loc[2:0]), .p(C[4]));
mux8_1 mux14(.a(m[5]), .b(m[5]), .c(m[5]), .d(m[5]), .e(m[5]), .f(n[5]), .g(m[5]), .h(m[5]), .sel(f_loc[2:0]), .p(C[5]));
mux8_1 mux15(.a(m[6]), .b(m[6]), .c(m[6]), .d(m[6]), .e(m[6]), .f(m[6]), .g(n[6]), .h(m[6]), .sel(f_loc[2:0]), .p(C[6]));
mux8_1 mux16(.a(m[7]), .b(m[7]), .c(m[7]), .d(m[7]), .e(m[7]), .f(m[7]), .g(m[7]), .h(n[7]), .sel(f_loc[2:0]), .p(C[7]));

assign Y = C % A;
endmodule 
