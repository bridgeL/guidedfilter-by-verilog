module face_blur
(
	input iCLK,
	input iRST_N,
	input iDVAL,
	output oDVAL,
	input [7:0] iDATA,
	output [23:0] oDATA
);

// max: 32bit x 131,072
// data: 32bit x 400 x 300


wire [23:0] oData1;
wire [23:0] oData2;
wire [23:0] oData3;
wire [23:0] oData4;
wire  wren1;
wire  wren2;
wire  wren3;
wire  wren4;
wire [16:0] iAddr1;
wire [16:0] iAddr2;
wire [16:0] iAddr3;
wire [16:0] iAddr4;
wire [23:0] iData1;
wire [23:0] iData2;
wire [23:0] iData3;
wire [23:0] iData4;
	

data_ctrl data_ctrl_inst
(
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.iDVAL(iDVAL) ,	// input  iDVAL
	.iDATA(iDATA) ,	// input [7:0] iDATA
	.oDVAL(oDVAL) ,	// output  oDVAL
	.oDATA(oDATA) ,	// output [7:0] oDATA
	.oData1(oData1) ,	// input [23:0] oData1
	.oData2(oData2) ,	// input [23:0] oData2
	.oData3(oData3) ,	// input [23:0] oData3
	.oData4(oData4) ,	// input [23:0] oData4
	.wren1(wren1) ,	// output  wren1
	.wren2(wren2) ,	// output  wren2
	.wren3(wren3) ,	// output  wren3
	.wren4(wren4) ,	// output  wren4
	.iAddr1(iAddr1) ,	// output [16:0] iAddr1
	.iAddr2(iAddr2) ,	// output [16:0] iAddr2
	.iAddr3(iAddr3) ,	// output [16:0] iAddr3
	.iAddr4(iAddr4) ,	// output [16:0] iAddr4
	.iData1(iData1) ,	// output [23:0] iData1
	.iData2(iData2) ,	// output [23:0] iData2
	.iData3(iData3) ,	// output [23:0] iData3
	.iData4(iData4) 	// output [23:0] iData4
);

ram2	u1_data
(
	.iADDR ( iAddr1 ),
	.iCLK ( iCLK ),
	.iDATA ( iData1 ),
	.iWREN ( wren1 ),
	.oDATA ( oData1 )
);

ram2	u2_data
(
	.iADDR ( iAddr2 ),
	.iCLK ( iCLK ),
	.iDATA ( iData2 ),
	.iWREN ( wren2 ),
	.oDATA ( oData2 )
);

ram2	u3_data
(
	.iADDR ( iAddr3 ),
	.iCLK ( iCLK ),
	.iDATA ( iData3 ),
	.iWREN ( wren3 ),
	.oDATA ( oData3 )
);

ram2	u4_data
(
	.iADDR ( iAddr4 ),
	.iCLK ( iCLK ),
	.iDATA ( iData4 ),
	.iWREN ( wren4 ),
	.oDATA ( oData4 )
);




endmodule 