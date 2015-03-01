----------------------------------------------------------------------------------
--Code by: Zachary Rauen
--Date: 10/6/14
--Last Modified: 11/2/14
--
--Description: This is a sequence controller that uses three buttons as
-- reset, reverse and a system enable. Using the clock this sytem will 
-- generate an address for a ROM. However, this can be easily
-- modified in order to create what is needed
--
--Version: 2.1
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SequenceController is
    Generic (NumOfSequences : integer := 8;
             DesiredDisplaySpeed : integer := 100000;
             InputClockSpeed : integer := 100000000);
    Port ( ClockState : in std_logic;
           Enabler : in std_logic;
           Reset : in std_logic;
           Reverse : in std_logic;
           MemAddress : out integer := 0);
end SequenceController;

architecture Behavioral of SequenceController is

signal clkMax : integer := InputClockSpeed/DesiredDisplaySpeed;
signal clkCnt : integer := 0;
signal displayCnt : integer := 0;
signal StateEnable : std_logic;



begin

DisplaySpeed: process(ClockState)
begin
if rising_edge(ClockState) then
    if Reset <= '0' then
        if clkCnt = clkMax then
            StateEnable <= '1';
            clkCnt <= 0;
        else
            clkCnt<=clkCnt+1;
            StateEnable <= '0';
        end if;
    else
    clkCnt<=0;
    end if;
end if;

end process DisplaySpeed;


count: process(ClockState,StateEnable,Enabler,Reverse,Reset)
begin
        if Reset='1' then
            displayCnt <= 0;
        else
        if Enabler = '1' then
            if rising_edge(ClockState) AND StateEnable = '1' then
                   if Reverse = '0' then
                        if displayCnt = NumOfSequences then
                            displayCnt <= 0;
                        else
                            displayCnt <= displayCnt + 1;
                        end if;
                    else 
                        if displayCnt = 0 then
                            displayCnt <= NumOfSequences;
                        else
                            displayCnt <= displayCnt - 1;
                        end if;
                    end if;
            end if;
        end if;
    end if;
MemAddress<=displayCnt;

end process count;


end Behavioral;
