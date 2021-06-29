----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/29/2021 09:08:29 AM
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
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY dsed_audio IS
    PORT (
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
END dsed_audio;

ARCHITECTURE Behavioral OF dsed_audio IS

    COMPONENT clk_12megas
        PORT (
            clk_100 : IN STD_LOGIC;
            clk_12 : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT audio_interface
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
            jack_pwm : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT fir_filter PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        sample_in : IN signed (sample_size - 1 DOWNTO 0);
        sample_in_enable : IN STD_LOGIC;
        filter_select : IN STD_LOGIC; --0 lowpass, 1 highpass
        sample_out : OUT signed (sample_size - 1 DOWNTO 0);
        sample_out_ready : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT mem_ram PORT (
        addra : IN STD_LOGIC_VECTOR (18 DOWNTO 0);
        clka : IN STD_LOGIC;
        dina : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        ena : IN STD_LOGIC;
        wea : IN STD_LOGIC_VECTOR (0 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT controller PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        --To/From Nexys4DDR
        BTNL : IN STD_LOGIC;
        BTNC : IN STD_LOGIC;
        BTNR : IN STD_LOGIC;
        SW0 : IN STD_LOGIC;
        SW1 : IN STD_LOGIC;
        record_enable_audio : OUT STD_LOGIC;
        sample_out_audio : IN STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0);
        sample_out_ready_audio : IN STD_LOGIC;
        play_enable_audio : OUT STD_LOGIC;
        sample_in_audio : OUT STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
        sample_request_audio : IN STD_LOGIC;
        sample_in_filter : OUT signed (sample_size - 1 DOWNTO 0);
        sample_in_enable_filter : OUT STD_LOGIC;
        sample_out_filter : IN signed (sample_size - 1 DOWNTO 0);
        sample_out_ready_filter : IN STD_LOGIC;
        addra : OUT STD_LOGIC_VECTOR (18 DOWNTO 0);
        dina : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        douta : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        ena : OUT STD_LOGIC;
        wea : OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
        state : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clk_12meg : STD_LOGIC;
    SIGNAL s_sample_out_audio, s_sample_in_audio : STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
    SIGNAL s_sample_in_filter, s_sample_out_filter : signed(sample_size - 1 DOWNTO 0);
    SIGNAL s_record_enable, s_sample_out_ready_audio, s_play_enable, s_sample_request, s_sample_in_enable, s_sample_out_ready_filter, s_ena : STD_LOGIC;
    SIGNAL s_addra : STD_LOGIC_VECTOR(18 DOWNTO 0);
    SIGNAL s_dina, s_douta : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL s_wea : STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL s_state : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

    UUT_clk : clk_12megas
    PORT MAP(
        clk_100 => clk_100Mhz,
        clk_12 => clk_12meg);

    UUT_audio : audio_interface
    PORT MAP(
        clk_12megas => clk_12meg,
        reset => reset,
        record_enable => s_record_enable,
        sample_out => s_sample_out_audio,
        sample_out_ready => s_sample_out_ready_audio,
        micro_clk => micro_clk,
        micro_data => micro_data,
        micro_LR => micro_LR,
        play_enable => s_play_enable,
        sample_in => s_sample_in_audio,
        sample_request => s_sample_request,
        jack_sd => jack_sd,
        jack_pwm => jack_pwm
    );

    UUT_filter : fir_filter
    PORT MAP(
        clk => clk_12meg,
        reset => reset,
        sample_in => s_sample_in_filter,
        sample_in_enable => s_sample_in_enable,
        filter_select => SW0,
        sample_out => s_sample_out_filter,
        sample_out_ready => s_sample_out_ready_filter
    );

    UUT_ram : mem_ram
    PORT MAP(
        addra => s_addra,
        clka => clk_12meg,
        dina => s_dina,
        douta => s_douta,
        ena => s_ena,
        wea => s_wea
    );

    UUT_control : controller
    PORT MAP(
        clk => clk_12meg,
        reset => reset,
        BTNL => BTNL,
        BTNC => BTNC,
        BTNR => BTNR,
        SW0 => SW0,
        SW1 => SW1,
        record_enable_audio => s_record_enable,
        sample_out_audio => s_sample_out_audio,
        sample_out_ready_audio => s_sample_out_ready_audio,
        play_enable_audio => s_play_enable,
        sample_in_audio => s_sample_in_audio,
        sample_request_audio => s_sample_request,
        sample_in_filter => s_sample_in_filter,
        sample_in_enable_filter => s_sample_in_enable,
        sample_out_filter => s_sample_out_filter,
        sample_out_ready_filter => s_sample_out_ready_filter,
        addra => s_addra,
        dina => s_dina,
        douta => s_douta,
        ena => s_ena,
        wea => s_wea,
        state => s_state
    );

END Behavioral;