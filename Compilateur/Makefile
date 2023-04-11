all: bison

bison.tab.c bison.tab.h:	bison.y
	bison -t -v -d bison.y

lex.yy.c: lex.l bison.tab.h
	flex lex.l

bison: lex.yy.c bison.tab.c bison.tab.h
	gcc -o bison bison.tab.c lex.yy.c

clean:
	rm bison bison.tab.c lex.yy.c bison.tab.h bison.output

test: all
	cat samples/test.c | ./bison
