----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2020 11:20:02
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.package_dsed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity audio_interface_tb is
end audio_interface_tb;

architecture Behavioral of audio_interface_tb is

    component audio_interface port (
        clk_12megas         : in STD_LOGIC;
        reset               : in STD_LOGIC;
        --Recording ports
        --To/From the controller
        record_enable       : in STD_LOGIC;
        sample_out          : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
        sample_out_ready    : out STD_LOGIC;
        --To/From the microphone
        micro_clk           : out STD_LOGIC;
        micro_data          : in STD_LOGIC;
        micro_LR            : out STD_LOGIC;
        --Playing ports
        --To/From the controller
        play_enable         : in STD_LOGIC;
        sample_in           : in std_logic_vector(sample_size-1 downto 0);
        sample_request      : out std_logic;
        --To/From the mini-jack
        jack_sd             : out STD_LOGIC;
        jack_pwm            : out STD_LOGIC);
    end component;

    signal clk_12megas      : std_logic := '0';
    signal reset            : std_logic := '0';
    signal record_enable    : std_logic := '0';
    signal sample_out        : std_logic_vector(sample_size-1 downto 0) := (others => '0');
    signal sample_out_ready : std_logic := '0';
    signal micro_clk        : std_logic := '0';
    signal micro_data       : std_logic := '0';
    signal micro_LR         : std_logic := '0';
    signal play_enable      : std_logic := '0';
    signal sample_in        : std_logic_vector(sample_size-1 downto 0) := (others => '0');
    signal sample_request   : std_logic := '0';
    signal jack_sd          : std_logic := '0';
    signal jack_pwm         : std_logic := '0';
    
    signal s1               : std_logic_vector(sample_size-1 downto 0) := (others => '0');
    signal a,b,d : std_logic := '0';

    constant clk_period : time := 167 ns;
    
begin

    ain :  audio_interface
    port map (
        clk_12megas         => clk_12megas,
        reset               => reset,
        record_enable       => record_enable,
        sample_out          => s1,
        sample_out_ready    => sample_out_ready,
        micro_clk           => micro_clk,
        micro_data          => micro_data,
        micro_LR            => micro_LR,
        play_enable         => play_enable,
        sample_in           => s1,
        sample_request      => sample_request,
        jack_sd             => jack_sd,
        jack_pwm            => jack_pwm);

    -- Clock generation
    clk_12megas <= not clk_12megas after clk_period/2;
  
    stimuli : process
    begin
        reset <= '1';
        record_enable <= '1';
        play_enable <= '1';
        wait for 100 ns;
        reset <= '0';
        wait;
    end process;
    
    micro_data_proc: process
    begin
        wait for 100 ns;
        a <= not a after 1300 ns;
        b <= not b after 2100 ns;
        d <= not d after 3700 ns;
        micro_data <= a xor b xor d;
    end process;

end Behavioral;