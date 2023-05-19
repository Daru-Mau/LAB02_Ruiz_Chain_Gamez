%{
#include <stdio.h>
#include <stdlib.h>
#include "LAB02_Ruiz_Chain_Gamez_parser.h"
#include "LAB02_Ruiz_Chain_Gamez_lex.c"

extern int yyparse();
extern char *yytext;
extern int lex_errors;
void yyerror(char *s);

int parse_errors = 0;

typedef int YYSTYPE;

%}

%token NUM
%token OP_SUM OP_MINUS OP_MULT OP_DIV
%token OP_NOT OP_AND OP_OR OP_XOR 
%token PAR_A PAR_C
%token EOL

%start program

%type expression

%%

program:
    | program line
    ;

line:
    expression EOL {
        printf("\n");
    }
    | error EOL {
        lex_errors++;
    }
    ;

expression:
    NUM
    | OP_NOT expression
    | PAR_A expression PAR_C
    | expression OP_AND expression
    | expression OP_OR expression
    | expression OP_XOR expression
    | expression OP_SUM expression
    | expression OP_MINUS expression
    | expression OP_MULT expression
    | expression OP_DIV expression
    | error
    ;

%%

void yyerror(char *s) {
    parse_errors++;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Please provide an input file.\n");
        return 1;
    }

    FILE *f = fopen(argv[1], "a");
    fprintf(f, "\n");
    fclose(f);

    FILE* input = fopen(argv[1], "r");
    if (!input) {
        printf("Failed to open the input file.\n");
        return 1;
    }

    char* line = NULL;
    size_t line_size = 0;
    ssize_t read;

    while ((read = getline(&line, &line_size, input)) != -1) {
        printf("Expresion: %s", line);
        yy_scan_string(line);
        parse_errors = 0; lex_errors = 0;   
        yyparse();   
        printf("\n");  
    }

    fclose(input);
    free(line);

    FILE *fp = fopen(argv[1], "r+");
    fseek(fp, 0, SEEK_END);
    long pos = ftell(fp);

    for (long i = pos - 1; i >= 0; i--) {
        fseek(fp, i, SEEK_SET);
        char c = fgetc(fp);
        if (c == '\n') {
            ftruncate(fileno(fp), i);
            break;
        }
    }
    fclose(fp);

    return 0;
}
