#ifndef TABLEASM_H
#define TABLEASM_H

// extern int tab ;

void init_instr() ;

void ajout_exp_arith(int pcode, int addr_res, int addr_op1, int addr_op2) ;

void ajout_copy(int addr_res, int addr_op) ;

void ajout_afc(int addr_res, int val) ;

void ajout_jump(int num_instr);

void ajout_jumpf(int addr_test, int num_instr) ;

void ajout_print(int addr_res) ;

void ajout_ret() ;

void patch_jmf(int index) ;

void patch_jmp(int index) ;

int get_index() ;

void print_tab() ;

void export_file() ;

#endif