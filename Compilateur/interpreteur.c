#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>


// créer rtabelau pour représenter la RAM

int tab_ram[1024] ;
int tab_rom[1024][4] ;
int index_rom = 0 ;
int ebp = 0 ;

void add(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res + ebp] = tab_ram[addr_op1 + ebp] + tab_ram[addr_op2 + ebp] ;
}

void mul(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res + ebp] = tab_ram[addr_op1 + ebp] * tab_ram[addr_op2 + ebp] ;
}

void sub(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res + ebp] = tab_ram[addr_op1 + ebp] - tab_ram[addr_op2 + ebp] ;
}

void dvd(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res + ebp] = tab_ram[addr_op1 + ebp] / tab_ram[addr_op2 + ebp] ;
}

void cop(int addr_res, int addr_op){
    tab_ram[addr_res + ebp] = tab_ram[addr_op + ebp] ;
}

void afc(int addr_res, int val){
    tab_ram[addr_res + ebp] = val ;
}

void jmp(int num_instr){
    index_rom = num_instr - 1 ;
}

void jmf(int addr_cond, int num_instr){
    if (tab_ram[addr_cond + ebp] == 0) {
        index_rom = num_instr - 1 ;
    }
}

void inf(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res + ebp] = (tab_ram[addr_op1 + ebp] < tab_ram[addr_op2 + ebp]) ? 1 : 0 ;
}

void sup(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res + ebp] = (tab_ram[addr_op1 + ebp] > tab_ram[addr_op2 + ebp]) ? 1 : 0 ;
}

void equ(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res + ebp] = (tab_ram[addr_op1 + ebp] == tab_ram[addr_op2 + ebp]) ? 1 : 0 ;
}

void geq(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res + ebp] = (tab_ram[addr_op1 + ebp] >= tab_ram[addr_op2 + ebp]) ? 1 : 0 ;
}

void seq(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res + ebp] = (tab_ram[addr_op1 + ebp] <= tab_ram[addr_op2 + ebp]) ? 1 : 0 ;
}

void neq(int addr_res, int addr_op1, int addr_op2){
    tab_ram[addr_res + ebp] = (tab_ram[addr_op1 + ebp] != tab_ram[addr_op2 + ebp]) ? 1 : 0 ;
}

void pri(int addr_res){
    printf("%d\n", tab_ram[addr_res + ebp]) ;
}

void ret(){
    int addr_retour = tab_ram[ebp] ;
    if (addr_retour == -1) {
        printf("\nEnd of program reached.\n") ;
    } else {
        index_rom = addr_retour - 1 ;
    }
}

void push_asm(int offset){
    ebp = ebp + (offset * 4) ; // MULTIPLIER L'OFFSET car nos adresses avancent de 4 en 4 (données sur 4 octets)
}

void call(int addr_appel){
    tab_ram[ebp] = index_rom + 1 ; // on sauvegarde dans ebp l'adresse de retour
    index_rom = addr_appel - 1 ; // on saute à la fonction appellée
}

void pop_asm(int offset){
    ebp = ebp - (offset * 4) ; // MULTIPLIER L'OFFSET car nos adresses avancent de 4 en 4 (données sur 4 octets)
}

void init_ram(){
    tab_ram[0] = -1 ;
}

void print_memoire(){
    int row = 30 ;
    int leave = 1 ;

    printf("\nMémoire :");

    for (int i = 0; i < row; i++) {
        printf("[%d] %d ", i, tab_ram[i]);
        printf("\n");
    }

    printf("\n");

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

    printf("\nExecution :\n") ;

    init_ram();

    // parcourir tab_rom jusqu'au NOP
    while (tab_rom[index_rom][0] != 0){

        // print_memoire() ;

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
            case 15:
            // GEQ
                geq(tab_rom[index_rom][1], tab_rom[index_rom][2], tab_rom[index_rom][3]);
                break;
            case 16:
            // SEQ
                seq(tab_rom[index_rom][1], tab_rom[index_rom][2], tab_rom[index_rom][3]);
                break;
            case 21:
            // NEQ
                neq(tab_rom[index_rom][1], tab_rom[index_rom][2], tab_rom[index_rom][3]);
                break;
            case 17:
                ret();
                break;
            case 18:
                push_asm(tab_rom[index_rom][1]);
                break;
            case 19:
                call(tab_rom[index_rom][1]);
                break;
            case 20:
                pop_asm(tab_rom[index_rom][1]);
                break;
            default:
                printf("ERROR : l'instruction %d du fichier d'entrée n'est pas prise en compte par l'interpréteur\n", tab_rom[index_rom][0]) ;
                break;
        }

        index_rom ++ ;
        // printf("new index : %d\n", index_rom) ;

    }

    printf("end execution\n \n") ;

}