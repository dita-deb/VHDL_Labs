----------------------------------------------------------------------------------
-- Engineer: Anindita Deb 
-- 
-- Create Date: 04/17/2023 02:51:39 PM
-- Design Name: 
-- Module Name: ColorDriver - ColorDriver_ARCH
-- Description: 
-- This component will drive a stream of 24 bits representing a specific color. These
-- pulses will appear on the output when triggered by an enable pulse on of the inputs.
--
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity ColorDriver is
 Port (
    txColorEn: in std_logic;                              --Color is enabled
    txColor: in std_logic_vector(23 downto 0);            --24 Bits of Color     
    txColorDone: out std_logic;                           --Color is done transferring
    serialOut: out std_logic;
    clock: in std_logic;
    reset: in std_logic
    );
end ColorDriver;

architecture ColorDriver_ARCH of ColorDriver is

    ----general definitions----------------------------------------------CONSTANTS
    constant ACTIVE: std_logic := '1';
    constant TIME_BETWEEN_PULSES: positive := 400;       -- In Ns
    constant CLOCK_FREQUENCY:     positive := 1000000000; -- In Ns
    constant PULSE_COUNT_TIME:    integer  := (CLOCK_FREQUENCY/((10**9/TIME_BETWEEN_PULSES)-1));
    constant BIT_NUM:             integer  := 24;
    
----state-machine-declarations---------------------------------SIGNALS
    type States_t is (wAIT_FOR_TX, START_TX, BIT_ENCODER_EN, NEXT_COLOR_BIT, WAIT_BIT_DONE);
    signal currentState: States_t;
    signal nextState: States_t;
    
     --SIGNALS--   
    signal pulse: std_logic;
    signal goNextState: std_logic;
    --INTERNAL SIGNALS--
    signal loadReg: std_logic;
    signal shift: std_logic;
    signal txBitData: std_logic;
    signal txBitDone: std_logic;
    signal lastBit: std_logic;
    signal txBitEn: std_logic;
--===========================================================================================
 --COMPONENT BIT_ENCODER
--===========================================================================================

component BitEncoder
    port( 
       reset:       in std_logic;
       clock:       in std_logic;
       txEn:        in std_logic;  --transmit enable
       dataBit:     in std_logic;
       txDone:      out std_logic;   --transmit done
       serialOut:   out std_logic
  
  );
end component;
--===========================================================================================
  
    
begin
 
 MY_ENCODER: BitEncoder port map (
 
         reset => reset,
         clock => clock,
         txEn => txBitEn,
         dataBit => txBitData,
         txDone => txBitDone,
         serialOut => serialOut
 );
  
 
 --signal assignments
 txColorDone <= lastBit and txBitDone;
 shift <= txBitEn and txBitDone and (not lastBit);  
 loadReg <= txColorEn and txBitEn;
 
--===========================================================================================
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
--===========================================================================================
      --Bit Generator                                                           Process
--===========================================================================================
        BIT_GENERATOR: process(reset, clock)
            variable count: natural range 0 to (BIT_NUM-1);
            begin
                if (reset = ACTIVE) then
                    count := 0;
                    txColorDone <= lastBit and txBitDone;
                    
                    txBitEn <= not ACTIVE;
                    txBitData <= not ACTIVE;
                    txBitDone<= not ACTIVE;
                    lastBit <= not ACTIVE;
                    
                    shift <= txBitEn and txBitDone and (not lastBit); 
                    loadReg <= txColorEn and txBitEn;
                    
                elsif (rising_edge(clock)) then
                    if (BIT_NUM /= 23) then
                        count := count +1;
                        txColorDone <= lastBit and txBitDone;
                    
                        txBitEn <= ACTIVE;
                        txBitData <= ACTIVE;
                        txBitDone<= ACTIVE;
                        lastBit <= not ACTIVE;
                    
                        shift <= txBitEn and txBitDone and (not lastBit); 
                        loadReg <= txColorEn and txBitEn;
                    
                     else 
                    txColorDone <= lastBit and txBitDone;
                    
                    txBitEn <= not ACTIVE;
                    txBitData <= not ACTIVE;
                    txBitDone<= ACTIVE;
                    lastBit <= ACTIVE;
                    
                    shift <= txBitEn and txBitDone and (not lastBit); 
                    loadReg <= txColorEn and (not txBitData) and lastBit;
                       
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
 STATE_TRANSITION: process(currentState, txColor, txColorEn, txBitData, txBitEn, 
                           txBitDone, loadReg, shift)                       
 begin

 shift <= not Active;   
     case CurrentState is
        ---------------------------------------------------------WAIT_FOR_TX
         when WAIT_FOR_TX =>
               loadReg <= not ACTIVE;
               shift <= '0';
               txBitEn <= not ACTIVE;
             if (txColorEn = ACTIVE) then
                nextState <= START_TX;
                serialOut <= not ACTIVE;
                shift <='0';
             else
                nextState <= currentState;
                serialOut <= not ACTIVE;
                txColorDone <= ACTIVE;
             end if; 
         
         ---------------------------------------------------------START_TX
          when START_TX =>
              loadReg <= ACTIVE;
              shift <= '0';
              nextState <= BIT_ENCODER_EN;              
         
         ---------------------------------------------------------BIT_ENCODER_EN
          when BIT_ENCODER_EN =>
              txBitEn <= ACTIVE;
              loadReg <= not ACTIVE;
              shift <= '1'; 
              if (txBitDone = ACTIVE) then
                nextState <= NEXT_COLOR_BIT;
              else
                nextState <= currentState;
              end if;
              
         ---------------------------------------------------------NEXT_COLOR_BIT
          when NEXT_COLOR_BIT =>
               shift <= '1';
              if (lastBit <=not ACTIVE) then           
                nextState <= WAIT_BIT_DONE;
                shift<='0';
              else
                nextState <= currentState;
              end if;   
              
              
         ---------------------------------------------------------WAIT_BIT_DONE       
          when WAIT_BIT_DONE =>
              shift<='0';
             if (txColorEn <= ACTIVE) then
                 nextState <= START_TX;
             elsif (txColorEn <= not ACTIVE)then
                 nextState <= WAIT_FOR_TX;
                 txColorDone <= ACTIVE;
                 
             else 
             nextState <= currentState;
             end if;
    end case;
 end process;

end ColorDriver_ARCH;
