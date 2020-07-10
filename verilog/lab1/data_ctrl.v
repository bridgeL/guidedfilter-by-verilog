module flow_ctrl
(
    input iCLK,
    input iRST_N,
    input [15:0] done,
    output reg [3:0] STATUS,
    output reg [15:0] ena
);

always @(posedge iCLK)	begin
	if(!iRST_N)	begin
        STATUS <= 0;
        ena <= 0;
    end
    else begin
        if(done[STATUS]) begin
            STATUS <= STATUS + 1;
            ena <= (1 << STATUS);
        end
        else begin
            STATUS <= STATUS;
            ena <= 0;
        end           
    end 
end

endmodule 

module data_ctrl
(
	input iCLK,
	input iRST_N,
	
	input iDVAL,
	input [7:0] iDATA,
	
	output oDVAL,
	output [23:0] oDATA,
	
	input [23:0] oData1,
	input [23:0] oData2,
	input [23:0] oData3,
	input [23:0] oData4,
	output wren1,
	output wren2,
	output wren3,
	output wren4,
	output [16:0] iAddr1,
	output [16:0] iAddr2,
	output [16:0] iAddr3,
	output [16:0] iAddr4,
	output [23:0] iData1,
	output [23:0] iData2,
	output [23:0] iData3,
	output [23:0] iData4
);

wire [3:0] STATUS;
wire [15:0] ena;
wire [15:0] done;
assign done[0] = iDVAL;

flow_ctrl flow_ctrl_inst
(
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.done(done) ,	// input [3:0] done
	.STATUS(STATUS) ,	// output [3:0] STATUS
	.ena(ena) 	// output [3:0] ena
);

wire f1_wren1;
wire f1_wren2;
wire f1_wren3;
wire [16:0] f1_iAddr1;
wire [16:0] f1_iAddr2;
wire [16:0] f1_iAddr3;
wire [23:0] f1_iData1;
wire [23:0] f1_iData2;
wire [23:0] f1_iData3;


read_data read_data_inst
(
	.ena(ena[0]) ,	// input  ena
	.done(done[1]) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.iDATA(iDATA) ,	// input [7:0] iDATA
	.wrenA(f1_wren1) ,	// output  wrenA
	.wrenB(f1_wren2) ,	// output  wrenB
	.wrenC(f1_wren3) ,	// output  wrenC
	.iAddrA(f1_iAddr1) ,	// output [16:0] iAddrA
	.iAddrB(f1_iAddr2) ,	// output [16:0] iAddrB
	.iAddrC(f1_iAddr3) ,	// output [16:0] iAddrC
	.iDataA(f1_iData1) ,	// output [23:0] iDataA
	.iDataB(f1_iData2) ,	// output [23:0] iDataB
	.iDataC(f1_iData3) 	// output [23:0] iDataC
);

wire f2_wren1;
wire f2_wren4;
wire [16:0] f2_iAddr1;
wire [16:0] f2_iAddr4;
wire [23:0] f2_iData1;
wire [23:0] f2_iData4;

// meanI存入ram1中
blur blur_inst1
(
	.ena(ena[1]) ,	// input  ena
	.done(done[2]) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.oDataA(oData1) ,	// input [23:0] oDataA
	.oDataB(oData4) ,	// input [23:0] oDataB
	.wrenA(f2_wren1) ,	// output  wrenA
	.wrenB(f2_wren4) ,	// output  wrenB
	.iAddrA(f2_iAddr1) ,	// output [16:0] iAddrA
	.iAddrB(f2_iAddr4) ,	// output [16:0] iAddrB
	.iDataA(f2_iData1) ,	// output [23:0] iDataA
	.iDataB(f2_iData4) 	// output [23:0] iDataB
);

wire f3_wren2;
wire f3_wren4;
wire [16:0] f3_iAddr2;
wire [16:0] f3_iAddr4;
wire [23:0] f3_iData2;
wire [23:0] f3_iData4;

// meanII存入ram2中
blur blur_inst2
(
	.ena(ena[2]) ,	// input  ena
	.done(done[3]) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.oDataA(oData2) ,	// input [23:0] oDataA
	.oDataB(oData4) ,	// input [23:0] oDataB
	.wrenA(f3_wren2) ,	// output  wrenA
	.wrenB(f3_wren4) ,	// output  wrenB
	.iAddrA(f3_iAddr2) ,	// output [16:0] iAddrA
	.iAddrB(f3_iAddr4) ,	// output [16:0] iAddrB
	.iDataA(f3_iData2) ,	// output [23:0] iDataA
	.iDataB(f3_iData4) 	// output [23:0] iDataB
);

wire f4_wren1;
wire f4_wren2;
wire f4_wren4;
wire [16:0] f4_iAddr1;
wire [16:0] f4_iAddr2;
wire [16:0] f4_iAddr4;
wire [23:0] f4_iData4;

