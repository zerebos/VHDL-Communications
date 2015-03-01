----------------------------------------------------------------------------------
--Code by: Zachary Rauen
--Date: 10/6/14
--Last Modified: 10/16/14
--
--Description: This is a 7 segment display that takes in
-- a 16 bit number and displays it across 4 7 segment displays
--
--Version: 2.3
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BoardDisplay is
    Generic (RefreshRate : integer := 1000;
             ClockSpeed : integer := 100000000);
    Port ( ClockState : in std_logic;
           Data : in std_logic_vector(15 downto 0);
           DisplayVector : out std_logic_vector(7 downto 0);
           SegmentVector : out std_logic_vector(7 downto 0));
end BoardDisplay;

architecture Behavioral of BoardDisplay is


signal vectorSection : std_logic_vector(3 downto 0);
signal segCnt : integer := 0;
signal segCntMax : integer := 3;
signal dispCarry : std_logic_vector(7 downto 0);
signal SegmentEnable : std_logic;
signal clkEnableMax : integer := ClockSpeed/RefreshRate;
signal clkEnCnt : integer := 0;

begin


Refresh: process(ClockState)
begin
if rising_edge(ClockState) then
    if clkEnCnt = clkEnableMax then
        SegmentEnable <= '1';
        clkEnCnt <= 0;
    else
        clkEnCnt<=clkEnCnt+1;
        SegmentEnable <= '0';
    end if;
end if;
if rising_edge(ClockState) AND SegmentEnable = '1' then
    if segCnt = segCntMax then
        segCnt <= 0;
    else
        segCnt <= segCnt + 1;
    end if;
end if;
end process Refresh;

Display: process(ClockState,Data)
begin

case segCnt is
    when 0 => 
    SegmentVector <="11111110";
    vectorSection <=Data(3 downto 0);
    when 1 =>
    SegmentVector <="11111101";
    vectorSection <=Data(7 downto 4);
    when 2 =>
    SegmentVector <="11111011";
    vectorSection <=Data(11 downto 8);
    when 3 =>
    SegmentVector <="11110111";
    vectorSection <=Data(15 downto 12);
    when others =>
    SegmentVector <="11111111";
    vectorSection <="1111";
end case;

end process Display;
with vectorSection select dispCarry <=
    "11111100" when "0000",
    "01100000" when "0001",
    "11011010" when "0010",
    "11110010" when "0011",
    "01100110" when "0100",
    "10110110" when "0101",
    "10111110" when "0110",
    "11100000" when "0111",
    "11111110" when "1000",
    "11110110" when "1001",
    "11101110" when "1010",
    "00111110" when "1011",
    "10011100" when "1100",
    "01111010" when "1101",
    "10011110" when "1110",
    "10001110" when "1111";

DisplayVector<= NOT dispCarry;

end Behavioral;




