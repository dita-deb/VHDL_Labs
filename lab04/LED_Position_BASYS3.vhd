------------------------------------------------------------------------------------------
-- Wrapper for the LED_Position program. It uses the Debouncer, SynchronizationChain, and SevenSegmentDriver components.
-- This wrapper also contains a BCD converter, since our seven segment display requires an 8 bit value and our LED postion is a
-- 15 bit value. Additionally, the various components on the Basys-3 board are utilized to change the position of the LED. The center button
-- is used as a reset, while the left and right are for decrementing and incrementing respectively. The first switch is used for edit mode,
-- and the seven segment display is used to display the value of the LED position.
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_Position_BASYS3 is
	port(
		clk:   in   std_logic;
		btnC:  in   std_logic;
		btnR:  in   std_logic;
		btnL:  in   std_logic;
		sw:    in   std_logic_vector(15 downto 0);
		seg:   out  std_logic_vector(6 downto 0);
		led:   out  std_logic_vector(15 downto 0);
		an:    out  std_logic_vector(3 downto 0)
		);
end LED_Position_BASYS3;

architecture LED_Position_BASYS3_ARCH of LED_Position_BASYS3 is

	-- Active High Constant
	constant ACTIVE: std_logic := '1';
	
	-- LedPosition Constants
	constant NUM_OF_LEDS: positive := 16;
	constant NUM_OF_OUTPUT_BITS: positive := 8;
	
	-- Debouncer Constants
    constant TIME_BETWEEN_PULSES: positive := 15;
    constant CLOCK_FREQUENCY:     positive := 100000000;
    
    -- SynchronizerChain Constants
    constant CHAIN_SIZE: positive := 2;

	-- Internal Connection Signals
    signal incrementLEDSync:  std_logic;
    signal decrementLEDSync:  std_logic;
    signal editModeSync:                     std_logic;
    
    signal incrementLED:  std_logic;
    signal decrementLED:  std_logic;
    
    signal currentLED: std_logic_vector(7 downto 0);
    
    signal digit0:     std_logic_vector(3 downto 0);
    signal digit1:     std_logic_vector(3 downto 0);
    signal tempDigits: std_logic_vector(7 downto 0);
    
    signal sevenSegs: std_logic_vector(6 downto 0);
    signal anodes:    std_logic_vector(3 downto 0);

    --===================================================================================
    --  LedPosition                                                             COMPONENT
    --===================================================================================
    component LED_Position
		
        port(
            reset:         in  std_logic;
            clock:         in  std_logic;
            incrementLED:  in  std_logic;
            decrementLED:  in  std_logic;
            editMode:      in  std_logic;
            currentLED:    out std_logic_vector(7 downto 0)
            );
	end component LED_Position;

    --===================================================================================
    --  SynchronizerChain                                                       COMPONENT
    --===================================================================================
	component SynchronizerChain
		generic (
		    CHAIN_SIZE: positive
		    );
        port (
            reset:    in  std_logic;
            clock:    in  std_logic;
            asyncIn:  in  std_logic;
            syncOut:  out std_logic
            );
	end component SynchronizerChain;

    --===================================================================================
    --  Debouncer                                                               COMPONENT
    --===================================================================================
    component Debouncer
        generic (
            ACTIVE: std_logic := '1';
            TIME_BETWEEN_PULSES: positive := 12;       -- In Hz
            CLOCK_FREQUENCY: positive := 100000000     -- In Hz
            );
        port (
            reset:           in  std_logic;
            clock:           in  std_logic;
            input:           in  std_logic;
            debouncedOutput: out std_logic
            );
    end component;
	
	--===================================================================================
    --  SevenSegmentDriver                                                      COMPONENT
    --===================================================================================
	component SevenSegmentDriver
		port(
            reset: in std_logic;
            clock: in std_logic;
    
            digit3: in std_logic_vector(3 downto 0);    --leftmost digit
            digit2: in std_logic_vector(3 downto 0);    --2nd from left digit
            digit1: in std_logic_vector(3 downto 0);    --3rd from left digit
            digit0: in std_logic_vector(3 downto 0);    --rightmost digit
    
            blank3: in std_logic;    --leftmost digit
            blank2: in std_logic;    --2nd from left digit
            blank1: in std_logic;    --3rd from left digit
            blank0: in std_logic;    --rightmost digit
    
            sevenSegs: out std_logic_vector(6 downto 0);    --MSB=g, LSB=a
            anodes:    out std_logic_vector(3 downto 0)    --MSB=leftmost digit
            );
	end component SevenSegmentDriver;

    --===================================================================================
    --  to_bcd_8bit()                                                            FUNCTION
    --      Convert the input integer value to a two digit BCD representation.
    --      This function limits the return value to 99.
    --===================================================================================
    function to_bcd_8bit(inputValue: integer) return std_logic_vector is
        variable tensValue: integer;
        variable onesValue: integer;
    begin
        if (inputValue < 99) then
            tensValue := inputValue / 10;
            onesValue := inputValue mod 10;
        else
            tensValue := 9;
            onesValue := 9;
        end if;
        return std_logic_vector(to_unsigned(tensValue, 4))
               & std_logic_vector(to_unsigned(onesValue, 4));
    end to_bcd_8bit;

