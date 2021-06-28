----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:42:00 PM
-- Design Name: 
-- Module Name: control_route - Behavioral
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

ENTITY control_route IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        sample_in_enable : IN STD_LOGIC;
        count : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        sample_out_ready : OUT STD_LOGIC);
END control_route;

ARCHITECTURE Behavioral OF control_route IS

    TYPE state_type IS (IDLE, S0, S1, S2, S3, S4, S5, S6);
    SIGNAL state_next, state_reg : state_type;

BEGIN

    SYNC_PROC : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            state_reg <= IDLE;
        ELSE
            IF (clk'event AND clk = '1') THEN
                state_reg <= state_next;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (state_reg, sample_in_enable)
    BEGIN
        state_next <= IDLE;
        sample_out_ready <= '0';
        count <= "000";
        CASE (state_reg) IS
            WHEN IDLE =>
                IF (sample_in_enable = '1') THEN
                    state_next <= S0;
                END IF;
            WHEN S0 =>
                count <= "000";
                state_next <= S1;
            WHEN S1 =>
                count <= "001";
                state_next <= S2;
            WHEN S2 =>
                count <= "010";
                state_next <= S3;
            WHEN S3 =>
                count <= "011";
                state_next <= S4;
            WHEN S4 =>
                count <= "100";
                state_next <= S5;
            WHEN S5 =>
                count <= "101";
                state_next <= S6;
            WHEN S6 =>
                count <= "110";
                sample_out_ready <= '1';
        END CASE;
    END PROCESS;

END Behavioral;