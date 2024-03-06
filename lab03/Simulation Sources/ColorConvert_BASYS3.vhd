--*******************************************************************************
-- LEDSwitch_BASYS3
-- Designer: Anindita Deb
--
-- Wrapper for ColorConvert Project to map Basys3 resources to ColorConvert
-- ports.  We will be using the 7 right most slide switches for the value input.
-- We will use all 16 LEDs for the display.
--
--*******************************************************************************
library ieee;
use ieee.std_logic_1164.all;


entity ColorConvert_BASYS3 is
      port (
            sw:   in  std_logic_vector(6 downto 0);    --slide switch inputs                      
            led:  out std_logic_vector(15 downto 0);   --16 LED Outputs
            btnC: in std_logic;                        --Center Joystick button
            seg: out std_logic_vector(6 downto 0)      --7 segment display value
            );    
end ColorConvert_BASYS3;

architecture ColorConvert_BASYS3_ARCH of ColorConvert_BASYS3 is

      -------------------------------------------------------------------CONSTANTS
      constant OFF_LEDS: std_logic_vector(7 downto 0) := (others => '0'); --Turns off lower 8 leds
      -------------------------------------------------------------------SIGNALS
      signal color: std_logic_vector(23 downto 0); --Internal color signal
      --ColorConvert-----------------------------------------------------COMPONENT
      component ColorConvert
            port(
              currentChar: in std_logic_vector(6 downto 0);
              color: out std_logic_vector(23 downto 0);
              seg: out std_logic_vector(6 downto 0)
              
            );
      end component;
      
begin

      --COLOR-driver---------------------------------------------------COMPONENT
      COLOR_DRIVER: ColorConvert port map (
        currentChar => sw,
        color => color,
        seg => seg
       
    );
 ------------------------------------------------------------------
 --Button Selector: when the button is off, the lower 16 color bits are displayed.
 --When it is pressed, the upper 8 are displayed.
 ------------------------------------------------------------------
 with btnC select
        led <= color(15 downto 0) when '0',
               color(23 downto 16) & OFF_LEDS when others;

end ColorConvert_BASYS3_ARCH;
