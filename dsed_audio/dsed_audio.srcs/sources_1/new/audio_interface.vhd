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
END audio_interface;

ARCHITECTURE Behavioral OF audio_interface IS

BEGIN
END Behavioral;