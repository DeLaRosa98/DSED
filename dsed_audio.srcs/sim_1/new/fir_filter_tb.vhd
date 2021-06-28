----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:39:44 PM
-- Design Name: 
-- Module Name: fir_filter_tb - Behavioral
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

ENTITY fir_filter_tb IS
END fir_filter_tb;

ARCHITECTURE Behavioral OF fir_filter_tb IS

    COMPONENT fir_filter PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        sample_in : IN signed (sample_size - 1 DOWNTO 0);
        sample_in_enable : IN STD_LOGIC;
        filter_select : IN STD_LOGIC;
        sample_out : OUT signed (sample_size - 1 DOWNTO 0);
        sample_out_ready : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL sample_in : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sample_in_enable : STD_LOGIC := '0';
    SIGNAL filter_select : STD_LOGIC := '0';
    SIGNAL sample_out : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sample_out_ready : STD_LOGIC := '0';

    CONSTANT clk_period : TIME := 83.3 ns;

BEGIN

    UUT_filter : fir_filter
    PORT MAP(
        clk => clk,
        reset => reset,
        sample_in => sample_in,
        sample_in_enable => sample_in_enable,
        filter_select => filter_select,
        sample_out => sample_out,
        sample_out_ready => sample_out_ready
    );

    clk <= NOT clk AFTER clk_period/2;

    stimuli : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 113 ns;
        reset <= '0';
        filter_select <= '0';

        sample_in_enable <= '1';
        sample_in <= "00000000"; -- 0
        WAIT FOR clk_period;
        sample_in_enable <= '0';
        WAIT FOR 1500ns;

        sample_in_enable <= '1';
        sample_in <= "01000000"; -- 0.5
        WAIT FOR clk_period;
        sample_in_enable <= '0';
        WAIT FOR 1500ns;

        sample_in_enable <= '1';
        sample_in <= "00000000"; -- 0
        WAIT FOR clk_period;
        sample_in_enable <= '0';
        WAIT FOR 1500ns;

        sample_in_enable <= '1';
        sample_in <= "00100000"; -- 0.125
        WAIT FOR clk_period;
        sample_in_enable <= '0';
        WAIT FOR 1500ns;

        sample_in_enable <= '1';
        sample_in <= "00000000"; -- 0
        WAIT FOR clk_period;
        sample_in_enable <= '0';
        WAIT FOR 1500ns;

        sample_in_enable <= '1';
        sample_in <= "00000000"; -- 0
        WAIT FOR clk_period;
        sample_in_enable <= '0';
        WAIT FOR 1500ns;

        sample_in_enable <= '1';
        sample_in <= "00000000"; -- 0
        WAIT FOR clk_period;
        sample_in_enable <= '0';
        WAIT FOR 1500ns;

        sample_in_enable <= '1';
        sample_in <= "00000000"; -- 0
        WAIT FOR clk_period;
        sample_in_enable <= '0';
        WAIT FOR 1500ns;

        sample_in_enable <= '1';
        sample_in <= "00000000"; -- 0
        WAIT FOR clk_period;
        sample_in_enable <= '0';
        WAIT FOR 1500ns;

--        reset <= '1';
--        WAIT FOR 113 ns;
--        reset <= '0';
--        filter_select <= '1';

--        sample_in_enable <= '1';
--        sample_in <= "00000000"; -- 0
--        WAIT FOR clk_period;
--        sample_in_enable <= '0';
--        WAIT FOR 1500ns;

--        sample_in_enable <= '1';
--        sample_in <= "01000000"; -- 0.5
--        WAIT FOR clk_period;
--        sample_in_enable <= '0';
--        WAIT FOR 1500ns;

--        sample_in_enable <= '1';
--        sample_in <= "00100000"; -- 0.125
--        WAIT FOR clk_period;
--        sample_in_enable <= '0';
--        WAIT FOR 1500ns;

--        sample_in_enable <= '1';
--        sample_in <= "00000000"; -- 0
--        WAIT FOR clk_period;
--        sample_in_enable <= '0';
--        WAIT FOR 1500ns;

--        sample_in_enable <= '1';
--        sample_in <= "00000000"; -- 0
--        WAIT FOR clk_period;
--        sample_in_enable <= '0';
--        WAIT FOR 1500ns;

--        sample_in_enable <= '1';
--        sample_in <= "00000000"; -- 0
--        WAIT FOR clk_period;
--        sample_in_enable <= '0';
--        WAIT FOR 1500ns;

--        sample_in_enable <= '1';
--        sample_in <= "00000000"; -- 0
--        WAIT FOR clk_period;
--        sample_in_enable <= '0';
--        WAIT FOR 1500ns;

--        sample_in_enable <= '1';
--        sample_in <= "00000000"; -- 0
--        WAIT FOR clk_period;
--        sample_in_enable <= '0';
--        WAIT FOR 1500ns;

--        sample_in_enable <= '1';
--        sample_in <= "00000000"; -- 0
--        WAIT FOR clk_period;
--        sample_in_enable <= '0';
--        WAIT FOR 1500ns;

        WAIT;
    END PROCESS;

END Behavioral;