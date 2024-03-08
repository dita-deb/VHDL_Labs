----------------------------------------------------------------------------------
-- Engineer: Anindita Deb
-- Create Date: 03/28/2023 08:51:29 AM
-- Project Name:  Lab5_BitEncoder
-- Module Name: BitEncoder - BitEncoder_ARCH
-- 
--
--  This is a bit encoder that reads the pulses and decides whether the signal is a
--  '0' bit or a '1' bit after going through the state machine. 
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BitEncoder is
  port ( 
       reset: in std_logic;
       clock: in std_logic;
       txEn: in std_logic;  --transmit enable
       dataBit: in std_logic;
       txDone:     out std_logic;   --transmit done
       serialOut: out std_logic
  
  );
end BitEncoder;

--========================================================ARCHITECTURE
-- ARCHECTURE DECLARATIONS AND DEFINITIONS
--===================================================================

architecture BitEncoder_ARCH of BitEncoder is

    ----general definitions----------------------------------------------CONSTANTS
    constant ACTIVE: std_logic := '1';
    constant TIME_BETWEEN_PULSES: positive := 400;       -- In Ns
    constant CLOCK_FREQUENCY:     positive := 1000000000; -- In Ns
    constant PULSE_COUNT_TIME:    integer := (CLOCK_FREQUENCY/((10**9/TIME_BETWEEN_PULSES)-1));
    
----state-machine-declarations---------------------------------SIGNALS
    type States_t is (WAIT_FOR_TX, T400NS, T800NS_0, T800NS_1, T1200NS);
    signal currentState: States_t;
    signal nextState: States_t;
    
     --SIGNALS--   
    signal pulse: std_logic;
    signal phaseDone: std_logic;
    signal goNextState: std_logic;
--    signal txDone: std_logic;

begin

--===================================================================================
        -- Pulse Generator                                                            PROCESS
        --===================================================================================
        PULSE_GENERATOR: process(reset, clock)
            variable count: natural range 0 to PULSE_COUNT_TIME;
            begin
                if (reset = ACTIVE) then
                    count := 0;
                    goNextState <= not ACTIVE;
                elsif (rising_edge(clock)) then
                    if (nextState /= WAIT_FOR_TX) then
                        if (count = PULSE_COUNT_TIME) then
                            count := 0;
                            goNextState <= ACTIVE;
                        else
                            count := count + 1;
                            goNextState <= not ACTIVE; 
                        end if;
                    else
                        count := 0; 
                    end if;         
                end if;
            end process;

 --=============================================================PROCESS
-- State register
 --====================================================================
 STATE_REGISTER: process(reset, clock)
     begin
         if (reset=ACTIVE) then
             currentState <= WAIT_FOR_TX;
         elsif (rising_edge(clock)) then
             currentState <= nextState;
         end if;
      end process;

 --=============================================================PROCESS
 -- State transitions
 --====================================================================
 STATE_TRANSITION: process(currentState, txEn, phaseDone, pulse)
    variable stxEn: std_logic;
 begin
    case CurrentState is
        ---------------------------------------------------------WAIT_FOR_TX
         when WAIT_FOR_TX =>
             pulse <= '0';
             serialOut <= not ACTIVE;
             txDone <= not ACTIVE;
--             stxEn:= txEn;
             if (txEn = ACTIVE) then
                nextState <= T400NS;
                phaseDone <= ACTIVE;
                serialOut <= not ACTIVE;
             else
                nextState <= currentState;
                phaseDone <= not ACTIVE;
             end if; 
             
         ---------------------------------------------------------T400NS
          when T400NS =>
              txDone <= not ACTIVE;
              pulse <= '1'; 
              phaseDone <= not ACTIVE;  
              if (databit = ACTIVE) then
                serialOut <= ACTIVE;
                nextState <= T800NS_1;
                phaseDone <= ACTIVE;
              elsif (databit = not ACTIVE) then 
                nextState <= T800NS_0;
                phaseDone <= ACTIVE;
                serialOut <= ACTIVE;                
              else
                nextState <= currentState;
                phaseDone <= not ACTIVE;
              end if;
              
         ---------------------------------------------------------T800NS_1
          when T800NS_1 =>
             pulse <= ACTIVE; 
             phaseDone <= not ACTIVE; 
             stxEn := not ACTIVE; 
              if (databit = ACTIVE) then
                serialOut <= ACTIVE;
                nextState <= T1200NS;
                phaseDone <= ACTIVE;
              else
                nextState <= currentState;
                phaseDone <= not ACTIVE;
              end if;
              
              
         ---------------------------------------------------------T800NS_0
          when T800NS_0 =>
             pulse <= '0'; 
             phaseDone <= not ACTIVE;  
             stxEn := ACTIVE;
              if (stxEn = ACTIVE) then
                serialOut <= not ACTIVE;              
                nextState <= T1200NS;
                phaseDone <= ACTIVE;
              else
                nextState <= currentState;
                phaseDone <= not ACTIVE;
              end if;   
              
              
         ---------------------------------------------------------T1200NS       
          when T1200NS =>
             pulse <='0';
             serialOut <= not ACTIVE;
             phaseDone <= not ACTIVE;
             txDone <= ACTIVE;
             if (txEn <= ACTIVE) then
                 nextState <= T400NS;
                 phaseDone <= ACTIVE;
             elsif ((phaseDone <= not ACTIVE) and (txEn <= not ACTIVE)) then
                 nextState <= WAIT_FOR_TX;
             else 
                 nextState <= currentState;
             end if;
    end case;
 end process;
                   
                
                       

end BitEncoder_ARCH;
