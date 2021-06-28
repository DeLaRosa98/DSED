----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:32:32 PM
-- Design Name: 
-- Module Name: FSMD_microphone_tb - Behavioral
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

ENTITY FSMD_microphone_tb IS
END FSMD_microphone_tb;

ARCHITECTURE Behavioral OF FSMD_microphone_tb IS

    COMPONENT FSMD_microphone PORT (
        clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable_4_cycles : IN STD_LOGIC;
        micro_data : IN STD_LOGIC;
        sample_out : OUT STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0);
        sample_out_ready : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT en_4_cycles PORT (
        clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        clk_3megas : OUT STD_LOGIC;
        en_2_cycles : OUT STD_LOGIC;
        en_4_cycles : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL clk_12megas : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL enable_4_cycles : STD_LOGIC := '0';
    SIGNAL micro_data : STD_LOGIC := '0';
    SIGNAL sample_out : STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sample_out_ready : STD_LOGIC := '0';
    SIGNAL clk_3megas : STD_LOGIC := '0';
    SIGNAL en_2_cycles : STD_LOGIC := '0';
    SIGNAL a, b, c : STD_LOGIC := '0';

    CONSTANT clk_period : TIME := 83.3 ns;

BEGIN

    UUT_microphone : FSMD_microphone
    PORT MAP(
        clk_12megas => clk_12megas,
        reset => reset,
        enable_4_cycles => enable_4_cycles,
        micro_data => micro_data,
        sample_out => sample_out,
        sample_out_ready => sample_out_ready
    );

    UUT_enable : en_4_cycles
    PORT MAP(
        clk_12megas => clk_12megas,
        reset => reset,
        clk_3megas => clk_3megas,
        en_2_cycles => en_2_cycles,
        en_4_cycles => enable_4_cycles
    );

    clk_12megas <= NOT clk_12megas AFTER clk_period/2;

    stimuli : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 100 ns;
        reset <= '0';
        WAIT;
    END PROCESS;

    a <= NOT a AFTER 1300 ns;
    b <= NOT b AFTER 2100 ns;
    c <= NOT c AFTER 3700 ns;
    micro_data <= a XOR b XOR c;

END Behavioral;
