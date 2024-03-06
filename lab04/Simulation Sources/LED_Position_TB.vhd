
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_Position_TB is
end LED_Position_TB;

architecture LED_Position_TB_ARCH of LED_Position_TB is
    
    
    constant NUM_OF_LEDS: integer := 16;
    constant NUM_OF_OUTPUT_BITS: integer := 8;
    constant ACTIVE: std_logic := '1';
    
    --unit-under-test-------------------------------------COMPONENT
    component LED_Position
        port (
            reset:         in  std_logic;
            clock:         in  std_logic;
            incrementLED:  in  std_logic;
            decrementLED:  in  std_logic;
            editMode:      in  std_logic;
            currentLED:    out std_logic_vector(7 downto 0)
        );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:          std_logic;
    signal clock:          std_logic;
    signal incrementLED:   std_logic;
    signal decrementLED:   std_logic;
    signal editMode:       std_logic;
    signal currentLed:     std_logic_vector(7 downto 0);
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: LED_Position
    port map(
        reset               => reset,
        clock               => clock,
        incrementLED        => incrementLED,
        decrementLED        => decrementLED,
        editMode            => editMode,
        currentLED          => currentLED
        );
    
    
    SYSTEM_RESET: process
    begin
        reset <= ACTIVE;
        wait for 100 ns;
        reset <= not ACTIVE;
        wait;
    end process SYSTEM_RESET;

   
    SYSTEM_CLOCK: process
    begin
        clock <= not ACTIVE;
        wait for 5 ns;
        clock <= ACTIVE;
        wait for 5 ns;
    end process SYSTEM_CLOCK;
    
  
    LEDTEST: process
    begin
  
        editMode <= '0';
        wait for 10 ns;
        incrementLED <= '1';
        wait for 10 ns;
        decrementLED <= '1';
        wait for 10 ns;
        incrementLED <= '0';
        wait for 10 ns;
        decrementLED <= '0';
        wait for 10 ns;
        
        
        editMode <= '1';
        wait for 10 ns;
        incrementLED <= '1';
        wait for 10 ns;
        decrementLED <= '1';
        wait for 10 ns;
        incrementLED <= '0';
        wait for 10 ns;
        decrementLED <= '0';
        wait for 10 ns;
        
    
        editMode <= '0';
        wait for 25 ns;
        
       
        editMode <= '0';
        wait for 10 ns;
        incrementLED <= '1';
        wait for 10 ns;
        decrementLED <= '1';
        wait for 10 ns;
        incrementLED <= '0';
        wait for 10 ns;
        decrementLED <= '0';
        wait for 10 ns;
        
       
        editMode <= '1';
        wait for 25 ns;
        incrementLED <= '1';
        wait for 200 ns;
        decrementLED <= '1';
        wait for 50 ns;
        incrementLED <= '0';
        wait for 200 ns;
        decrementLED <= '0';
        wait for 25 ns;
        
       
        incrementLED <= '1';
        wait for 10 ns;
        incrementLED <= '0';
        wait for 10 ns;
        incrementLED <= '1';
        wait for 10 ns;
        incrementLED <= '0';
        wait for 10 ns;
        incrementLED <= '1';
        wait for 10 ns;
        incrementLED <= '0';
        wait for 10 ns;
        
        
        wait;
    end process;
end LED_Position_TB_ARCH;
