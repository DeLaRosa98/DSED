----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:40:48 PM
-- Design Name: 
-- Module Name: data_route_filter - Behavioral
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY data_route_filter IS
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
        count : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        y : OUT signed (sample_size - 1 DOWNTO 0));
END data_route_filter;

ARCHITECTURE Behavioral OF data_route_filter IS

    COMPONENT mux6
        PORT (
            in0 : IN signed (sample_size - 1 DOWNTO 0);
            in1 : IN signed (sample_size - 1 DOWNTO 0);
            in2 : IN signed (sample_size - 1 DOWNTO 0);
            in3 : IN signed (sample_size - 1 DOWNTO 0);
            in4 : IN signed (sample_size - 1 DOWNTO 0);
            in5 : IN signed (sample_size - 1 DOWNTO 0);
            in6 : IN signed (sample_size - 1 DOWNTO 0);
            s : OUT signed (sample_size - 1 DOWNTO 0);
            ctrl : IN STD_LOGIC_VECTOR (2 DOWNTO 0));
    END COMPONENT;

    SIGNAL s0, s1, s2, sum, r1_reg, r1_next, r2_reg, r2_next : signed (sample_size - 1 DOWNTO 0);
    SIGNAL mult_reg, mult_next : signed (2 * sample_size - 1 DOWNTO 0);

BEGIN

    UUT_mux1 : mux6 PORT MAP(
        in0 => c0,
        in1 => c1,
        in2 => c2,
        in3 => c3,
        in4 => c4,
        in5 => (OTHERS => '0'),
        in6 => (OTHERS => '0'),
        s => s0,
        ctrl => count
    );

    UUT_mux2 : mux6 PORT MAP(
        in0 => x0,
        in1 => x1,
        in2 => x2,
        in3 => x3,
        in4 => x4,
        in5 => (OTHERS => '0'),
        in6 => (OTHERS => '0'),
        s => s1,
        ctrl => count
    );

    UUT_mux3 : mux6 PORT MAP(
        in0 => (OTHERS => '0'),
        in1 => mult_reg(2 * sample_size - 2 DOWNTO sample_size - 1),
        in2 => r1_reg,
        in3 => sum,
        in4 => sum,
        in5 => sum,
        in6 => sum,
        s => s2,
        ctrl => count
    );

    SYNC_PROC : PROCESS (clk, reset)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            IF (reset = '1') THEN
                r1_reg <= (OTHERS => '0');
                r2_reg <= (OTHERS => '0');
                mult_reg <= (OTHERS => '0');
            ELSE
                r1_reg <= r1_next;
                r2_reg <= r2_next;
                mult_reg <= mult_next;
            END IF;
        END IF;
    END PROCESS;

    r1_next <= s2;
    r2_next <= mult_reg(2 * sample_size - 2 DOWNTO sample_size - 1);
    mult_next <= s0 * s1;
    sum <= r1_reg + r2_reg;
    y <= signed(sum);

END Behavioral;