// cov存入ram4中
covAB covAB_inst
(
	.ena(ena[3]) ,	// input  ena
	.done(done[4]) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.oDataA(oData1) ,	// input [23:0] oDataA
	.oDataB(oData2) ,	// input [23:0] oDataB
	.wrenA(f4_wren1) ,	// output  wrenA
	.wrenB(f4_wren2) ,	// output  wrenB
	.wrenC(f4_wren4) ,	// output  wrenC
	.iAddrA(f4_iAddr1) ,	// output [16:0] iAddrA
	.iAddrB(f4_iAddr2) ,	// output [16:0] iAddrB
	.iAddrC(f4_iAddr4) ,	// output [16:0] iAddrC
	.iDataC(f4_iData4) 	// output [23:0] iDataC
);

wire f5_wren2;
wire f5_wren4;
wire [16:0] f5_iAddr4;
wire [16:0] f5_iAddr2;
wire [23:0] f5_iData2;

// a 存入ram2中
calcu_a calcu_a_inst
(
	.ena(ena[4]) ,	// input  ena
	.done(done[5]) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.oDataA(oData4) ,	// input [23:0] oDataA
	.wrenA(f5_wren4) ,	// output  wrenA
	.wrenB(f5_wren2) ,	// output  wrenB
	.iAddrA(f5_iAddr4) ,	// output [16:0] iAddrA
	.iAddrB(f5_iAddr2) ,	// output [16:0] iAddrB
	.iDataB(f5_iData2) 	// output [23:0] iDataB
);

wire f6_wren1;
wire f6_wren2;
wire f6_wren4;
wire [16:0] f6_iAddr1;
wire [16:0] f6_iAddr2;
wire [16:0] f6_iAddr4;
wire [23:0] f6_iData4;

// b存入ram4中
calcu_b calcu_b_inst
(
	.ena(ena[5]) ,	// input  ena
	.done(done[6]) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.oDataA(oData1) ,	// input [23:0] oDataA
	.oDataB(oData2) ,	// input [23:0] oDataB
	.wrenA(f6_wren1) ,	// output  wrenA
	.wrenB(f6_wren2) ,	// output  wrenB
	.wrenC(f6_wren4) ,	// output  wrenC
	.iAddrA(f6_iAddr1) ,	// output [16:0] iAddrA
	.iAddrB(f6_iAddr2) ,	// output [16:0] iAddrB
	.iAddrC(f6_iAddr4) ,	// output [16:0] iAddrC
	.iDataC(f6_iData4) 	// output [23:0] iDataC
);

wire f7_wren1;
wire f7_wren2;
wire [16:0] f7_iAddr1;
wire [16:0] f7_iAddr2;
wire [23:0] f7_iData1;
wire [23:0] f7_iData2;

// mean_a存入ram2中
blur blur_inst3
(
	.ena(ena[6]) ,	// input  ena
	.done(done[7]) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.oDataA(oData2) ,	// input [23:0] oDataA
	.oDataB(oData1) ,	// input [23:0] oDataB
	.wrenA(f7_wren2) ,	// output  wrenA
	.wrenB(f7_wren1) ,	// output  wrenB
	.iAddrA(f7_iAddr2) ,	// output [16:0] iAddrA
	.iAddrB(f7_iAddr1) ,	// output [16:0] iAddrB
	.iDataA(f7_iData2) ,	// output [23:0] iDataA
	.iDataB(f7_iData1) 	// output [23:0] iDataB
);


wire f8_wren1;
wire f8_wren4;
wire [16:0] f8_iAddr1;
wire [16:0] f8_iAddr4;
wire [23:0] f8_iData1;
wire [23:0] f8_iData4;

// mean_b存入ram4中
blur blur_inst4
(
	.ena(ena[7]) ,	// input  ena
	.done(done[8]) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.oDataA(oData4) ,	// input [23:0] oDataA
	.oDataB(oData1) ,	// input [23:0] oDataB
	.wrenA(f8_wren4) ,	// output  wrenA
	.wrenB(f8_wren1) ,	// output  wrenB
	.iAddrA(f8_iAddr4) ,	// output [16:0] iAddrA
	.iAddrB(f8_iAddr1) ,	// output [16:0] iAddrB
	.iDataA(f8_iData4) ,	// output [23:0] iDataA
	.iDataB(f8_iData1) 	// output [23:0] iDataB
);

wire f9_wren1;
wire f9_wren2;
wire f9_wren3;
wire f9_wren4;
wire [16:0] f9_iAddr1;
wire [16:0] f9_iAddr2;
wire [16:0] f9_iAddr3;
wire [16:0] f9_iAddr4;
wire [23:0] f9_iData1;

