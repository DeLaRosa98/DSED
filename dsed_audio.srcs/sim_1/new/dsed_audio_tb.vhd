----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 29.06.2021 15:37:14
-- Design Name:
-- Module Name: dsed_audio_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dsed_audio_tb is
--  Port ( );
end dsed_audio_tb;

architecture Behavioral of dsed_audio_tb is

    component dsed_audio is PORT (
        clk_100Mhz : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        BTNL : IN STD_LOGIC;
        BTNC : IN STD_LOGIC;
        BTNR : IN STD_LOGIC;
        SW0 : IN STD_LOGIC;
        SW1 : IN STD_LOGIC;
        micro_clk : OUT STD_LOGIC;
        micro_data : IN STD_LOGIC;
        micro_LR : OUT STD_LOGIC;
        jack_sd : OUT STD_LOGIC;
        jack_pwm : OUT STD_LOGIC
    );
    end component;

    -- input signals
    signal clk_100Mhz   : std_logic := '0';
    signal reset        : std_logic := '0';
    signal BTNL         : std_logic := '0';
    signal BTNC         : std_logic := '0';
    signal BTNR         : std_logic := '0';
    signal SW0          : std_logic := '0';
    signal SW1          : std_logic := '0';
    signal micro_data   : std_logic := '0';

    -- output signals
    signal micro_clk    : std_logic := '0';
    signal micro_LR     : std_logic := '0';
    signal jack_sd      : std_logic := '0';
    signal jack_pwm     : std_logic := '0';

    CONSTANT clk_period : TIME := 5 ns;
    signal a,b,c : std_logic := '0';
begin

    UUT_dsed_audio: dsed_audio port map(
        clk_100Mhz => clk_100Mhz,
        reset => reset,
        BTNL => BTNL,
        BTNC => BTNC,
        BTNR => BTNR,
        SW0 => SW0,
        SW1 => SW1,
        micro_data => micro_data,
        micro_LR => micro_LR,
        jack_sd => jack_sd,
        jack_pwm => jack_pwm
    );

    clk_100Mhz <= NOT clk_100Mhz AFTER clk_period/2;

    reproduccion: process
    begin
      reset <= '1';
      SW0 <= '1';
      SW1 <= '0';
      wait for 100 ns;
      reset <= '0';
      wait for 1100 us;
      BTNR <= '1';
      wait for 100 ns;
      BTNR <= '0';
      wait for 1200 us;
      BTNR <= '1';
      wait for 100 ns;
      BTNR <= '0';
      wait for 700 us;
      BTNR <= '1';
      wait for 100 ns;
      BTNR <= '0';
      wait;
    end process;

    MICRO_PROC : PROCESS        -- Se�al pseudo aleatoria de entrada
    BEGIN
        WAIT FOR 100 ns;
        a <= NOT a AFTER 1300 ns;
        b <= NOT b AFTER 2100 ns;
        c <= NOT c AFTER 3700 ns;
        micro_data <= a XOR b XOR c;
    END PROCESS;

    grabar: process
    begin
      wait for 300 us;
      BTNL <= '1';
      wait for 500 us;
      BTNL <= '0';
      wait for 1000 us;
      BTNL <= '1';
      wait for 500 us;
      BTNL <= '0';
      wait;
    end process;

    clear: process
    begin
      wait for 3000 us;
      BTNC <= '1';
      wait for 100 ns;
      BTNC <= '0';
      wait;
    end process;
end Behavioral;
