`timescale 1ns / 10 ps
module face_TB;

parameter w = 210;
parameter h = 300;

reg iCLK; 
reg iRST_N; 
initial begin  iCLK = 0;   iRST_N = 0;    #40    iRST_N = 1;   end

always #10 iCLK = ~iCLK;

reg iDVAL;
reg [7:0] iDATA;
initial begin iDVAL = 0; iDATA = 0; end

wire oDVAL;
wire [23:0] oDATA;

reg [7:0] DataSource    [0:w*h-1];
reg [23:0] DataOutput    [0:w*h-1];

initial
begin
    $readmemh("imgdata.txt",DataSource);
#20
	$display("0x00: %h",DataSource[8'h00]);
end 

reg [3:0] STATUS;
reg [15:0] cnt;

integer save_picture;
integer i;


always @(negedge iCLK)
begin 
    if(!iRST_N) begin
        STATUS <= 0;
        cnt <= 0;
    end
    else begin
       case(STATUS) 
        0: begin
            STATUS <= 1; 
            iDVAL <= 1;
            iDATA <= DataSource[0];
            cnt <= 0;
        end

        1: begin
            if(cnt >= h*w - 1) begin
                cnt <= 0;
                iDVAL <= 0;
                iDATA <= 0;
                STATUS <= 2;
            end
            else begin
                cnt <= cnt + 1;
                iDATA <= DataSource[cnt];
            end
        end

        2: begin
            if(oDVAL) begin
                STATUS <= 3;
                cnt <= 0;
            end
        end
        
        3: begin
            if(cnt >= h*w-1) begin
                cnt <= 0;
                STATUS <= 4;
            end
            else begin
                cnt <= cnt + 1;
                DataOutput[cnt] <= oDATA;
            end
        end

        4: begin
            save_picture = $fopen("savedata.txt");
            for(i=0;i<w*h;i=i+1)
            begin
            #1 
                if (!i) $fdisplay(save_picture,"%2h",i);
                else    $fdisplay(save_picture,"%h",DataOutput[i]);
            end
            $fclose(save_picture);
            $stop();  
        end
        endcase
    end
end



face_blur face_blur_inst
(
	.iCLK(iCLK) ,	// input  iCLK_sig
	.iRST_N(iRST_N) ,	// input  iRST_N_sig
	.iDVAL(iDVAL) ,	// input  iDVAL_sig
	.oDVAL(oDVAL) ,	// output  oDVAL_sig
	.iDATA(iDATA) ,	// input [7:0] iDATA_sig
	.oDATA(oDATA), 	// output [7:0] oDATA_sig
    .eps(800)   // 美颜力度
);


   
endmodule
