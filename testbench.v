module testbench();
reg clk;
reg reset;
reg start;

wire [7:0] in, out;
// instantiate device to be tested
processor processor (clk, reset, start, in, out);
// initialize test
initial
begin
reset <= 1; 
start <=0;
# 10;
reset <= 0;
#40
start <=1;
end
// generate clock to sequence tests
always
	begin
		clk <= 1;
		 # 10; 
		 clk <= 0;
		 # 10; // clock duration
	end
	// check results
	always @ (negedge clk)
		begin
			if (out > 0 ) begin
				$display("out : %d", out);
				$display ("Simulation succeeded");
				$stop;
			end
		end
endmodule
