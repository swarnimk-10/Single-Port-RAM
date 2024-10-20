`include "defines.v"
module tb;
	reg clk,rstn,en,wr_rd;
	reg [`data_width-1:0] data_in;
	reg [`addr_width-1:0] addr;
	wire [`data_width-1:0] data_out;
	wire out_en;
	reg [`data_width-1:0] temp [`depth-1:0]; //internal memory of tb
	
	reg [`addr_width-1:0] addr_l;
	reg [`data_width-1:0] data_out_l;
	
	ram dut (clk,rstn,en,addr,wr_rd,data_in,data_out,out_en);
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	initial begin
		en=1;
		rstn=0;
		#10;
		rstn=1;
	end
	initial begin
		write_mem();
		#50;
		read_mem();
		comp();
	end
	
	task write_mem();
	begin
		wr_rd=1;
		addr = $random;
		data_in = $random;
		addr_l = addr;
		temp[addr_l] = data_in;
		$display("WRITE PACKET: en=%h, wr_rd=%h, addr=%h, data_in=%h", en, wr_rd,addr, data_in);
		end
	endtask
	
	task read_mem();
	begin
		wr_rd=0;
		addr=addr_l;
		wait(out_en)begin
			data_out_l = data_out;
		end
		$display("WRITE PACKET: en=%h, wr_rd=%h, addr=%h, data_out=%h", en, wr_rd, addr, data_out);
	end
	endtask
	
	task comp();
	begin
		if(temp[addr_l] == data_out_l) begin
			$display("RAM is passed");
			$display("temp[%h]=%h, data_out_l=%h", addr_l, temp[addr_l], data_out_l);
		end
		else begin
			$display("RAM is failed");
			$display("temp[%h]=%h, data_out_l=%h", addr_l, temp[addr_l], data_out_l);
		end
	end
	endtask
	
	initial begin
		#500;
		$finish;
	end
endmodule