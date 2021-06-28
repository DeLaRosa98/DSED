----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:31:13 PM
-- Design Name: 
-- Module Name: en_4_cycles_tb - Behavioral
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

ENTITY en_4_cycles_tb IS
END en_4_cycles_tb;

ARCHITECTURE Behavioral OF en_4_cycles_tb IS

    COMPONENT en_4_cycles
        PORT (
            clk_12megas : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            clk_3megas : OUT STD_LOGIC;
            en_2_cycles : OUT STD_LOGIC;
            en_4_cycles : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL clk_12megas : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL clk_3megas : STD_LOGIC := '0';
    SIGNAL en_2_cycles : STD_LOGIC := '0';
    SIGNAL en_4_cycles1 : STD_LOGIC := '0';

    CONSTANT clk_period : TIME := 83.3 ns;

BEGIN

    UUT_enable : en_4_cycles
    PORT MAP(
        clk_12megas => clk_12megas,
        reset => reset,
        clk_3megas => clk_3megas,
        en_2_cycles => en_2_cycles,
        en_4_cycles => en_4_cycles1);

    clk_12megas <= NOT clk_12megas AFTER clk_period/2;

    stimuli : PROCESS
    BEGIN

        reset <= '1';
        WAIT FOR 100 ns;
        reset <= '0';
        WAIT FOR 100 ns;

        WAIT;
    END PROCESS;

END Behavioral;
