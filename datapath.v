module datapath (input clk, reset, 
input [7:0] in,
input IRload,
input MRload,
output [7:0] IR,
input [1:0] JMPmux, 
input PCload, MemInst,
input MemWr, 
input [1:0] Asel,
input Aload,
output Aeq0, Apos,
input RFwr,
input [2:0] ALUsel,
input [1:0] Shiftsel,
input outen,
output [7:0] oOutput);

wire [7:0] irnext; //next instruction and current instruction
wire [7:0] o_accout, o_ramout, o_aluout, o_rfout, o_shifterout, o_amuxout; 
wire [5:0] memAddress; 
wire [5:0] pcnext, pcplusone, pc, mraddress;

wire [31:0] result;
wire [5:0] sumrel,subtrel;

	
	
	always @ (*) begin
			$display("o_ramout : %b", o_ramout);
			$display("accout : %b", o_accout);
			$display("memAddress : %b", memAddress);


		end
	//Instruction register
	reg8 instReg(clk, reset, IRload, o_ramout, IR);
	
	
	assign pcplusone = pc + 1;

	
	addrel addrel(pc, IR[2:0], sumrel);
	subrel subrel(pc, IR[2:0], subtrel);
	
	// next PC logic
	mux46 pcmux (pcplusone, o_ramout[5:0], subtrel, sumrel,JMPmux, pcnext);
	reg6 #(32) pcreg(clk, reset, PCload, pcnext, pc);
	
	
	reg6 #(32) mrreg(clk, reset, MRload, o_ramout[5:0], mraddress);
	
	mux2 memmux(pc, mraddress, MemInst, memAddress);
	
	// Acummulator 
	mux4 amux (o_shifterout, o_rfout, in, o_ramout, Asel, o_amuxout );
	reg8 accumulator(clk, reset, Aload, o_amuxout, o_accout);
	
	// Executables
	alu alu(o_accout, o_rfout, ALUsel, o_aluout);
	shifter shifter(o_aluout, Shiftsel, o_shifterout);
	
	//Register File 
	regfile rf(clk, RFwr, IR[2:0],o_accout, o_rfout);
	
	//Output Reg
	reg8 outputReg(clk, reset, outen, o_accout,oOutput);
	
	
	//Ram 
	ram ram(~clk, MemWr, memAddress,  o_accout, o_ramout);
	
	assign Aeq0 = ~(o_accout[0] | o_accout [1] | o_accout [2] | o_accout [3] | o_accout [4] | o_accout [5] | o_accout [6] | o_accout [7]);
	assign Apos = ~ o_accout [7];
endmodule