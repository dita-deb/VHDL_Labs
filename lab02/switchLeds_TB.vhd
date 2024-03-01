---------------------------------------------------------------------------------- 
-- Create Date: 01/31/2023 08:54:30 AM
-- Name: Anindita Deb 
-- Design Name: Lab02
-- Module Name: switchLeds
-- Description: 
-- We are driving the LEDS on the bottom of the basys3 board with the first three
-- switches. We will convert the three switch inputs into a binary value and control the 
-- left or right joysticks to display the corresponding number of leds on the board. 
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity switchLeds_TB is
--  Port ( );
end switchLeds_TB;

architecture switchLeds_TB_ARCH of switchLeds_TB is

component switchLeds is
    port (
        ledCount: in std_logic_vector(2 downto 0);  --switches into binary count
        leftButton: in  std_logic;                  --left button digtital pad
        rightButton: in std_logic;                  --right button digital pad 
        leds: out std_logic_vector(15 downto 0)
        );  
end component;

--Signal
    signal ledCount: std_logic_vector(2 downto 0);  --switches into binary count signals
    signal leftButton:  std_logic;                  --left button digtital pad signal
    signal rightButton: std_logic;                  --right button digital pad signal
    signal leds: std_logic_vector(15 downto 0);
    
begin
--UUT Port Map
    UUT: switchLeds port map(
         ledCount => ledCount, 
         leftButton => leftButton,
         rightButton => rightButton, 
         leds => leds 
    );
    
--LED SWITCH DRIVER process
LED_DRIVER: process
begin 
--No Buttons are pressed on
    ledCount <= "000";
    rightButton <= '0';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "001";
    rightButton <= '0';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "010";
    rightButton <= '0';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "011";
    rightButton <= '0';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "100";
    rightButton <= '0';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "101";
    rightButton <= '0';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "110";
    rightButton <= '0';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "111";
    rightButton <= '0';
    leftButton <= '0';
    wait for 20 ns;
--leftButton pressed On
    ledCount <= "000";
    rightButton <= '0';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "001";
    rightButton <= '0';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "010";
    rightButton <= '0';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "011";
    rightButton <= '0';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "100";
    rightButton <= '0';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "101";
    rightButton <= '0';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "110";
    rightButton <= '0';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "111";
    rightButton <= '0';
    leftButton <= '1';
    wait for 20 ns;

--rightButton pressed On
    ledCount <= "000";
    rightButton <= '1';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "001";
    rightButton <= '1';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "010";
    rightButton <= '1';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "011";
    rightButton <= '1';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "100";
    rightButton <= '1';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "101";
    rightButton <= '1';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "110";
    rightButton <= '1';
    leftButton <= '0';
    wait for 20 ns;

ledCount <= "111";
    rightButton <= '1';
    leftButton <= '0';
    wait for 20 ns;
--both left and right buttons are pressed On
    ledCount <= "000";
    rightButton <= '1';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "001";
    rightButton <= '1';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "010";
    rightButton <= '1';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "011";
    rightButton <= '1';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "100";
    rightButton <= '1';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "101";
    rightButton <= '1';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "110";
    rightButton <= '1';
    leftButton <= '1';
    wait for 20 ns;

ledCount <= "111";
    rightButton <= '1';
    leftButton <= '1';
    wait;
end process;

end switchLeds_TB_ARCH;
