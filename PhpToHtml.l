/*
  Name: Translator C to Pseudocode
  Copyright: Gokhan Gobus (Geveloption) 
  Author: Gökhan Göbüs
  Description: CSE252 Term Projects lex file
*/

digit		[0-9]
allletter	[A-Za-z]
all		[A-Za-z0-9]
		
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

%}
%%


";"					return SEMICOLON;
,					return COMMA;
\"					return QUOTATION;
"'"					return APOSTROPHE;
"="					return EQUAL;
"+"					return PLUS;
"-"					return MINUS;
"*"					return STAR;
"%"					return PERCENT;
"/"					return SLASH;
"&"					return AND;
"|"					return OR;
"<"					return LESSTHAN;
">"					return GREATERTHAN;
"!"					return EXCLAMATION;
"{"					return CURLYLEFT;
"}"					return CURLYRIGHT;
"["					return SQUARELEFT;
"]"					return SQUARERIGHT;
"("					return PARANTHESESLEFT;
")"					return PARANTHESESRIGHT;



if					return IF;
else					return ELSE;
for					return FOR;
printf					return PRINTF;
scanf					return SCANF;


int					return INT;
char     				return CHAR;
void					return VOID;




return					return RETURN;

\"%d\"					return PERCENTD;
\"%s\"					return PERCENTS;
\"%c\"					return PERCENTC;
\".+\"					yylval.string=strdup(yytext);return STRING;
"'"."'"					yylval.string=strdup(yytext);return CHARACTER;
{digit}+				yylval.string=strdup(yytext);return NUMBER;
{allletter}({all})*	yylval.string=strdup(yytext);return VARIABLE;


"#"include\ (\"|\<){all}+\.h(\"|\>)     return INCLUDE;

.|\n
%%
