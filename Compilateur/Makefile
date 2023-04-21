all: bison

bison.tab.c bison.tab.h:	bison.y
	bison -t -v -d bison.y

lex.yy.c: lex.l bison.tab.h
	flex lex.l

%.o: %.c
	gcc -c -o $@ $^

bison: lex.yy.o bison.tab.o symboles.o tablasm.o
	gcc -o bison $^

clean:
	rm bison bison.tab.c lex.yy.c bison.tab.h bison.output

test: all
	cat samples/test_exp_arith.c | ./bison
