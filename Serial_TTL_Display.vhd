----------------------------------------------------------------------------------
--Code by: Zachary Rauen
--Date: 10/28/14
--Last Modified: 11/2/14
--
--Description: This takes in 16 bit data and displays them on an external display
-- using GPIO and serial ttl communication.
--
--Version: 1.3
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Serial_TTL_display is
    Generic (BaudSpeed : integer :=9600;
             Boardspeed : integer :=100000000);
    Port ( Clock : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR (15 downto 0);
           RX : out STD_LOGIC);
end Serial_TTL_display;

architecture Behavioral of Serial_TTL_display is

signal DataSection  :   std_logic_vector(7 downto 0);
type state_type is (bit0,bit1,bit2,bit3,bit4,bit5,bit6,bit7,bit8,bit9);
signal nextState : state_type;
signal currentState : state_type := bit0;
signal bitEnableCnt,ByteChoice : integer:=0;
signal ByteMax : integer :=8;
signal BitEnable : std_logic :='0';
signal BaudClockEnableMax : integer := Boardspeed/BaudSpeed-1;

begin

BitEnabler: process(Clock)
begin
if rising_edge(Clock) then
    if bitEnableCnt = BaudClockEnableMax then
        BitEnable <= '1';
        bitEnableCnt <= 0;
    else
        bitEnableCnt<=bitEnableCnt+1;
        BitEnable <= '0';
    end if;
end if;
end process BitEnabler;




StateChange: process (Clock,BitEnable)
begin
if (rising_edge(Clock) and BitEnable='1') then
    if currentState = bit9 then
        if ByteChoice = ByteMax then
        ByteChoice <= Bytechoice-3;
        else
        ByteChoice<=ByteChoice+1;
        end if;
    end if;
    
    currentState <= nextState;
end if;

end process StateChange;



States: process(currentState)
begin
case currentState is
    when bit0=>
        RX<='0';
        nextState<=bit1;
    when bit1=>
        RX<=DataSection(0);
        nextState<=bit2;
    when bit2=>
        RX<=DataSection(1);
        nextState<=bit3;
    when bit3=>
        RX<=DataSection(2);
        nextState<=bit4;
    when bit4=>
        RX<=DataSection(3);
        nextState<=bit5;
    when bit5=>
        RX<=DataSection(4);
        nextState<=bit6;
    when bit6=>
        RX<=DataSection(5);
        nextState<=bit7;
    when bit7=>
        RX<=DataSection(6);
        nextState<=bit8;
    when bit8=>
        RX<=DataSection(7);
        nextState<=bit9;
    when bit9=>
        RX<='1';
        nextState<=bit0;
end case;



case ByteChoice is
    when 0 => DataSection<=x"76";
    when 1 => DataSection<=x"76";
    when 2 => DataSection<=x"76";
    when 3 => DataSection<=x"76";
    when 4 => DataSection<=x"76";
--    when 5 => DataSection<=x"7A";
--    when 6 => DataSection<=std_logic_vector(to_unsigned(0, 8));
--    when 6 => DataSection<=x"79";
--    when 7 => DataSection<=std_logic_vector(to_unsigned(0, 8));
    when 5 => DataSection <=x"0" & Data(15 downto 12);
    when 6 => DataSection <=x"0" & Data(11 downto 8);
    when 7 => DataSection <=x"0" & Data(7 downto 4);
    when 8 => DataSection <=x"0" & Data(3 downto 0);
    when others => DataSection <="11111111";
end case;
end process States;

end Behavioral;
