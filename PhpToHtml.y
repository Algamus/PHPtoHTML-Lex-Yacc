/*
  Name: Translator C to Pseudocode
  Copyright: Gokhan Gobus (Geveloption) 
  Author: Gökhan Göbüs
  Description: CSE252 Term Projects yacc file
*/
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
extern FILE *yyin;
int tab=0;
%}
%union
{
char *string;
}
//-----------------------
//  THE STRUCTURE
%{
typedef struct text{
	char* string;
	struct text* next;
}TEXT;
typedef struct page{
	int count;
	TEXT* head;
	struct page* next;
}PAGE;
typedef struct stack{
	int count;
	PAGE* head;
}STACK;
//-----------------------

STACK* s;

%}
%token SEMICOLON COMMA QUOTATION APOSTROPHE EQUAL PLUS MINUS STAR PERCENT SLASH AND OR LESSTHAN GREATERTHAN EXCLAMATION CURLYLEFT CURLYRIGHT SQUARELEFT SQUARERIGHT PARANTHESESLEFT PARANTHESESRIGHT IF ELSE FOR PRINTF SCANF INT CHAR VOID RETURN PERCENTD PERCENTS PERCENTC INCLUDE
%token <string> STRING
%token <string> CHARACTER 
%token <string> NUMBER 
%token <string> VARIABLE
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
%%
commands:
	| commands command
	;

command:  assignment
	| INCLUDE
	;

assignment: ftype VARIABLE {printf("function %s ",$2);pushpage();pushtext($2);} PARANTHESESLEFT paramaters PARANTHESESRIGHT  {printf("\n");tab++;}  CURLYLEFT operations CURLYRIGHT {tab--;printf("end function\n");} 
	;
ftype: INT
	| CHAR
	| VOID
	;
paramaters:  paramatersa COMMA paramaters
	| paramatersb COMMA paramaters
	| paramatersa
	| paramatersb
	| VOID
	;
paramatersa: INT VARIABLE {printf("%s ",$2);}
	;
paramatersb: CHAR VARIABLE {printf("%s ",$2);}
	;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
operations: operation1 operations
	| operation2 operations
	| operation3 operations
	| operation4 operations
	| operation6 operations
	| operation1
	| operation2
	| operation3
	| operation4
	| operation6
	;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
operation1: INT exprint SEMICOLON
	| CHAR exprchar SEMICOLON
	;
operation2: ifstatement {tab--;} ELSE {tabber();printf("else");} elsestatement {tab--;tabber();printf("endif\n");}
	| ifstatement {tab--;tabber();printf("endif\n");}
	;
operation3: FOR  PARANTHESESLEFT  forinside PARANTHESESRIGHT {printf("\n");} CURLYLEFT operations {tabber();poptext();poppage();printf("\n");} CURLYRIGHT {tab--;tabber();printf("End While\n");}
	;
operation4: VARIABLE {tabber();printf("%s",$1);} operation5
	;
operation5: EQUAL {printf("=");} expr SEMICOLON
	| PLUS PLUS SEMICOLON {printf("++\n");}
	| MINUS MINUS SEMICOLON {printf("--\n");}
	| op EQUAL {printf("=");} ident {printf("\n");} SEMICOLON
	// |  EQUAL {printf("=");} op ident {printf("\n");}SEMICOLON
	| call SEMICOLON
	;
operation6: SCANF PARANTHESESLEFT  readvalue  COMMA AND VARIABLE PARANTHESESRIGHT SEMICOLON {tabber();printf("Read %s\n",$6);}//hata
	| PRINTF PARANTHESESLEFT STRING {tabber();printf("Print %s",$3);} insideprintfa   PARANTHESESRIGHT SEMICOLON {printf("\n");}
	| RETURN {tabber();poptext();poppage();printf("=");} ident {printf("\n");} SEMICOLON
	;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CALLER FUNCTION
