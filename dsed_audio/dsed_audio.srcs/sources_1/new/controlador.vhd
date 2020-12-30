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

entity controlador is
  Port (
    clk_100Mhz : in std_logic;
    reset: in std_logic;
    --To/From the microphone
    micro_clk : out STD_LOGIC;
    micro_data : in STD_LOGIC;
    micro_LR : out STD_LOGIC;
    --To/From the mini-jack
    jack_sd : out STD_LOGIC;
    jack_pwm : out STD_LOGIC
  );
end controlador;

architecture Behavioral of controlador is

  COMPONENT audio_interface
    PORT(
      clk_12megas : in STD_LOGIC;
      reset : in STD_LOGIC;
      --Recording ports
      --To/From the controller
      record_enable: in STD_LOGIC;
      sample_out: out STD_LOGIC_VECTOR (sample_size-1 downto 0);
      sample_out_ready: out STD_LOGIC;
      --To/From the microphone
      micro_clk : out STD_LOGIC;
      micro_data : in STD_LOGIC;
      micro_LR : out STD_LOGIC;
      --Playing ports
      --To/From the controller
      play_enable: in STD_LOGIC;
      sample_in: in std_logic_vector(sample_size-1 downto 0);
      sample_request: out std_logic;
      --To/From the mini-jack
      jack_sd : out STD_LOGIC;
      jack_pwm : out STD_LOGIC);
  END COMPONENT;

  COMPONENT clk_12MHz
    PORT(
        reset: in std_logic;
        clk_in1: in std_logic;
        clk_out1: out std_logic);
  END COMPONENT;

  --Output signals
  signal clock_12megas: std_logic;
  signal s_sample        : std_logic_vector(sample_size-1 downto 0) := (others => '0');
  signal sample_out_ready : std_logic := '0';
  signal sample_request   : std_logic := '0';

begin

  UUT_clock: clk_12MHz
  PORT MAP(
      reset => reset,
      clk_in1 => clk_100Mhz,
      clk_out1 => clock_12megas);

  UUT_audio: audio_interface
  PORT MAP(
    clk_12megas         => clock_12megas,
    reset               => reset,
    record_enable       => '1',
    sample_out          => s_sample,
    sample_out_ready    => sample_out_ready,
    micro_clk           => micro_clk,
    micro_data          => micro_data,
    micro_LR            => micro_LR,
    play_enable         => '1',
    sample_in           => s_sample,
    sample_request      => sample_request,
    jack_sd             => jack_sd,
    jack_pwm            => jack_pwm);

end Behavioral;
