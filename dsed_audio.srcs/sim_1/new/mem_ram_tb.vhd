----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/29/2021 09:25:35 AM
-- Design Name: 
-- Module Name: mem_ram_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY mem_ram_tb IS
END mem_ram_tb;

ARCHITECTURE Behavioral OF mem_ram_tb IS

    COMPONENT mem_ram PORT (
        addra : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
        clka : IN STD_LOGIC;
        dina : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR (0 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL addra : STD_LOGIC_VECTOR(18 DOWNTO 0) := (OTHERS => '0');
    SIGNAL clka : STD_LOGIC := '0';
    SIGNAL dina : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL douta : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ena : STD_LOGIC := '0';
    SIGNAL wea : STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');

    CONSTANT clk_period : TIME := 83.3 ns;
    CONSTANT delta : TIME := 500 ns;

BEGIN

    UUT_ram : mem_ram
    PORT MAP(
        addra => addra,
        clka => clka,
        dina => dina,
        douta => douta,
        ena => ena,
        wea => wea
    );

    clka <= NOT clka AFTER clk_period/2;

    stimuli : PROCESS
    BEGIN
        ena <= '1';
        WAIT FOR delta;
        wea <= "1";
        WAIT FOR delta;
        addra <= "0000000000000000000";
        dina <= "10101010";
        WAIT FOR delta;
        addra <= "0000000000000000001";
        dina <= "00001111";
        WAIT FOR delta;
        wea <= "0";
        WAIT FOR delta;
        addra <= "0000000000000000000";
        WAIT FOR delta;
        addra <= "0000000000000000001";
        WAIT;
    END PROCESS;

END Behavioral;