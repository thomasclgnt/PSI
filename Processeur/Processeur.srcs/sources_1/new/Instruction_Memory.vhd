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
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
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
            1 => x"06040300", -- AFC 4 3 0
            2 => x"01000004", -- MUL 0 0 4
            3 => x"06080200", -- AFC 8 2 0
            4 => x"05030800", -- COP 3 8 0
            5 => x"02020408", -- ADD 2 4 8  
            6 => X"0d010000", -- LOAD 1 0 0 (addr1 dans registre et addr0 dans data mem)
            7 => x"0e040100", -- STORE 4 1 0 (store addresse1 registre4) 
            others => x"00000000"
    ) ;
    process
        -- variable ip : integer := to_integer(unsigned(addr)) ;
    begin
        wait until CLK'event and CLK='1';
        -- report "valeur ip : " & integer'image(ip);
            OUT_instr <= memory(to_integer(unsigned(addr))); -- memory(ip);
            -- if not(ip = 254) then 
                -- ip := ip + 1 ;
            -- end if;
    end process ;


end Behavioral;
