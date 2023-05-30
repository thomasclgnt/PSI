----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 13:38:08
-- Design Name: 
-- Module Name: Instruction_mem - Behavioral
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

entity Instruction_Memory is
    Port ( enable : in STD_LOGIC ;
           addr : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           OUT_instr : out STD_LOGIC_VECTOR (31 downto 0));
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

    type type_memory is array (255 downto 0) of STD_LOGIC_VECTOR (31 downto 0) ; -- 4096 octets car dans compilateur tableau de 1024 symboles/instructions et 4 octets chacun
    signal memory : type_memory ;

begin

    -- remplir memory
    -- de la forme (x"00" & x"aa" & x"bb" & x"cc") OU x"00aabbcc",
    -- avec "OO" = pcode, et le reste = @
    -- LOAD : 13 => x"0d"
    -- STORE : 14 => x"0e"
    
    memory <= (
     -- TEST ALÉAS DE DONNÉES
            1 => x"06011000", -- AFC R1, 10 ; R1 = 10
            2 => x"06020500", -- AFC R2, 5 ; R2 = 5
            3 => x"06030200", -- AFC R3, 2 ; R3 = 2
            4 => x"01040102", -- ADD R4, R1, R2 ; R4 = R1 + R2 = 10 + 5 = 15
            5 => x"05050400", -- COPY R5, R4 ; R5 = R4 = 15
            6 => x"0d060000", -- LOAD R6, MEM0 ; R6 = Valeur en mémoire 0 = 4
            7 => x"03040403", -- SUB R4, R4, R3 ; R4 = R4 - R3 = 15 - 2 = 13
            8 => x"0e010400", -- STORE R4, MEM1 ; Stocke la valeur de R4 dans la mémoire1
      -- TESTS JUMPS ET ALÉAS DE BRANCHEMENT
            -- JMP FORWARD
                -- 1 => x"06000100", -- AFC R0, 1
                -- 2 => x"07040000", -- JMP @instr=4
                -- 3 => x"06010300", -- AFC R1, 3
                -- 4 => x"06020500", -- AFC R2, 5
                -- 4 => x"", -- JMP @instr=2
            -- JMF
                -- 1 => x"06000100", -- AFC @0 1
                -- 2 => x"06020500", -- AFC @2 5
                -- 3 => x"08020600", -- JMF @2 N6
                -- 4 => x"06030600", -- AFC @3 6
                -- 5 => x"06040600",-- AFC @4 6
                -- 6 => x"08010c00", -- JMF @1 N9
                -- 7 => x"06060900", -- AFC @6 9
                -- 8 => x"06050900", -- AFC @5 9
                -- 12 => x"06070800", -- AFC @7 8
            others => x"ffffffff"
    ) ;
    process
    begin
        wait until CLK'event and CLK='1';
        if enable = '0' then
            OUT_instr <= memory(to_integer(unsigned(addr)));
        end if ;
    end process ;


end Behavioral;
