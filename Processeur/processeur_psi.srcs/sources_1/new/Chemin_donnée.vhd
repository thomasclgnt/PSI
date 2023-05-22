----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.05.2023 19:53:59
-- Design Name: 
-- Module Name: Processeur - Behavioral
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

entity Processeur is
    Port ( CLK : in STD_LOGIC);
end Processeur;


architecture Behavioral of Processeur is

    component Banc_registre is
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
    end component ;
    
    component ALU is
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
     
     component data_memory is
         Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
               IN_data : in STD_LOGIC_VECTOR (7 downto 0);
               RW : in STD_LOGIC;
               RST : in STD_LOGIC;
               CLK : in STD_LOGIC;
               OUT_data : out STD_LOGIC_VECTOR (7 downto 0));        
     end component ;
     
     component Pipeline is
        Port (A_in : in STD_LOGIC_VECTOR (7 downto 0);
            Op_in : in STD_LOGIC_VECTOR (7 downto 0);
            B_in : in STD_LOGIC_VECTOR (7 downto 0);
            C_in : in STD_LOGIC_VECTOR (7 downto 0);
            A_out : out STD_LOGIC_VECTOR (7 downto 0);
            Op_out : out STD_LOGIC_VECTOR (7 downto 0);
            B_out : out STD_LOGIC_VECTOR (7 downto 0);
            C_out : out STD_LOGIC_VECTOR (7 downto 0);
            CLK : in STD_LOGIC
            );
        end component;
        
    -- DECLARATION DES SIGNAUX
    signal instruction : STD_LOGIC_VECTOR(31 downto 0) ; -- instruction sortie de mémoire d'instruction, qu'on découpe en 4
    signal instruction_A : STD_LOGIC_VECTOR(7 downto 0) ;
    signal instruction_B : STD_LOGIC_VECTOR(7 downto 0) ;
    signal instruction_C : STD_LOGIC_VECTOR(7 downto 0) ;
    signal instruction_Op : STD_LOGIC_VECTOR(7 downto 0) ;
    
    type instr_record is record
        Op : STD_LOGIC_VECTOR(7 downto 0) ;
        A : STD_LOGIC_VECTOR(7 downto 0);
        B : STD_LOGIC_VECTOR(7 downto 0);
        C: STD_LOGIC_VECTOR(7 downto 0) ;
    end record ;
    
    signal lidi2diex : instr_record ;
    signal diex2exmem : instr_record ;
    signal exmem2memre : instr_record ;
    signal memre2bancreg : instr_record ;
    
    signal LC : STD_LOGIC ;
    
begin
    pip_lidi : Pipeline Port map (A_in => instruction_A,
    Op_in => instruction_Op,
    B_in => instruction_B,
    C_in => instruction_C,
    A_out => lidi2diex.A,
    Op_out => lidi2diex.Op,
    B_out => lidi2diex.B,
    C_out => lidi2diex.C,
    CLK => CLK
    );
    
    pip_diex : Pipeline Port map (A_in => lidi2diex.A,
        Op_in => lidi2diex.Op,
        B_in => lidi2diex.B,
        C_in => lidi2diex.C,
        A_out => diex2exmem.A,
        Op_out => diex2exmem.Op,
        B_out => diex2exmem.B,
        C_out => diex2exmem.C,
        CLK => CLK
        );
     
     pip_exmem : Pipeline Port map (A_in => diex2exmem.A,
                Op_in => diex2exmem.Op,
                B_in => diex2exmem.B,
                C_in => diex2exmem.C,
                A_out => exmem2memre.A,
                Op_out => exmem2memre.Op,
                B_out => exmem2memre.B,
                C_out => exmem2memre.C,
                CLK => CLK
                );
    
    pip_memre : Pipeline Port map (A_in => exmem2memre.A,
                                Op_in => exmem2memre.Op,
                                B_in => exmem2memre.B,
                                C_in => exmem2memre.C,
                                A_out => memre2bancreg.A,
                                Op_out => memre2bancreg.Op,
                                B_out => memre2bancreg.B,
                                C_out => memre2bancreg.C,
                                CLK => CLK
                                );

    main_banc_reg : banc_registre Port map (addrW => memre2bancreg.A (3 downto 0), --A fait 8 bits et rentre dans @W qui en fait 4
                    Data => memre2bancreg.B,
                    W => LC, 
                    addrA => "0000",
                    addrB => "0000",
                    RST => '0',
                    CLK => CLK --signal clock du processeur
                    );
                   
--LC : signal que prend W dans le banc de reg., à 1 quand on veut écrire
-- donc à 1 pour AFC 
    LC <= '1' when memre2bancreg.Op = x"06" else '0' ; -- AFC, écriture
    

    
end Behavioral;
