// Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2014.4 (win32) Build 1071353 Tue Nov 18 18:06:20 MST 2014
// Date        : Wed Jan 21 16:06:49 2015
// Host        : ul-win7-12 running 32-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/ulab/Downloads/Lab_Project1.xpr/Lab_Project1/Lab_Project1.srcs/sources_1/ip/SequenceStorage/SequenceStorage_stub.v
// Design      : SequenceStorage
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_2,Vivado 2014.4" *)
module SequenceStorage(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[3:0],douta[15:0]" */;
  input clka;
  input [3:0]addra;
  output [15:0]douta;
endmodule
