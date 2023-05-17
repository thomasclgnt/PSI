----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 10:29:08
-- Design Name: 
-- Module Name: Test_Banc_registre - Behavioral
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

entity Test_Banc_registre is
--  Port ( );
end Test_Banc_registre;

architecture Behavioral of Test_Banc_registre is

    Component Banc_registre is
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
              end Component ;
              
    signal addrA :  STD_LOGIC_VECTOR (3 downto 0);
    signal addrB : STD_LOGIC_VECTOR (3 downto 0);
    signal addrW : STD_LOGIC_VECTOR (3 downto 0);
    signal W : STD_LOGIC;
    signal Data : STD_LOGIC_VECTOR (7 downto 0);
    signal RST : STD_LOGIC;
    signal CLK : STD_LOGIC := '0' ;
    signal QA: STD_LOGIC_VECTOR (7 downto 0);
    signal QB : STD_LOGIC_VECTOR (7 downto 0);

begin

    uut: Banc_registre port map (addrA=>addrA, addrB=>addrB, addrW=>addrW, W=>W, Data=>Data, RST=>RST, CLK=>CLK, QA=>QA, QB=>QB);
    
    process
        begin
            CLK <= not CLK;
            wait for 100 ns;
        end process;


    W<= '1';
    RST<='0';
    Data <= "11110000";

--lecture
addrW<="0000";
addrA<="0000";
addrB<="1111";



end Behavioral;
