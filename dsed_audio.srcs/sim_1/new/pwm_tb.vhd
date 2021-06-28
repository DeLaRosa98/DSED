----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:35:16 PM
-- Design Name: 
-- Module Name: pwm_tb - Behavioral
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

ENTITY pwm_tb IS
END pwm_tb;

ARCHITECTURE Behavioral OF pwm_tb IS

    COMPONENT pwm PORT (
        clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        en_2_cycles : IN STD_LOGIC;
        sample_in : IN STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
        sample_request : OUT STD_LOGIC;
        pwm_pulse : OUT STD_LOGIC);
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
    SIGNAL en_2_cycles : STD_LOGIC := '0';
    SIGNAL sample_in : STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sample_request : STD_LOGIC := '0';
    SIGNAL pwm_pulse : STD_LOGIC := '0';
    SIGNAL clk_3megas : STD_LOGIC := '0';
    SIGNAL enable_4_cycles : STD_LOGIC := '0';

    CONSTANT clk_period : TIME := 83.3 ns;

BEGIN

    UUT_pwm : pwm
    PORT MAP(
        clk_12megas => clk_12megas,
        reset => reset,
        en_2_cycles => en_2_cycles,
        sample_in => sample_in,
        sample_request => sample_request,
        pwm_pulse => pwm_pulse);

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
        sample_in <= (OTHERS => '0');
        WAIT FOR 250 us;
        sample_in <= (OTHERS => '1');
        WAIT FOR 500 us;
        sample_in <= "10110010";
        WAIT FOR 500 us;
        sample_in <= "10010010";
        WAIT FOR 500 us;
        sample_in <= "01001101";
        WAIT FOR 500 us;
        sample_in <= "01101101";
        WAIT;
    END PROCESS;

END Behavioral;