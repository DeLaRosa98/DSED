----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2021 02:47:54 PM
-- Design Name: 
-- Module Name: mux6 - Behavioral
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

ENTITY mux6 IS
    PORT (
        in_1 : IN signed (sample_size - 1 DOWNTO 0);
        in_2 : IN signed (sample_size - 1 DOWNTO 0);
        in_3 : IN signed (sample_size - 1 DOWNTO 0);
        in_4 : IN signed (sample_size - 1 DOWNTO 0);
        in_5 : IN signed (sample_size - 1 DOWNTO 0);
        in_6 : IN singed(sample_size - 1 DOWNTO 0);
        out_mux : OUT signed (sample_size - 1 DOWNTO 0);
        control : IN STD_LOGIC_VECTOR (2 DOWNTO 0)
    );
END mux6;

ARCHITECTURE Behavioral OF mux6 IS

BEGIN
    WITH control SELECT out_mux <=
        in_0 WHEN "000",
        in_1 WHEN "001",
        in_2 WHEN "010",
        in_3 WHEN "011",
        in_4 WHEN "100",
        in_5 WHEN "101",
        in_6 WHEN "110",
        in_0 WHEN OTHERS;

END Behavioral;