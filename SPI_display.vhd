----------------------------------------------------------------------------------
--Code by: Zachary Rauen
--Date: 10/30/14
--Last Modified: 11/2/14
--
--Description: This takes in 16 bit data and displays them on an external display
-- using GPIO and SPI communication.
--
--Version: 1.1
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SPI_display is
Generic (constant BoardClockSpeed : integer := 100000000;
         constant SCKSpeed : integer := 250000);
    Port ( BoardClock : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR (15 downto 0);
           SCK : out STD_LOGIC;
           SS : out STD_LOGIC;
           MOSI : out STD_LOGIC
           );
end SPI_display;

architecture Behavioral of SPI_display is

signal clkMax : integer := (BoardClockSpeed/SCKSpeed)-1;
signal clkCnt : integer := 0;
signal StateClock : std_logic :='0';
type state_type is (state0,state1,state2,state3,state4,state5,state6,state7,state8,state9,
state10,state11,state12,state13,state14,state15,state16,state17,state18);
signal currentState : state_type :=state0;
signal nextState : state_type;
signal dataSection : std_logic_vector(7 downto 0);
signal byteChoice: integer :=0;
signal byteMax: integer :=8;
begin

ClkEnable : process(BoardClock)
begin
if rising_edge(BoardClock) then
    if clkCnt = clkMax then
        StateClock <= '1';
        clkCnt <= 0;
    else
        clkCnt<=clkCnt+1;
        StateClock <= '0';
    end if;
end if;
end process ClkEnable;

StateChange: process (BoardClock,StateClock)
begin
if (rising_edge(BoardClock) and StateClock='1') then 
if currentState = state18 then
    if byteChoice = byteMax then
    byteChoice <= byteChoice-3;
    else
    byteChoice<=byteChoice+1;
    end if;
end if;
    currentState <= nextState;
end if;

end process StateChange;

States: process(currentState)
begin
case currentState is
    when state0=>
        SCK<='0';
        SS<='1';
        MOSI<='Z';
        nextState<=state1;
    when state1=>
        SCK<='0';
        SS<='0';
        MOSI<=dataSection(7);
        nextState<=state2;        
    when state2=>
        SCK<='1';
        SS<='0';
        MOSI<=dataSection(7);
        nextState<=state3;  
    when state3=>
       SCK<='0';
       SS<='0';
       MOSI<=dataSection(6);
       nextState<=state4;  
    when state4=>
        SCK<='1';
        SS<='0';
        MOSI<=dataSection(6);
        nextState<=state5;  
    when state5=>
        SCK<='0';
        SS<='0';
        MOSI<=dataSection(5);
        nextState<=state6;
    when state6=>
        SCK<='1';
        SS<='0';
        MOSI<=dataSection(5);
        nextState<=state7;
    when state7=>
        SCK<='0';
        SS<='0';
        MOSI<=dataSection(4);
        nextState<=state8;
    when state8=>
        SCK<='1';
        SS<='0';
        MOSI<=dataSection(4);
        nextState<=state9;
    when state9=>
        SCK<='0';
        SS<='0';
        MOSI<=dataSection(3);
        nextState<=state10;
    when state10=>
        SCK<='1';
        SS<='0';
        MOSI<=dataSection(3);
        nextState<=state11;
    when state11=>
        SCK<='0';
        SS<='0';
        MOSI<=dataSection(2);
        nextState<=state12;
    when state12=>
        SCK<='1';
        SS<='0';
        MOSI<=dataSection(2);
        nextState<=state13;
    when state13=>
        SCK<='0';
        SS<='0';
        MOSI<=dataSection(1);
        nextState<=state14;
    when state14=>
        SCK<='1';
        SS<='0';
        MOSI<=dataSection(1);
        nextState<=state15;
    when state15=>
        SCK<='0';
        SS<='0';
        MOSI<=dataSection(0);
        nextState<=state16;
    when state16=>
        SCK<='1';
        SS<='0';
        MOSI<=dataSection(0);
        nextState<=state17;
    when state17=>
        SCK<='0';
        SS<='0';
        MOSI<=datasection(0);
        nextState<=state18;
    when state18=>
        SCK<='0';
        SS<='1';
        MOSI<='Z';
        nextState<=state1;
end case;

end process States;

ByteSelection: process(byteChoice)
begin
case byteChoice is
   when 0 => dataSection<=x"76";
   when 1 => dataSection<=x"76";
   when 2 => dataSection<=x"76";
   when 3 => dataSection<=x"76";
   when 4 => dataSection<=x"76";
   when 5 => dataSection <=x"0" & Data(15 downto 12);
   when 6 => dataSection <=x"0" & Data(11 downto 8);
   when 7 => dataSection <=x"0" & Data(7 downto 4);
   when 8 => dataSection <=x"0" & Data(3 downto 0);
   when others => dataSection <="11111111";
end case;
end process ByteSelection;

        
end Behavioral;

