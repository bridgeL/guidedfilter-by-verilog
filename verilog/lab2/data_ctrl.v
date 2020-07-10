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
	
    input [23:0] eps,
    
	input [23:0] oData1,
	input [23:0] oData2,
	input [23:0] oData3,
	input [23:0] oData4,
	output wren1,
	output wren2,
	output wren3,
	output wren4,
	output [15:0] iAddr1,
	output [15:0] iAddr2,
	output [15:0] iAddr3,
	output [15:0] iAddr4,
	output [23:0] iData1,
	output [23:0] iData2,
	output [23:0] iData3,
	output [23:0] iData4
);

wire [3:0] STATUS;
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
wire [15:0] f1_iAddr1;
wire [15:0] f1_iAddr2;
wire [15:0] f1_iAddr3;
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
	.iAddrA(f1_iAddr1) ,	// output [15:0] iAddrA
	.iAddrB(f1_iAddr2) ,	// output [15:0] iAddrB
	.iAddrC(f1_iAddr3) ,	// output [15:0] iAddrC
	.iDataA(f1_iData1) ,	// output [23:0] iDataA
	.iDataB(f1_iData2) ,	// output [23:0] iDataB
	.iDataC(f1_iData3) 	// output [23:0] iDataC
);

wire br_ena;
wire br_done;
wire [23:0] br_oDataA;
wire [23:0] br_oDataB;
wire br_wrenA;
wire br_wrenB;
wire [15:0] br_iAddrA;
wire [15:0] br_iAddrB;
wire [23:0] br_iDataA;
wire [23:0] br_iDataB;

assign br_ena = s2 ? ena[1] :
                s3 ? ena[2] : 
                s7 ? ena[6] :
                s8 ? ena[7] : 0;
assign done[2] = s2 ? br_done : 0;
assign done[3] = s3 ? br_done : 0;
assign done[7] = s7 ? br_done : 0;
assign done[8] = s8 ? br_done : 0;
assign br_oDataA = s2 ? oData1 :
                   s3 ? oData2 : 
                   s7 ? oData2 :
                   s8 ? oData4 : 0;
assign br_oDataB = s2 ? oData4 :
                   s3 ? oData4 : 
                   s7 ? oData1 :
                   s8 ? oData1 : 0;

blur b0
(
	.ena(br_ena) ,	// input  ena
	.done(br_done) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
	.oDataA(br_oDataA) ,	// input [23:0] oDataA
	.oDataB(br_oDataB) ,	// input [23:0] oDataB
	.wrenA(br_wrenA) ,	// output  wrenA
	.wrenB(br_wrenB) ,	// output  wrenB
	.iAddrA(br_iAddrA) ,	// output [15:0] iAddrA
	.iAddrB(br_iAddrB) ,	// output [15:0] iAddrB
	.iDataA(br_iDataA) ,	// output [23:0] iDataA
	.iDataB(br_iDataB) 	// output [23:0] iDataB
);

wire f4_wren1;
wire f4_wren2;
wire f4_wren4;
wire [15:0] f4_iAddr1;
wire [15:0] f4_iAddr2;
wire [15:0] f4_iAddr4;
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
	.iAddrA(f4_iAddr1) ,	// output [15:0] iAddrA
	.iAddrB(f4_iAddr2) ,	// output [15:0] iAddrB
	.iAddrC(f4_iAddr4) ,	// output [15:0] iAddrC
	.iDataC(f4_iData4) 	// output [23:0] iDataC
);

wire f5_wren2;
wire f5_wren4;
wire [15:0] f5_iAddr4;
wire [15:0] f5_iAddr2;
wire [23:0] f5_iData2;

// a 存入ram2中
calcu_a calcu_a_inst
(
	.ena(ena[4]) ,	// input  ena
	.done(done[5]) ,	// output  done
	.iCLK(iCLK) ,	// input  iCLK
	.iRST_N(iRST_N) ,	// input  iRST_N
    .eps(eps),
	.oDataA(oData4) ,	// input [23:0] oDataA
	.wrenA(f5_wren4) ,	// output  wrenA
	.wrenB(f5_wren2) ,	// output  wrenB
	.iAddrA(f5_iAddr4) ,	// output [15:0] iAddrA
	.iAddrB(f5_iAddr2) ,	// output [15:0] iAddrB
	.iDataB(f5_iData2) 	// output [23:0] iDataB
);

