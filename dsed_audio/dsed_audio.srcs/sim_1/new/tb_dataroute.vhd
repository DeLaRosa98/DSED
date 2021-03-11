----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2021 10:07:27 AM
-- Design Name: 
-- Module Name: tb_dataroute - Behavioral
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

ENTITY tb_dataroute IS
END tb_dataroute;

ARCHITECTURE Behavioral OF tb_dataroute IS

    COMPONENT dataroute
        PORT (
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
            control : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            y : OUT signed (sample_size - 1 DOWNTO 0));
        );
    END COMPONENT;

    SIGNAL clk : IN STD_LOGIC;
    SIGNAL reset : IN STD_LOGIC;
    SIGNAL c0 : IN signed (sample_size - 1 DOWNTO 0);
    SIGNAL c1 : IN signed (sample_size - 1 DOWNTO 0);
    SIGNAL c2 : IN signed (sample_size - 1 DOWNTO 0);
    SIGNAL c3 : IN signed (sample_size - 1 DOWNTO 0);
    SIGNAL c4 : IN signed (sample_size - 1 DOWNTO 0);
    SIGNAL x0 : IN signed (sample_size - 1 DOWNTO 0);
    SIGNAL x1 : IN signed (sample_size - 1 DOWNTO 0);
    SIGNAL x2 : IN signed (sample_size - 1 DOWNTO 0);
    SIGNAL x3 : IN signed (sample_size - 1 DOWNTO 0);
    SIGNAL x4 : IN signed (sample_size - 1 DOWNTO 0);
    SIGNAL control : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL y : OUT signed (sample_size - 1 DOWNTO 0));

    CONSTANT clk_period : TIME := 167 ns;

BEGIN

    UUT_dataroute : dataroute PORT MAP(
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
        control => control,
        y => y,
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
        control <= "000";
        WAIT 100 ns;
        control <= "001";
        WAIT 100 ns;
        control <= "010";
        WAIT 100 ns;
        control <= "011";
        WAIT 100 ns;
        control <= "100";
        WAIT 100 ns;
        control <= "101";
        WAIT 100 ns;
        control <= "110";
        WAIT 100 ns;
    END PROCESS;

END Behavioral;