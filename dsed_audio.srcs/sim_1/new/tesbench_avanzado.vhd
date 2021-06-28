----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:43:11 PM
-- Design Name: 
-- Module Name: tesbench_avanzado - Behavioral
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
USE STD.TEXTIO.ALL;
USE work.package_dsed.ALL;
ENTITY tesbench_avanzado IS
END tesbench_avanzado;

ARCHITECTURE Behavioral OF tesbench_avanzado IS

    COMPONENT fir_filter PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        sample_in : IN signed (sample_size - 1 DOWNTO 0);
        sample_in_enable : IN STD_LOGIC;
        filter_select : IN STD_LOGIC;
        sample_out : OUT signed (sample_size - 1 DOWNTO 0);
        sample_out_ready : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL sample_in : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sample_in_enable : STD_LOGIC := '0';
    SIGNAL filter_select : STD_LOGIC := '0';
    SIGNAL sample_out : signed (sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sample_out_ready : STD_LOGIC := '0';
    SIGNAL c : STD_LOGIC := '1';
    SIGNAL sample_out_matlab : INTEGER;

    CONSTANT clk_period : TIME := 83.3 ns;

BEGIN

    UUT_filter : fir_filter
    PORT MAP(
        clk => clk,
        reset => reset,
        sample_in => sample_in,
        sample_in_enable => sample_in_enable,
        filter_select => filter_select,
        sample_out => sample_out,
        sample_out_ready => sample_out_ready
    );

    clk <= NOT clk AFTER clk_period/2;

    READ_PROC : PROCESS (sample_in_enable)
        FILE in_file : text OPEN read_mode IS "C:/Users/PdlRdV/Desktop/Uni/DSED/dsed_audio/Matlab/sample_in.dat";
        VARIABLE in_line : line;
        VARIABLE in_int : INTEGER;
        VARIABLE in_read_ok : BOOLEAN;
    BEGIN

        IF (sample_in_enable'event AND sample_in_enable = '1') THEN
            IF NOT endfile(in_file) THEN
                readLine(in_file, in_line);
                read(in_line, in_int, in_read_ok);
                sample_in <= to_signed(in_int, sample_size);
            ELSE
                ASSERT false REPORT "Simulation Finished" SEVERITY failure;
            END IF;
        END IF;
    END PROCESS;

    WRITE_PROC : PROCESS (sample_out_ready, filter_select)
        FILE out_file : text;
        VARIABLE out_line : line;
    BEGIN
        IF (c = '1') THEN
            file_open(out_file, "C:/Users/PdlRdV/Desktop/Uni/DSED/dsed_audio/Matlab/sample_out.dat", write_mode);
            sample_out_matlab <= 0;
        END IF;
        c <= '0';
        IF (sample_out_ready'event AND sample_out_ready = '1') THEN
            sample_out_matlab <= to_integer(sample_out);
            write(out_line, sample_out_matlab, left, sample_size);
            writeline(out_file, out_line);
        END IF;
    END PROCESS;

    stimuli : PROCESS
    BEGIN
        sample_in_enable <= '0';
        WAIT FOR 10*clk_period;
        sample_in_enable <= '1';
        WAIT FOR clk_period;
    END PROCESS;
    
    reset <= '1', '0' after 3*clk_period;

END Behavioral;