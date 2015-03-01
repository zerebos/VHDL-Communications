-- Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2014.4 (win32) Build 1071353 Tue Nov 18 18:06:20 MST 2014
-- Date        : Wed Jan 21 16:06:49 2015
-- Host        : ul-win7-12 running 32-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/ulab/Downloads/Lab_Project1.xpr/Lab_Project1/Lab_Project1.srcs/sources_1/ip/SequenceStorage/SequenceStorage_stub.vhdl
-- Design      : SequenceStorage
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SequenceStorage is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 3 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );

end SequenceStorage;

architecture stub of SequenceStorage is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[3:0],douta[15:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_2,Vivado 2014.4";
begin
end;
