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
	Port ( CLK : in STD_LOGIC;
       	RST : in STD_LOGIC
        	);
end Processeur;


architecture Behavioral of Processeur is

	component Banc_Registre is
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
	 
 	component Data_Memory is
     	Port ( 
     	    addr : in STD_LOGIC_VECTOR (7 downto 0);
           	IN_data : in STD_LOGIC_VECTOR (7 downto 0);
           	RW : in STD_LOGIC;
           	RST : in STD_LOGIC;
           	CLK : in STD_LOGIC;
           	OUT_data : out STD_LOGIC_VECTOR (7 downto 0));   	 
 	end component ;
	 
 	component Pipeline is
    	Port ( enable : in STD_LOGIC;
    	    nop : in STD_LOGIC;
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
    	end component;
   	 
    component Instruction_Memory is
        Port ( 
        enable : in STD_LOGIC ;
        addr : in STD_LOGIC_VECTOR (7 downto 0);
        CLK : in STD_LOGIC;
        OUT_instr : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component ;
    
    component Compteur_IP is
              Port ( enable : in STD_LOGIC ;
              CLK : in STD_LOGIC ;
              IP_Out : out STD_LOGIC_VECTOR (7 downto 0)
              );
    end component ;
       
   	 
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
    
	signal QA_Banc_Reg : STD_LOGIC_VECTOR(7 downto 0) ;
	signal QB_Banc_Reg : STD_LOGIC_VECTOR(7 downto 0) ;
	signal Res_ALU : STD_LOGIC_VECTOR(7 downto 0) ;
	signal Out_Data_Mem : STD_LOGIC_VECTOR(7 downto 0) ;
	
	signal IP : STD_LOGIC_VECTOR(7 downto 0) ;
    
	signal memre2bancreg_LC : STD_LOGIC ;
	signal lidi2diex_MUX : STD_LOGIC_VECTOR(7 downto 0) ;
	signal diex2exmem_LC : STD_LOGIC_VECTOR (2 downto 0);
	signal diex2exmem_MUX : STD_LOGIC_VECTOR(7 downto 0) ;
	signal exmem2memre_LC : STD_LOGIC ;
	signal exmem2datamem_MUX : STD_LOGIC_VECTOR(7 downto 0) ;
	signal datamem2memre_MUX : STD_LOGIC_VECTOR(7 downto 0) ;
	
	-- gestion d'aléas
	
	signal lidi_read : STD_LOGIC ;
	signal diex_write : STD_LOGIC ;
	signal exmem_write : STD_LOGIC ;
	signal alea_diex : STD_LOGIC ;
	signal alea_exmem : STD_LOGIC ;
	signal alea : STD_LOGIC :=  '0'; -- HMMMMM
	signal instr_arithm : STD_LOGIC ;
    
begin

    -- détection des aléas
	instr_arithm <= '1' when (lidi2diex.Op = x"01" or lidi2diex.Op = x"02" or lidi2diex.Op = x"03") else '0' ;
    lidi_read <= '1' when (instr_arithm = '1' or lidi2diex.Op = x"05" or lidi2diex.Op = x"0e") else '0'; -- instructions de l'ALU, STORE, COPY
    diex_write <= '1' when (diex2exmem.Op = x"01" or diex2exmem.Op = x"02" or diex2exmem.Op = x"03" or diex2exmem.Op = x"06" or diex2exmem.Op = x"0d") else '0'; -- instrus de l'ALU, LOAD,, COP, AFC
    exmem_write <= '1' when (exmem2memre.Op = x"01" or exmem2memre.Op = x"02" or exmem2memre.Op = x"03" or exmem2memre.Op = x"06" or exmem2memre.Op = x"0d" ) else '0';
    alea_diex <= '1'
        when (lidi_read = '1' and diex_write = '1' and instr_arithm = '0' and lidi2diex.B = diex2exmem.A)
        or (lidi_read = '1' and diex_write = '1' and instr_arithm = '1' and (lidi2diex.B = diex2exmem.A or lidi2diex.C = diex2exmem.A)) else '0';
    alea_exmem <= '1'
        when (lidi_read = '1' and exmem_write = '1' and instr_arithm = '0' and lidi2diex.B = exmem2memre.A)
        or (lidi_read = '1' and exmem_write = '1' and instr_arithm = '1' and (lidi2diex.B = exmem2memre.A or lidi2diex.C = exmem2memre.A)) else '0';
    alea <= '1' when alea_diex = '1' or  alea_exmem = '1' else '0';

    
    -- À FAIRE :

            -- bloquer IP => entree enable (qui recoit alea) : DONE
            -- bloauer mi => entree enable (qui recoit alea) : DONE
            -- bloauer lidi => entree enable (qui recoit alea) : DONE
            -- inserer un nop dans diex => entree nop (qui recoit alea pour diex) : DONE


	main_instruction_mem : Instruction_Memory Port map (
        enable => alea,
        addr => IP,
        CLK => CLK,
        OUT_instr => instruction -- sort une instruction sur 32 bits
	);
    
    
	instruction_C <= instruction(7 downto 0) ;
	instruction_B <= instruction(15 downto 8) ;
	instruction_A <= instruction(23 downto 16) ;
	instruction_Op <= instruction(31 downto 24) ;
    
	pip_lidi : Pipeline Port map (
	    enable => alea,
	    nop => '0',
	    A_in => instruction_A,
    	Op_in => instruction_Op,
    	B_in => instruction_B,
    	C_in => instruction_C,
    	A_out => lidi2diex.A,
    	Op_out => lidi2diex.Op,
    	B_out => lidi2diex.B,
    	C_out => lidi2diex.C,
    	CLK => CLK
	);
	 
    
	pip_diex : Pipeline Port map (
		enable => alea, -- SE BLOQUE DANS TOUS LES CAS enable => alea_diex,
        nop => alea_diex,
	    A_in => lidi2diex.A,
    	Op_in => lidi2diex.Op,
    	B_in => lidi2diex_MUX,
    	C_in => QB_Banc_Reg,
    	A_out => diex2exmem.A,
    	Op_out => diex2exmem.Op,
    	B_out => diex2exmem.B,
    	C_out => diex2exmem.C,
    	CLK => CLK
   );
	 
	pip_exmem : Pipeline Port map (
		enable => alea_exmem,
        nop => alea_exmem, 
	    A_in => diex2exmem.A,
    	Op_in => diex2exmem.Op,
    	B_in => diex2exmem_MUX,
    	C_in => "00000000",
    	A_out => exmem2memre.A,
    	Op_out => exmem2memre.Op,
    	B_out => exmem2memre.B,
    	C_out => open,
    	CLK => CLK
	);

	pip_memre : Pipeline Port map (
	    enable => '0',
        nop => '0',
        A_in => exmem2memre.A,
        Op_in => exmem2memre.Op,
        B_in => datamem2memre_MUX,
        C_in => "00000000",
        A_out => memre2bancreg.A,
        Op_out => memre2bancreg.Op,
        B_out => memre2bancreg.B,
        C_out => open,
        CLK => CLK
    );

              	 
	main_banc_reg : Banc_Registre Port map (addrW => memre2bancreg.A (3 downto 0), --A fait 8 bits et rentre dans @W qui en fait 4
                	Data => memre2bancreg.B,
                	W => memre2bancreg_LC,
                	addrA => lidi2diex.B(3 downto 0),
                	addrB => lidi2diex.C(3 downto 0),
                	RST => RST,
                	CLK => CLK, --signal clock du processeur
                	QA => QA_Banc_Reg,
                	QB => QB_Banc_Reg
   );
   
   main_alu : ALU Port map (A => diex2exmem.B,
               	B => diex2exmem.C,
               	S => Res_ALU,
               	Ctr_Alu => diex2exmem_LC
    );
 
    main_data_mem : Data_Memory Port map (
                addr => exmem2datamem_MUX,
             	IN_data => exmem2memre.B,
             	RW => exmem2memre_LC,
             	RST => RST,
             	CLK => CLK,
             	OUT_data => Out_Data_Mem
	);
	
	main_ip : Compteur_IP Port map ( 
	           enable => alea,
	           CLK => CLK,
               IP_Out => IP
    );

               	 
               	 
--LC : signal que prend W dans le banc de reg., à 1 quand on veut écrire
-- donc à 1 pour AFC, COPY, ou expr de l'ALU
memre2bancreg_LC <= '1' when (memre2bancreg.Op = x"06" or memre2bancreg.Op = x"05" or memre2bancreg.Op = x"01" or memre2bancreg.Op = x"02" or memre2bancreg.Op = x"03" or memre2bancreg.Op = x"0d") else '0' ; -- AFC ou COPY, écriture

-- MUX pour banc de registre, instruction COPY
-- quand c'est un copy OU expr de l'ALU, on va chercher la valeur à l'adresse donné par instr.B, pour le STORE aussi (0e)
lidi2diex_MUX <= QA_Banc_Reg when (lidi2diex.Op = x"05" or lidi2diex.Op = x"01" or lidi2diex.Op = x"02" or lidi2diex.Op = x"03" or lidi2diex.Op = x"0e") else lidi2diex.B ;


-- GESTION OP ALU :
-- côté processeur : 001 = addition, 010 = multiplication, 011 = soustraction
-- côté compilateur/instructions :  1 = add, 2 = mul, 3 = sub
diex2exmem_LC <= "001" when diex2exmem.Op = x"01" else "010" when diex2exmem.Op = x"02" else "011" when diex2exmem.Op = x"03" ;

-- MUX en sortie de l'ALU
diex2exmem_MUX <= Res_ALU when (diex2exmem.Op = x"01" or diex2exmem.Op = x"02" or diex2exmem.Op = x"03") else diex2exmem.B;

exmem2memre_LC <= '1' when exmem2memre.Op = x"0d" else '0' when exmem2memre.Op = x"0e" ; -- LOAD : 0d, lecture donc LC = 1

datamem2memre_MUX <= Out_Data_Mem when exmem2memre.Op = x"0d" else exmem2memre.B ;

exmem2datamem_MUX <= exmem2memre.B when exmem2memre.Op = x"0d" else exmem2memre.A ;
               	 
    
end Behavioral;
