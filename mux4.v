module mux4 # (parameter WIDTH = 8)
(input [WIDTH-1:0] d0, d1, d2, d3, input [1:0] s,
output reg [WIDTH-1:0] y);
always @ (*)
begin
case(s)
	2'b00:
	begin 
	y <=  d0;
	end
	2'b01:
	begin
	y <=  d1;
	end
	2'b10:
	begin
	y <=  d2;
	end
	2'b11:
	begin
	y <=  d3;
	end
endcase
end
endmodule