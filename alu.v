module alu (a,b, sel, out);
	 input [7:0] a,b; //A is acumulator B is Register
	 input [2:0] sel; 
	 output reg [7:0] out;
  
  initial
	  begin
	     out = 0;
	  end
  always @ (*) 
  begin 
	case(sel) 
		3'b000: 
		begin
			out = a; 
		end       
		3'b001: 
		begin
			out = a & b; 
		end                   
		3'b010:
		begin
			out= a | b; 
		end		
		3'b011: 
		begin
			out = ~a;  
		end              
		3'b100: 
		begin
			out = a+b;  
		end   
		3'b101: 
		begin
			out = a-b;  
		end           
		3'b110: 
		begin
			out = a+1;  
		end        	
		3'b111: 
		begin
			out = a-1;
		end 
	endcase
  end
endmodule