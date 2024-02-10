%option reentrant noyywrap bison-bridge bison-locations
%option extra-type="struct Extra *"

/* Подавление предупреждений для -Wall */
%option noinput nounput

%{

#include <stdio.h>
#include <stdlib.h>
#include "lexer.h"
#include "parser.tab.h"  /* файл генерируется Bison’ом */

#define YY_USER_ACTION \
  { \
    int i; \
    struct Extra *extra = yyextra; \
    if (! extra->continued ) { \
      yylloc->first_line = extra->cur_line; \
      yylloc->first_column = extra->cur_column; \
    } \
    extra->continued = false; \
    for (i = 0; i < yyleng; ++i) { \
      if (yytext[i] == '\n') { \
        extra->cur_line += 1; \
        extra->cur_column = 1; \
      } else { \
        extra->cur_column += 1; \
      } \
    } \
    yylloc->last_line = extra->cur_line; \
    yylloc->last_column = extra->cur_column; \
  }

void yyerror(YYLTYPE *loc, yyscan_t scanner, long env[26], const char *message) {
    printf("Error (%d,%d): %s\n", loc->first_line, loc->first_column, message);
}

%}

%%

[\r\t\n ]+

\=   return '=';
\(   return '(';
\)   return ')';
\{   return '{';
\}   return '}';
\,   return ',';
\;   return ';';
\:   return ':';
\<   return '<';
\>   return '>';

[0-9]+  {
    yylval->number = atoi(yytext);
    return NUMBER;
}

[ste]\.[0-9]+|[ste]\.[A-Za-z][A-Za-z_0-9]* {
    yylval->indentifier = yytext;
    return VAR;
}

[A-Za-z][A-Za-z_0-9]* {
    yylval->indentifier = yytext;
    return IDENT;
}

\$EXTERN|\$EXTRN|\$EXTERNAL   {
    yylval->indentifier = yytext;
    return EXTERN;
}

\$ENTRY   {
    yylval->indentifier = yytext;
    return ENTRY;
}

\'.\'   {
    yylval->indentifier = yytext;
    return SYMBOL;
}

\'[^\']*\'   {
    yylval->indentifier = yytext;
    return STRING;
}

.

%%

void init_scanner(FILE *input, yyscan_t *scanner, struct Extra *extra) {
    extra->continued = false;
    extra->cur_line = 1;
    extra->cur_column = 1;

    yylex_init(scanner);
    yylex_init_extra(extra, scanner);
    yyset_in(input, *scanner);
}

void destroy_scanner(yyscan_t scanner) {
    yylex_destroy(scanner);
}