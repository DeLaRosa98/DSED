----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/29/2021 09:19:53 AM
-- Design Name: 
-- Module Name: controller - Behavioral
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

ENTITY controller IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        BTNL : IN STD_LOGIC;
        BTNC : IN STD_LOGIC;
        BTNR : IN STD_LOGIC;
        SW0 : IN STD_LOGIC;
        SW1 : IN STD_LOGIC;
        record_enable_audio : OUT STD_LOGIC;
        sample_out_audio : IN STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0);
        sample_out_ready_audio : IN STD_LOGIC;
        play_enable_audio : OUT STD_LOGIC;
        sample_in_audio : OUT STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
        sample_request_audio : IN STD_LOGIC;
        sample_in_filter : OUT signed (sample_size - 1 DOWNTO 0);
        sample_in_enable_filter : OUT STD_LOGIC;
        sample_out_filter : IN signed (sample_size - 1 DOWNTO 0);
        sample_out_ready_filter : IN STD_LOGIC;
        addra : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
        dina : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        douta : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        ena : OUT STD_LOGIC;
        wea : OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
        state : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
    );
END controller;

ARCHITECTURE Behavioral OF controller IS

    TYPE state_type IS (IDLE, CLEAR, REC, PLAY);
    SIGNAL state_next, state_reg : state_type;
    SIGNAL addra_forward_next, addra_forward_reg, addra_reverse_next, addra_reverse_reg, pointer_next, pointer_reg : STD_LOGIC_VECTOR (18 DOWNTO 0);
    SIGNAL first_next, first_reg : STD_LOGIC;
    SIGNAL sample_in_audio_next, sample_in_audio_reg : STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0);
    
BEGIN

    SYNC_PROC : PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            state_reg <= IDLE;
            addra_forward_reg <= (OTHERS => '0');
            addra_reverse_reg <= (OTHERS => '0');
            pointer_reg <= (OTHERS => '0');
            first_reg <= '0';
            sample_in_audio_reg <= (OTHERS => '0');
        ELSE
            IF (clk'event AND clk = '1') THEN
                state_reg <= state_next;
                addra_forward_reg <= addra_forward_next;
                addra_reverse_reg <= addra_reverse_next;
                pointer_reg <= pointer_next;
                first_reg <= first_next;
                sample_in_audio_reg <= sample_in_audio_next;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (state_reg, addra_forward_reg, addra_reverse_reg, pointer_reg, first_reg, sample_in_audio_reg, BTNL, BTNR, BTNC, SW0, SW1, sample_out_audio, sample_out_ready_audio, sample_request_audio, sample_out_filter, sample_out_ready_filter, douta)
    BEGIN
        state_next <= IDLE;
        addra_forward_next <= addra_forward_reg;
        addra_reverse_next <= addra_reverse_reg;
        pointer_next <= pointer_reg;
        first_next <= first_reg;
        sample_in_audio_next <= sample_in_audio_reg;

        play_enable_audio <= '0';
        record_enable_audio <= '0';
        sample_in_audio <= (OTHERS => '0');
        sample_in_enable_filter <= '0';
        dina <= (OTHERS => '0');
        sample_in_filter <= (OTHERS => '0');
        ena <= '1';
        wea <= "0";

        CASE state_reg IS
            WHEN IDLE =>
                sample_in_audio <= (OTHERS => '0');
                IF (BTNL = '1') THEN
                    addra_forward_next <= pointer_reg;
                    IF (unsigned(pointer_reg) >= 524287) THEN
                        state_next <= IDLE;
                    ELSE
                        state_next <= REC;
                    END IF;
                ELSIF (BTNR = '1') THEN
                    state_next <= PLAY;
                    addra_forward_next <= (OTHERS => '0');
                    addra_reverse_next <= pointer_reg;
                    first_next <= '1';
                ELSIF (BTNC = '1') THEN
                    state_next <= CLEAR;
                END IF;
            WHEN CLEAR =>
                pointer_next <= (OTHERS => '0');
                IF (BTNC = '0') THEN
                    state_next <= IDLE;
                ELSE
                    state_next <= CLEAR;
                END IF;
            WHEN REC =>
                record_enable_audio <= '1';
                IF (sample_out_ready_audio = '1') THEN
                    wea <= "1";
                    addra_forward_next <= STD_LOGIC_VECTOR(unsigned(addra_forward_reg) + 1);
                    addra_reverse_next <= addra_forward_reg;
                    dina <= sample_out_audio;
                    pointer_next <= addra_forward_reg;
                END IF;
                IF (BTNL = '0' OR unsigned(pointer_reg) = 524287) THEN
                    state_next <= IDLE;
                ELSE
                    state_next <= REC;
                END IF;
            WHEN PLAY =>
                play_enable_audio <= '1';
                IF (SW1 = '0') THEN
                    sample_in_audio <= douta;
                    IF (sample_request_audio = '1') THEN
                        IF (SW0 = '0') THEN
                            IF (addra_forward_reg = pointer_reg) THEN
                                state_next <= IDLE;
                            ELSE
                                addra_forward_next <= STD_LOGIC_VECTOR(unsigned(addra_forward_reg) + 1);
                                addra_reverse_next <= addra_forward_reg;
                                state_next <= PLAY;
                            END IF;
                        ELSE
                            IF (unsigned(addra_reverse_reg) = 0) THEN
                                state_next <= IDLE;
                            ELSE
                                addra_reverse_next <= STD_LOGIC_VECTOR(unsigned(addra_reverse_reg) - 1);
                                addra_forward_next <= addra_reverse_reg;
                                state_next <= PLAY;
                            END IF;
                        END IF;
                    ELSE
                        state_next <= PLAY;
                    END IF;
                ELSE
                    sample_in_filter <= signed(NOT(douta(7)) & douta(6 DOWNTO 0));
                    sample_in_audio <= sample_in_audio_reg;
                    IF (first_reg = '1') THEN
                        sample_in_enable_filter <= '1';
                        first_next <= '0';
                    END IF;
                    IF (sample_out_ready_filter = '1') THEN
                        sample_in_audio_next <= STD_LOGIC_VECTOR(NOT(sample_out_filter(7)) & sample_out_filter(6 DOWNTO 0));
                    END IF;
                    IF (sample_request_audio = '1') THEN
                        sample_in_enable_filter <= '1';
                        IF (addra_forward_reg = pointer_reg) THEN
                            state_next <= IDLE;
                        ELSE
                            addra_forward_next <= STD_LOGIC_VECTOR(unsigned(addra_forward_reg) + 1);
                            addra_reverse_next <= addra_forward_reg;
                            state_next <= PLAY;
                        END IF;
                    ELSE
                        state_next <= PLAY;
                    END IF;
                END IF;
        END CASE;
    END PROCESS;

    PROCESS (SW1, SW0, addra_forward_reg, addra_reverse_reg)
    BEGIN
        addraa <= addra_forward_reg;
        IF (SW1 = '0' AND SW0 = '1') THEN
            addraa <= addra_reverse_reg;
        END IF;
    END PROCESS;

END Behavioral;