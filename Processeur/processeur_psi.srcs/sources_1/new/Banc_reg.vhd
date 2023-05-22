----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 13:23:55
-- Design Name: 
-- Module Name: Banc_registre - Behavioral
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

entity Banc_reg is
    Port ( addrA : in STD_LOGIC_VECTOR (3 downto 0);
           addrB : in STD_LOGIC_VECTOR (3 downto 0);
           addrW : in STD_LOGIC_VECTOR (3 downto 0);
           W : in STD_LOGIC;
           Data : in STD_LOGIC_VECTOR (7 downto 0);
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (7 downto 0);
           QB : out STD_LOGIC_VECTOR (7 downto 0));
end Banc_reg;

architecture Behavioral of Banc_reg is

--Declaration des signaux
type tab is array(0 to 15) of STD_LOGIC_VECTOR(7 downto 0) ;
signal registre : tab ;

begin

    process
    
    begin
        wait until CLK'event and CLK='1' ;
        
        if RST = '0' then
        -- initialiser le contenu du banc de registre à 0x00
            registre(0 to 15) <= (others => (others => '0'));
        end if ;
        
        QA <= registre(to_integer(unsigned(addrA))) ;
        QB <= registre(to_integer(unsigned(addrB))) ;
    
        if W = '1' then
            if addrW = addrA then
            -- protection si essai de lecture / écriture sur le même registre A
                registre(to_integer(unsigned(addrA))) <= Data ;
                QA <= Data ;
            elsif addrW = addrB then
            -- protection si essai de lecture / écriture sur le même registre B
                registre(to_integer(unsigned(addrB))) <= Data ;
                QB <= Data ;
            else
            -- écriture sur un registre différent
                registre(to_integer(unsigned(addrW))) <= Data ;
                
            end if ;
             
        end if ;
        
        
    end process ;

end Behavioral;