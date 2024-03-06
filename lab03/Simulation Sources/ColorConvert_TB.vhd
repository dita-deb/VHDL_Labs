----------------------------------------------------------------------------------
-- Engineer:  Anindita Deb
-- CPE 3020
-- Create Date: 02/20/2023 08:36:04 PM
--
-- This is the test bench code for the ColorConvert block. It simulates the 8 RBG colors
-- described in ColorConvert, using a 7 bit binary input and outputs a 16 bit value
--that simulates the LEDs on the board lighting up.

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ColorConvert_TB is
--  Port ( );
end ColorConvert_TB;

architecture ColorConvert_TB_ARCH of ColorConvert_TB is

--unit-under-test-------------------------------------COMPONENT
component ColorConvert
      port(
            currentChar: in std_logic_vector(6 downto 0);
            color: out std_logic_vector(23 downto 0);
            seg: out std_logic_vector(6 downto 0)
            );
end component;

--uut-signals-------------------------------------------SIGNALS
      signal currentChar:  std_logic_vector(6 downto 0);
    signal color: std_logic_vector(23 downto 0);
    signal seg: std_logic_vector(6 downto 0);
begin

--Unit-Under-Test-------------------------------------------UUT
      UUT: ColorConvert port map(
            currentChar => currentChar,
            color => color,
            seg => seg
      );
      
----------------------------------------------------------------
--This process simulates all possible letter values defined in the main code,
--and returns their output via waveform.
----------------------------------------------------------------

ColorPicker: process
begin
currentChar <= "1110010"; --r
wait for 20 ns;
currentChar <= "1101111";
wait for 20 ns;
currentChar <= "1111001";
wait for 20 ns;
currentChar <= "1100111";
wait for 20 ns;
currentChar <= "1100010";
wait for 20 ns;
currentChar <= "1101001";
wait for 20 ns;
currentChar <= "1110110";
wait for 20 ns;
currentChar <= "1110110";
wait for 20 ns;
currentChar <= "1110111";
wait for 20 ns;
currentChar <= "1111111";
wait;
end process;


end ColorConvert_TB_ARCH;
