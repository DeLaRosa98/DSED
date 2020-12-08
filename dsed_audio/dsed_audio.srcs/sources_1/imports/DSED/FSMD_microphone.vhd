----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2020 18:37:25
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSMD_microphone is
Port ( clk_12megas : in STD_LOGIC;
       reset : in STD_LOGIC;
       enable_4_cycles : in STD_LOGIC;
       micro_data : in STD_LOGIC;
       sample_out : out STD_LOGIC_VECTOR (7 downto 0);
       sample_out_ready : out STD_LOGIC);
end FSMD_microphone;


architecture Behavioral of FSMD_microphone is
    constant DATO_COUNT_MAX : integer := 2**8;

    type state_type is (S1,S2,S3);
    signal state_reg, state_next : state_type;
    signal dato1_reg, dato1_next : unsigned (7 downto 0);
    signal dato2_reg, dato2_next : unsigned (7 downto 0);
    signal sample_out_reg, sample_out_next : STD_LOGIC_VECTOR (7 downto 0) := (others=>'0');
    signal cuenta_reg, cuenta_next : unsigned (8 downto 0);
    signal primer_ciclo_reg, primer_ciclo_next : std_logic;
    signal sample_out_ready_aux : std_logic;
begin
    
    -- Clock process
    process(clk_12megas, reset)
    begin
       if (reset = '1') then
        state_reg <= S1;
        cuenta_reg <= (others=>'0');
        dato1_reg <= (others=>'0');
        dato2_reg <= (others=>'0');
        primer_ciclo_reg <= '0';
        sample_out_reg <= (others=>'0');
       else
         if(clk_12megas'event and clk_12megas='1') then
            if(enable_4_cycles = '1') then
                state_reg <= state_next;
                cuenta_reg <= cuenta_next;
                dato1_reg <= dato1_next;
                dato2_reg <= dato2_next;
                cuenta_reg <= cuenta_next;
                primer_ciclo_reg <= primer_ciclo_next;
                sample_out_reg <= sample_out_next;
            end if;
         end if;
       end if;
    end process;

    -- Control Path
    process(state_reg, cuenta_reg)
    begin
        state_next <= S1;
    
        case state_reg is
            when S1 =>
                if cuenta_reg = 104 then
                    state_next <= S2;
                elsif cuenta_reg = 254 then
                    state_next <= S3;
                end if;
            when S2 =>
                if cuenta_reg = 148 then
                    state_next <= S1;
                else
                  state_next <= S2;
                end if;
            when S3 =>
                if cuenta_reg = 299 then
                    state_next <= S1;
                else
                    state_next <= S3;
                end if;
            when others =>
                state_next <= S1;
         end case;
     end process;
     
     -- Data path
     process(state_reg, dato1_reg, dato2_reg, cuenta_reg, primer_ciclo_reg, enable_4_cycles, micro_data, sample_out_reg)
     begin
        sample_out_ready_aux <= '0';
        dato1_next <= dato1_reg;
        dato2_next <= dato2_reg;
        cuenta_next <= cuenta_reg;
        primer_ciclo_next <= primer_ciclo_reg;
        
        case state_reg is
            when S1 =>
                sample_out_ready_aux <= '0';
                cuenta_next <= cuenta_reg +1;
                if micro_data = '1' then
                    dato1_next <= dato1_reg + 1;
                    dato2_next <= dato2_reg + 1;
                end if;                   
            when S2 =>
                cuenta_next <= cuenta_reg + 1;
                if micro_data = '1' then
                    dato1_next <= dato1_reg + 1;
                end if;
                if(primer_ciclo_reg = '1' and cuenta_reg = 106) then
                    sample_out_next <= std_logic_vector(dato2_reg);
                    dato2_next <= (others=>'0');
                    sample_out_ready_aux <= enable_4_cycles;
                else
                    sample_out_ready_aux <= '0';
                end if;
            when S3 =>
                cuenta_next <= cuenta_reg + 1;
                if micro_data = '1' then
                    dato2_next <= dato2_reg + 1;
                end if;
                if(cuenta_reg = 255) then
                    sample_out_next <= std_logic_vector(dato1_reg);
                    dato1_next <= (others=>'0');
                    sample_out_ready_aux <= enable_4_cycles;
                else
                    sample_out_ready_aux <= '0';
                end if;
                if cuenta_reg = 299 then
                    primer_ciclo_next <= '1';
                    cuenta_next <= (others=>'0');
                end if;
         end case;
     end process;

    sample_out <= sample_out_reg;
    sample_out_ready <= sample_out_ready_aux;

end Behavioral;
