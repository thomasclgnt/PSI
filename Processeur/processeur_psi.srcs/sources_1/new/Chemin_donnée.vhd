----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.05.2023 19:53:59
-- Design Name: 
-- Module Name: Processeur - Behavioral
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

entity Processeur is
    Port ( CLK : in STD_LOGIC);
end Processeur;


architecture Behavioral of Processeur is

    component Banc_registre is
        Port ( addrA : in STD_LOGIC_VECTOR (3 downto 0);
                  addrB : in STD_LOGIC_VECTOR (3 downto 0);
                  addrW : in STD_LOGIC_VECTOR (3 downto 0);
                  W : in STD_LOGIC;
                  Data : in STD_LOGIC_VECTOR (7 downto 0);
                  RST : in STD_LOGIC;
                  CLK : in STD_LOGIC ;
                  QA : out STD_LOGIC_VECTOR (7 downto 0);
                  QB : out STD_LOGIC_VECTOR (7 downto 0)
                  );
    end component ;
    
    component ALU is
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
     
     component data_memory is
        
     end component ;

begin


end Behavioral;
