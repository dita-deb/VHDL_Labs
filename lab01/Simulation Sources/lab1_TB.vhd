----------------------------------------------------------------------------------
-- CPE3020
-- Anindita Deb 
-- 
-- Create Date: 01/24/2023 08:21:37 AM
-- Design Name: lab1
-- Module Name: lab1 - Behavioral
-- Project Name: lab1
-- Target Devices: none
-- Description: The purpose of this lab is to create a project file and it's design source
-- file in vivado. The lab focuses on making a boolean equation from the given problem.
-- When four refs make a vote on a call, majority wins;
-- however, when votes are tied head ref's vote takes prioritity.
-- 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lab1_TB is
end lab1_TB;

architecture lab1_TB_ARCH of lab1_TB is
    constant ACTIVE: std_logic := '1';
    --unit-under-test---------------------COMPONENT-----------
    component lab1
        port(
            headRef: in std_logic;     --head ref input
            ref2: in std_logic;         --ref2 input
            ref3: in std_logic;         --ref3 input
            ref4: in std_logic;         --ref4 input
            decision: out std_logic    --decision output
        );
    end component;
    ----uut-signals-----------------------SIGNALS------------- 
    signal headRef: std_logic;
    signal ref2: std_logic;
    signal ref3: std_logic;
    signal ref4: std_logic;
    signal decision: std_logic;

begin
    --Unit-Under-Test----------------------UUT-----------------
    UUT: lab1 port map(
        headref => headref,
        ref2 => ref2,
        ref3 => ref3,
        ref4 => ref4,
        decision => decision
    );
    --Switch Driver-----------------------PROCESS--------------
    Switch_Driver: process
        begin
            --input values:
            --0000 
            headref <= '0';
            ref2 <= '0';
            ref3 <= '0';
            ref4 <= '0';
            wait for 20 ns;
            ---0001
            headref <= '0';
            ref2 <= '0';
            ref3 <= '0';
            ref4 <= '1';
            wait for 20 ns;
            ---0010
            headref <= '0';
            ref2 <= '0';
            ref3 <= '1';
            ref4 <= '0';
            wait for 20 ns;
            ---0011
            headref <= '0';
            ref2 <= '0';
            ref3 <= '1';
            ref4 <= '1';
            wait for 20 ns;
            ---0100
            headref <= '0';
            ref2 <= '1';
            ref3 <= '0';
            ref4 <= '0';
            wait for 20 ns;
            ---0101
            headref <= '0';
            ref2 <= '1';
            ref3 <= '0';
            ref4 <= '1';
            wait for 20 ns;
            ---0110
            headref <= '0';
            ref2 <= '1';
            ref3 <= '1';
            ref4 <= '0';
            wait for 20 ns;
            ---0111
            headref <= '0';
            ref2 <= '1';
            ref3 <= '1';
            ref4 <= '1';
            wait for 20 ns;
            ---1000
            headref <= '1';
            ref2 <= '0';
            ref3 <= '0';
            ref4 <= '0';
            wait for 20 ns;
            ---1001
            headref <= '1';
            ref2 <= '0';
            ref3 <= '0';
            ref4 <= '1';
            wait for 20 ns;
            ---1010        
            headref <= '1';
            ref2 <= '0';
            ref3 <= '1';
            ref4 <= '0';
            wait for 20 ns;    
            ---1011
            headref <= '1';
            ref2 <= '0';
            ref3 <= '1';
            ref4 <= '1';
            wait for 20 ns;
            ---1100
            headref <= '1';
            ref2 <= '1';
            ref3 <= '0';
            ref4 <= '0';
            wait for 20 ns;
            ---1101
            headref <= '1';
            ref2 <= '1';
            ref3 <= '0';
            ref4 <= '1';
            wait for 20 ns;
            ---1110
            headref <= '1';
            ref2 <= '1';
            ref3 <= '1';
            ref4 <= '0';
            wait for 20 ns;
            ---1111        
            headref <= '1';
            ref2 <= '1';
            ref3 <= '1';
            ref4 <= '1';
            wait;
    end process;
    
end lab1_TB_ARCH;
