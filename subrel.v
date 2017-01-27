module subrel
(
	input [5:0] dataa, //PC(6) 
	input [2:0] datab, //IR 2-0 
	output [5:0] result
);
	assign result = dataa - datab;
endmodule
