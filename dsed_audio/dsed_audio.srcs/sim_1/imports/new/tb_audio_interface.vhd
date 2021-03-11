----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2020 10:37:16
-- Design Name: 
-- Module Name: audio_interface_tb - Behavioral
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

ENTITY audio_interface_tb IS
END audio_interface_tb;

ARCHITECTURE Behavioral OF audio_interface_tb IS

    COMPONENT audio_interface PORT (
        clk_12megas : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        --Recording ports
        --To/From the controller
        record_enable : IN STD_LOGIC;
        sample_out : OUT STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0);
        sample_out_ready : OUT STD_LOGIC;
        --To/From the microphone
        micro_clk : OUT STD_LOGIC;
        micro_data : IN STD_LOGIC;
        micro_LR : OUT STD_LOGIC;
        --Playing ports
        --To/From the controller
        play_enable : IN STD_LOGIC;
        sample_in : IN STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
        sample_request : OUT STD_LOGIC;
        --To/From the mini-jack
        jack_sd : OUT STD_LOGIC;
        jack_pwm : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL clk_12megas : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL record_enable : STD_LOGIC := '0';
    SIGNAL sample_out : STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sample_out_ready : STD_LOGIC := '0';
    SIGNAL micro_clk : STD_LOGIC := '0';
    SIGNAL micro_data : STD_LOGIC := '0';
    SIGNAL micro_LR : STD_LOGIC := '0';
    SIGNAL play_enable : STD_LOGIC := '0';
    SIGNAL sample_in : STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sample_request : STD_LOGIC := '0';
    SIGNAL jack_sd : STD_LOGIC := '0';
    SIGNAL jack_pwm : STD_LOGIC := '0';

    SIGNAL s1 : STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL a, b, d : STD_LOGIC := '0';

    CONSTANT clk_period : TIME := 167 ns;

BEGIN

    ain : audio_interface
    PORT MAP(
        clk_12megas => clk_12megas,
        reset => reset,
        record_enable => record_enable,
        sample_out => s1,
        sample_out_ready => sample_out_ready,
        micro_clk => micro_clk,
        micro_data => micro_data,
        micro_LR => micro_LR,
        play_enable => play_enable,
        sample_in => s1,
        sample_request => sample_request,
        jack_sd => jack_sd,
        jack_pwm => jack_pwm);

    -- Clock generation
    clk_12megas <= NOT clk_12megas AFTER clk_period/2;

    stimuli : PROCESS
    BEGIN
        reset <= '1';
        record_enable <= '1';
        play_enable <= '1';
        WAIT FOR 100 ns;
        reset <= '0';
        WAIT;
    END PROCESS;

    micro_data_proc : PROCESS
    BEGIN
        WAIT FOR 100 ns;
        a <= NOT a AFTER 1300 ns;
        b <= NOT b AFTER 2100 ns;
        d <= NOT d AFTER 3700 ns;
        micro_data <= a XOR b XOR d;
    END PROCESS;

END Behavioral;