----------------------------------------------------------------------------------
-- Engineer: Anindita Deb
-- CPE3020
-- Professor Scott Tippens
--
-- Create Date: 02/20/2023 08:55:38 PM
--
-- Module Name: ColorConvert
--
-- This program converts a 7 bit binary ASCII value input(representing the letters roygbivwk) to two different values,
-- the first being a 24 bit led value that will represent the 24 bit color format,
-- and the second being a seven segment value that can be used to drive the
-- seven segment display.
--
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ColorConvert is
    Port (
        currentChar: in std_logic_vector(6 downto 0); --Character ASCII Input
        color: out std_logic_vector(23 downto 0); --24 bit LED output
        seg: out std_logic_vector(6 downto 0) --seven segment display value

        );
end ColorConvert;

architecture ColorConvert_ARCH of ColorConvert is

    --**************************************************************
    -- Character List: r=red, o=orange, y=yellow, g=green, b=blue
    -- i=indigo, v=violet, h=white, k=black(off)
    --**************************************************************
    -------------------------------------------------CHARACTER CONSTANTS
    constant CHAR_R: std_logic_vector(6 downto 0) := "1110010";    -- character for red
    constant CHAR_O: std_logic_vector(6 downto 0) := "1101111";    -- charcter for orange
    constant CHAR_Y: std_logic_vector(6 downto 0) := "1111001";    -- charcter for yellow
    constant CHAR_G: std_logic_vector(6 downto 0) := "1100111";    -- charcter for green
    constant CHAR_B: std_logic_vector(6 downto 0) := "1100010";    -- charcter for blue
    constant CHAR_I: std_logic_vector(6 downto 0) := "1101001";    -- charcter for indigo
    constant CHAR_V: std_logic_vector(6 downto 0) := "1110110";    -- charcter for violet
    constant CHAR_H: std_logic_vector(6 downto 0) := "1110111";    -- charcter for white
    constant CHAR_K: std_logic_vector(6 downto 0) := "1101011";    -- charcter for black(off)

    ---------------------------------------------------LED CONSTANTS
    constant RED:       std_logic_vector(23 downto 0) := "111111110000000000000000";    --24 bit value for red
    constant ORANGE:    std_logic_vector(23 downto 0) := "111111111000000000000000";    --24 bit value for orange
    constant YELLOW:    std_logic_vector(23 downto 0) := "111111111111111100000000";    --24 bit value for yellow 
    constant GREEN:     std_logic_vector(23 downto 0) := "000000001111111100000000";    --24 bit value for green
    constant BLUE:      std_logic_vector(23 downto 0) := "000000000000000011111111";    --24 bit value for blue
    constant INDIGO:    std_logic_vector(23 downto 0) := "001100110000000001100110";    --24 bit value for indigo
    constant VIOLET:    std_logic_vector(23 downto 0) := "011001100000000001100110";    --24 bit value for violet
    constant WHITE:     std_logic_vector(23 downto 0) := "111111111111111111111111";    --24 bit value for white
    constant BLACK:     std_logic_vector(23 downto 0) := "000000000000000000000000";    --24 bit value for black
    


    -----------------------------------------------------SIGNALS
    signal myColor: std_logic_vector(23 downto 0);
    signal sevenSegs: std_logic_vector(6 downto 0); --7 bit seven segment output
    -----------------------------------------------------

begin

    -------------------------------------------------------------------------------
    --This selected signal assignment assigns all required ASCII values to their
    --corresponding 24 bit RGB value
    -------------------------------------------------------------------------------
    
    with currentChar select
        myColor <=       RED when CHAR_R,       --ASCII value for r, 24 bit color value for red
                         ORANGE when CHAR_O,    --ASCII value for o, 24 bit color value for orange
                         YELLOW when CHAR_Y,    --ASCII value for y, 24 bit color value for yellow
                         GREEN when CHAR_G,     --ASCII value for g, 24 bit color value for green
                         BLUE when CHAR_B,      --ASCII value for b, 24 bit color value for blue
                         INDIGO when CHAR_I,    --ASCII value for i, 24 bit color value for indigo
                         VIOLET when CHAR_V,    --ASCII value for v, 24 bit color value for violet
                         WHITE when CHAR_H,     --ASCII value for w, 24 bit color value for white
                         BLACK when others;     --ASCII value for k, 24 bit color value for black
                       
    --------------------------------------------------------------------------------
    --This selected signal assignment converts all required ASCII values to
    --their corresponding seven segment values
    --------------------------------------------------------------------------------
                
    with currentChar select
    sevenSegs <= "0101111" when CHAR_R, --ASCII value for r, 7 segment value for r
                 "0100011" when CHAR_O, --ASCII value for o, 7 segment value for o
                 "0010001" when CHAR_Y, --ASCII value for y, 7 segment value for y
                 "0010000" when CHAR_G, --ASCII value for g, 7 segment value for g
                 "0000011" when CHAR_B, --ASCII value for b, 7 segment value for b
                 "1111001" when CHAR_I, --ASCII value for i, 7 segment value for i
                 "1100011" when CHAR_V, --ASCII value for v, 7 segment value for v
                 "0001011" when CHAR_H, --ASCII value for w, 7 segment value for w
                 "0001001" when others; --ASCII value for k, 7 segment value for k
                 
    ---------------------------------------------------------------------------------
    --Signal routing
    ---------------------------------------------------------------------------------
    color <= myColor;
    seg <= sevenSegs;
                 
end ColorConvert_ARCH;
