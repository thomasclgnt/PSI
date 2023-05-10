----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2023 14:01:44
-- Design Name: 
-- Module Name: Test_ALU - Behavioral
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

entity Test_ALU is
--  Port ( );
end Test_ALU;

architecture Behavioral of Test_ALU is

    Component Alu is
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
              
    signal A :  STD_LOGIC_VECTOR (7 downto 0);
    signal B : STD_LOGIC_VECTOR (7 downto 0);
    signal S : STD_LOGIC_VECTOR (7 downto 0);
    signal Ctr_Alu : STD_LOGIC_VECTOR (2 downto 0);
    signal N : STD_LOGIC;
    signal O : STD_LOGIC;
    signal Z: STD_LOGIC;
    signal C : STD_LOGIC;

begin
    
    uut: Alu port map (A=>A, B=>B, S=>S, Ctr_Alu=>Ctr_Alu, N=>N, O=>O, Z=>Z, C=>C);
    
    A <= "00000010";
    B <= "00000001";
    Ctr_Alu<="000"; --addition test
    

end Behavioral;
