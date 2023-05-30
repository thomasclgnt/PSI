----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.05.2023 11:01:24
-- Design Name: 
-- Module Name: Pipeline - Behavioral
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

entity Pipeline is
    Port (enable : in STD_LOGIC ;
            A_in : in STD_LOGIC_VECTOR (7 downto 0);
            Op_in : in STD_LOGIC_VECTOR (7 downto 0);
            B_in : in STD_LOGIC_VECTOR (7 downto 0);
            C_in : in STD_LOGIC_VECTOR (7 downto 0);
            A_out : out STD_LOGIC_VECTOR (7 downto 0);
            Op_out : out STD_LOGIC_VECTOR (7 downto 0);
            B_out : out STD_LOGIC_VECTOR (7 downto 0);
            C_out : out STD_LOGIC_VECTOR (7 downto 0);
            CLK : in STD_LOGIC
            );
end Pipeline;

architecture Behavioral of Pipeline is

begin

    -- rajouter qqch du style :
    -- if jmp = '1' then
    --      BLOQUER, donc IN et OUT ne bouge pas
    --      et au tour d'après, 
    --      la valeur actuellement en IN qui représente le jump
    --      sera écrasée par la valeur de l'instruction à laquelle on a sauté

    process
    begin
        wait until CLK'event and CLK='1';
        if enable = '1' then
            report "je fais un NOPPPP" ;
            A_out <= x"00" ;
            B_out <= x"00" ;
            C_out <= x"00" ;
            Op_out <= x"00" ;
        else
            report "enabled" ;
            A_out <= A_in ;
            B_out <= B_in ;
            C_out <= C_in ;
            Op_out <= Op_in ;
        end if ;
    end process ;


end Behavioral;
