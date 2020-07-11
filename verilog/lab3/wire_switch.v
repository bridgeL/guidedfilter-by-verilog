module  wire_switch
(
    input [3:0] STATUS,
    input [15:0] ena,
    output [15:0] _done,
    
    output wren1,
    output wren2,
    output wren3,
    output wren4,
    
    output [15:0] iAddr1,
    output [15:0] iAddr2,
    output [15:0] iAddr3,
    output [15:0] iAddr4,
    
    output [15:0] iData1,
    output [15:0] iData2,
    output [15:0] iData3,
    output [15:0] iData4,
    
    input [15:0] oData1,
    input [15:0] oData2,
    input [15:0] oData3,
    input [15:0] oData4,
    
    input iDVAL,
    output oDVAL,
    output [15:0] oDATA,
    
    input f1_wren1,
    input f1_wren2,
    input f1_wren3,
    input [15:0] f1_iAddr1,
    input [15:0] f1_iAddr2,
    input [15:0] f1_iAddr3,
    input [15:0] f1_iData1,
    input [15:0] f1_iData2,
    input [15:0] f1_iData3,
    
    output br_ena,
    input br_done,
    output [15:0] br_oDataA,
    output [15:0] br_oDataB,
    input br_wrenA,
    input br_wrenB,
    input [15:0] br_iAddrA,
    input [15:0] br_iAddrB,
    input [15:0] br_iDataA,
    input [15:0] br_iDataB,
    
    input f4_wren1,
    input f4_wren2,
    input f4_wren4,
    input [15:0] f4_iAddr1,
    input [15:0] f4_iAddr2,
    input [15:0] f4_iAddr4,
    input [15:0] f4_iData4,
    
    input f5_wren2,
    input f5_wren4,
    input [15:0] f5_iAddr4,
    input [15:0] f5_iAddr2,
    input [15:0] f5_iData2,
    
    input f6_wren1,
    input f6_wren2,
    input f6_wren4,
    input [15:0] f6_iAddr1,
    input [15:0] f6_iAddr2,
    input [15:0] f6_iAddr4,
    input [15:0] f6_iData4,
    
    input f9_wren1,
    input f9_wren2,
    input f9_wren3,
    input f9_wren4,
    input [15:0] f9_iAddr1,
    input [15:0] f9_iAddr2,
    input [15:0] f9_iAddr3,
    input [15:0] f9_iAddr4,
    input [15:0] f9_iData1,
    
    input f10_oDVAL,
    input [15:0] f10_oDATA,
    input f10_wren1,
    input [15:0] f10_iAddr1
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

assign br_ena = s2 ? ena[1] :
                s3 ? ena[2] : 
                s7 ? ena[6] :
                s8 ? ena[7] : 0;
assign _done[2] = s2 ? br_done : 0;
assign _done[3] = s3 ? br_done : 0;
assign _done[7] = s7 ? br_done : 0;
assign _done[8] = s8 ? br_done : 0;
assign br_oDataA = s2 ? oData1 :
                   s3 ? oData2 : 
                   s7 ? oData2 :
                   s8 ? oData4 : 0;
assign br_oDataB = s2 ? oData4 :
                   s3 ? oData4 : 
                   s7 ? oData1 :
                   s8 ? oData1 : 0;
                   
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
                                        
assign {iData1,iData2,iData3,iData4} = s1 ? {f1_iData1, f1_iData2, f1_iData3,     16'b0} :
                                       s2 ? {br_iDataA,     16'b0,     16'b0, br_iDataB} : 
                                       s3 ? {    16'b0, br_iDataA,     16'b0, br_iDataB} : 
                                       s4 ? {    16'b0,     16'b0,     16'b0, f4_iData4} : 
                                       s5 ? {    16'b0, f5_iData2,     16'b0,     16'b0} :
                                       s6 ? {    16'b0,     16'b0,     16'b0, f6_iData4} : 
                                       s7 ? {br_iDataB, br_iDataA,     16'b0,     16'b0} : 
                                       s8 ? {br_iDataB,     16'b0,     16'b0, br_iDataA} : 
                                       s9 ? {f9_iData1,     16'b0,     16'b0,     16'b0} : 96'b0;
                                       
endmodule 