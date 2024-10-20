`include "defines.v"
module ram(clk,rstn,en,addr,wr_rd,data_in,data_out,out_en);
	input clk,rstn,wr_rd,en;
	input[`data_width-1:0] data_in;
	input[`addr_width-1:0] addr;
	output reg [`data_width-1:0] data_out;
	output reg out_en;
	
	integer i;
	reg [`data_width-1:0] mem [`depth-1:0]; //memory declaration
	
	always@(posedge clk)
		if(en) begin
			if(!rstn)begin
				data_out <= 0;
				for(i=0; i<(2**`addr_width); i=i+1)begin
					mem[i]=0;
					$display("mem[%0d] = %h", i, mem[i]);
				end
			end
			else begin
				if(wr_rd==1)begin
					mem[addr] <= data_in;
				end
				else begin
					data_out <= mem[addr];
					out_en <= 1;
					@(posedge clk);
					out_en <= 0;
				end
			end
		end
		else
			$display("RAM is disabled.");
endmodule
