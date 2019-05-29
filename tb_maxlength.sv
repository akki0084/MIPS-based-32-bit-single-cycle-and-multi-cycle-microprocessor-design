module tb_maxlength();

logic clk, reset; // clock and reset are internal
logic [7:0]Y; 
logic [3:0]Z; // output of circuit
logic [3:0]zexpected;

reg [31:0]vectornum, errors; // bookkeeping variables
reg [11:0]testvectors[10000:0];// array of testvectors

max_length dut(.Y(Y), .Z(Z));  // instantiate device under test

// generate clock
always // no sensitivity list, so it always executes
begin
clk = 1; #5; clk = 0; #5; // 10ns period
end

// at start of test, load vectors
// and pulse reset
initial // Will execute at the beginning once
begin              
$readmemb("C:/Users/aksha/Desktop/tb_maxlength.txt", testvectors); // Read vectors
//C:\Users\aksha\Desktop
vectornum = 0; errors = 0; // Initialize
reset = 1; #10; reset = 0; // Apply reset wait
end

// apply test vectors on rising edge of clk
always @(posedge clk)
begin
#1; {Y, zexpected} = testvectors[vectornum];
end

// check results on falling edge of clk
always @(negedge clk)
if (~reset) // skip during reset
begin
if (Z !== zexpected)
begin
$display("Error: inputs = %b", {Y});
$display(" outputs = %b (%b expected)",Z,zexpected);
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
