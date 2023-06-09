----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.05.2023 10:33:06
-- Design Name: 
-- Module Name: Test_Processeur - Behavioral
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

entity Test_Processeur is
--  Port ( );
end Test_Processeur;

architecture Behavioral of Test_Processeur is
    component Processeur is
    
        Port ( CLK : in STD_LOGIC ;
               RST : in STD_LOGIC ;
               sortie : out STD_LOGIC_VECTOR (7 downto 0)
        );
        
    end component;
    
    signal CLK : STD_LOGIC := '0' ;
    signal RST : STD_LOGIC := '0' ;
    signal sortie : STD_LOGIC_VECTOR (7 downto 0) := "00000000" ;
    
begin
    
     uut : Processeur port map (CLK => CLK, RST => RST, sortie => sortie) ;
     
     -- IP <= "00000001" after 10ns, "00000011" after 100ns, "00000101" after 200ns ; -- afc puis copy

     RST <= '0' after 10ns, '1' after 100ns;
     
     process
     begin
          CLK <= not CLK;
          wait for 10 ns ;
     end process ;
            
end Behavioral;
