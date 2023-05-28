----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2023 10:22:56
-- Design Name: 
-- Module Name: Compteur_IP - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Compteur_IP is
--  Port ( );
  Port ( enable : in STD_LOGIC ;
        jmp : in STD_LOGIC ;
        CLK : in STD_LOGIC ;
        IP_JMP : in STD_LOGIC_VECTOR(7 downto 0) ;
        IP_Out : out STD_LOGIC_VECTOR(7 downto 0)
          );
end Compteur_IP;

architecture Behavioral of Compteur_IP is

signal aux : integer := 0 ;

begin
    -- IP_Out <= STD_LOGIC_VECTOR(to_unsigned(aux -1, 8)) ;
    IP_Out <= IP_JMP when jmp = '1' else STD_LOGIC_VECTOR(to_unsigned(aux -1, 8)) ;
    
    process
    begin
        wait until CLK'event and CLK='1';
        if enable = '0' then
                aux <= aux + 1 ;
        end if ;
    end process ;

end Behavioral;
