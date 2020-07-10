module ram2
(
	input iCLK,
	input iWREN,
	input [16:0] iADDR,
	input [23:0] iDATA,
	output [23:0] oDATA
);

wire [23:0] oDATAL;
wire [23:0] oDATAH;
wire iWRENL,iWRENH;

assign iWRENL = iADDR[16] ? 0 : iWREN;
assign iWRENH = iADDR[16] ? iWREN : 0;

ram1	ram1_low
(
	.address ( iADDR[15:0] ),
	.clock ( iCLK ),
	.data ( iDATA ),
	.wren ( iWRENL ),
	.q ( oDATAL )
);

ram1	ram1_high
(
	.address ( iADDR[15:0] ),
	.clock ( iCLK ),
	.data ( iDATA ),
	.wren ( iWRENH ),
	.q ( oDATAH )
);

assign oDATA = iADDR[16] ? oDATAH : oDATAL;

endmodule 

