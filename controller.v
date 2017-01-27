module controller (input clk,
input START, 
input RESET,
output reset, 
output IRload,
output MRload,
input [7:0] IR,
output [1:0] JMPmux, 
output PCload, MemInst, MemWr,
output [1:0] Asel,
output Aload,
input Aeq0, Apos,
output RFwr,
output [2:0] ALUsel,
output [1:0] Shiftsel,
output outen);

reg [2:0] state = 3'b000;
reg [17:0] controls;
assign {IRload, JMPmux, PCload, MemInst, MemWr, Asel, Aload, reset, RFwr, ALUsel, Shiftsel, outen, MRload}  = controls;
initial begin
	controls <= 18'b100000xx000xxxxx00;
end
always @ (posedge clk) begin
 case(state)
	3'b000: 										//Fetch State
		begin
			if(RESET) begin					//Reset if high
				$display("reset");
				controls <= 18'b000000xx010xxxxx00;
			end else	if(START) begin 				//otherwise if start is high continue
			
				$display("Cycle0");
				$display("IR : %b", IR);
				controls <= 18'b100100xx000xxxxx00; 
				state <=  2'b01; 
			end else begin
				controls <= 18'b100000xx000xxxxx00;
			end
		end
	3'b001:
		begin
			
			$display("Cycle1");
			$display("IR : %b", IR[7:4]);
			case(IR[7:4])
			
				//Data movement instructions
				
				4'b0001:				  //LDA
					begin
						controls <= 18'b00000001100xxxxx00;
						state <= 3'b010; 
					end
					
				4'b0010:				  //STA
					begin
						controls <= 18'b000000xx001xxxxx00;
						state <= 3'b010; 
					end
					
				4'b0011:				  //LDM
					begin
						controls <= 18'b000000xx000xxxxx01; 
						state <= 3'b011; // GO to load state 
					end
					
				4'b0100:				  //STM
					begin
						controls <= 18'b000000xx000xxxxx01;
						state <= 3'b100;
					end
						
				4'b0101:				  //LDI
					begin
						controls <= 18'b00010011100xxxxx00; 
						state <= 3'b010; 
					end
					
				//Jump Instructions
				
				4'b0110:				  //JMP & JMPR relative
					begin
						if(IR[3:0] == 4'b0000) begin 						//JMP absolute
							controls <= 18'b001100xx000xxxxx00; 
							state <= 3'b110; 
						end else begin
							if(IR[3] == 1'b0) begin 						//JMPR relative positive
								controls <= 18'b011100xx000xxxxx00;
								state <= 3'b110;  
							end else	begin											//JMPR relative negative 
								controls <= 18'b010100xx000xxxxx00; 
								state <= 3'b110; 
							end
						end 
					end
					
				4'b0111:				  //JZ & JZR
					begin
						if(Aeq0) begin 
							if(IR[3:0] == 4'b0000) begin 						//JZ absolute
								controls <= 18'b001100xx000xxxxx00; 
									state <= 3'b110; 
							end else begin
								if(IR[3] == 1'b0) begin 						//JZR relative positive
									controls <= 18'b011100xx000xxxxx00;
									state <= 3'b110;  
								end else	begin											//JZR relative negative 
									controls <= 18'b010100xx000xxxxx00;
									state <= 3'b110;  
								end
							end 
						end else begin
							controls <= 18'b000100xx000xxxxx00;
							state <= 3'b010; 
						end
					end
					
				4'b1000:				  //JNZ & JNZR
					begin
						if(!Aeq0) begin 
							if(IR[3:0] == 4'b0000) begin 						//JZ absolute
									controls <= 18'b001100xx000xxxxx00;
									state <= 3'b110; 
							end else begin
								if(IR[3] == 1'b0) begin 						//JZR relative positive
									controls <= 18'b011100xx000xxxxx00;
									state <= 3'b110;  
								end else	begin											//JZR relative negative 
								$display("JZR");
									controls <= 18'b010100xx000xxxxx00;
									state <= 3'b110; 
								end
							end 
						end else begin
							controls <= 18'b000100xx000xxxxx00;
							state <= 3'b010; 
						end
					end
					
				4'b1001:				  //JP & JPR
					begin
						if(Apos) begin 
							if(IR[3:0] == 4'b0000) begin 						//JZ absolute
								controls <= 18'b001100xx000xxxxx00; 
								state <= 3'b110; 
							end else begin
								if(IR[3] == 1'b0) begin 						//JZR relative positive
									controls <= 18'b011100xx000xxxxx00; 
									state <= 3'b110; 
								end else	begin											//JZR relative negative 
									controls <= 18'b010100xx000xxxxx00; 
									state <= 3'b110; 
								end
							end 
						end else begin
							controls <= 18'b000100xx000xxxxx00;
							state <= 3'b010; 
						end
					end
				
				//Arithmetic and logical instructrions 
				
				4'b1010:				  //AND
					begin
						controls <= 18'b000000001000010000; 
						state <= 3'b010;
					end
					
				4'b1011:				  //OR
					begin
						controls <= 18'b000000001000100000;
						state <= 3'b010; 
					end
					
				4'b1100:				  //ADD
					begin
						controls <= 18'b000000001001000000;
						state <= 3'b010; 			
					end
					
				4'b1101:				  //SUB
					begin
						controls <= 18'b000000001001010000; 
						state <= 3'b010;
					end
					
				4'b1110:				  //NOT, INC, DEC, SHFL, SHFR, ROTR
					begin
						case(IR[3:0])
							4'b0000:		//NOT
								begin
									controls <= 18'b000000001000110000; 
									state <= 3'b010;
								end
							4'b0001:    //INC
								begin
									controls <= 18'b000000001001100000; 
									state <= 3'b010;
								end
							4'b0010:    //DEC  
								begin
									controls <= 18'b000000001001110000;
									state <= 3'b010;
								end
							4'b0011:    //SHFL
								begin
									controls <= 18'b000000001000000100;
									state <= 3'b010;
								end
							4'b0100:    //SHFR
								begin
									controls <= 18'b000000001000001000;
									state <= 3'b010;
								end
							4'b0101:    //ROTR
								begin
									controls <= 18'b000000001000001100;
									state <= 3'b010;
								end
						endcase
					end
				
				//Input / Output and Miscellaneous
				
				4'b0000:				  //NOP
					begin
						controls <= 18'b000000xx000xxxxx00;
						state <= 3'b010;
					end
				
				
				4'b1111:				  //IN, OUT, HALT
					begin
						case(IR[3:0])
							4'b0000:		//IN
								begin
									controls <= 18'b00000010100xxxxx00;
									state <= 3'b010; 
								end
							4'b0001:    //OUT
								begin
									$display("OUT");
									controls <= 18'b000000xx000xxxxx10; 
									state <= 3'b010;
								end
							4'b0010:    //HALT  
								begin
									controls <= 18'b000000xx000xxxxx00;
									state <=2'b101;
								end
						endcase
					end
				default:
					controls <= 18'bxxxxxxxxxxxxxxxxxx;
			endcase 
		end //end state 1
		3'b010: //Latch next instruction
		begin 
			controls <= 18'b100000xx000xxxxx00; 
			state <= 2'b00; 
		end 	
		3'b011:					//Load Memory State 
		begin
			controls <= 18'b00011011100xxxxx00;
			state <= 3'b010; 
		end
		3'b100:					//Store Memory
		begin
			controls <= 18'b000111xx000xxxxx00;
			state <= 3'b010; 
		end
		3'b101:					//HALT
		begin
			controls <= 18'b000000xx000xxxxx00; 
		end
		3'b110:					//Jump allocate
		begin
			controls <= 18'b000000xx000xxxxx00; 
			state <= 3'b010; 
		end
	endcase
end
endmodule


