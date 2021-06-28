-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
-- Date        : Fri Dec 21 10:35:05 2018
-- Host        : DESKTOP-13SP0QN running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/Guille/VivadoProjects/proyecto/proyecto.srcs/sources_1/ip/clk_12megas/clk_12megas_stub.vhdl
-- Design      : clk_12megas
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_12megas is
  Port ( 
    clk_12 : out STD_LOGIC;
    clk_100 : in STD_LOGIC
  );

end clk_12megas;

architecture stub of clk_12megas is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_12,clk_100";
begin
end;
