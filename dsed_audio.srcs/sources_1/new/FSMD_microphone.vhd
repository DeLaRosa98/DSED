----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:31:54 PM
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY FSMD_microphone IS
    PORT (
        clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable_4_cycles : IN STD_LOGIC;
        micro_data : IN STD_LOGIC;
        sample_out : OUT STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0);
        sample_out_ready : OUT STD_LOGIC);
END FSMD_microphone;

ARCHITECTURE Behavioral OF FSMD_microphone IS

    TYPE state_type IS (S1, S2, S3);
    SIGNAL state_next, state_reg : state_type;
    SIGNAL cuenta_next, cuenta_reg : INTEGER := 0;
    SIGNAL dato1_next, dato1_reg, dato2_next, dato2_reg : STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0);
    SIGNAL sample_out_reg, sample_out_next : STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0);
    SIGNAL primer_ciclo_reg, primer_ciclo_next : STD_LOGIC;
    SIGNAL sample_out_ready_aux : STD_LOGIC;

BEGIN

    SYNC_PROC : PROCESS (clk_12megas, reset)
    BEGIN
        IF (reset = '1') THEN
            state_reg <= S1;
            cuenta_reg <= 0;
            dato1_reg <= (OTHERS => '0');
            dato2_reg <= (OTHERS => '0');
            primer_ciclo_reg <= '0';
            sample_out_reg <= (OTHERS => '0');
        ELSE
            IF (clk_12megas'event AND clk_12megas = '1') THEN
                IF (enable_4_cycles = '1') THEN
                    state_reg <= state_next;
                    cuenta_reg <= cuenta_next;
                    dato1_reg <= dato1_next;
                    dato2_reg <= dato2_next;
                    primer_ciclo_reg <= primer_ciclo_next;
                    sample_out_reg <= sample_out_next;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    NEXT_STATE_LOGIC : PROCESS (state_reg, cuenta_reg, micro_data, dato1_reg, dato2_reg, enable_4_cycles, primer_ciclo_reg, sample_out_reg)
    BEGIN
        sample_out_ready_aux <= '0';
        cuenta_next <= cuenta_reg;
        sample_out_next <= sample_out_reg;
        primer_ciclo_next <= primer_ciclo_reg;
        dato1_next <= dato1_reg;
        dato2_next <= dato2_reg;
        CASE state_reg IS
            WHEN S1 =>
                cuenta_next <= cuenta_reg + 1;
                IF (micro_data = '1') THEN
                    dato1_next <= dato1_reg + '1';
                    dato2_next <= dato2_reg + '1';
                END IF;
            WHEN S2 =>
                cuenta_next <= cuenta_reg + 1;
                IF (micro_data = '1') THEN
                    dato1_next <= dato1_reg + '1';
                END IF;
                IF (primer_ciclo_reg = '1' AND cuenta_reg = 106) THEN
                    sample_out_next <= dato2_reg;
                    dato2_next <= (OTHERS => '0');
                    sample_out_ready_aux <= enable_4_cycles;
                ELSE
                    sample_out_ready_aux <= '0';
                END IF;
            WHEN S3 =>
                IF (cuenta_reg = 299) THEN
                    cuenta_next <= 0;
                    primer_ciclo_next <= '1';
                ELSE
                    cuenta_next <= cuenta_reg + 1;
                END IF;
                IF (micro_data = '1') THEN
                    dato2_next <= dato2_reg + '1';
                END IF;
                IF (cuenta_reg = 255) THEN
                    sample_out_next <= dato1_reg;
                    dato1_next <= (OTHERS => '0');
                    sample_out_ready_aux <= enable_4_cycles;
                ELSE
                    sample_out_ready_aux <= '0';
                END IF;
        END CASE;
    END PROCESS;

    NEXT_STATE_DECODE : PROCESS (state_reg, cuenta_reg)
    BEGIN
        state_next <= S1;
        CASE (state_reg) IS
            WHEN S1 =>
                IF (cuenta_reg = 254) THEN
                    state_next <= S3;
                ELSIF (cuenta_reg = 104) THEN
                    state_next <= S2;
                END IF;
            WHEN S2 =>
                IF (cuenta_reg = 148) THEN
                    state_next <= S1;
                ELSE
                    state_next <= S2;
                END IF;
            WHEN S3 =>
                IF (cuenta_reg = 299) THEN
                    state_next <= S1;
                ELSE
                    state_next <= S3;
                END IF;
            WHEN OTHERS =>
                state_next <= S1;
        END CASE;
    END PROCESS;

    sample_out <= sample_out_reg;
    sample_out_ready <= sample_out_ready_aux;

END Behavioral;