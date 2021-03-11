----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2020 12:35:13 PM
-- Design Name: 
-- Module Name: en_4_cycles - Behavioral
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY en_4_cycles IS
    PORT (
        clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        clk_3megas : OUT STD_LOGIC;
        en_2_cycles : OUT STD_LOGIC;
        en_4_cycles : OUT STD_LOGIC);
END en_4_cycles;

ARCHITECTURE Behavioral OF en_4_cycles IS

    SIGNAL count : STD_LOGIC_VECTOR (1 DOWNTO 0);

BEGIN
    PROCESS (clk_12megas)
    BEGIN
        IF (clk_12megas'event AND clk_12megas = '1') THEN
            IF (reset = '1') THEN
                count <= "00";
            ELSE
                count <= count + '1';
            END IF;
        END IF;
    END PROCESS;

    WITH count SELECT
        clk_3megas <= '1' WHEN "01",
        '1' WHEN "10",
        '0' WHEN OTHERS;
    WITH count SELECT
        en_4_cycles <= '1' WHEN "01",
        '0' WHEN OTHERS;
    WITH count SELECT
        en_2_cycles <= '1' WHEN "00",
        '1' WHEN "10",
        '0' WHEN OTHERS;
END Behavioral;