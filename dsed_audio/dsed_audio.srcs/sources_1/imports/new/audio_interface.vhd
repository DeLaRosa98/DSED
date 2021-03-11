----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 28/11/2020 12:31:14 PM
-- Design Name:
-- Module Name: audio_interface - Behavioral
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

ENTITY audio_interface IS
  PORT (
    clk_12megas : IN STD_LOGIC; -- Reloj global de la arquitectura a 12 MHz
    reset : IN STD_LOGIC; -- Reset global del sistema.
    --Recording ports
    --To/From the controller
    record_enable : IN STD_LOGIC; -- Señal de control de la grabación. Cuando esté a '1', la digitalización de la información del micrófono funcionará.
    sample_out : OUT STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0); -- Dato de 8 bits (número positivo sin signo) correspondiente a la señal digitalizada obtenida del micrófono.
    sample_out_ready : OUT STD_LOGIC; --Señal de control que proporciona un pulso activo de un periodo de reloj de duración cada vez que se proporciona un nuevo dato digitalizado.
    --To/From the microphone
    micro_clk : OUT STD_LOGIC; -- Salida del reloj del micrófono. Un reloj de 3 MHz obtenido a partir de nuestro reloj de 12 MHz.
    micro_data : IN STD_LOGIC; -- Entrada de la señal PDM proveniente del micrófono.
    micro_LR : OUT STD_LOGIC; -- Salida de control del microfono que determina si las muestras se toman en el banco de subida o de bajada del reloj. Dejaremos este valor estable en '1', correspondiente al banco de subida
    --Playing ports
    --To/From the controller
    play_enable : IN STD_LOGIC; -- Señal de control de la reproducción de audio. Cuando esté a '1', se procederá a la generación de la señal PWM hacia la salida de audio mono
    sample_in : IN STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0); -- Dato de 8 bits correspondiente a la señal que hay que reproducir
    sample_request : OUT STD_LOGIC; -- Señal de control que proporciona un pulso activo de un periodo de reloj de duración cada vez que se requiere un nuevo dato en sample in.
    --To/From the mini-jack
    jack_sd : OUT STD_LOGIC; --Información de control para los operacionales de la etapa de audio mono. Dejaremos este valor estable en '1'.
    jack_pwm : OUT STD_LOGIC); -- La señal PWM generada a partir del dato en sample in.
END audio_interface;

ARCHITECTURE Behavioral OF audio_interface IS
  COMPONENT pwm
    PORT (
      clk_12megas : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      en_2_cycles : IN STD_LOGIC;
      sample_in : IN STD_LOGIC_VECTOR(sample_size - 1 DOWNTO 0);
      sample_request : OUT STD_LOGIC;
      pwm_pulse : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT FSMD_microphone
    PORT (
      clk_12megas : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      enable_4_cycles : IN STD_LOGIC;
      micro_data : IN STD_LOGIC;
      sample_out : OUT STD_LOGIC_VECTOR (sample_size - 1 DOWNTO 0);
      sample_out_ready : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT en_4_cycles
    PORT (
      clk_12megas : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      clk_3megas : OUT STD_LOGIC;
      en_2_cycles : OUT STD_LOGIC;
      en_4_cycles : OUT STD_LOGIC);
  END COMPONENT;

  --Output signals
  SIGNAL and_enable_2_cycles, enable_2_cycles : STD_LOGIC := '1';
  SIGNAL and_enable_4_cycles, enable_4_cycles : STD_LOGIC := '1';
BEGIN
  and_enable_2_cycles <= enable_2_cycles AND play_enable;
  and_enable_4_cycles <= enable_4_cycles AND record_enable;

  UUT_pwm : pwm
  PORT MAP(
    clk_12megas => clk_12megas,
    reset => reset,
    en_2_cycles => and_enable_2_cycles,
    sample_in => sample_in,
    sample_request => sample_request,
    pwm_pulse => jack_pwm
  );

  UUT_microphone : FSMD_microphone
  PORT MAP(
    clk_12megas => clk_12megas,
    reset => reset,
    enable_4_cycles => and_enable_4_cycles,
    micro_data => micro_data,
    sample_out => sample_out,
    sample_out_ready => sample_out_ready
  );

  UUT_enables : en_4_cycles
  PORT MAP(
    clk_12megas => clk_12megas,
    reset => reset,
    clk_3megas => micro_clk,
    en_2_cycles => enable_2_cycles,
    en_4_cycles => enable_4_cycles
  );

  jack_sd <= '1'; --  Dejaremos este valor estable en '1'.
  micro_LR <= '1'; -- Dejaremos este valor estable en '1', correspondiente al banco de subida

END Behavioral;