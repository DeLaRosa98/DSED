----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:40:12 PM
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
USE work.package_dsed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY mux6 IS
    PORT (
        in0 : IN signed (sample_size - 1 DOWNTO 0);
        in1 : IN signed (sample_size - 1 DOWNTO 0);
        in2 : IN signed (sample_size - 1 DOWNTO 0);
        in3 : IN signed (sample_size - 1 DOWNTO 0);
        in4 : IN signed (sample_size - 1 DOWNTO 0);
        in5 : IN signed (sample_size - 1 DOWNTO 0);
        in6 : IN signed (sample_size - 1 DOWNTO 0);
        s : OUT signed (sample_size - 1 DOWNTO 0);
        ctrl : IN STD_LOGIC_VECTOR (2 DOWNTO 0));
END mux6;

ARCHITECTURE Behavioral OF mux6 IS

BEGIN

    WITH ctrl SELECT s <=
        in0 WHEN "000",
        in1 WHEN "001",
        in2 WHEN "010",
        in3 WHEN "011",
        in4 WHEN "100",
        in5 WHEN "101",
        in6 WHEN "110",
        in0 WHEN OTHERS;

END Behavioral;