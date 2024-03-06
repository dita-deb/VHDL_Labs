----------------------------------------------------------------------------------
-- Create Date: 01/31/2023 08:54:30 AM
-- Name: Anindita Deb 
-- Design Name: Lab02
-- Module Name: switchLeds
-- Description: 
-- This is a wrapper targeting the Digilent Basys3 development board for the switchesLed.vhd file. 
-- We are driving the LEDS on the bottom of the basys3 board with the first three
-- switches. We will convert the three switch inputs into a binary value and control the 
-- left and/or right joysticks to display the corresponding number of leds on the board. 
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity switchLeds_BASYS3 is
    Port ( 
        sw: in std_logic_vector(2 downto 0);
        led: out std_logic_vector(15 downto 0);
        btnL: in std_logic;
        btnR: in std_logic);
end switchLeds_BASYS3;

architecture switchLeds_BASYS3_ARCH of switchLeds_BASYS3 is
    --Component for LED DRIVER
    component switchLeds
            port (
                ledCount: in std_logic_vector(2 downto 0);  --ledCount
                leftButton: in std_logic;                  --leftButton
                rightButton: in std_logic;                  --rightButton
                leds: out std_logic_vector(15 downto 0)     --leds
                );
        end component;
begin
    --each port is given it's corresponding hardware pin location
     MY_LED_DRIVER: switchLeds port map (                                     --
        ledCount => sw,
        leftButton => btnL,
        rightButton => btnR,
        leds => led
    );

end switchLeds_BASYS3_ARCH;
