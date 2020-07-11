module face_blur
(
	input iCLK,
	input iRST_N,
	input iDVAL,
	output oDVAL,
	input [7:0] iDATA,
	output [15:0] oDATA,
    input [15:0] eps
);

// max: 32bit x 131,072
// data: 32bit x 300 x 210


wire [15:0] oData1;
wire [15:0] oData2;
wire [15:0] oData3;
wire [15:0] oData4;
wire  wren1;
wire  wren2;
wire  wren3;
wire  wren4;
wire [15:0] iAddr1;
wire [15:0] iAddr2;
wire [15:0] iAddr3;
wire [15:0] iAddr4;
wire [15:0] iData1;
wire [15:0] iData2;
wire [15:0] iData3;
wire [15:0] iData4;
	

data_ctrl data_ctrl_inst
(
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.iDVAL(iDVAL) ,	// input  iDVAL
	.iDATA(iDATA) ,	// input [7:0] iDATA
	.oDVAL(oDVAL) ,	// output  oDVAL
	.oDATA(oDATA) ,	// output [7:0] oDATA
    
    .eps(eps),
    
	.oData1(oData1) ,	// input [15:0] oData1
	.oData2(oData2) ,	// input [15:0] oData2
	.oData3(oData3) ,	// input [15:0] oData3
	.oData4(oData4) ,	// input [15:0] oData4
	.wren1(wren1) ,	// output  wren1
	.wren2(wren2) ,	// output  wren2
	.wren3(wren3) ,	// output  wren3
	.wren4(wren4) ,	// output  wren4
	.iAddr1(iAddr1) ,	// output [15:0] iAddr1
	.iAddr2(iAddr2) ,	// output [15:0] iAddr2
	.iAddr3(iAddr3) ,	// output [15:0] iAddr3
	.iAddr4(iAddr4) ,	// output [15:0] iAddr4
	.iData1(iData1) ,	// output [15:0] iData1
	.iData2(iData2) ,	// output [15:0] iData2
	.iData3(iData3) ,	// output [15:0] iData3
	.iData4(iData4) 	// output [15:0] iData4
);

ram1	u1
(
	.address ( iAddr1 ),
	.clock ( iCLK ),
	.data ( iData1 ),
	.wren ( wren1 ),
	.q ( oData1 )
);

ram1	u2
(
	.address ( iAddr2 ),
	.clock ( iCLK ),
	.data ( iData2 ),
	.wren ( wren2 ),
	.q ( oData2 )
);

ram1	u3
(
	.address ( iAddr3 ),
	.clock ( iCLK ),
	.data ( iData3 ),
	.wren ( wren3 ),
	.q ( oData3 )
);

ram1	u4
(
	.address ( iAddr4 ),
	.clock ( iCLK ),
	.data ( iData4 ),
	.wren ( wren4 ),
	.q ( oData4 )
);




endmodule 