call: PARANTHESESLEFT  callinside PARANTHESESRIGHT {printf("\n");}
	| PARANTHESESLEFT  PARANTHESESRIGHT {printf("\n");}
	;
callinside: VARIABLE {printf(" %s",$1);} COMMA callinside
	| VARIABLE {printf(" %s",$1);}
	;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SCANF & PRINTF
readvalue: PERCENTD
	| PERCENTS
	| PERCENTC
	;
insideprintfa:  insideprintfb
	|  
	;
insideprintfb: COMMA VARIABLE {printf(",%s",$2);} insideprintfb
	| COMMA VARIABLE  {printf(",%s",$2);}
	;
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// IF- ELSE IF- IF
ifstatement: IF PARANTHESESLEFT {tabber();printf("if ");} comparison PARANTHESESRIGHT  {printf("\n");tabber();printf("then\n");tab++;} CURLYLEFT operations  CURLYRIGHT
	;
elsestatement: IF  PARANTHESESLEFT {printf("if ");} comparison PARANTHESESRIGHT  {printf("\n");tab++;} CURLYLEFT operations CURLYRIGHT ELSE {tab--;tabber();printf("else");} elsestatement
	| CURLYLEFT {printf("\n");tab++;} operations   CURLYRIGHT 
	;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//    4 OPERATION & OTHERS
expr:  ident op expr
	| VARIABLE {printf("%s",$1);} call
	| ident {printf("\n");}
	;
exprint: VARIABLE EQUAL NUMBER COMMA {tabber();printf("%s=%s\n",$1,$3);} exprint 
	| VARIABLE EQUAL NUMBER{tabber();printf("%s=%s\n",$1,$3);}
	| VARIABLE EQUAL VARIABLE COMMA {tabber();printf("%s=%s\n",$1,$3);} exprint
	| VARIABLE EQUAL VARIABLE{tabber();printf("%s=%s\n",$1,$3);}
	| VARIABLE COMMA exprint
	| VARIABLE
	;
exprchar: VARIABLE EQUAL CHARACTER COMMA {tabber();printf("%s=%s\n",$1,$3);} exprchar
	| VARIABLE EQUAL CHARACTER{tabber();printf("%s=%s\n",$1,$3);}
	| VARIABLE EQUAL VARIABLE COMMA {tabber();printf("%s=%s\n",$1,$3);} exprchar
	| VARIABLE EQUAL VARIABLE{tabber();printf("%s=%s\n",$1,$3);}
	| VARIABLE COMMA exprchar
	| VARIABLE
	;
///////////////////////////////////////////////////////////////////////////////////////////////////////////
///    FOR
forinside: forinsidea SEMICOLON {tabber();printf("While ");} comparison {tab++;} SEMICOLON {pushpage();} forinsideb
	;
forinsidea: INT exprint COMMA forinsidea
	|   CHAR exprchar COMMA forinsidea
	|   forinsideab COMMA forinsidea
	|   INT exprint
	|   CHAR exprchar
	|   forinsideab
	;
forinsideab: VARIABLE EQUAL {tabber();printf("%s=",$1);} expr
	;
forinsideb: forinsidec COMMA  {pushtext("\n");} forinsideb
	|   forinsidec
	;
forinsidec: VARIABLE {pushtext($1);} forinsided
	;
forinsided:  EQUAL {pushtext("=");} forinsidebb
	|  PLUS PLUS {pushtext("++");pushtext("\n");}
	|  MINUS MINUS {pushtext("--");pushtext("\n");}
	|  op EQUAL {pushtext("=");} ident SEMICOLON {pushtext("\n");}
	// |  EQUAL {pushtext("=");} op ident SEMICOLON {pushtext("\n");}
	;
forinsidebb: 
	forident forop forinsidebb
	| forident
	;
forident: VARIABLE {pushtext($1);}
	| NUMBER {pushtext($1);}
	| CHARACTER {pushtext($1);}
	;
