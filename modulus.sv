module modulus(input logic [7:0]A, [3:0]B, output logic [7:0]Y);

reg [7:0]C;
wire W1,W2,W3,W4,W5,W6,W7,W8,W9,W10,W11,W12,W13,W14,W15;
reg [9:2]O;
reg [11:1]P; 

assign C[0]=B[0] & B[0];
// 1st FA
assign W1 = B[1] & B[0];
assign W2 = B[0] & B[1];
assign C[1]= W1 ^ W2 ^ 0;
assign P[1]= (W1&W2) | (W2&0) | (0&W1);
//2nd FA
assign W3= B[2] & B[0];
assign W4= B[1] & B[1];
assign O[2] = W3 ^ W4 ^ P[1];
assign P[2] = (W3&W4) | (W4&P[1]) | (P[1]&W3);
//3rd FA
assign W5= B[3] & B[0];
assign W6= B[2] & B[1];
assign O[3] = W5 ^ W6 ^ P[2];
assign P[3] = (W5&W6) | (W6&P[2]) | (P[2]&W5);
//4th FA
assign W7= B[3] & B[1];
assign O[4] = W7 ^ 0 ^ P[3];
assign P[4] = (W7&0) | (0&P[3]) | (P[3]&W7);
//5th FA
assign W8= B[0] & B[2];
assign C[2] = W8 ^ O[2] ^ 0;
assign P[5] = (W8&O[2]) | (O[2]&0) | (0&W8);
//6th FA
assign W9= B[1] & B[2];
assign O[5] = W9 ^ O[3] ^ P[5];
assign P[6] = (W9&O[3]) | (O[3]&P[5]) | (P[5]&W9);
//7th FA
assign W10= B[2] & B[2];
assign O[6] = W10 ^ O[4] ^ P[6];
assign P[7] = (W10&O[4]) | (O[4]&P[6]) | (P[6]&W10);
//8th FA
assign W11= B[3] & B[2];
assign O[7] = W11 ^ P[4] ^ P[6];
assign P[8] = (W11&P[4]) | (P[4]&P[6]) | (P[6]&W11);
//9th FA
assign W12= B[0] & B[3];
assign C[3] = W12 ^ O[5] ^ 0;
assign P[9] = (W12&O[5]) | (O[5]&0) | (0&W12);
//10th FA
assign W13= B[1] & B[3];
assign C[4] = W13 ^ O[6] ^ P[9];
assign P[10] = (W13&O[6]) | (O[6]&P[9]) | (P[9]&W13);
//11th FA
assign W14= B[2] & B[3];
assign C[5] = W14 ^ O[7] ^ P[10];
assign P[11] = (W14&O[7]) | (O[7]&P[10]) | (P[10]&W14);
//12th FA
assign W15= B[3] & B[3];
assign C[6] = W15 ^ P[8] ^ P[11];
assign C[7] = (W15&P[8]) | (P[8]&P[11]) | (P[11]&W15);

assign Y = C % A ;

endmodule 







