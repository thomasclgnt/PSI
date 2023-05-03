#ifndef TABLEASM_H
#define TABLEASM_H

// extern int tab ;

void ajout_exp_arith(int pcode, int addr_res, int addr_op1, int addr_op2) ;

void ajout_copy(int addr_res, int addr_op) ;

void ajout_afc(int addr_res, int val) ;

void ajout_jump(int num_instr);

void ajout_jumpf(int addr_test, int num_instr) ;


void patch_jmf(int index) ;

int get_index() ;

void print_tab() ;

#endif