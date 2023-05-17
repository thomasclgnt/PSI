----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 11:24:39
-- Design Name: 
-- Module Name: Test_DataMem - Behavioral
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

entity Test_DataMem is
--  Port ( );
end Test_DataMem;

architecture Behavioral of Test_DataMem is
    component data_memory is
           Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           IN_data : in STD_LOGIC_VECTOR (7 downto 0);
           RW : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUT_data : out STD_LOGIC_VECTOR (7 downto 0));
    end component ;
    
signal addr : STD_LOGIC_VECTOR (7 downto 0);
signal IN_data : STD_LOGIC_VECTOR (7 downto 0);
signal RW : STD_LOGIC;
signal RST : STD_LOGIC := '0';
signal CLK : STD_LOGIC := '0' ;
signal OUT_data : STD_LOGIC_VECTOR (7 downto 0);
              
begin

    uut : data_memory port map (addr => addr, IN_data => IN_data, RW => RW, RST => RST, CLK => CLK, OUT_data => OUT_data) ;

    
    process
    begin
        CLK <= not CLK;
        wait for 10 ns ;  
    
    end process ;
    IN_data <= x"11";
    rst <= '0' after 10ns, '1' after 100ns;
    RW <= '1', '0' after 140ns, '1' after 190ns;
    addr <= "00000001";
  

end Behavioral;
