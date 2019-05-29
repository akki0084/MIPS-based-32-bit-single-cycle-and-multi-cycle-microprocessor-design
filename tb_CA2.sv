module tb_CA2();

logic clk, reset; // clock and reset are internal
logic [7:0]A; 
logic [3:0]B;
logic [7:0]Y; // output of circuit
logic [7:0]yexpected;

reg [31:0]vectornum, errors; // bookkeeping variables
reg [19:0]testvectors[10000:0];// array of testvectors

CA2 dut(.A(A), .B(B), .Y(Y));  // instantiate device under test

// generate clock
always // no sensitivity list, so it always executes
begin
clk = 1; #5; clk = 0; #5; // 10ns period
end

// at start of test, load vectors
// and pulse reset
initial // Will execute at the beginning once
begin              
$readmemb("C:/Users/aksha/Desktop/tb_CA2.txt", testvectors); // Read vectors
//C:\Users\aksha\Desktop
vectornum = 0; errors = 0; // Initialize
reset = 1; #10; reset = 0; // Apply reset wait
end

// apply test vectors on rising edge of clk
always @(posedge clk)
begin
#1; {A, B, yexpected} = testvectors[vectornum];
end

// check results on falling edge of clk
always @(negedge clk)
if (~reset) // skip during reset
begin
if (Y !== yexpected)
begin
$display("Error: inputs = %b", {A, B});
$display(" outputs = %b (%b expected)",Y,yexpected);
errors = errors + 1;
end

// increment array index and read next testvector
vectornum = vectornum + 1;
if ( vectornum == 70)
begin
$display("%d tests completed with %d errors",
vectornum, errors);
$finish; // End simulation
end
end
endmodule 
