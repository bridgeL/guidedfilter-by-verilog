module calcu_b
// b
(
    input ena,
    output done,
    
    input iCLK,
    input iRST_N,
    
    input [23:0] oDataA,
    input [23:0] oDataB,
	
    output wrenA,
	output wrenB,
    output wrenC,
    output [15:0] iAddrA,
	output [15:0] iAddrB,
    output [15:0] iAddrC,
    output [23:0] iDataC
);

reg [1:0] STATUS;

wire s0,s1,s2,s3;
assign s0 = (STATUS==0) ? 1 : 0;
assign s1 = (STATUS==1) ? 1 : 0;
assign s2 = (STATUS==2) ? 1 : 0;
assign s3 = (STATUS==3) ? 1 : 0;

reg [15:0] iAddr;
assign iAddrA = iAddr;
assign iAddrB = iAddr;
assign iAddrC = iAddr;

assign done   = s2 ? 1 : 0;
assign wrenA  = 0;       
assign wrenB  = 0;   
assign wrenC  = s1 ? 1 : 0;  
assign iDataC = s1 ? (oDataA << 7) - (oDataA * oDataB) : 0;

always @(posedge iCLK)	begin
	if(!iRST_N)	begin
        iAddr <= 0;
    end
    else begin
        if(STATUS==1) begin
            if(iAddr >= 300*210 - 1) begin
                iAddr <= 0;
            end
            else begin
                iAddr <= iAddr + 1;
            end
        end
        else begin
            iAddr <= 0;
        end
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
            if(iAddr >= 300*210 - 1) begin
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