begin

	--===================================================================================
	--  SynchronizerChain component being initalized as SYNC_BTNR
	--===================================================================================
	SYNC_BTNR: SynchronizerChain
		generic map (
		    CHAIN_SIZE => CHAIN_SIZE
		    )
		port map (
			clock    => clk,
			reset    => btnC,
			asyncIn  => btnR,
			syncOut  => incrementLEDSync
			);

    --===================================================================================
	--  SynchronizerChain component being initalized as SYNC_BTNL
	--===================================================================================
	SYNC_BTNL: SynchronizerChain
		generic map (
		    CHAIN_SIZE => CHAIN_SIZE
		    )
		port map (
			clock    => clk,
			reset    => btnC,
			asyncIn  => btnL,
			syncOut  => decrementLEDSync
			);
			
	--===================================================================================
	--  SynchronizerChain component being initalized as SYNC_SW0
	--===================================================================================
	SYNC_SW0: SynchronizerChain
		generic map (
		    CHAIN_SIZE => CHAIN_SIZE
		    )
		port map (
			clock    => clk,
			reset    => btnC,
			asyncIn  => sw(0),
			syncOut  => editModeSync
			);
			
	--===================================================================================
	--  Debouncer component being initalized as DEBOUNCE_INC
	--===================================================================================
	DEBOUNCE_INC: Debouncer
	    generic map (
            ACTIVE              => ACTIVE,
            TIME_BETWEEN_PULSES => TIME_BETWEEN_PULSES,
            CLOCK_FREQUENCY     => CLOCK_FREQUENCY
            )
		port map (
			clock           => clk,
			reset           => btnC,
			input           => incrementLEDSync,
			debouncedOutput => incrementLED
			);		

    --===================================================================================
	--  Debouncer component being initalized as DEBOUNCE_DEC
	--===================================================================================
	DEBOUNCE_DEC: Debouncer
	    generic map (
            ACTIVE              => ACTIVE,
            TIME_BETWEEN_PULSES => TIME_BETWEEN_PULSES,
            CLOCK_FREQUENCY     => CLOCK_FREQUENCY
            )
		port map (
			clock           => clk,
			reset           => btnC,
			input           => decrementLEDSync,
			debouncedOutput => decrementLED
			);
			
	--===================================================================================
	--  LedPosition component being initalized as LED_POSITION_DRIVER
	--===================================================================================
	LED_POSITION_DRIVER: LED_Position
		
        port map(
            reset        => btnC,
            clock        => clk,
            incrementLED => incrementLED,
            decrementLED => decrementLED,
            editMode     => editModeSync,
            currentLED   => currentLED
            );		
			
	--===================================================================================
	--  Implements to_bcd_8bit() function
	--      currentLedPosition is converted to an integer then to BCD values.
	--      Each bcd digit is then assigned accordingly. 
	--===================================================================================
	tempDigits <= to_bcd_8bit(to_integer(unsigned(currentLed)));
	digit1 <= tempDigits(7 downto 4);    -- tens place
	digit0 <= tempDigits(3 downto 0);    -- ones place
	
	--===================================================================================
	--  SevenSegmentDriver component being initalized as SEVEN_SEG_DRIVER
	--===================================================================================
	SEVEN_SEG_DRIVER: SevenSegmentDriver
		port map (
			clock     => clk,
			reset     => btnC,
			digit0    => digit0,
			digit1    => digit1,
			digit2    => (others=>not ACTIVE),
			digit3    => (others=>not ACTIVE),
			blank0    => not ACTIVE,
			blank1    => not ACTIVE,
			blank2    => ACTIVE,
			blank3    => ACTIVE,
			sevenSegs => sevenSegs,
			anodes    => anodes
			);
			
	-- Assigning output ports		
	seg <= sevenSegs;
	an  <= anodes;					
					
end LED_Position_BASYS3_ARCH;
