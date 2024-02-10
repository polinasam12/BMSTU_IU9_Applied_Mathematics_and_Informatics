%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lexer.h"
%}

%define api.pure
%locations
%lex-param {yyscan_t scanner}  /* параметр для yylex() */
/* параметры для yyparse() */
%parse-param {yyscan_t scanner}
%parse-param {long env[26]}

%union {
    char* indentifier;
    char variable;
    long number;
}

%token <indentifier> IDENT SYMBOL STRING VAR EXTERN ENTRY
%token <number> NUMBER

%{

int yylex(YYSTYPE *yylval_param, YYLTYPE *yylloc_param, yyscan_t scanner);
void yyerror(YYLTYPE *loc, yyscan_t scanner, long env[26], const char *message);

void print_newline_with_offset(long* env) {
    printf("\n");
    env[2] = 0;
    long k = env[1];
    for (int i = 0; i < k; i++) {
        printf("    ");
        env[2] += 4;
    }
}

void check_len(long len, long* env) {
    if ((len + env[2] > env[0]) && (env[1] * 4 + len <= env[0])) {
        print_newline_with_offset(env);
    }
}

int number_len(long num) {
    char str[20];
    int len = snprintf(str, sizeof(str), "%ld", num);
    return len;
}

void print_str(char* str, long* env) {
    int len = strlen(str);
    check_len(len, env);
    printf("%s", str);
    env[2] += len;
}

void print_num(long num, long* env) {
    int len  = number_len(num);
    check_len(env[2] + len, env);
    printf("%ld", num);
    env[2] += len;
}

%}

%%

program: 
      general program 
    | 
    ;

general: 
      extern
    | function 
    | ';' { print_str(";", env); print_newline_with_offset(env); print_newline_with_offset(env); }
    ;
    
extern: 
      EXTERN { print_str($EXTERN, env); print_str(" ", env); } function_name function_names_list
    ;

function_names_list: 
      ',' { print_str(",", env); print_str(" ", env); } function_name function_names_list 
    |
    ;

function: 
      ENTRY { print_str($ENTRY, env); print_str(" ", env); } function_name body 
    | function_name body
    ;

function_name:
      IDENT { print_str($IDENT, env); print_str(" ", env); }
    ;

body:
      '{' { print_str("{", env); env[1] += 1; } sentences '}'
       {
          env[1] -= 1;
          print_newline_with_offset(env);
          print_str("}", env);
          print_newline_with_offset(env);
          print_newline_with_offset(env);
        }
    ;

sentences: 
      sentence sentences_list
    ;

sentence: 
      { print_newline_with_offset(env); } pattern { print_str(" ", env); } pattern_right
      | { print_newline_with_offset(env); } pattern_right
    ;

pattern_right: 
      '=' { print_str("=", env); print_str(" ", env); } result 
    | ',' { print_str(",", env); print_str(" ", env); } result ':' { print_str(":", env); print_str(" ", env); } sentence_or_body
    ;

sentence_or_body:
      sentence
    | body
    ;

sentences_list: 
      ';' { print_str(";", env); } sentences_le_one sentences_list 
    | 
    ;

sentences_le_one:
      sentence 
    | 
    ;

pattern: 
      pattern_term patterns
    ;

patterns: 
      { print_str(" ", env); } pattern_term patterns
    | 
    ;

pattern_term: 
      common 
    | '(' { print_str("(", env); }  pattern ')' { print_str(")", env); }
    ;

common: 
      IDENT { print_str($IDENT, env); }
    | NUMBER { print_num($NUMBER, env); }
    | SYMBOL { print_str($SYMBOL, env); }
    | STRING { print_str($STRING, env); }
    | VAR { print_str($VAR, env); }
    ;

result: 
      result_term results
    | 
    ;

results: 
      { print_str(" ", env); } result_term results
    | 
    ;

result_term:
      common 
    | '(' { print_str("(", env); } result ')' { print_str(")", env); }
    | '<' { print_str("<", env); } function_name result '>' { print_str(">", env); }
    ;

%%

int main(int argc, char *argv[]) {
    FILE *input = 0;
    long env[26] = { 0 };
    env[0] = 0;
    env[1] = 0;
    env[2] = 0;
    yyscan_t scanner;
    struct Extra extra;
    if (argc > 1) {
        input = fopen(argv[1], "r");
        env[0] = atoi(argv[2]);
    } else {
        printf("No file in command line, use stdin\n");
        input = stdin;
    }
    init_scanner(input, &scanner, &extra);
    yyparse(scanner, env);
    destroy_scanner(scanner);
    if (input != stdin) {
        fclose(input);
    }
    return 0;
}