result result_inst
(
	.ena(ena[8]) ,	// input  ena
	.done(done[9]) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.oDataA(oData2) ,	// input [23:0] oDataA
	.oDataB(oData4) ,	// input [23:0] oDataB
	.oDataC(oData3) ,	// input [23:0] oDataC
	.wrenA(f9_wren2) ,	// output  wrenA
	.wrenB(f9_wren4) ,	// output  wrenB
	.wrenC(f9_wren3) ,	// output  wrenC
	.wrenD(f9_wren1) ,	// output  wrenD
	.iAddrA(f9_iAddr2) ,	// output [16:0] iAddrA
	.iAddrB(f9_iAddr4) ,	// output [16:0] iAddrB
	.iAddrC(f9_iAddr3) ,	// output [16:0] iAddrC
	.iAddrD(f9_iAddr1) ,	// output [16:0] iAddrD
	.iDataD(f9_iData1) 	// output [23:0] iDataD
);



wire f10_oDVAL;
wire [23:0] f10_oDATA;
wire f10_wren1;
wire [16:0] f10_iAddr1;

output_jpg output_jpg_inst
(
	.ena(ena[9]) ,	// input  ena
	.done(done[10]) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.oDataA(oData1) ,	// input [23:0] oDataA
	.oDVAL(f10_oDVAL) ,	// output  oDVAL
	.oDATA(f10_oDATA) ,	// output [7:0] oDATA
	.wrenA(f10_wren1) ,	// output  wrenA
	.iAddrA(f10_iAddr1) 	// output [16:0] iAddrA
);

wire s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10;
assign s0 = (STATUS==0) ? 1 : 0;
assign s1 = (STATUS==1) ? 1 : 0;
assign s2 = (STATUS==2) ? 1 : 0;
assign s3 = (STATUS==3) ? 1 : 0;
assign s4 = (STATUS==4) ? 1 : 0;
assign s5 = (STATUS==5) ? 1 : 0;
assign s6 = (STATUS==6) ? 1 : 0;
assign s7 = (STATUS==7) ? 1 : 0;
assign s8 = (STATUS==8) ? 1 : 0;
assign s9 = (STATUS==9) ? 1 : 0;
assign s10 = (STATUS==10) ? 1 : 0;

assign oDVAL = s10 ? f10_oDVAL : 0;
assign oDATA = s10 ? f10_oDATA : 0;

assign {wren1,wren2,wren3,wren4}  = s1 ? {f1_wren1, f1_wren2, f1_wren3, 1'b0    } :  
                                    s2 ? {f2_wren1,     1'b0,     1'b0, f2_wren4} : 
                                    s3 ? {    1'b0, f3_wren2,     1'b0, f3_wren4} : 
                                    s4 ? {f4_wren1, f4_wren2,     1'b0, f4_wren4} : 
                                    s5 ? {    1'b0, f5_wren2,     1'b0, f5_wren4} : 
                                    s6 ? {f6_wren1, f6_wren2,     1'b0, f6_wren4} : 
                                    s7 ? {f7_wren1, f7_wren2,     1'b0,     1'b0} : 
                                    s8 ? {f8_wren1,     1'b0,     1'b0, f8_wren4} : 
                                    s9 ? {f9_wren1, f9_wren2, f9_wren3, f9_wren4} : 
                                    s10 ? {f10_wren1,    1'b0,     1'b0,     1'b0} : 0;

assign {iAddr1,iAddr2,iAddr3,iAddr4} = s1 ? {f1_iAddr1, f1_iAddr2, f1_iAddr3,     17'b0} :   
                                       s2 ? {f2_iAddr1,     17'b0,     17'b0, f2_iAddr4} : 
                                       s3 ? {    17'b0, f3_iAddr2,     17'b0, f3_iAddr4} : 
                                       s4 ? {f4_iAddr1, f4_iAddr2,     17'b0, f4_iAddr4} : 
                                       s5 ? {    17'b0, f5_iAddr2,     17'b0, f5_iAddr4} : 
                                       s6 ? {f6_iAddr1, f6_iAddr2,     17'b0, f6_iAddr4} : 
                                       s7 ? {f7_iAddr1, f7_iAddr2,     17'b0,     17'b0} : 
                                       s8 ? {f8_iAddr1,     17'b0,     17'b0, f8_iAddr4} : 
                                       s9 ? {f9_iAddr1, f9_iAddr2, f9_iAddr3, f9_iAddr4} : 
                                       s10 ? {f10_iAddr1,    17'b0,     17'b0,     17'b0} : 0;
                                        
assign {iData1,iData2,iData3,iData4} = s1 ? {f1_iData1, f1_iData2, f1_iData3,     24'b0} :
                                       s2 ? {f2_iData1,     24'b0,     24'b0, f2_iData4} : 
                                       s3 ? {    24'b0, f3_iData2,     24'b0, f3_iData4} : 
                                       s4 ? {    24'b0,     24'b0,     24'b0, f4_iData4} : 
                                       s5 ? {    24'b0, f5_iData2,     24'b0,     24'b0} :
                                       s6 ? {    24'b0,     24'b0,     24'b0, f6_iData4} : 
                                       s7 ? {f7_iData1, f7_iData2,     24'b0,     24'b0} : 
                                       s8 ? {f8_iData1,     24'b0,     24'b0, f8_iData4} : 
                                       s9 ? {f9_iData1,     24'b0,     24'b0,     24'b0} : 0;
                                     
endmodule 