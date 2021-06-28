----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:37:50 PM
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
        micro_clk : OUT STD_LOGIC;
        micro_data : IN STD_LOGIC;
        micro_LR : OUT STD_LOGIC;
        jack_sd : OUT STD_LOGIC;
        jack_pwm : OUT STD_LOGIC
    );
END controlador;

ARCHITECTURE Behavioral OF controlador IS

    COMPONENT clk_12megas
        PORT (
            clk_100 : IN STD_LOGIC;
            clk_12 : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT audio_interface
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
            jack_pwm : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL clk_12meg : STD_LOGIC;
    SIGNAL s_sample : STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
    SIGNAL s_ready, s_request : STD_LOGIC;

BEGIN

    UUT_clk : clk_12megas
    PORT MAP(
        clk_100 => clk_100Mhz,
        clk_12 => clk_12meg);

    UUT_audio : audio_interface
    PORT MAP(
        clk_12megas => clk_12meg,
        reset => reset,
        record_enable => '1',
        sample_out => s_sample,
        sample_out_ready => s_ready,
        micro_clk => micro_clk,
        micro_data => micro_data,
        micro_LR => micro_LR,
        play_enable => '1',
        sample_in => s_sample,
        sample_request => s_request,
        jack_sd => jack_sd,
        jack_pwm => jack_pwm);

END Behavioral;