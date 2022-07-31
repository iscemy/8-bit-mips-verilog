`define and_alu 2'b0000
`define not_alu 2'b0001
`define add_alu 2'b0010

// module test (
    
// );
//     reg [7:0] A,B;
//     reg [2:0] F;
//     wire [7:0] out;
//     wire [3:0] flags;
//     alu al(A, B, F, out, flags);

//     initial begin
//         $dumpfile("alu.vcd");
//         $dumpvars(0,test);
//         A = 8'b10100110;
//         B = 8'b11111111;
//         F = 0;
//         #5
//         F=1;
//         #5
//         F=2;
//         #5
//         $finish;
//     end
    
// endmodule
//010 add
//011 sub
module alu (
    A, B, out, flags, control
);
    input [7:0] A, B;
    input [3:0] control;
    output [7:0] out;
    output [7:0] flags;

    reg[8:0] result;

    assign flags[0] = result[8];            //carry /
    assign flags[1] = result[7:0] == 0;     //zero
    assign flags[2] = A > B;                //is A > B
    assign flags[3] = 0;                    // todo overflow
    assign flags[7:4] = 0;                    //reserved
    assign out = result[7:0];
    
    initial begin
        result = 0;
    end

    always @* begin
        if(control == 3'b010) begin
            result <= A+B;
        end else if (control == 4'b0000) begin
            result <= B;
        end else if (control == 4'b0001) begin // and
            result <= A&B;
        end else if (control == 4'b0011) begin // A-B
            result <= A-B; 
        end else if (control == 4'b0100) begin // or
            result <=A|B;
        end else if (control == 4'b0101) begin // invert
            result <= ~A;
        end else if (control == 4'b0110) begin // shift left
            result <= A << 1;
            result[8] <= A[7];
        end else if (control == 4'b0111) begin //shift right
            result <= A >> 1;
            result[8] <= A[0];
        end else if (control == 4'b1000) begin
            result <= A  < B;
        end
    end
    
endmodule