----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2021 12:17:13 PM
-- Design Name: 
-- Module Name: fir_filter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY fir_filter IS
    PORT (
        clk : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        Sample_In : IN signed (sample_size - 1 DOWNTO 0);
        Sample_In_enable : IN STD_LOGIC;
        filter_select : IN STD_LOGIC; --0 lowpass, 1 highpass
        Sample_Out : OUT signed (sample_size - 1 DOWNTO 0);
        Sample_Out_ready : OUT STD_LOGIC);
END fir_filter;

ARCHITECTURE Behavioral OF fir_filter IS

BEGIN
END Behavioral;