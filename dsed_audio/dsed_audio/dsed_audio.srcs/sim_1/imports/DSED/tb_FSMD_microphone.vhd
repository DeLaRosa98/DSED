----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2020 22:20:37
-- Design Name: 
-- Module Name: tb_FSMD_microphone - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.package_dsed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_FSMD_microphone is
--  Port ( );
end tb_FSMD_microphone;

architecture Behavioral of tb_FSMD_microphone is

    component FSMD_microphone is
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               enable_4_cycles : in STD_LOGIC;
               micro_data : in STD_LOGIC;
               sample_out : out STD_LOGIC_VECTOR (7 downto 0);
               sample_out_ready : out STD_LOGIC);
    end component;
    
    component en_4_cycles
         port (clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_3megas: out STD_LOGIC;
               en_2_cycles: out STD_LOGIC;
               en_4_cycle : out STD_LOGIC);
    end component;
    
    -- Inputs signals
    signal clk_12megas : std_logic := '1';
    signal reset : std_logic:= '0';
    signal enable_4_cycles: std_logic:= '1';
    signal micro_data : std_logic := '0'; -- Tarea 1.7
    --signal micro_data : std_logic := '1'; --Tarea 1.6
    
    
    -- Output signals
    signal sample_out : std_logic_vector(7 downto 0);
    signal sample_out_ready : std_logic:= '0';
    signal clk_3megas : std_logic:= '0';    
    signal en_2_cycles : std_logic:= '0';
    
    -- Constant time
    constant clk_period : time := 166.66 ns;
    
    --Simulation signals
    signal a, b, c : std_logic := '1';

begin

    UUT_enables:  en_4_cycles
        port map (clk_12megas => clk_12megas ,
            reset => reset ,
            clk_3megas => clk_3megas ,
            en_2_cycles => en_2_cycles ,
            en_4_cycle => enable_4_cycles 
             );
             
    UUT_FSMD:  FSMD_microphone
        port map (clk_12megas => clk_12megas ,
            reset => reset ,
            enable_4_cycles => enable_4_cycles,
            micro_data => micro_data ,
            sample_out => sample_out ,
            sample_out_ready => sample_out_ready);
    
    -- Reset process definitions
    reset_process :process
                 begin
                    reset <= '1';
                    wait for 15 ns;
                    reset <= '0';
                    wait;
                 end process;
    
    -- Clock process definitions
    CLK_process :process
    begin
        clk_12megas <= '0';
        wait for clk_period/2;
        clk_12megas <= '1';
        wait for clk_period/2;
    end process;
    
    -- Microdata definitions - Tarea 1.7
    a <= not a after 1300 ns;
    b <= not b after 2100 ns;
    c <= not c after 3700 ns;
    micro_data <= a xor b xor c;

end Behavioral;
