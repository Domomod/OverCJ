# makefile for flex + bison project

SCANNER_DESC_FILE=scan.l
PARSER_DESC_FILE=gram.y
PARSER_EXEC_FILE=gram.x

all: $(PARSER_EXEC_FILE)

$(PARSER_EXEC_FILE): lex.yy.c y.tab.c
	gcc -o $(PARSER_EXEC_FILE) y.tab.c lex.yy.c

lex.yy.c: $(SCANNER_DESC_FILE)
	flex -l $(SCANNER_DESC_FILE)

y.tab.c: $(PARSER_DESC_FILE)
	bison -y -d $(PARSER_DESC_FILE)

clean:
	rm -f lex.yy.c
	rm -f y.tab.c
	rm -f y.tab.h
