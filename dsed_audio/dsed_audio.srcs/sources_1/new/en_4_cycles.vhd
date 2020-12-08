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

    SIGNAL count2 : INTEGER := 1;
    SIGNAL count4 : INTEGER := 1;
    SIGNAL temp2 : STD_LOGIC;
    SIGNAL temp3 : STD_LOGIC;
    SIGNAL temp4 : STD_LOGIC;

BEGIN
    PROCESS (clk_12megas, reset)
    BEGIN
        IF (reset = '1') THEN
            count2 <= 0;
            temp2 <= '0';
            temp3 <= '0';
            count4 <= 0;
            temp4 <= '0';
        END IF;
        IF (clk_12megas'event AND clk_12megas = '1') THEN
            count2 <= count2 + 1;
            temp2 <= '0';
            count4 <= count4 + 1;
            temp4 <= '0';
            IF (count2 = 2) THEN
                count2 <= 0;
                temp2 <= '1';
                temp3 <= NOT temp3;
            END IF;
            IF (count4 = 4) THEN
                count4 <= 0;
                temp4 <= '1';
            END IF;
        END IF;
        clk_3megas <= temp3;
        en_2_cycles <= temp2;
        en_4_cycles <= temp4;
    END PROCESS;
END Behavioral;