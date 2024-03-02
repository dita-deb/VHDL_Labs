----------------------------------------------------------------------------------------------------------------------
-- This component debounces a button input. This prevents unwanted incrementing and decrementing of the LED position,
-- due to the properties of the mechanical button system.
----------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Debouncer is
    port (
    	reset:           in  std_logic;
        clock:           in  std_logic;
    	input:           in  std_logic;
        debouncedOutput: out std_logic
        );
end Debouncer;

architecture Debouncer_ARCH of Debouncer is
    constant ACTIVE: std_logic := '1';
    constant TIME_BETWEEN_PULSES: integer := 12;
    constant CLOCK_FREQUENCY: integer := 100000000;
    signal pulse: std_logic;
    
  -- Calculating the count per clock cycle needed to achieve the desired pulse frequency.
    constant COUNT_BETWEEN_PULSES: integer := (CLOCK_FREQUENCY/TIME_BETWEEN_PULSES) - 1;
    
    -- Creating needed type and signals for state machine.
    type States_t is (WAIT_FOR_INPUT, OUTPUT, WAIT_FOR_CONDITIONS);
    signal currentState: States_t;
    signal nextState:    States_t;

begin

	-------------------------------------------------------------------------------------
    -- Pulse Generator                                                            PROCESS
    -------------------------------------------------------------------------------------
	PULSE_GENERATOR: process(reset, clock)
    variable count: integer range 0 to COUNT_BETWEEN_PULSES;
    begin
        if (reset = ACTIVE) then
            count := 0;
        elsif (rising_edge(clock)) then
            if (count = COUNT_BETWEEN_PULSES) then
                count := 0;
                pulse <= ACTIVE;
            else
                count := count + 1;
                pulse <= not ACTIVE; 
            end if;
        end if;
    end process PULSE_GENERATOR;
    
    --===================================================================================
    -- State Register                                                             PROCESS
    --===================================================================================
    STATE_REGISTER: process(reset, clock)
    begin
        if (reset = ACTIVE) then
            currentState <= WAIT_FOR_INPUT;
        elsif (rising_edge(clock)) then
            currentState <= nextState;
        end if;
    end process;
    
    --===================================================================================
    -- State Transitions                                                          PROCESS
    --===================================================================================
    STATE_TRANSITION: process(currentState, input, pulse)
    begin
        -- Defaults
        debouncedOutput <= not ACTIVE;
        nextState <= currentState;
        
        case currentState is
            when WAIT_FOR_INPUT =>
                if (input = ACTIVE) then
                    nextState <= OUTPUT;
                end if;
                
            when OUTPUT =>
                debouncedOutput <= ACTIVE;
                nextState <= WAIT_FOR_CONDITIONS; 
                  
            when WAIT_FOR_CONDITIONS => 
                if (input = not ACTIVE) and (pulse = ACTIVE) then
                    nextState <= WAIT_FOR_INPUT;
                end if;
            
        end case;
    end process;
end Debouncer_ARCH;
