module shifter (a, sel, out);
	 input [7:0] a; //a is output coming from ALU
	 input [1:0] sel; 
	 output reg [7:0] out;
  
  initial
	  begin
	  out = 0;
	  end
  always @ (*) 
  begin 
	case(sel)
		2'b00:
		begin
			out = a; 
		end
		2'b01:
		begin
		   out = a << 1;
		end
		2'b11:
		begin
		   out = a >> 1;
		end
	endcase
  end
endmodule