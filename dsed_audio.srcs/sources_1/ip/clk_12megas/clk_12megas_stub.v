// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Fri Dec 21 10:35:05 2018
// Host        : DESKTOP-13SP0QN running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/Guille/VivadoProjects/proyecto/proyecto.srcs/sources_1/ip/clk_12megas/clk_12megas_stub.v
// Design      : clk_12megas
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_12megas(clk_12, clk_100)
/* synthesis syn_black_box black_box_pad_pin="clk_12,clk_100" */;
  output clk_12;
  input clk_100;
endmodule
