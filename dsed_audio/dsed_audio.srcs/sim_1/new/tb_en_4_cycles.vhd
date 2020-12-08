----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2020 05:30:54 PM
-- Design Name: 
-- Module Name: tb_en_4_cycles - Behavioral
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
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.package_dsed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY tb_en_4_cycles IS
    --  Port ( );
END tb_en_4_cycles;

ARCHITECTURE Behavioral OF tb_en_4_cycles IS

    COMPONENT en_4_cycles IS
    PORT (
        clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        clk_3megas : OUT STD_LOGIC;
        en_2_cycles : OUT STD_LOGIC;
        en_4_cycles : OUT STD_LOGIC);
    END COMPONENT;

    -- Inputs signals
    SIGNAL clk_12megas : STD_LOGIC := '1';
    SIGNAL reset : STD_LOGIC := '0';
    
    -- Output signals
    SIGNAL clk_3megas : STD_LOGIC := '0';
    SIGNAL en_2_cycles : STD_LOGIC := '0';
    SIGNAL en_4_cycles : STD_LOGIC := '0';

    -- Constant time
    CONSTANT clk_period : TIME := 166.66 ns;

BEGIN

    UUT_enables : en_4_cycles
    PORT MAP(
        clk_12megas => clk_12megas,
        reset => reset,
        clk_3megas => clk_3megas,
        en_2_cycles => en_2_cycles,
        en_4_cycles => en_4_cycles
    );

    reset_process : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 15 ns;
        reset <= '0';
        WAIT;
    END PROCESS;

    CLK_process : PROCESS
    BEGIN
        clk_12megas <= '0';
        WAIT FOR clk_period/2;
        clk_12megas <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

END Behavioral;