----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2020 11:55:13 AM
-- Design Name: 
-- Module Name: tb_pwm - Behavioral
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
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.package_dsed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY tb_pwm IS
    --  Port ( );
END tb_pwm;

ARCHITECTURE Behavioral OF tb_pwm IS

    COMPONENT en_4_cycles IS
        PORT (
            clk_12megas : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            clk_3megas : OUT STD_LOGIC;
            en_2_cycles : OUT STD_LOGIC;
            en_4_cycles : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT pwm IS
        PORT (
            clk_12megas : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            en_2_cycles : IN STD_LOGIC;
            sample_in : IN STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
            sample_request : OUT STD_LOGIC;
            pwm_pulse : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Input signals
    SIGNAL clock_12megas : STD_LOGIC := '1';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL enable_2_cycles : STD_LOGIC := '1';
    SIGNAL smpl_in : STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);

    -- Output signals
    SIGNAL smpl_rqst : STD_LOGIC := '1';
    SIGNAL pwm_pls : STD_LOGIC := '1';
    SIGNAL clock_3megas : STD_LOGIC := '1';
    SIGNAL enable_4_cycles : STD_LOGIC := '1';

    -- Constant time
    CONSTANT clk_period : TIME := 83.33 ns;
    CONSTANT wait_time : TIME := 200 ns;
BEGIN

    UUT_enables : en_4_cycles
    PORT MAP(
        clk_12megas => clock_12megas,
        reset => rst,
        clk_3megas => clock_3megas,
        en_2_cycles => enable_2_cycles,
        en_4_cycles => enable_4_cycles
    );

    UUT_pwm : pwm
    PORT MAP(
        clk_12megas => clock_12megas,
        reset => rst,
        en_2_cycles => enable_2_cycles,
        sample_in => smpl_in,
        sample_request => smpl_rqst,
        pwm_pulse => pwm_pls
    );

    reset_process : PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR 100 ns;
        rst <= '0';
        WAIT;
    END PROCESS;

    CLK_process : PROCESS
    BEGIN
        clock_12megas <= '0';
        WAIT FOR clk_period/2;
        clock_12megas <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    SAMPLE_IN_process : PROCESS
    BEGIN
        smpl_in <= "00000000";
        WAIT FOR wait_time;
        smpl_in <= "00001111";
        WAIT FOR wait_time;
        smpl_in <= "11110000";
        WAIT FOR wait_time;
        smpl_in <= "10101010";
        WAIT FOR wait_time;
        smpl_in <= "01010101";
        WAIT FOR wait_time;
        smpl_in <= "11111111";
        WAIT FOR wait_time;
    END PROCESS;

END Behavioral;