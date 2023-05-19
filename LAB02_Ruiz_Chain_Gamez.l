%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "LAB02_Ruiz_Chain_Gamez_parser.h"

extern int parse_errors;

int num_count = 0;
int lex_errors = 0;

typedef int YYSTYPE;
%}

%%
[01]+        { num_count++; printf("num%d = %s\n", num_count ,yytext); return NUM; }
"not"         { printf("op-not = %s\n", yytext); return OP_NOT; }
"and"         { printf("op-and = %s\n", yytext); return OP_AND; }
"or"          { printf("op-or = %s\n", yytext); return OP_OR; }
"xor"         { printf("op-xor = %s\n", yytext); return OP_XOR; }
"+"           { printf("op-sum = %s\n", yytext); return OP_SUM; }
"-"           { printf("op-rest = %s\n", yytext); return OP_MINUS; }
"*"           { printf("op-mult = %s\n", yytext); return OP_MULT; }
"/"           { printf("op-div = %s\n", yytext); return OP_DIV; }
"("           { printf("par-a = %s\n", yytext); return PAR_A; }
")"           { printf("par-c= %s\n", yytext); return PAR_C; }
[\n]    { printf("Análisis Sintáctico\n"); 
        if (lex_errors > 0) {
            printf("No se ejecuta.");
        } else {
            if (parse_errors == 0) {
                printf("Correcto!!");
            } else {
                printf("Errores Sintácticos: %d", parse_errors);
            }
        } num_count=0; printf("\n"); return EOL;}
[\r\n]  ;
[ \t]        ; /* ignore whitespace */
[a-zA-Z]+    { printf("ERROR Léxico!!\n"); lex_errors++; return *yytext; }
[0-9]+       { printf("ERROR Léxico!!\n"); lex_errors++; return *yytext; }
.            { printf("ERROR Léxico!!\n"); lex_errors++; return *yytext; }
%%

int yywrap() {
    return 1;
}
