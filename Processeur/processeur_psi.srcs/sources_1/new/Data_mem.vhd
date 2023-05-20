----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 13:33:30
-- Design Name: 
-- Module Name: data_memory - Behavioral
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

entity data_memory is
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           IN_data : in STD_LOGIC_VECTOR (7 downto 0);
           RW : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUT_data : out STD_LOGIC_VECTOR (7 downto 0));
end data_memory;

architecture Behavioral of data_memory is

    type type_memory is array (255 downto 0) of STD_LOGIC_VECTOR (7 downto 0) ; -- 4096 octets car dans compilateur tableau de 1024 symboles/instructions et 4 octets chacun
    signal memory : type_memory ;

begin
    
    
    process
    begin
        wait until CLK'event and CLK='1';
            -- reset
            if RST='0' then
                -- mettre la memoire à O
                memory<= (others => "00000000") ;
            else
            
                if RW='1' then -- lecture
                    report "je suis dedans";
                    OUT_data <= memory(to_integer(unsigned(addr))) ;               
                elsif RW='0' then -- ecriture
                   memory(to_integer(unsigned(addr))) <= IN_data ;
                end if ; 
           end if;

     end process;  

end Behavioral;
