----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2020 10:31:34 AM
-- Design Name: 
-- Module Name: pwm - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;
USE work.package_dsed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY pwm IS
    PORT (
        clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        en_2_cycles : IN STD_LOGIC;
        sample_in : IN STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
        sample_request : OUT STD_LOGIC;
        pwm_pulse : OUT STD_LOGIC
    );
END pwm;

ARCHITECTURE Behavioral OF pwm IS

    CONSTANT c_299 : STD_LOGIC_VECTOR (8 DOWNTO 0) := "100101011"; -- Counter to 299

    SIGNAL r_reg : unsigned (8 DOWNTO 0); -- 299(10) = 100101011(2) => 9 bits needed
    SIGNAL r_next : unsigned (8 DOWNTO 0);
    SIGNAL buf_reg, buf_next : STD_LOGIC;

BEGIN
    -- register and output buffer
    PROCESS (clk_12megas, reset)
    BEGIN
        IF (reset = '1') THEN
            r_reg <= (OTHERS => '0');
            buf_reg <= '0';
        ELSIF (clk_12megas'event AND clk_12megas = '0') THEN
            r_reg <= r_next;
            buf_reg <= buf_next;
        END IF;
    END PROCESS;
    -- sample request
    PROCESS (r_reg, buf_reg, en_2_cycles)
    BEGIN
        r_next <= r_reg;
        buf_next <= buf_reg;
        sample_request <= '0';

        IF (en_2_cycles = '1') THEN
            r_next <= r_reg + 1;
            IF (r_reg = to_unsigned(c_299, r_next'length)) THEN
                sample_request <= '1';
                r_next <= (OTHERS => '0');
            ELSE
                sample_request <= '0';
            END IF;

            IF (r_reg < unsigned(sample_in)) THEN
                buf_next <= '1';
            ELSE
                buf_next <= '0';
            END IF;
        END IF;
    END PROCESS;
    -- Outpu
    pwm_pulse <= buf_reg;
END Behavioral;