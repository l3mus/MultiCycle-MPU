module ram (input clk, we,
input [5:0] a, 
input [7:0] wd, //Write data from accumulator
output [7:0] rd);
reg [7:0] RAM[63:0];
initial
begin
$readmemh ("data.dat",RAM);
end
assign rd = RAM[a]; // word aligned
always @ (posedge clk)
if (we)
RAM[a] <= wd;
endmodule