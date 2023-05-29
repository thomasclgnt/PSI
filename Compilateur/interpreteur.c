#include <stdio.h>
#include <stdlib.h>

// créer rtabelau pour représenter la RAM

int tab_ram[1024] ;
int tab_rom[1024][4] ;
int index_rom = 0 ;

void add(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res] = tab_ram[addr_op1] + tab_ram[addr_op2] ;
}

void mul(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res] = tab_ram[addr_op1] * tab_ram[addr_op2] ;
}

void sub(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res] = tab_ram[addr_op1] - tab_ram[addr_op2] ;
}

void dvd(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res] = tab_ram[addr_op1] / tab_ram[addr_op2] ;
}

void cop(int addr_res, int addr_op){
    tab_ram[addr_res] = tab_ram[addr_op] ;
}

void afc(int addr_res, int val){
    tab_ram[addr_res] = val ;
}

void jmp(int num_instr){
    index_rom = num_instr - 1 ;
}

void jmf(int addr_cond, int num_instr){
    if (tab_ram[addr_cond] == 0) {
        index_rom = num_instr - 1 ;
    }
}

void inf(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res] = (tab_ram[addr_op1] < tab_ram[addr_op2]) ? 1 : 0 ;
}

void sup(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res] = (tab_ram[addr_op1] > tab_ram[addr_op2]) ? 1 : 0 ;
}

void equ(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res] = (tab_ram[addr_op1] == tab_ram[addr_op2]) ? 1 : 0 ;
}

void pri(int addr_res){
    printf("%d\n", tab_ram[addr_res]) ;
}

void read_file(){

    FILE * file ;
    char line[100];
    int i = 0 ;

    if (file == NULL) {
        printf("Error opening file.");
        exit(1);
    }

    file = fopen("instructions.txt", "r") ;

    //remplir tab_rom

    // Read each line of the file
    while (fgets(line, sizeof(line), file)) {
        // Parse the line into four numbers

        if (sscanf(line, "%d %d %d %d", &tab_rom[i][0], &tab_rom[i][1], &tab_rom[i][2], &tab_rom[i][3]) != 4) {
            printf("Error parsing line: %s", line);
            continue;
        }
        
        // Increment the row index
    	i++;
   	 
    	// Check if the array is full
    	if (i >= 1024) {
        	printf("Error: array is full.\n");
        	break;
    	}

	}

    // Print the contents of the array to the console

    fclose(file) ;

}


void execute(){

    printf("start execute\n") ;

    read_file(); // on remplit tab_rom à partir du fichier généré

    printf("file read\n") ;

    // parcourir tab_rom jusqu'au NOP
    while (tab_rom[index_rom][0] != 0){

        switch (tab_rom[index_rom][0]) {
           case 1:
           // ADD
               add(tab_rom[index_rom][1], tab_rom[index_rom][2], tab_rom[index_rom][3]) ;
               break;
           case 2:
           // MUL
               mul(tab_rom[index_rom][1], tab_rom[index_rom][2], tab_rom[index_rom][3]) ;
               break;
           case 3:
           // SOU
               sub(tab_rom[index_rom][1], tab_rom[index_rom][2], tab_rom[index_rom][3]) ;
               break;
           case 4:
           // DIV
               dvd(tab_rom[index_rom][1], tab_rom[index_rom][2], tab_rom[index_rom][3]) ;
               break;
           case 5:
           // COP
               cop(tab_rom[index_rom][1], tab_rom[index_rom][2]);
               break;
           case 6:
           // AFC
               afc(tab_rom[index_rom][1], tab_rom[index_rom][2]);
               break;
           case 7:
           // JMPnum_instr
               jmp(tab_rom[index_rom][1]) ;
               break;
           case 8:
           // JMF
               jmf(tab_rom[index_rom][1], tab_rom[index_rom][2]) ;
               break;
           case 9:
           // INF
               inf(tab_rom[index_rom][1], tab_rom[index_rom][2], tab_rom[index_rom][3]) ;
               break;
           case 10:
           // SUP
                sup(tab_rom[index_rom][1], tab_rom[index_rom][2], tab_rom[index_rom][3]) ;
                break;
           case 11:
           // EQU
                equ(tab_rom[index_rom][1], tab_rom[index_rom][2], tab_rom[index_rom][3]) ;
                break;
           case 12:
           // PRI
                pri(tab_rom[index_rom][1]) ;
                break;
        }

    }

    printf("end execution\n \n") ;

}