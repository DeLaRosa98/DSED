----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2020 12:31:14 PM
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

entity audio_interface is
Port ( clk_12megas : in STD_LOGIC;
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
end audio_interface;

architecture Behavioral of audio_interface is

begin


end Behavioral;