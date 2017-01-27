module reg8 # (parameter WIDTH = 8)
(input clk, clear, load,
input [WIDTH-1:0] d,
output reg [WIDTH-1:0] q);

always @ (posedge clk) begin
	if (clear) q <= 0;
	else if (load) q <= d;
end

endmodule