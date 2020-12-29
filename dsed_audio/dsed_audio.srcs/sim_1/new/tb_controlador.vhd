----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.12.2020 14:08:03
-- Design Name: 
-- Module Name: tb_controlador - Behavioral
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

entity tb_controlador is
end tb_controlador;

architecture Behavioral of tb_controlador is

    component controlador port (
        clk_100Mhz : in std_logic;
        reset: in std_logic;
        --To/From the microphone
        micro_clk : out STD_LOGIC;
        micro_data : in STD_LOGIC;
        micro_LR : out STD_LOGIC;
        --To/From the mini-jack
        jack_sd : out STD_LOGIC;
        jack_pwm : out STD_LOGIC);
    end component;

    signal clk_100Mhz       : std_logic := '0';
    signal reset            : std_logic := '0';
    signal micro_clk        : std_logic := '0';
    signal micro_data       : std_logic := '0';
    signal micro_LR         : std_logic := '0';
    signal jack_sd          : std_logic := '0';
    signal jack_pwm         : std_logic := '0';

    signal a,b,d : std_logic := '0';

    constant clk_period : time := 5 ns;
    
begin

    con :  controlador
    port map (
        clk_100Mhz          => clk_100Mhz,
        reset               => reset,
        micro_clk           => micro_clk,
        micro_data          => micro_data,
        micro_LR            => micro_LR,
        jack_sd             => jack_sd,
        jack_pwm            => jack_pwm);

    -- Clock generation
    clk_100Mhz <= not clk_100Mhz after clk_period/2;
  
    stimuli : process
    begin
        reset <= '1';
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