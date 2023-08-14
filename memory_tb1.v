module memory_tb1;

  // Inputs
  reg clk;
  wire wr_en;
  wire rd_en;
  wire [3:0] addrr;
  wire [3:0] addrw;
  wire [15:0] wdata;

  // Outputs
  wire [15:0] rdata;
// Instantiate the memory module
  memory dut (
    .clk(clk),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .addrr(addrr),
	 .addrw(addrw),
    .wdata(wdata),
    .rdata(rdata)
  );

  // Instantiate the generator module
  generator gen (
    .clk(clk),
    .wr_en(wr_en),
    .rd_en(rd_en),
	 .addrr(addrr),
	 .addrw(addrw),
    .wdata(wdata),
	 .rdata(rdata)
  );
  
  // Instantiate the comparator module
  comparator comp (
    .rdata(rdata),
	 .wdata(wdata)
  );

  // Instantiate the monitor module
  monitor mon (
    .clk(clk),
    .wr_en(wr_en),
    .rd_en(rd_en),
	 .addrr(addrr),
	 .addrw(addrw),
    .wdata(wdata),
    .rdata(rdata)
  );
  
  // Clock generation
  initial begin
  clk = 1;
  forever #5 clk <= ~clk;
  end
endmodule

	module generator(
	  input wire clk,
	  output reg wr_en,
	  output reg rd_en,
	  output reg [3:0] addrr,
	  output reg [3:0] addrw,
	  output reg [15:0] wdata,
	  input wire [15:0] rdata
	);

   // Initialize variables
  integer i=0;
  integer j=0;
  integer num_writes = 8;
  integer num_reads = 8;
  
  // Generate write and read transactions
  always @(posedge clk) begin
    if (i < num_writes) begin
      wr_en <= 1;
      rd_en <= 0;
      addrw <= i % 8;
      wdata <= $random;
      i <= i + 1;
		#10;
	 end else if (j < num_reads) begin
      wr_en <= 0;
      rd_en <= 1;
      addrr <= j % 8;
		#10;
      j <= j + 1;
		#10;
    end else begin
      wr_en <= 0;
      rd_en <= 0;
    end
  end
endmodule

module comparator(
  input wire [15:0] rdata,
  input wire [15:0] wdata
);

  integer i;
  integer num_reads = 8;
  // Compare read data to expected values
  always @(posedge rdata) begin
    if (i < num_reads) begin
      if (rdata != wdata) $display("Mismatch at address %0d: expected %0d, got %0d", i, wdata, rdata);
      i <= i + 1;
    end
  end

endmodule

module monitor(
  input wire clk,
  input wire wr_en,
  input wire rd_en,
  input wire [3:0] addrr,
  input wire [3:0] addrw,
  input wire [15:0] wdata,
  input wire [15:0] rdata);
  
  always @(*) begin
    if (wr_en) begin
        $display("[Monitor] Write to address %0h: %0h", addrw, wdata);
    end
    if (rd_en) begin
			#20;
        $display("[Monitor] Read from address %0h: %0h", addrr, rdata);
    end
end
endmodule
