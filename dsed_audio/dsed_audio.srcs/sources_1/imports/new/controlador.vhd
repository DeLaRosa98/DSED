----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 29.12.2020 13:23:18
-- Design Name:
-- Module Name: controlador - Behavioral
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

ENTITY controlador IS
  PORT (
    clk_100Mhz : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    --To/From the microphone
    micro_clk : OUT STD_LOGIC;
    micro_data : IN STD_LOGIC;
    micro_LR : OUT STD_LOGIC;
    --To/From the mini-jack
    jack_sd : OUT STD_LOGIC;
    jack_pwm : OUT STD_LOGIC
  );
END controlador;

ARCHITECTURE Behavioral OF controlador IS

  COMPONENT audio_interface
    PORT (
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

  COMPONENT clk_12MHz
    PORT (
      reset : IN STD_LOGIC;
      clk_in1 : IN STD_LOGIC;
      clk_out1 : OUT STD_LOGIC);
  END COMPONENT;

  --Output signals
  SIGNAL clock_12megas : STD_LOGIC;
  SIGNAL s_sample : STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL sample_out_ready : STD_LOGIC := '0';
  SIGNAL sample_request : STD_LOGIC := '0';

BEGIN

  UUT_clock : clk_12MHz
  PORT MAP(
    reset => reset,
    clk_in1 => clk_100Mhz,
    clk_out1 => clock_12megas);

  UUT_audio : audio_interface
  PORT MAP(
    clk_12megas => clock_12megas,
    reset => reset,
    record_enable => '1',
    sample_out => s_sample,
    sample_out_ready => sample_out_ready,
    micro_clk => micro_clk,
    micro_data => micro_data,
    micro_LR => micro_LR,
    play_enable => '1',
    sample_in => s_sample,
    sample_request => sample_request,
    jack_sd => jack_sd,
    jack_pwm => jack_pwm);

END Behavioral;