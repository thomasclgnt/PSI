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
constant zero_9b : bit_vector(8 downto 0):="000000000";
--Declaration des signaux
signal aux_add : STD_LOGIC_VECTOR(8 downto 0);
signal aux_sous : STD_LOGIC_VECTOR(8 downto 0);
signal aux_mul : STD_LOGIC_VECTOR(15 downto 0);



begin

    process(A, B, Ctr_Alu)
    -- Partie déclarative
    begin
    --Corps du programme
    
    if (Ctr_Alu = "000") then
    -- ADDITION
    --aux <= A + B ;
        aux_add <= std_logic_vector(A+B);
        
        if (aux_add(8) = '1') then --retenue sur le 8° bit
            C <= '1' ;
        end if ;
        
        if (aux_add = "000000000") then -- zéro
            Z <= '1' ;
        end if ;
        
        S <= aux_add ;
    
    elsif (Ctr_Alu = "001") then
    -- SOUSTRACTION
        aux_sous <= A - B ;
        
        if (aux_sous > "011111111") then -- négatif
            N <= '1' ;
            end if ;
    
        S <= aux_sous ;
        
    elsif (Ctr_Alu = "010") then
    -- multiplication
        aux_mul <= std_logic_vector(A*B);
        
        if (aux_mul > "0000000011111111") then --overflow
            C <= '1' ;
        end if ;
        -- garder que les 8 premiers bits pour mettre dans S
        S <= aux_mul(7 downto 0) ;
    
    elsif (Ctr_Alu = "011") then
    --division
    
    end if ;
    

    
    end process;


end Behavioral;
