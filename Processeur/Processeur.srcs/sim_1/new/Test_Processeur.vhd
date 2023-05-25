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
               IP : in STD_LOGIC_VECTOR(7 downto 0)
        );
        
    end component;
    
    signal CLK : STD_LOGIC := '0' ;
    signal RST : STD_LOGIC := '0' ;
    signal IP : STD_LOGIC_VECTOR(7 downto 0) ;
    
begin
    
     uut : Processeur port map (CLK => CLK, RST => RST, IP => IP) ;
     
     -- IP <= "00000001" after 10ns, "00000011" after 100ns, "00000101" after 200ns ; -- afc puis copy
     IP <= "00000110", "00000111" after 100ns;
     RST <= '0' after 10ns, '1' after 100ns;
     
     process
     begin
          CLK <= not CLK;
          wait for 10 ns ;
     end process ;
            
end Behavioral;
