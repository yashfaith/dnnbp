////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Perceptron Module
// File Name        : perceptron.v
// Version          : 1.0
// Description      : Perceptron with 2 inputs, 2 weight, and 1 bias.
//                    Giving output of activation and z value.
//
////////////////////////////////////////////////////////////////////////////////

module perceptron1 (clk, rst, wr, i_k, i_w, i_b, o);

// parameters
parameter NUM = 2;
parameter WIDTH = 32;

// common ports
input clk, rst;

// control ports
input wr;

// input ports
input signed [NUM*WIDTH-1:0] i_k;
input signed [NUM*WIDTH-1:0] i_w;
input signed [WIDTH-1:0] i_b;

// output ports
output signed [WIDTH-1:0] o;

// wires
wire signed [NUM*WIDTH-1:0] o_mul;
wire signed [WIDTH-1:0] o_add;

// registers
reg signed [NUM*WIDTH-1:0] wght_mem [0:0];
reg signed [NUM*WIDTH-1:0] wght;
reg signed [WIDTH-1:0] bias_mem [0:0];
reg signed [WIDTH-1:0] bias;

always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		// RAM initialization
		$readmemh("mem_wght.list", wght_mem);
		$readmemh("mem_bias.list", bias_mem);
	end
	else if (wr)
	begin
		// To add new value to RAM
		wght_mem[0] <= i_w;
		bias_mem[0] <= i_b;
	end
	else
	begin
		// To read value from RAM
		wght <= wght_mem[0];
		bias <= bias_mem[0];
	end
end

// Generate N multiplier, o_mul is an array of multiplier outputs, WIDTH bits each
mult_2in #(.WIDTH(WIDTH)) mult[NUM-1:0] (.i_a(i_k), .i_b(wght), .o(o_mul));

// Adding all multiplier output & bias
adder #(.NUM(NUM+1), .WIDTH(WIDTH)) add (.i({bias, o_mul}), .o(o_add));

// Using sigmoid function for the Activation value
sigmf sigmoid (.i(o_add), .o(o));

endmodule