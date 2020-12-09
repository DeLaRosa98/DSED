----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2020 22:20:37
-- Design Name: 
-- Module Name: tb_FSMD_microphone - Behavioral
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

ENTITY tb_FSMD_microphone IS
    --  Port ( );
END tb_FSMD_microphone;

ARCHITECTURE Behavioral OF tb_FSMD_microphone IS

    COMPONENT FSMD_microphone IS
        PORT (
            clk_12megas : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable_4_cycles : IN STD_LOGIC;
            micro_data : IN STD_LOGIC;
            sample_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            sample_out_ready : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT en_4_cycles
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
    SIGNAL enable_4_cycles : STD_LOGIC := '1';
    SIGNAL micro_data : STD_LOGIC := '0'; -- Tarea 1.7
    --signal micro_data : std_logic := '1'; --Tarea 1.6
    -- Output signals
    SIGNAL sample_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL sample_out_ready : STD_LOGIC := '0';
    SIGNAL clk_3megas : STD_LOGIC := '0';
    SIGNAL en_2_cycles : STD_LOGIC := '0';

    -- Constant time
    CONSTANT clk_period : TIME := 83.33 ns;

    --Simulation signals
    SIGNAL a, b, c : STD_LOGIC := '1';

BEGIN

    UUT_enables : en_4_cycles
    PORT MAP(
        clk_12megas => clk_12megas,
        reset => reset,
        clk_3megas => clk_3megas,
        en_2_cycles => en_2_cycles,
        en_4_cycles => enable_4_cycles
    );

    UUT_FSMD : FSMD_microphone
    PORT MAP(
        clk_12megas => clk_12megas,
        reset => reset,
        enable_4_cycles => enable_4_cycles,
        micro_data => micro_data,
        sample_out => sample_out,
        sample_out_ready => sample_out_ready
    );

    -- Reset process definitions
    reset_process : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 100 ns;
        reset <= '0';
        WAIT;
    END PROCESS;

    -- Clock process definitions
    CLK_process : PROCESS
    BEGIN
        clk_12megas <= '0';
        WAIT FOR clk_period/2;
        clk_12megas <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Microdata definitions - Tarea 1.7
    a <= NOT a AFTER 1300 ns;
    b <= NOT b AFTER 2100 ns;
    c <= NOT c AFTER 3700 ns;
    micro_data <= a XOR b XOR c;

END Behavioral;