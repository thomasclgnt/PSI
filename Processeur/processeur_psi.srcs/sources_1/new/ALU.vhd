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
use IEEE.STD_LOGIC_ARITH.ALL;
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
           C : out STD_LOGIC); --flag ! retenue addition ou multiplication
end ALU;

architecture Behavioral of ALU is
--Déclaration des composants

--Declaration des signaux
signal aux_add : STD_LOGIC_VECTOR(8 downto 0);
signal aux_sous : STD_LOGIC_VECTOR(8 downto 0);
signal aux_mul : STD_LOGIC_VECTOR(16 downto 0);



begin

    process
    -- Partie déclarative
    begin
    --Corps du programme
    
    if (Ctr_Alu = "000") then
    -- addition
    --aux <= A + B ;
        aux_add <= std_logic_vector(A+B);
        
        if (aux_add > "011111111") then
            C <= '1' ;
        end if ;
    
    
    elsif (Ctr_Alu = "001") then
    -- soustraction, faut des signés
    aux <= A - B ;
    aux <= std_logic_vector(A-B);
    
    elsif (Ctr_Alu = "010") then
    -- multiplication
    aux <= A * B ;
    aux <= std_logic_vector(A*B);
    
    elsif (Ctr_Alu = "011") then
    --division
    aux <= A/B ;
    
    
    end if ;
    
    if (aux = "00000000") then
        Z <= '1' ;
    end if ;
    
    if (aux > "11111111") then
            O <= '1' ;
    end if ;
    
    if (aux < "00000000") then
            N <= '1' ;
    end if ;
    
    S <= aux ;
     
    
    end process;


end Behavioral;
