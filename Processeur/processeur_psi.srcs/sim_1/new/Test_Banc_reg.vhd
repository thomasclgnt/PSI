----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 15:08:57
-- Design Name: 
-- Module Name: Test_Banc_Registre - Behavioral
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

entity Test_Banc_reg is
--  Port ( );
end Test_Banc_reg;

architecture Behavioral of Test_Banc_reg is

Component Banc_reg is
        Port ( A : in STD_LOGIC_VECTOR (7 downto 0); --opérande 1
              B : in STD_LOGIC_VECTOR (7 downto 0); --opérande 2
              S : out STD_LOGIC_VECTOR (7 downto 0); --resultat
              Ctr_Alu : in STD_LOGIC_VECTOR (2 downto 0);
              N : out STD_LOGIC; --flag : resultat negatif
              O : out STD_LOGIC; --flag : overflow (plus de 8 bits)
              Z : out STD_LOGIC; --flag : sortie nulle
              C : out STD_LOGIC --flag ! retenue addition ou multiplication
              ) ;
              end Component ;
              
    

begin


end Behavioral;
