----------------------------------------------------------------------------------
--Code by: Zachary Rauen
--Date: 10/6/14
--Last Modified: 1/22/15
--
--
--Version: 1.2
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;	-- add to do arithmetic operations
use IEEE.std_logic_arith.all;		-- add to do arithmetic operations

entity top_level is
    Generic (constant SequenceDisplaySpeed : integer := 1; -- 1 Hz
             constant RefreshSpeed : integer := 1000; -- 1 KHz
             constant sequenceCount : integer := 8;
             constant BoardClock : integer := 100000000;
             constant buttonMax: std_logic_vector(15 downto 0) := X"FFFF";
             constant baud : integer := 9600;
             constant SPIspeed : integer :=250000); -- 1KHz, 1Hz
--    Generic (constant SequenceDisplaySpeed : integer := 1000;
--             constant RefreshSpeed : integer := 100000;
--             constant BoardClock : integer := 100000000;
--             constant sequenceCount : integer := 8;
--             constant buttonMax: std_logic_vector(15 downto 0) := X"0002";
--             constant baud : integer := 2000000;
--             constant SPIspeed : integer :=2000000);
 ----The above lines are used for simulation and chipscope.
    Port ( clk : in std_logic;
           reset : in std_logic;
           reverse : in std_logic;
           enabler : in std_logic;
           DispVector : out std_logic_vector(7 downto 0);
           SegVector : out std_logic_vector(7 downto 0);
           oRx : out std_logic;
           oSCK : out std_logic;
           oSS : out std_logic;
           oMOSI : out std_logic;
           i2c_sda : inout std_logic;
           i2c_scl : inout std_logic);

end top_level;



architecture Behavioral of top_level is

component BoardDisplay is
    Generic (RefreshRate : integer := 1000;
             ClockSpeed : integer := 100000000);
    Port ( ClockState : in std_logic;
           Data : in std_logic_vector(15 downto 0);
           DisplayVector : out std_logic_vector(7 downto 0);
           SegmentVector : out std_logic_vector(7 downto 0));
end component BoardDisplay;

component SequenceController is
    Generic (NumOfSequences : integer := 8;
             DesiredDisplaySpeed : integer := 100000;
             InputClockSpeed : integer := 100000000);
    Port ( ClockState : in std_logic;
           Enabler : in std_logic;
           Reset : in std_logic;
           Reverse : in std_logic;
           MemAddress : out integer := 0);
end component SequenceController;

component Serial_TTL_display is
    Generic (BaudSpeed : integer :=9600;
         Boardspeed : integer :=100000000);
    Port ( Clock : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR (15 downto 0);
           RX : out STD_LOGIC);
end component Serial_TTL_display;

component btn_debounce_toggle is
GENERIC (
	CONSTANT CNTR_MAX : std_logic_vector(15 downto 0) := X"FFFF");  
    Port ( BTN_I 	: in  STD_LOGIC;
           CLK 		: in  STD_LOGIC;
           BTN_O 	: out  STD_LOGIC;
           TOGGLE_O : out  STD_LOGIC);
end component btn_debounce_toggle;

COMPONENT SequenceStorage
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

component SPI_display is
Generic (constant BoardClockSpeed : integer := 100000000;
         constant SCKSpeed : integer := 250000);
    Port ( BoardClock : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR (15 downto 0);
           SCK : out STD_LOGIC;
           SS : out STD_LOGIC;
           MOSI : out STD_LOGIC
           );
end component SPI_display;

component i2c_controller is
    Port ( Clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (15 downto 0);
           oSDA : inout STD_LOGIC;
           oSCL : inout STD_LOGIC);
end component i2c_controller;

signal resetDebounce, enablerToggle, reverseToggle : std_logic;
signal DataFromRom : std_logic_vector(15 downto 0);
signal DataAddress : integer;
signal DataAddressToRom : std_logic_vector(3 downto 0);
signal notReverseToggle : std_logic;
signal high : std_logic := '1';


begin

notReverseToggle <= NOT reverseToggle;
DataAddressToRom <= std_logic_vector(to_unsigned(DataAddress,4));
    
Reset_debounce: btn_debounce_toggle
    generic map (CNTR_MAX => buttonMax) 
    port map (BTN_I=>reset,CLK=>clk,BTN_O=>resetDebounce,TOGGLE_O=>OPEN);
    
Enabler_debounce: btn_debounce_toggle
    generic map (CNTR_MAX => buttonMax) 
    port map (BTN_I=>enabler,CLK=>clk,BTN_O=>OPEN,TOGGLE_O=>enablerToggle);

Reverse_debounce: btn_debounce_toggle
    generic map (CNTR_MAX => buttonMax)
    port map (BTN_I=>reverse,CLK=>clk,BTN_O=>OPEN,TOGGLE_O=>reverseToggle);
    
SequenceControl: SequenceController
    Generic map (NumOfSequences=>sequenceCount,
             DesiredDisplaySpeed=>SequenceDisplaySpeed,
             InputClockSpeed=>BoardClock)
    Port map (ClockState=>clk,
              Enabler=>enablerToggle,
              Reset=>resetDebounce,
              Reverse=> notReverseToggle,
              MemAddress=>DataAddress);
    
BoardController: BoardDisplay
    generic map (RefreshRate=>RefreshSpeed,
                 ClockSpeed=>BoardClock)
    port map ( ClockState=>clk,
               Data=>DataFromRom,
               DisplayVector=>DispVector,
               SegmentVector=>SegVector);

TTL: Serial_TTL_display
generic map (BaudSpeed=>baud,
             Boardspeed=>BoardClock)
Port map ( Clock=>clk,
       Data=>DataFromRom,
       RX=>oRx);
      
MainRom: SequenceStorage
        PORT MAP (
          clka => clk,
          addra => DataAddressToRom,
          douta => DataFromRom
        );
      
SPI: SPI_display
generic map (BoardClockSpeed=>BoardClock,
             SCKSpeed=>SPIspeed)
Port map ( BoardClock=>clk,
           Data=>DataFromRom,
           SCK=>oSCK,
           SS=>oSS,
           MOSI=>oMOSI
          );

I2C: i2c_controller
    Port map ( Clock=>clk,
       dataIn=>DataFromRom,
       oSDA=>i2c_sda,
       oSCL=>i2c_scl);



end Behavioral;
