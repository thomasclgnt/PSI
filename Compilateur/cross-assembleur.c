#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int tab_rom[1024][4] ;
int nb_instr_added = 0 ;
int index_rom_cross = 0 ;


void add_instr(int index, int pcode, int addr_res, int addr_op1, int addr_op2) {
    // Vérifier si l'index est valide
    if (index > 0 || index <= 1024) {
        // Décaler les lignes existantes vers le bas à partir de l'index
        for (int i = 1023; i > index; i--) {
            for (int j = 0; j < 4; j++) {
                tab_rom[i][j] = tab_rom[i - 1][j];
            }
        }

        // Insérer la nouvelle ligne à l'index spécifié
        for (int j = 0; j < 4; j++) {
            tab_rom[index][0] = pcode ;
            tab_rom[index][1] = addr_res ;
            tab_rom[index][2] = addr_op1 ;
            tab_rom[index][3] = addr_op2 ;
        }

        printf("added\n") ;
        nb_instr_added += 1 ;

    } else {
        printf("Erreur : index [%d] invalide.\n", index);
    }
}

// dans le processeur, on ne traite que les instructions
// AFC, COPY, ADD, SUB, MUL
// LOAD et STORE sont utilisés pour accéder à la mémoire de données

void ual_cross(int pcode, int addr_res, int addr_op1, int addr_op2){
    int addr_current1 = 0 ;
    int addr_current2 = addr_current1 + 1 ;
    // remplacer ADD par un premier LOAD @current1 @op1
    tab_rom[index_rom_cross][0] = 13 ;
    tab_rom[index_rom_cross][1] = addr_current1 ;
    tab_rom[index_rom_cross][2] = addr_op1 ;
    tab_rom[index_rom_cross][3] = -1 ;
    // rajour du deuxième LOAD @current2 @op2
    index_rom_cross ++ ;
    add_instr(index_rom_cross, 13, addr_current2, addr_op2, -1) ;
    // rajout du deuxième ADD @current1 @current1 @current2
    index_rom_cross ++ ;
    add_instr(index_rom_cross, pcode, addr_current1, addr_current1, addr_current2) ;
    // rajout du STORE @addr_res @current1
    index_rom_cross ++ ;
    add_instr(index_rom_cross, 14, addr_res, addr_current1, -1) ;

}

void cop_cross(int addr_res, int addr_op){
    int addr_current = 0 ;
    // remplacer COPY courrant par : LOAD @current @addr_op
    tab_rom[index_rom_cross][0] = 13 ;
    tab_rom[index_rom_cross][1] = addr_current ;
    tab_rom[index_rom_cross][2] = addr_op ;
    tab_rom[index_rom_cross][3] = -1 ;
    index_rom_cross ++ ;
    // ajouter l'instruction STR @addr_res(mem) @current
    add_instr(index_rom_cross, 14, addr_res, addr_current, -1) ;
    
}

void afc_cross(int addr_res, int val){
    int addr_current = 0 ;
    // remplacer l'afc courrant : AFC @addr_res(mem) val
    // par : AFC @current val
    tab_rom[index_rom_cross][1] = addr_current ;
    index_rom_cross ++ ;
    // ajouter l'instruction STR @addr_res(mem) @current
    add_instr(index_rom_cross, 14, addr_res, addr_current, -1) ;
}


void read_file_cross(){

    FILE * file ;
    char line[100];
    int i = 0 ;

    if (file == NULL) {
        printf("Error opening file.");
        exit(1);
    }

    // file = fopen("instructions.txt", "r") ;
    file = fopen("test_cross.txt", "r") ;

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

void export_file_cross(){

    FILE * file ;
    file = fopen("cross.txt", "w") ;
    int row = 1024 ;
    int col = 4 ;
    int leave = 1 ;
    int i = 0;
    
    // parcourir le tableau et rentrer chaque instruction dans le fichier

    while (leave && i<row) {
        if (tab_rom[i][0] != 0) {
            for (int j = 0; j < col; j++) {
                fprintf(file, "%d ", tab_rom[i][j]);
            }
            fprintf(file, "\n");
        } else {
            for (int j = 0; j < col; j++) {
                fprintf(file, "%d ", tab_rom[i][j]);
            }
            fprintf(file, "\n");
            leave = 0 ;
        }
        i++ ;
    }

    fclose(file);

}


void execute_cross(){

    printf("start execute\n") ;

    read_file_cross(); // on remplit tab_rom à partir du fichier lu

    printf("file read\n") ;

    // parcourir tab_rom jusqu'au NOP, en rajoutant des lignes si besoin
    while (tab_rom[index_rom_cross][0] != 0){
        
        printf("[%d] %d %d %d %d\n", index_rom_cross, tab_rom[index_rom_cross][0], tab_rom[index_rom_cross][1], tab_rom[index_rom_cross][2], tab_rom[index_rom_cross][3]);

        // dans le processeur, on ne traite que les instructions
    // AFC, COPY, ADD, SUB, MUL

        switch (tab_rom[index_rom_cross][0]) {
           case 1:
                ual_cross(1, tab_rom[index_rom_cross][1], tab_rom[index_rom_cross][2], tab_rom[index_rom_cross][3]) ;
               break;
           case 2:
                ual_cross(2, tab_rom[index_rom_cross][1], tab_rom[index_rom_cross][2], tab_rom[index_rom_cross][3]) ;
                break;
           case 3:
           // toutes les instructions de l'ALU
                ual_cross(3, tab_rom[index_rom_cross][1], tab_rom[index_rom_cross][2], tab_rom[index_rom_cross][3]) ;
                break;
           case 5:
           // COP
                cop_cross(tab_rom[index_rom_cross][1], tab_rom[index_rom_cross][2]);
                break;
           case 6:
           // AFC
                afc_cross(tab_rom[index_rom_cross][1], tab_rom[index_rom_cross][2]);
                break;
           default:
                assert(0 && "Erreur : L'instruction n'est pas prise en charge par le processeur\n");
                break ;
        }

        index_rom_cross ++ ;

    }

    export_file_cross();

    printf("end execution\n") ;

}