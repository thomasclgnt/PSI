----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 12:16:52
-- Design Name: 
-- Module Name: Test_InstrMem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_Instruction_Memory is
--  Port ( );
end Test_Instruction_Memory;

architecture Behavioral of Test_Instruction_Memory is
    component Instruction_Memory is
    Port (addr : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           OUT_instr : out STD_LOGIC_VECTOR (31 downto 0));
    end component ;
signal addr : STD_LOGIC_VECTOR (7 downto 0);
signal CLK : STD_LOGIC := '0';
signal OUT_instr : STD_LOGIC_VECTOR (31 downto 0) ;

begin

    uut : Instruction_Memory port map (addr => addr, CLK => CLK, OUT_instr => OUT_instr) ;

    process
    begin
        CLK <= not CLK;
        wait for 10 ns ;
    end process ;

    addr <= "00000001";
  
end Behavioral;
