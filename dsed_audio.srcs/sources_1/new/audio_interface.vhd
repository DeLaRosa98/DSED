----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:36:01 PM
-- Design Name: 
-- Module Name: audio_interface - Behavioral
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

ENTITY audio_interface IS
    PORT (
        clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        record_enable : IN STD_LOGIC;
        sample_out : OUT STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0);
        sample_out_ready : OUT STD_LOGIC;
        micro_clk : OUT STD_LOGIC;
        micro_data : IN STD_LOGIC;
        micro_LR : OUT STD_LOGIC;
        play_enable : IN STD_LOGIC;
        sample_in : IN STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
        sample_request : OUT STD_LOGIC;
        jack_sd : OUT STD_LOGIC;
        jack_pwm : OUT STD_LOGIC
    );
END audio_interface;

ARCHITECTURE Behavioral OF audio_interface IS

    COMPONENT en_4_cycles PORT (clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        clk_3megas : OUT STD_LOGIC;
        en_2_cycles : OUT STD_LOGIC;
        en_4_cycles : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT FSMD_microphone PORT (
        clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        enable_4_cycles : IN STD_LOGIC;
        micro_data : IN STD_LOGIC;
        sample_out : OUT STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0);
        sample_out_ready : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT pwm PORT (
        clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        en_2_cycles : IN STD_LOGIC;
        sample_in : IN STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
        sample_request : OUT STD_LOGIC;
        pwm_pulse : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL en_2_cycles, enable_4_cycles : STD_LOGIC;
    SIGNAL and_en_2_cycles, and_en_4_cycles : STD_LOGIC;

BEGIN

    and_en_4_cycles <= enable_4_cycles AND record_enable;
    and_en_2_cycles <= en_2_cycles AND play_enable;

    UUT_enable : en_4_cycles PORT MAP(
        clk_12megas => clk_12megas,
        reset => reset,
        clk_3megas => micro_clk,
        en_2_cycles => en_2_cycles,
        en_4_cycles => enable_4_cycles
    );

    UUT_microphone : FSMD_microphone PORT MAP(
        clk_12megas => clk_12megas,
        reset => reset,
        enable_4_cycles => and_en_4_cycles,
        micro_data => micro_data,
        sample_out => sample_out,
        sample_out_ready => sample_out_ready
    );

    UUT_pwm : pwm PORT MAP(
        clk_12megas => clk_12megas,
        reset => reset,
        en_2_cycles => and_en_2_cycles,
        sample_in => sample_in,
        sample_request => sample_request,
        pwm_pulse => jack_pwm
    );

    micro_LR <= '1';
    jack_sd <= '1';

END Behavioral;