wire f6_wren1;
wire f6_wren2;
wire f6_wren4;
wire [15:0] f6_iAddr1;
wire [15:0] f6_iAddr2;
wire [15:0] f6_iAddr4;
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
	.iAddrA(f6_iAddr1) ,	// output [15:0] iAddrA
	.iAddrB(f6_iAddr2) ,	// output [15:0] iAddrB
	.iAddrC(f6_iAddr4) ,	// output [15:0] iAddrC
	.iDataC(f6_iData4) 	// output [23:0] iDataC
);

wire f9_wren1;
wire f9_wren2;
wire f9_wren3;
wire f9_wren4;
wire [15:0] f9_iAddr1;
wire [15:0] f9_iAddr2;
wire [15:0] f9_iAddr3;
wire [15:0] f9_iAddr4;
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
	.iAddrA(f9_iAddr2) ,	// output [15:0] iAddrA
	.iAddrB(f9_iAddr4) ,	// output [15:0] iAddrB
	.iAddrC(f9_iAddr3) ,	// output [15:0] iAddrC
	.iAddrD(f9_iAddr1) ,	// output [15:0] iAddrD
	.iDataD(f9_iData1) 	// output [23:0] iDataD
);

wire f10_oDVAL;
wire [23:0] f10_oDATA;
wire f10_wren1;
wire [15:0] f10_iAddr1;

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
	.iAddrA(f10_iAddr1) 	// output [15:0] iAddrA
);

assign oDVAL = s10 ? f10_oDVAL : 0;
assign oDATA = s10 ? f10_oDATA : 0;

assign {wren1,wren2,wren3,wren4}  = s1 ? {f1_wren1, f1_wren2, f1_wren3, 1'b0    } :  
                                    s2 ? {br_wrenA,     1'b0,     1'b0, br_wrenB} : 
                                    s3 ? {    1'b0, br_wrenA,     1'b0, br_wrenB} : 
                                    s4 ? {f4_wren1, f4_wren2,     1'b0, f4_wren4} : 
                                    s5 ? {    1'b0, f5_wren2,     1'b0, f5_wren4} : 
                                    s6 ? {f6_wren1, f6_wren2,     1'b0, f6_wren4} : 
                                    s7 ? {br_wrenB, br_wrenA,     1'b0,     1'b0} : 
                                    s8 ? {br_wrenB,     1'b0,     1'b0, br_wrenA} : 
                                    s9 ? {f9_wren1, f9_wren2, f9_wren3, f9_wren4} : 
                                    s10 ? {f10_wren1,    1'b0,     1'b0,     1'b0} : 4'b0;

assign {iAddr1,iAddr2,iAddr3,iAddr4} = s1 ? {f1_iAddr1, f1_iAddr2, f1_iAddr3,     16'b0} :   
                                       s2 ? {br_iAddrA,     16'b0,     16'b0, br_iAddrB} : 
                                       s3 ? {    16'b0, br_iAddrA,     16'b0, br_iAddrB} : 
                                       s4 ? {f4_iAddr1, f4_iAddr2,     16'b0, f4_iAddr4} : 
                                       s5 ? {    16'b0, f5_iAddr2,     16'b0, f5_iAddr4} : 
                                       s6 ? {f6_iAddr1, f6_iAddr2,     16'b0, f6_iAddr4} : 
                                       s7 ? {br_iAddrB, br_iAddrA,     16'b0,     16'b0} : 
                                       s8 ? {br_iAddrB,     16'b0,     16'b0, br_iAddrA} : 
                                       s9 ? {f9_iAddr1, f9_iAddr2, f9_iAddr3, f9_iAddr4} : 
                                       s10 ? {f10_iAddr1,    16'b0,     16'b0,     16'b0} : 64'b0;
                                        
assign {iData1,iData2,iData3,iData4} = s1 ? {f1_iData1, f1_iData2, f1_iData3,     24'b0} :
                                       s2 ? {br_iDataA,     24'b0,     24'b0, br_iDataB} : 
                                       s3 ? {    24'b0, br_iDataA,     24'b0, br_iDataB} : 
                                       s4 ? {    24'b0,     24'b0,     24'b0, f4_iData4} : 
                                       s5 ? {    24'b0, f5_iData2,     24'b0,     24'b0} :
                                       s6 ? {    24'b0,     24'b0,     24'b0, f6_iData4} : 
                                       s7 ? {br_iDataB, br_iDataA,     24'b0,     24'b0} : 
                                       s8 ? {br_iDataB,     24'b0,     24'b0, br_iDataA} : 
                                       s9 ? {f9_iData1,     24'b0,     24'b0,     24'b0} : 96'b0;
                                     
endmodule 