#ifndef INTERPRETEUR_H
#define INTERPRETEUR_H

void add(int addr_res, int addr_op1, int addr_op2);
void mul(int addr_res, int addr_op1, int addr_op2);
void sub(int addr_res, int addr_op1, int addr_op2);
void dvd(int addr_res, int addr_op1, int addr_op2);
void cop(int addr_res, int addr_op);
void afc(int addr_res, int val);
void jmp(int num_instr);
void jmf(int addr_cond, int num_instr);
void inf(int addr_res, int addr_op1, int addr_op2);
void sup(int addr_res, int addr_op1, int addr_op2);
void equ(int addr_res, int addr_op1, int addr_op2);
void pri(int addr_res);
void ret();
void push_asm(int offset);
void call(int addr_appel);
void pop_asm(int offset);
void init_ram();

void print_memoire();

void execute();

void read_file();

#endif