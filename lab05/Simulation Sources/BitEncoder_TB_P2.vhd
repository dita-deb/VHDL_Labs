----------------------------------------------------------------------------------
-- Engineer: Anindita Deb
-- Project Name:  BitEncoder Test Bench PART 2
-- Module Name: BitEncoder_TB_P2 - BitEncoder_ARCH_TB_P2
-- 
--
--  This is the second test bench for the bit encoder to shows when signal is specifically 
--  a '1'. It reads the pulses and decides whether the signal is a
--  '0' bit or a '1' bit after going through the state machine. 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BitEncoder_TB_P2 is
--  Port ( );
end BitEncoder_TB_P2;

architecture BitEncoder_TB_P2_ARCH of BitEncoder_TB_P2 is

    --CONSTANTS--
    constant ACTIVE: std_logic := '1';

    --unit-under-test-------------------------------------COMPONENT
    component BitEncoder
        port (
            reset:          in  std_logic;
            clock:          in  std_logic;
            txEn:           in  std_logic;
            dataBit:        in  std_logic;
            txDone:         out std_logic;
            serialOut:      out std_logic
        );
    end component;

    --uut-signals-------------------------------------------SIGNALS
    signal reset:          std_logic;
    signal clock:          std_logic;
    signal txEn:           std_logic;
    signal dataBit:        std_logic;
    signal txDone:         std_logic;
    signal serialOut:      std_logic;

begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: BitEncoder
    port map(
        reset               => reset,
        clock               => clock,
        txEn                =>txEn,       
        dataBit             =>dataBit,
        txDone              =>txDone,  
        serialOut           => serialOut
        );

    SYSTEM_RESET: process
    begin
         reset <= ACTIVE;
         wait for 50 ns;
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

    SIGNAL_DRIVER: process
    begin
    
        txEn <= not ACTIVE;
        dataBit <= not ACTIVE;

        wait until (reset = not ACTIVE);
        wait for 10 ns;

        txEn <= ACTIVE;


        wait for 10 ns;
        txEn <= not ACTIVE;
        wait for 10 ns;
        dataBit <= ACTIVE;  
        
        wait;
    end process;

end BitEncoder_TB_P2_ARCH;
