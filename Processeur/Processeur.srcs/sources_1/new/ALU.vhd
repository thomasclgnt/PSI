----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.05.2023 12:58:32
-- Design Name: 
-- Module Name: ALU - Behavioral
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


library IEEE, STD;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Déclaration des entity
entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0); --opérande 1
           B : in STD_LOGIC_VECTOR (7 downto 0); --opérande 2
           S : out STD_LOGIC_VECTOR (7 downto 0); --resultat
           Ctr_Alu : in STD_LOGIC_VECTOR (2 downto 0);
           N : out STD_LOGIC; --flag : resultat negatif
           O : out STD_LOGIC; --flag : overflow (plus de 8 bits)
           Z : out STD_LOGIC; --flag : sortie nulle
           C : out STD_LOGIC); --flag ! retenue addition
end ALU;

architecture Behavioral of ALU is
--Déclaration des composants

--Declaration des signaux
signal aux_add : STD_LOGIC_VECTOR(8 downto 0);
signal aux_sous : STD_LOGIC_VECTOR(7 downto 0);
signal aux_mul : STD_LOGIC_VECTOR(15 downto 0);

signal res : STD_LOGIC_VECTOR(7 DOWNTO 0) ;

begin
    
    aux_add <= ('0' & A) + ('0' & B) ;
    aux_sous <= A - B ; 
    aux_mul <= A*B;
    
    
    res <=  aux_add(7 downto 0) when Ctr_Alu = "000" else -- addition
            aux_sous when Ctr_Alu = "001" else -- soustraction
            aux_mul(7 downto 0) when Ctr_Alu = "010" else
            "00000000"; -- multiplication
            
     C <= aux_add(8) when Ctr_Alu = "000" else '0' ; --retenue sur l'addition
     Z <= '1' when res = 0 else '0'; -- zéro
     N <= '1' when A < B and Ctr_Alu = "001" else '0' ; -- négatif
     O <= '1' when aux_mul > "0000000011111111" else --overflow
          '1' when aux_add(8)='1'and Ctr_Alu = "000" else '0' ;

    S <= res ;
    
end Behavioral;
