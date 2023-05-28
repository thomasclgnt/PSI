#ifndef CROSSASSEMBLEUR_H
#define CROSSASSEMBLEUR_H

// dans le processeur, on ne traite que les instructions
// AFC, COPY, ADD, SUB, MUL, et JUMP
// LOAD et STORE sont utilisés pour accéder à la mémoire de données

void ual_cross(int addr_res, int addr_op1, int addr_op2);

void cop_cross(int addr_res, int addr_op);

void afc_cross(int addr_res, int val);

void jmp_cross(int num_instr);

void add_instr(int index, int pcode, int addr_res, int addr_op1, int addr_op2);

void read_file_cross();

void export_file_cross();

void execute_cross();

#endif