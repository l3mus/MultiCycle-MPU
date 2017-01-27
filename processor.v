module processor (input clk, reset, start, 
input [7:0] in,
output [7:0] out);

wire o_reset;
wire IRload, MRload;
wire  [7:0] IR;
wire [1:0] JMPmux; 
wire PCload, MemInst;
wire MemWr;
wire [1:0] Asel;
wire Aload;
wire  Aeq0, Apos;
wire RFwr;
wire [2:0] ALUsel;
wire [1:0] Shiftsel;
wire outen;

controller c(clk,start, reset, o_reset,  IRload, MRload,IR, JMPmux, PCload, MemInst, MemWr, Asel, Aload, Aeq0, Apos, RFwr, ALUsel, Shiftsel, outen);

datapath d(clk, o_reset, in, IRload,MRload, IR, JMPmux, PCload, MemInst, MemWr, Asel, Aload, Aeq0, Apos, RFwr, ALUsel, Shiftsel, outen, out);


endmodule