----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:38:30 PM
-- Design Name: 
-- Module Name: controlador_tb - Behavioral
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

ENTITY controlador_tb IS
END controlador_tb;

ARCHITECTURE Behavioral OF controlador_tb IS

    COMPONENT controlador PORT (
        clk_100Mhz : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        micro_clk : OUT STD_LOGIC;
        micro_data : IN STD_LOGIC;
        micro_LR : OUT STD_LOGIC;
        jack_sd : OUT STD_LOGIC;
        jack_pwm : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL clk_100Mhz : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL micro_clk : STD_LOGIC := '0';
    SIGNAL micro_data : STD_LOGIC := '0';
    SIGNAL micro_LR : STD_LOGIC := '0';
    SIGNAL jack_sd : STD_LOGIC := '0';
    SIGNAL jack_pwm : STD_LOGIC := '0';
    SIGNAL a, b, d : STD_LOGIC := '0';

    CONSTANT clk_period : TIME := 83.3 ns;

BEGIN

    con : controlador
    PORT MAP(
        clk_100Mhz => clk_100Mhz,
        reset => reset,
        micro_clk => micro_clk,
        micro_data => micro_data,
        micro_LR => micro_LR,
        jack_sd => jack_sd,
        jack_pwm => jack_pwm);

    clk_100Mhz <= NOT clk_100Mhz AFTER clk_period/2;

    stimuli : PROCESS
    BEGIN
        reset <= '1';
        WAIT FOR 100 ns;
        reset <= '0';
        WAIT;
    END PROCESS;

    MICRO_PROC : PROCESS
    BEGIN
        WAIT FOR 100 ns;
        a <= NOT a AFTER 1300 ns;
        b <= NOT b AFTER 2100 ns;
        d <= NOT d AFTER 3700 ns;
        micro_data <= a XOR b XOR d;
    END PROCESS;

END Behavioral;