module regfile (input clk, input we,
input [2:0] wa,
input [7:0] wd,
output [7:0] rd1);
reg [7:0] rf[7:0];
// three ported register file
// read two ports combinationally
// write third port on rising edge of clock
// register 0 hardwired to 0
always @ (posedge clk)
if (we) rf[wa] <= wd;
assign rd1 = (wa != 0) ? rf[wa] : 0; //register file used as 0
endmodule