----------------------------------------------------------------------------------------------
-- Anindita
-- Professor Scott Tippens
-- CPE 3020
-- 
-- This component increments and decrements the position of LEDs on the Basys-3. There are 16 possible positions for the LED position.
-- When the position reaches the minimum or maximum position, the position is changed to 15 or 0 respectively.
-- Additionally, the user must be in edit mode in order to increment or decrement the position of the LED.
-----------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_Position is
    port(
        reset:         in  std_logic;
        clock:         in  std_logic;
        incrementLED:  in  std_logic;
        decrementLED:  in  std_logic;
        editMode:      in  std_logic;
        currentLED:    out std_logic_vector(7 downto 0)
        );
        
end LED_Position;

architecture LED_Position_ARCH of LED_Position is
    constant ACTIVE: std_logic := '1';

--Internal signal for the process to use
    signal currentLEDPosition: integer range 0 to 15;

--------------------------------------------------------------------------------------------
-- This process utilizes clock and reset inputs to increment and decrement the LED position.
-- The position will only increment on the rising edge of the clock, and will asynchronously reset to 0 if the reset input
-- is active.
-- Additionally, edit mode must be active for the position to increment or decrement
--------------------------------------------------------------------------------------------    
begin

    process(reset, clock)
    begin
        if (reset = ACTIVE) then
            currentLEDPosition <= 0;
        elsif (rising_edge(clock)) then
            if (editMode = not ACTIVE) then
                currentLEDPosition <= 0;
                
            elsif (editMode = ACTIVE) then
                if ((incrementLED and
                     decrementLED) = ACTIVE) then
                    currentLEDPosition <= currentLEDPosition;
                    
                elsif (incrementLED = ACTIVE) then
                    if (currentLEDPosition >= 15) then
                        currentLEDPosition <= 0;
                    else
                        currentLEDPosition <= currentLEDPosition + 1;
                    end if;
                    
                elsif (decrementLED = ACTIVE) then
                    if (currentLEDPosition <= 0) then
                        currentLEDPosition <= 15;
                    else
                        currentLEDPosition <= currentLEDPosition - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
--The requirement is to output a logic vector, rather than an integer, so it must be converted.
    currentLED <=
    std_logic_vector(to_unsigned(currentLEDPosition, currentLED'length));
    
end LED_Position_ARCH;
