----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:34:35 PM
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
USE work.package_dsed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;

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

    SIGNAL cuenta_reg, cuenta_next : STD_LOGIC_VECTOR (8 DOWNTO 0);
    SIGNAL buf_reg, buf_next : STD_LOGIC;
    SIGNAL sample_request_reg, sample_request_next : STD_LOGIC;

BEGIN

    SYNC_PROC : PROCESS (clk_12megas, reset)
    BEGIN
        IF (reset = '1') THEN
            cuenta_reg <= (OTHERS => '0');
            buf_reg <= '0';
            sample_request_reg <= '0';
        ELSE
            IF (clk_12megas'event AND clk_12megas = '1') THEN
                IF (sample_request_reg = '1') THEN
                    sample_request_reg <= '0';
                ELSE
                    sample_request_reg <= sample_request_next;
                END IF;

                IF (en_2_cycles = '1') THEN
                    cuenta_reg <= cuenta_next;
                    buf_reg <= buf_next;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    NEXT_STATE_LOGIC : PROCESS (cuenta_reg, sample_in)
    BEGIN
        sample_request_next <= '0';
        cuenta_next <= STD_LOGIC_VECTOR (unsigned(cuenta_reg) + 1);
        IF (cuenta_reg = STD_LOGIC_VECTOR(to_unsigned(299, 9))) THEN
            sample_request_next <= '1';
            cuenta_next <= (OTHERS => '0');
        END IF;
        IF ((cuenta_reg < ('0' & sample_in)) OR (unsigned(sample_in) = 0)) THEN
            buf_next <= '1';
        ELSE
            buf_next <= '0';
        END IF;
    END PROCESS;

    pwm_pulse <= buf_reg;
    sample_request <= sample_request_reg;

END Behavioral;