module memory(
  input wire clk,
  input wire wr_en,
  input wire rd_en,
  input wire [3:0] addrr,
  input wire [3:0] addrw,
  input wire [15:0] wdata,
  output reg [15:0] rdata
);

  reg [15:0] mem [0:15];

  always @(posedge clk) begin
    if (wr_en) mem[addrw] <= wdata;
    if (rd_en) rdata <= mem[addrr];
  end
  
endmodule