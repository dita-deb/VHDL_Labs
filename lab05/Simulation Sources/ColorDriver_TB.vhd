----------------------------------------------------------------------------------
-- 
-- Create Date: 04/17/2023 04:58:03 PM
-- Engineer Name: Anindita 
-- Module Name: ColorDriver_TB - ColorDriver_TB_ARCH
-- Project Name: 
-- Target Devices: 

-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity ColorDriver_TB is
--  Port ( );
end ColorDriver_TB;

architecture ColorDriver_TB_ARCH of ColorDriver_TB is

component ColorDriver is
 Port (
    txColorEn:      in std_logic;                              --Color is enabled
    txColor:        in std_logic_vector(23 downto 0);            --24 Bits of Color     
    txColorDone:    out std_logic;                           --Color is done transferring
    serialOut:      out std_logic;
    clock:          in std_logic;
    reset:          in std_logic
    );
end component;
--CONSTANTS--
    constant ACTIVE: std_logic := '1';
--UUT SIGNALS--
    signal txColorEn:       std_logic;                              --Color is enabled
    signal txColor:         std_logic_vector(23 downto 0);            --24 Bits of Color     
    signal txColorDone:     std_logic;                           --Color is done transferring
    signal serialOut:       std_logic;
    signal clock:           std_logic;
    signal reset:           std_logic;    

begin

 --Unit-Under-Test-------------------------------------------UUT
    UUT: ColorDriver
     Port map (
            txColorEn   =>      txColorEn, 
            txColor     =>      txColor,        
            txColorDone =>      txColorDone,
            serialOut   =>      serialOut,
            clock       =>      clock, 
            reset       =>      reset  
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

        txColorEn <= ACTIVE;

--        wait for 10 ns;
--        txColor <= "111111110000000000000000";
        for i in 0 to (2 ** (txColor'length - 1)) loop
          txColor <= std_logic_vector(TO_UNSIGNED(i, txColor'length));
          wait for 1 ns;
        end loop;
       
--        wait for 100 ns;
--        txColor <= "000000001111111100000000";
--        wait for 100 ns;
--        txColor <= "000000000000000011111111";

        wait until (reset = not ACTIVE);
        
        wait for 10 ns;
        
        txColorEn <= not ACTIVE;

        wait;
    end process;

end ColorDriver_TB_ARCH;
