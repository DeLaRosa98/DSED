----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/22/2021 05:39:10 PM
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY fir_filter IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        sample_in : IN signed (sample_size - 1 DOWNTO 0);
        sample_in_enable : IN STD_LOGIC;
        filter_select : IN STD_LOGIC;
        sample_out : OUT signed (sample_size - 1 DOWNTO 0);
        sample_out_ready : OUT STD_LOGIC);
END fir_filter;

ARCHITECTURE Behavioral OF fir_filter IS

    COMPONENT data_route_filter
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            c0 : IN signed (sample_size - 1 DOWNTO 0);
            c1 : IN signed (sample_size - 1 DOWNTO 0);
            c2 : IN signed (sample_size - 1 DOWNTO 0);
            c3 : IN signed (sample_size - 1 DOWNTO 0);
            c4 : IN signed (sample_size - 1 DOWNTO 0);
            x0 : IN signed (sample_size - 1 DOWNTO 0);
            x1 : IN signed (sample_size - 1 DOWNTO 0);
            x2 : IN signed (sample_size - 1 DOWNTO 0);
            x3 : IN signed (sample_size - 1 DOWNTO 0);
            x4 : IN signed (sample_size - 1 DOWNTO 0);
            count : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            y : OUT signed (sample_size - 1 DOWNTO 0));
    END COMPONENT;

    COMPONENT control_route
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            sample_in_enable : IN STD_LOGIC;
            count : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            sample_out_ready : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL C_0, C_1, C_2, C_3, C_4 : signed (sample_size - 1 DOWNTO 0);
    SIGNAL X_0, X_1, X_2, X_3, X_4 : signed (sample_size - 1 DOWNTO 0);
    SIGNAL s_cuenta : STD_LOGIC_VECTOR (2 DOWNTO 0);

BEGIN

    PROCESS (clk, sample_in_enable, reset)
    BEGIN
        IF (reset = '1') THEN
            X_0 <= (OTHERS => '0');
            X_1 <= (OTHERS => '0');
            X_2 <= (OTHERS => '0');
            X_3 <= (OTHERS => '0');
            X_4 <= (OTHERS => '0');
        ELSE
            IF (clk'event AND clk = '1' AND sample_in_enable = '1') THEN
                X_0 <= sample_in;
                X_1 <= X_0;
                X_2 <= X_1;
                X_3 <= X_2;
                X_4 <= X_3;
            END IF;
        END IF;
    END PROCESS;

    PROCESS (filter_select)
    BEGIN
        IF (filter_select = '0') THEN
            C_0 <= c0pb;
            C_1 <= c1pb;
            C_2 <= c2pb;
            C_3 <= c3pb;
            C_4 <= c4pb;
        ELSE
            C_0 <= c0pa;
            C_1 <= c1pa;
            C_2 <= c2pa;
            C_3 <= c3pa;
            C_4 <= c4pa;
        END IF;
    END PROCESS;

    UUT_dataroute : data_route_filter
    PORT MAP(
        clk => clk,
        reset => reset,
        c0 => C_0,
        c1 => C_1,
        c2 => C_2,
        c3 => C_3,
        c4 => C_4,
        x0 => X_0,
        x1 => X_1,
        x2 => X_2,
        x3 => X_3,
        x4 => X_4,
        count => s_cuenta,
        y => sample_out
    );

    UUT_control : control_route
    PORT MAP(
        clk => clk,
        reset => reset,
        sample_in_enable => sample_in_enable,
        count => s_cuenta,
        sample_out_ready => sample_out_ready
    );

END Behavioral;