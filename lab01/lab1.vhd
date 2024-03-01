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

entity lab1 is
    port( 
        headRef: in std_logic;     --head ref input
        ref2: in std_logic;         --ref2 input
        ref3: in std_logic;         --ref3 input
        ref4: in std_logic;         --ref4 input
        decision: out std_logic    --decision output
    );
end lab1;

architecture Behavioral of lab1 is
--declaration area

begin
--definition area
decision <= (headRef and ref2)or(headRef and ref4)or(headRef and ref3)
            or(ref2 and ref3 and ref4);    --decision output definition
end Behavioral;
