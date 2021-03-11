----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2021 09:43:37 AM
-- Design Name: 
-- Module Name: dataroute - Behavioral
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

ENTITY dataroute IS
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
END dataroute;

ARCHITECTURE Behavioral OF dataroute IS

    COMPONENT mux6
        PORT (
            in_1 : IN signed (sample_size - 1 DOWNTO 0);
            in_2 : IN signed (sample_size - 1 DOWNTO 0);
            in_3 : IN signed (sample_size - 1 DOWNTO 0);
            in_4 : IN signed (sample_size - 1 DOWNTO 0);
            in_5 : IN signed (sample_size - 1 DOWNTO 0);
            in_6 : IN singed(sample_size - 1 DOWNTO 0);
            out_mux : OUT signed (sample_size - 1 DOWNTO 0);
            control : IN STD_LOGIC_VECTOR (2 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL mux0, mux1, mux2, mux3, mux4, mux5, sum : signed (sample_size - 1 DOWNTO 0);
    SIGNAL r1_reg, r1_next, r2_reg, r2_next, r3_reg, r3_next : signed (sample_size - 1 DOWNTO 0);
    SIGNAL mult1_reg, mult1_next, mult2_reg, mult2_next : signed (2 * sample_size - 1 DOWNTO 0);

BEGIN

    UUT_mux1 : mux6 PORT MAP(
        in_1 => c0,
        in_2 => c2,
        in_3 => c4,
        in_4 => (OTHERS => '0'),
        in_5 => (OTHERS => '0'),
        in_6 => (OTHERS => '0'),
        out_mux => mux0,
        control => control
    );

    UUT_mux2 : mux6 PORT MAP(
        in_1 => x0,
        in_2 => x2,
        in_3 => x4,
        in_4 => (OTHERS => '0'),
        in_5 => (OTHERS => '0'),
        in_6 => (OTHERS => '0'),
        out_mux => mux2,
        control => control
    );

    UUT_mux3 : mux6 PORT MAP(
        in_1 => c1,
        in_2 => c3,
        in_3 => (OTHERS => '0'),
        in_4 => (OTHERS => '0'),
        in_5 => (OTHERS => '0'),
        in_6 => (OTHERS => '0'),
        out_mux => mux3,
        control => control
    );

    UUT_mux4 : mux6 PORT MAP(
        in_1 => x1,
        in_2 => x3,
        in_3 => (OTHERS => '0'),
        in_4 => (OTHERS => '0'),
        in_5 => (OTHERS => '0'),
        in_6 => (OTHERS => '0'),
        out_mux => mux4,
        control => control
    );

    UUT_mux5 : mux6 PORT MAP(
        in_1 => (OTHERS => '0'),
        in_2 => (OTHERS => '0'),
        in_3 => r1_reg,
        in_4 => r1_reg,
        in_5 => r1_reg,
        in_6 => r1_reg,
        out_mux => mux5,
        control => control
    );

    UUT_mux6 : mux6 PORT MAP(
        in_1 => (OTHERS => '0'),
        in_2 => (OTHERS => '0'),
        in_3 => r2_reg,
        in_4 => r2_reg,
        in_5 => r3_reg,
        in_6 => r2_reg,
        out_mux => mux6,
        control => control
    );

    UUT_mux7 : mux6 PORT MAP(
        in_1 => (OTHERS => '0'),
        in_2 => mult1_reg(2 * sample_size - 2 DOWNTO sample_size - 1),
        in_3 => sum,
        in_4 => sum,
        in_5 => sum,
        in_6 => sum,
        out_mux => r1_next,
        control => control
    );

    UUT_mux8 : mux6 PORT MAP(
        in_1 => (OTHERS => '0'),
        in_2 => mult2_reg(2 * sample_size - 2 DOWNTO sample_size - 1),
        in_3 => mult1_reg(2 * sample_size - 2 DOWNTO sample_size - 1),
        in_4 => mult1_reg(2 * sample_size - 2 DOWNTO sample_size - 1),
        in_5 => r2_reg,
        in_6 => (OTHERS => '0'),
        out_mux => r2_next,
        control => control
    );

    UUT_mux9 : mux6 PORT MAP(
        in_1 => (OTHERS => '0'),
        in_2 => (OTHERS => '0'),
        in_3 => (OTHERS => '0'),
        in_4 => mult2_reg(2 * sample_size - 2 DOWNTO sample_size - 1),
        in_5 => r3_reg,
        in_6 => (OTHERS => '0'),
        out_mux => r3_next,
        control => control
    );

    SYNC_PROC : PROCESS (clk, reset)
    BEGIN
        IF (clk'event AND clk = '1') THEN
            IF (reset = '1') THEN
                r1_reg <= (OTHERS => '0');
                r2_reg <= (OTHERS => '0');
                r3_reg <= (OTHERS => '0');
                mult1_reg <= (OTHERS => '0');
                mult2_reg <= (OTHERS => '0');
            ELSE
                r1_reg <= r1_next;
                r2_reg <= r2_next;
                r3_reg <= r2_next;
                mult1_reg <= mult1_next;
                mult2_reg <= mult2_next;
            END IF;
        END IF;
    END PROCESS;

    mult1_next <= mux0 * mux1;
    mult2_next <= mux2 * mux3;
    sum <= mux4 + mux5;
    y <= signed(sum);

END Behavioral;