---------------------------------------------------------------------------------- 
-- Create Date: 01/31/2023 08:54:30 AM
-- Name: Anindita Deb 
-- Design Name: Lab02
-- Module Name: switchLeds
-- Description: 
-- We are driving the LEDS on the bottom of the basys322 board with the first three
-- switches. We will convert the three switch inputs into a binary value and control the 
-- left or right joysticks to display the corresponding number of leds on the board. 
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
--*******************************************************************************
library ieee;
use ieee.std_logic_1164.all;


entity switchLeds is
    port (
        ledCount: in std_logic_vector(2 downto 0);  --switches into binary count
        leftButton: in  std_logic;                  --left button digtital pad
        rightButton: in std_logic;                  --right button digital pad 
        leds: out std_logic_vector(15 downto 0)     --leds bus
        );  
end switchLeds;

architecture switchLeds_ARCH of switchLeds is

    -------------------------------------------------------------------CONSTANTS
    constant GROUND: std_logic_vector(8 downto 7) := "00";          --these two bits will always be 0
    constant NO_PATTERN: std_logic_vector(6 downto 0):= "0000000";  --all 7 leds off
    -------------------------------------------------------------------COMPONENT

    --internal connections-----------------------------------------------SIGNALS
    signal leftPattern: std_logic_vector(6 downto 0);
    signal leftLed: std_logic_vector(6 downto 0);
    signal rightPattern: std_logic_vector(6 downto 0);
    signal rightLed: std_logic_vector(6 downto 0);
    
begin
    --Multiplexers that show where the leds are on in each pattern 
    with ledCount select
         leftPattern <=  "0000000" when "000",
                         "1000000" when "001",
                         "1100000" when "010",
                         "1110000" when "011",
                         "1111000" when "100",
                         "1111100" when "101",
                         "1111110" when "110",
                         "1111111" when others;
    with ledCount select
        rightPattern<=   "0000000" when "000",
                         "0000001" when "001",
                         "0000011" when "010",
                         "0000111" when "011",
                         "0001111" when "100",
                         "0011111" when "101",
                         "0111111" when "110",
                         "1111111" when others;
   
     --RIGHT LED Selector
     with rightButton select
        rightLed <= NO_PATTERN when '0',
                    rightPattern when others;
     --LEFT LED Selector
     with leftButton select
        leftLed <= NO_PATTERN when '0',
                    leftPattern when others;
    --LED DRIVER
    leds(15 downto 9) <= leftLed;   --specify leftLeds
    leds(8 downto 7) <= GROUND;     --middle two are off
    leds(6 downto 0) <= rightLed;   --specify rightLeds
    
end switchLeds_ARCH;
