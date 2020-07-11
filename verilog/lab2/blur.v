module blur
(
    input ena,
    output done,
    
    input iCLK,
    input iRST_N,
    
    input [23:0] oDataA,
    input [23:0] oDataB,
   
    output wrenA,
    output wrenB,
    output [15:0] iAddrA,
    output [15:0] iAddrB,
    output [23:0] iDataA,
    output [23:0] iDataB
);

reg [2:0] STATUS;

wire s0,s1,s2,s3;
assign s0 = (STATUS==0) ? 1 : 0;
assign s1 = (STATUS==1) ? 1 : 0;
assign s2 = (STATUS==2) ? 1 : 0;
assign s3 = (STATUS==3) ? 1 : 0;

reg [23:0] databuf [0:15];
reg [9:0] row;
reg [9:0] col;

wire [15:0] iAddr;
assign iAddr = row * 210 + col;

wire [23:0] data;
wire [25:0] sum4 [0:3];
wire [27:0] sum;

integer i;
genvar j; 

generate
    for(j=0;j<4;j=j+1) begin:adder
        assign sum4[j] = databuf[j*4+0] + databuf[j*4+1] + databuf[j*4+2] + databuf[j*4+3];
    end
endgenerate
  
assign sum = sum4[0] + sum4[1] + sum4[2] + sum4[3];

assign done   = s3 ? 1 : 0;
assign data   = s1 ? oDataA : 
                s2 ? oDataB : 0;
assign wrenA  = s1 ? 0 : 
                s2 ? 1 : 0;
assign wrenB  = s1 ? 1 : 
                s2 ? 0 : 0;
assign iDataA = s2 ? sum[27:4] : 0;
assign iDataB = s1 ? sum[27:4] : 0;
assign iAddrA = s1 ? iAddr :
                s2 ? iAddr - 8*210 : 0;
assign iAddrB = s1 ? iAddr - 8 :
                s2 ? iAddr : 0;


always @(posedge iCLK)	begin
	if(!iRST_N)	begin
        for(i=0;i<16;i=i+1) begin
            databuf[i] <= 0;
        end
    end
    else if(s1||s2) begin
        databuf[0] <= data;
        for(i=0;i<16-1;i=i+1) begin
            databuf[i+1] <= databuf[i];
        end
    end
    else begin
        for(i=0;i<16;i=i+1) begin
            databuf[i] <= 0;
        end
    end
end

always @(posedge iCLK)	begin
	if(!iRST_N)	begin
        row <= 0;
        col <= 0;
    end
    else begin
        case(STATUS)
        1: begin
            if(col < 210 - 1) begin
                col <= col + 1;
            end
            else if (row < 300 - 1) begin
                row <= row + 1;
                col <= 0;
            end
            else begin
                row <= 0;
                col <= 0;
            end
        end

        2: begin
            if(row < 300 - 1) begin
                row <= row + 1;
            end
            else if (col < 210 - 1) begin
                col <= col + 1;
                row <= 0;
            end
            else begin
                row <= 0;
                col <= 0;
            end
        end
        
        default: begin 
            row <= 0;
            col <= 0;
        end
            
        endcase
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
        end

        2: begin
            if(iAddr >= 300*210 - 1) begin
                STATUS <= 3;
            end
        end
        
        3: begin
            STATUS <= 0; 
        end
        
        default: begin 
            STATUS <= 0; 
        end
            
        endcase
    end
end


endmodule 