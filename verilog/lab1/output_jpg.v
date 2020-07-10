module output_jpg
// 输出图片数据
(
    input ena,
    output done,
    
    input iCLK,
    input iRST_N,
    
    input [23:0] oDataA,
    
    output oDVAL,
	output [23:0] oDATA,
	
    output wrenA,
    output reg [16:0] iAddrA

);

reg [1:0] STATUS;

wire s0,s1,s2;
assign s0 = (STATUS==0) ? 1 : 0;
assign s1 = (STATUS==1) ? 1 : 0;
assign s2 = (STATUS==2) ? 1 : 0;

assign oDVAL = s1 ? 1 : 0;
assign done  = s2 ? 1 : 0;
assign oDATA = s1 ? oDataA : 0; //24bits for debug, correctly should be 8bits
assign wrenA = 0;

always @(posedge iCLK)	begin
	if(!iRST_N)	begin
        iAddrA <= 0;
    end
    else if(s1) begin
        if(iAddrA >= 300*400 - 1) begin
            iAddrA <= 0;
        end
        else begin
            iAddrA <= iAddrA + 1;
        end
    end
    else begin
        iAddrA <= 0;
    end
end


always @(posedge iCLK)	begin
	if(!iRST_N)	begin
        STATUS <= 0;
    end
    else begin
        case(STATUS)
        0: begin
            if(ena) begin
                STATUS <= 1;
            end
            else begin
                STATUS <= 0;
            end
        end
        
        1: begin
            if(iAddrA >= 300*400 - 1) begin
                STATUS <= 2;
            end
            else begin
				STATUS <= 1;
            end
        end
        
        2: begin
            STATUS <= 0;
        end
        
        default: begin 
            STATUS <= 0; 
        end
            
        endcase
    end
end


endmodule 