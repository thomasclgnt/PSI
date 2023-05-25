----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2023 10:27:35
-- Design Name: 
-- Module Name: Test_Compteur_IP - Behavioral
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

entity Test_Compteur_IP is

end Test_Compteur_IP;

architecture Behavioral of Test_Compteur_IP is

 component Compteur_IP is
           Port ( CLK : in STD_LOGIC;
           IP_Out : out STD_LOGIC_VECTOR (7 downto 0)
           );
    end component ;
    
signal CLK : STD_LOGIC := '0' ;
signal IP_Out : STD_LOGIC_VECTOR (7 downto 0) ;

begin
    
     uut : Compteur_IP port map (CLK => CLK, IP_Out => IP_Out) ;
     
     process
         begin
             CLK <= not CLK;
             wait for 10 ns ;
         
         end process ;


end Behavioral;
