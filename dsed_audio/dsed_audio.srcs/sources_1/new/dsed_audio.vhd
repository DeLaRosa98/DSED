----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2020 12:28:17 PM
-- Design Name: 
-- Module Name: dsed_audio - Behavioral
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

ENTITY dsed_audio IS
    PORT (
        clk_100Mhz : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        --Control ports
        BTNL : IN STD_LOGIC;
        BTNC : IN STD_LOGIC;
        BTNR : IN STD_LOGIC;
        SW0 : IN STD_LOGIC;
        SW1 : IN STD_LOGIC;
        --To/From the microphone
        micro_clk : OUT STD_LOGIC;
        micro_data : IN STD_LOGIC;
        micro_LR : OUT STD_LOGIC;
        --To/From the mini-jack
        jack_sd : OUT STD_LOGIC;
        jack_pwm : OUT STD_LOGIC
    );
END dsed_audio;

ARCHITECTURE Behavioral OF dsed_audio IS

BEGIN
END Behavioral;