forop: PLUS {pushtext("+");}
	| MINUS {pushtext("-");}
	| STAR {pushtext("*");}
	| PERCENT {pushtext("%");}
	| SLASH {pushtext("/");}
	;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// COMPARISON
comparison: ident comparisona ident
	| comparison comparisonb comparison
	;
comparisona: EQUAL EQUAL {printf(" == ");}
	| EXCLAMATION EQUAL {printf(" != ");}
	| LESSTHAN EQUAL {printf(" <= ");}
	| GREATERTHAN EQUAL {printf(" >= ");}
	| LESSTHAN {printf(" < ");}
	| GREATERTHAN {printf(" > ");}
	;
comparisonb: AND AND {printf(" && ");}
	| OR OR {printf(" || ");}
	;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ELEMENTS
type: INT {printf("int");}
	| CHAR {printf("char");}
	;
ident: VARIABLE {printf("%s",$1);}
	| NUMBER {printf("%s",$1);}
	| CHARACTER {printf("%s",$1);}
	;
op: PLUS {printf("+");}
	| MINUS {printf("-");}
	| STAR {printf("*");}
	| PERCENT {printf("%");}//printf warning veriyo gcc de
	| SLASH {printf("/");}
	;
%%
///////////////////////////////////////////////////////////////////////////
//-------------------------STACK FUNCTIONS----------------------------
STACK* createstack(void){
      STACK* stack;
      stack=(STACK*)malloc(sizeof(STACK));
      if (stack){
                stack->count=0;
                stack->head=NULL;
      }
      return stack;
}
PAGE* createpage(void){
      PAGE* page;
      page=(PAGE*)malloc(sizeof(PAGE));
      if (page){
                page->count=0;
                page->head=NULL;
		page->next=NULL;
      }
      return page;
}
TEXT* createtext(void){
      TEXT* text;
      text=(TEXT*)malloc(sizeof(TEXT));
      if (text){
                text->string=(char*)malloc(sizeof(char));
		text->next=NULL;
      }
      return text;
}
void pushpage(void){
	if(s->count==0){
		s->head=createpage();
		s->count=1;
	}else{
		PAGE* p;
		p=s->head;
		s->head=createpage();
		s->head->next=p;
		s->count+=1;
	}
}
void poppage(void){
	if(s->count==1){
		free(s->head);
		s->count=0;
	}else{
		PAGE* p;
		p=s->head;
		s->head=s->head->next;
		free(p);
		s->count-=1;
	}
}
void pushtext(char* str){
	TEXT* text=createtext();
	strcpy(text->string,str);
	if(s->head->count==0){
		s->head->head=text;
		s->head->count=1;
	}else{
		TEXT* t=s->head->head;
		while(t->next!=NULL){
			t=t->next;
		}
		t->next=text;
		s->head->count+=1;
	}
}
void poptext(void){
	TEXT* text;
	TEXT* t=NULL;
	int i;
	text=s->head->head;
	for(i=0;i<s->head->count;i++){
		t=text->next;
		//	
			//pushlama yazdır.
			printf("%s",text->string);
			if(!(strcmp(text->string,"\n"))){
				tabber();
			}
		//
		free(text->string);
		free(text);
		text=t;
	}
	s->head->count=0;
}


///////////////////////////////////////////////////////////////////////////////////////////
//----------------------------------------blank----------------------------------------------
void tabber(void){
	int i;
	for(i=0;i<tab;i++){
		printf("\t");
	}
}
///////////////////////////////////////////////////////////////////////////////////////////
void yyerror(char *s){
	fprintf(stderr,"error: %s\n",s);
}
int yywrap(){
	return 1;
}
int main(int argc, char *argv[])
{
    s=createstack();
    /* Call the lexer, then quit. */
    yyin=fopen(argv[1],"r");
    yyparse();
    fclose(yyin);
    free(s);
    return 0;
}
