----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:41:19 PM
-- Design Name: 
-- Module Name: data_route_filter_tb - Behavioral
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

ENTITY data_route_filter_tb IS
END data_route_filter_tb;

ARCHITECTURE Behavioral OF data_route_filter_tb IS

    COMPONENT data_route_filter PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        c0 : IN signed (sample_size - 1 DOWNTO 0);
        c1 : IN signed (sample_size - 1 DOWNTO 0);
        c2 : IN signed (sample_size - 1 DOWNTO 0);
        c3 : IN signed (sample_size - 1 DOWNTO 0);
        c4 : IN signed (sample_size - 1 DOWNTO 0);
        x0 : IN signed (sample_size - 1 DOWNTO 0);
        x1 : IN signed (sample_size - 1 DOWNTO 0);
        x2 : IN signed (sample_size - 1 DOWNTO 0);
        x3 : IN signed (sample_size - 1 DOWNTO 0);
        x4 : IN signed (sample_size - 1 DOWNTO 0);
        count : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        y : OUT signed (sample_size - 1 DOWNTO 0));
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL c0 : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL c1 : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL c2 : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL c3 : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL c4 : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL x0 : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL x1 : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL x2 : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL x3 : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL x4 : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL cuenta : STD_LOGIC_VECTOR (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL y : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');

    CONSTANT clk_period : TIME := 83.3 ns;

BEGIN

    UUT_dataroute : data_route_filter
    PORT MAP(
        clk => clk,
        reset => reset,
        c0 => c0,
        c1 => c1,
        c2 => c2,
        c3 => c3,
        c4 => c4,
        x0 => x0,
        x1 => x1,
        x2 => x2,
        x3 => x3,
        x4 => x4,
        count => cuenta,
        y => y
    );

    clk <= NOT clk AFTER clk_period/2;

    stimuli : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 100 ns;
        reset <= '0';
        c0 <= "00000000";
        x0 <= "00000000";
        c1 <= "00000001";
        x1 <= "00000001";
        c2 <= "00100010";
        x2 <= "00000010";
        c3 <= "00000011";
        x3 <= "01000011";
        c4 <= "00000100";
        x4 <= "00000100";
        WAIT FOR 500 us;
        cuenta <= "000";
        WAIT FOR 500 us;
        cuenta <= "001";
        WAIT FOR 500 us;
        cuenta <= "010";
        WAIT FOR 500 us;
        cuenta <= "011";
        WAIT FOR  500 us;
        cuenta <= "100";
        WAIT FOR 500 us;
        cuenta <= "101";
        WAIT FOR 500 us;
        cuenta <= "110";
        WAIT FOR 500 us;
        cuenta <= "111";
        WAIT;
    END PROCESS;

END Behavioral;